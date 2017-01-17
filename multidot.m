function [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence, conestim, gapstim] = multidot(CFG)

[I stimposx stimposy] = deal([]); % Needed to instantiate nested variable access
[stimwidth,stimheight] = deal(CFG.selectionwidth); % Stimulus total width and height
dotsize = CFG.stimsize; % Square side length or circle diameter
dottype = CFG.stim_shape; % So far either 'circle' or 'square'
antialias = CFG.antialiased; % For smooth edges 

% Look for prior selected cone locations
if exist('conestim.bmp','file')==2  && exist('gapstim.bmp','file')==2 % ask for redo
    choice = questdlg('Earlier multidot stimuli detected.', ...
        'Redo?', ...
        'Redo last', 'Start new', 'Redo');
    switch choice % skip selection process and use saved files again
        case 'Redo last'
            stimconec = imread('conestim.bmp');
            stimgapc = imread('gapstim.bmp');
        case 'Start new' % start selection process
            getPositionFromFile;
            selectLocation;
    end
else % start from scratch
    getPositionFromFile; % Find cross from tif or avi
    selectLocation; % User input selects cone and gap position
end

conestim = stimconec; gapstim = stimgapc;
imwrite(conestim,'conestim.bmp'); imwrite(gapstim,'gapstim.bmp');

if strcmp(CFG.method,'Mocs');
    numtrials = CFG.beta.*CFG.delta;
    ncatch = 0; nlapse = 0;
    prange = CFG.priorSD/100;
    if prange == 1.0;
        Intensity_Vector = (0:prange/(CFG.beta-1):1.0)';
    else
        Intensity_Vector = (CFG.thresholdGuess-(prange/2):prange/(CFG.beta-1):CFG.thresholdGuess+(prange/2))';
        [rows,cols] = find(Intensity_Vector >1);
        Intensity_Vector(rows,cols) = [];
        numtrials = size(Intensity_Vector,1).*CFG.delta;
    end
else
    numtrials = CFG.npresent+CFG.ncatch+CFG.nlapse;
    ncatch = CFG.ncatch; nlapse = CFG.nlapse;
    prange = []; Intensity_Vector = [];
end


% Setup trial order and other output values to be used in ConeMappingNew
% Experiment script
offset_matrix = zeros(2,3); offset_matrix(:,3) = [1 2];
numcones = size(offset_matrix,1);

trial_matrix = zeros(numtrials, numcones);
for nc = 1:numcones
    temp_mat = ones(numtrials,2);
    temp_mat(:,1)=randn(numtrials,1);
    temp_mat(1:ncatch,2) = 0; %0 indicates catch trial
    temp_mat(end-nlapse+1:end,2) = 2; %2 indicates lapse trial
    temp_mat = sortrows(temp_mat,1);
    trial_matrix(:,nc) = temp_mat(:,2);
end

index_sequence = zeros(numcones,1,numtrials);
for nt = 1:numtrials
    temp_vector = zeros(numcones,2);
    temp_vector(:,1) = randn(numcones,1);
    temp_vector(:,2) = (1:numcones)';
    temp_vector = sortrows(temp_vector,1);
    index_sequence(:,1,nt) = temp_vector(:,2);
end

exp_sequence = zeros(numcones*numtrials,5); ns = 1;
for m = 1:size(index_sequence,3)
    for p = 1:size(index_sequence,1)
        exp_sequence(ns,1) = index_sequence(p,1,m); %cone
        if strcmp(CFG.method,'Mocs')
            exp_sequence(ns,2) = 0; %fill in later; will be trial intensities in MOCS
        else
            exp_sequence(ns,2) = trial_matrix(m,index_sequence(p,1,m)); %trial_flag
        end
        exp_sequence(ns,3) = offset_matrix(index_sequence(p,1,m),1); %x offset
        exp_sequence(ns,4) = offset_matrix(index_sequence(p,1,m),2); %y offset
        exp_sequence(ns,5) = m;
        ns = ns+1;
    end
end

if strcmp(CFG.method,'Mocs')
    for nn = 1:numcones
        test_vector = rand(numtrials,1);
        test_vector(:,2) = 0;
        n = 1;
        for int = 1:CFG.beta;
            test_vector(n:CFG.delta*int,2) = int;
            n = n+CFG.delta;
        end
        test_sequence = sortrows(test_vector);
        test_sequence(:,1)= [];
        k = 1;
        [row,col] = find(exp_sequence(:,1)==nn);
        for row_num = 1:size(row,1)
            exp_sequence(row(row_num),2) = Intensity_Vector(test_sequence(k,1));
            k = k+1;
        end
    end
end


% Find cross location from selected video
    function getPositionFromFile(hObject,eventdata,h)
        directory = 'D:\Video_Folder';
        [fname, pname] = uigetfile('*.avi;*.tif', 'Select image or video for cone selection', directory);
        [dump1, dump2, ext] = fileparts([pname fname]);
        movie_name = [pname fname];
        if strcmp(ext,'.avi')==1
            I = mov_norm(pname, fname);
            %save image for use later;
            imwrite(I, [pname fname(1:end-4) '_sumframe.tif'], 'tif', 'compression', 'none');
            [stimposx stimposy] = FCIM(movie_name);
        elseif strcmp(ext,'.tif')==1
            I = imread([pname fname]);
            [x y dump] = textread([cd '\IR_target.txt'], '%s %s %s');
            stimposx = median(str2num(char(x)));
            stimposy = median(str2num(char(y)));
        end
        
    end

% Show ROI and let user select cones from zoomed image
    function selectLocation (hObject,eventdata,h)
        
        fsize = [500 500]; screensize = get(0,'ScreenSize');
        fposx = ceil((screensize(3)-fsize(2))/2); fposy = ceil((screensize(4)-fsize(1))/2);
        Ic = imcrop(I,[stimposx-floor(stimwidth/2) stimposy-floor(stimwidth/2) stimwidth-1 stimheight-1]);
        f1 = figure('position',[fposx, fposy, fsize(2), fsize(1)]);
        imshow(Ic,'InitialMagnification','fit'); hold on;
        h.rect=rectangle('Position',[round(dotsize/2) round(dotsize/2) stimwidth-dotsize stimheight-dotsize]);
        set(h.rect,'EdgeColor',[1 0 0]);
        h.title = title('Left click selects cones. Press any other key when ready','FontSize',14);
        set(h.title,'BackgroundColor',[1 1 0.6]);
        [xi,yi] = deal([]);
        [conecount,but] = deal(1);
        while but == 1
            [x,y,but] = ginput(1);
            if but ~=1
                break;
            end
            plot(x,y,'g+');
            xi(conecount,1) = x;
            yi(conecount,1) = y;
            conecount = conecount+1;
        end
        close
        
        % Let user select best GAP position from zoomed image
        f1 = figure('position',[fposx, fposy, fsize(2), fsize(1)]);
        imshow(Ic,'InitialMagnification','fit'); hold on;
        h.title = title('Select a gap next to first cone selected','FontSize',14);
        set(h.title,'BackgroundColor',[1 1 0.6]);
        plot(xi,yi,'g.');
        plot(xi(1),yi(1),'r+','MarkerSize',10);
        gapmaxx = stimwidth-round(max(xi)+(dotsize/2));gapminx = round(min(xi)-(dotsize/2));
        gapmaxy = stimheight-round(max(yi)+(dotsize/2));gapminy = round(min(yi)-(dotsize/2));
        h.rect=rectangle('Position',[xi(1)-gapminx yi(1)-gapminy gapminx+gapmaxx gapminy+gapmaxy]);
        set(h.rect,'EdgeColor',[1 0 0],'LineStyle','--');
        [xgap,ygap] = ginput(1); close
        gapshiftx = round(xgap - xi(1)); gapshifty = round(ygap - yi(1));
        
        % Make CONE and GAP stimuli based off of selected pixels and shift
        cone_x = round(xi); cone_y = round(yi);
        gap_x = round(xi)+gapshiftx; gap_y = round(yi)+gapshifty;
        stimcone = makeStimulus(int8(stimwidth),int8(stimheight),dotsize,dottype,cone_x,cone_y,antialias);
        stimgap = makeStimulus(int8(stimwidth),int8(stimheight),dotsize,dottype,gap_x,gap_y,antialias);
        
        % Crop stimuli to ensure best possible stimulus delivery
        [row col] = find((stimcone+stimgap)~=0);
        cc = min(min(col),size(stimcone,1)+1-max(col))-1;
        cr = min(min(row),size(stimcone,1)+1-max(row))-1;
        stimconec = stimcone; stimgapc = stimgap;
        stimconec([1:cr end-cr+1:end],:) = []; stimconec(:, [1:cc end-cc+1:end]) = [];
        stimgapc ([1:cr end-cr+1:end],:) = []; stimgapc (:, [1:cc end-cc+1:end]) = [];
        
        % Visual and qunatitative feedback on CONE and GAP stimulus
        % position and control buttons
        stimImage = stimcone.*0.4; stimImagegap = stimgap.*0.4;
        green = cat(3,zeros(size(stimImage)),ones(size(stimImage)),zeros(size(stimImage)));
        pixelValueCone = (sum(sum(stimcone.*im2double(Ic)))); pixelValueGap = (sum(sum(stimgap.*im2double(Ic))));
        ConeGapImageRatio = pixelValueCone/pixelValueGap;
        f1 = figure('position',[fposx, fposy, fsize(2), fsize(1)],'Name','Review selection');
        sp1 = subplot(2,2,1); imshow(Ic,'InitialMagnification','fit'); hold on
        hr = imshow(green); set(hr,'AlphaData',stimImage);title(['Pixel Value: ',num2str(pixelValueCone)]); hold off
        sp2 = subplot(2,2,2); imshow(Ic,'InitialMagnification','fit'); hold on
        hr = imshow(green); set(hr,'AlphaData',stimImagegap); title(['Pixel Value: ', num2str(pixelValueGap)]); hold off
        sp3 = subplot(2,2,3);imshow(stimconec), title('CONE stimulus');
        sp4 = subplot(2,2,4);imshow(stimgapc), title('GAP stimulus');
        
        h.text = uicontrol('Style','Text','Position',[162 2 190 39],...
            'String',['Cone/Gap Pixel Value Ratio: ',num2str(ConeGapImageRatio,3)],'FontWeight','Bold',...
            'BackgroundColor',[0.8 0.8 0.8]);
        if ConeGapImageRatio<=1.1
            set(h.text,'ForeGroundcolor',[1 0 0], 'BackgroundColor',[1 1 0.6]);
        end
        
        h.button1 = uicontrol('Style','Pushbutton','Position',[273 6 70 20],...
            'String','Accept');
        set(h.button1,'callback',{@acceptSelection,h});
        
        h.button2 = uicontrol('Style','Pushbutton','Position',[178 6 70 20],...
            'String','Re-select');
        set(h.button2,'callback',{@restartSelection,h});
        uiwait; % Otherwise multidot would give back slected loctions already
    end

% Executes on button press, restarts selection process
    function restartSelection (hObject,eventdata,h)
       close(gcf); selectLocation; 
    end

% Executes on button press, accepts selection and quits window
    function acceptSelection (hObject,eventdata,h)
        uiresume; close(gcf); % makes sure that stimuli are given back only after pressing 'Accept' button
    end

% Generate and return stimulus bitmap
    function s = makeStimulus (sheight, swidth, dotsize, dottype, dotposx, dotposy, antialias)
         s = zeros(sheight, swidth);
        
        if strcmp(dottype,'Square')
            for n = 1:size(dotposx,1)
                if mod(dotsize,2)==0
                    s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2)-1,...
                        dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)-1) = 1;
                    
                else
                    s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2),...
                        dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)) = 1;
                end
            end
            
        elseif strcmp(dottype,'Circle')
            
            [rr cc] = meshgrid(1:dotsize+1);
            if mod(dotsize,2)==0
                ci = sqrt((rr-((dotsize+1)/2)).^2+(cc-((dotsize+1)/2)).^2)<=((dotsize)/2);
            else
                if dotsize <= 3
                    ci = sqrt((rr-ceil((dotsize)/2)).^2+(cc-ceil((dotsize)/2)).^2)<=ceil((dotsize-1)/2);
                elseif dotsize <=5
                    ci = sqrt((rr-floor((dotsize+1)/2)).^2+(cc-floor((dotsize+1)/2)).^2)<=((dotsize)/2);
                else
                    ci = sqrt((rr-floor((dotsize+1)/2)).^2+(cc-floor((dotsize+1)/2)).^2)<=((dotsize)/2);
                end
                
            end
            ci(:,sum(ci,1)==0)=[];
            ci(sum(ci,2)==0,:)=[];
            
            for n = 1:size(dotposx,1)
                if mod(dotsize,2)==0
                    s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2)-1,...
                        dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)-1) = ci;
                else
                    s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2),...
                        dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)) = ci;
                end
            end
        end
        
        if antialias == 1
            f = fspecial('gaussian',[3 3],1);
            s = imfilter(s,f,'replicate');
        end
    end

end

