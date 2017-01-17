function Gabor
global SYSPARAMS StimParams VideoParams;

if exist('handles','var') == 0;
    handles = guihandles;
end



startup;



if strcmp(CFG.method,'2d1u')
    Spat_Vec = CFG.PeriodsVector;     % [50 30 5 2];% spatial frequencies in cycles/degree
    Num_Spats = length(Spat_Vec);
    
    if CFG.ConLogSpace
        if CFG.ContrastMin~=0
            Contrast_Vec = logspace(log10(CFG.ContrastMin),log10(CFG.ContrastMax),20);
        elseif CFG.ContrastMin==0
            Contrast_Vec = logspace(-3,log10(CFG.ContrastMax),20);
            Contrast_Vec (1)= CFG.ContrastMin;
        end
        
    else
        Contrast_Vec = linspace(CFG.ContrastMin,CFG.ContrastMax,20);
    end
    
    Staircase = struct;
    
    for iaa = 1:Num_Spats
        
        FillA = ['Contrast' num2str(iaa)];
        FillB = ['Trial' num2str(iaa)];
        FillC = ['CorrectCount' num2str(iaa)];      % CorrectCount = 2: next step
        FillD = ['Correct' num2str(iaa)];           % Correct Answer
        Staircase.(FillA) = length(Contrast_Vec)-2;  % Position in Contrast_Vec Spatial Freq.1
        Staircase.(FillB) = 1;
        Staircase.(FillC) = 0;
        Staircase.(FillD) = 0;
    end
    
    
    
    Alltrials = CFG.npresent*Num_Spats;
    All=repmat([1:Num_Spats],1,3);
    L_All  = length(All);
    
    i4 = [0 0 1 1];
    i2 = 1:Num_Spats;
    RanDom = [];
    
    HowMany = floor(Alltrials/L_All);
    
    for idx = 1:HowMany % rand permutate All list
        Pre_Choice=All(randperm(L_All));
        RanDom(idx*L_All-(L_All-1):idx*L_All)=Pre_Choice;
    end
    if mod(Alltrials,L_All)==2*Num_Spats % add if Alltrials not divideable by L_All
        RanDom = [RanDom repmat([1:Num_Spats],1,2)];
    elseif mod(Alltrials,L_All)==Num_Spats
        RanDom = [RanDom [1:Num_Spats]];
    end
    
end



%setup the keyboard constants from config
% kb_Abort = CFG.kb_Abort;
kb_Rotation = CFG.kb_Rotation;
kb_FreqIn = CFG.kb_FreqIn;
kb_FreqDe = CFG.kb_FreqDe;
kb_ContrastInS = CFG.kb_ContrastInS;
kb_ContrastInL = CFG.kb_ContrastInL;
kb_ContrastDeS = CFG.kb_ContrastDeS;
kb_ContrastDeL = CFG.kb_ContrastDeL;

psyflag = 1;
writePsyfileHeader
matfname = [psyfname(1:end-4) '_Gabor_data.mat'];
response_matrix=struct;

%offsets
green_x_offset = -CFG.green_x_offset; green_y_offset = CFG.green_y_offset; %enter in negative of TCA measures
red_x_offset = -CFG.red_x_offset; red_y_offset = CFG.red_y_offset; %enter negative of TCA measure

%get the stimulus parameters
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;
% fieldsize = CFG.fieldsize;

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;


SYSPARAMS.aoms_state(2)=1; % SWITCH RED ON
SYSPARAMS.aoms_state(3)=1; % SWITCH GREEN ON


%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
framenum2 = 3;
framenum3 = 4; %cue stim
startframe = 1; %the frame at which it starts presenting stimulus
cueframe = 5; cuedur = 2;
fps = 30;
stimdur = CFG.presentdur; %how long is the presentation (in frames)
numframes = fps*CFG.videodur;
%AOM1 (RED) parameters
if CFG.red_stim_color == 1;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.red_stim_color == 0;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,numframes-startframe+1-stimdur)];
end
% aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];

aom1pow = ones(size(aom1seq));
aom1pow(:) = 1;
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
aom1offx(:) = red_x_offset;
aom1offy(:) = red_y_offset;

%AOM2 (GREEN) paramaters
if CFG.green_stim_color == 1;
    aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.green_stim_color == 0;
    aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,numframes-startframe+1-stimdur)];
end

aom2pow = ones(size(aom1seq));
aom2pow(:) = 1;
aom2offx = zeros(size(aom1seq));
aom2offx(:) = green_x_offset;
aom2offy = zeros(size(aom1seq));
aom2offy(:) = green_y_offset;

%AOM0 (IR) parameters
% aom0seq = ones(size(aom1seq));
% aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
if CFG.ir_stim_color == 1;
    aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.ir_stim_color == 0;
    aom0seq = ones(size(aom1seq));
end
%for cuing in IR;
% aom0seq = [zeros(1,cueframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
aom0locx = zeros(size(aom1seq));
aom0locy = zeros(size(aom1seq));
aom0pow = ones(size(aom1seq));

gainseq = zeros(size(aom1seq));
gainseq(:,:) = CFG.edit_gain;
angleseq = zeros(size(aom1seq));
stimbeep = zeros(size(aom1seq));
stimbeep(startframe+stimdur-1) = 1;
%stimbeep = [zeros(1,startframe+stimdur-1) 1 zeros(1,numframes-startframe-stimdur+2)];
%Set up movie parameters
Mov.duration = size(aom1seq,2);

Mov.aom0seq = aom0seq;
Mov.aom0pow = aom0pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;

Mov.aom1seq = aom1seq;
Mov.aom1pow = aom1pow;
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;

Mov.aom2seq = aom2seq;
Mov.aom2pow = aom2pow;
Mov.aom2offx = aom2offx;
Mov.aom2offy = aom2offy;

Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.stimbeep = stimbeep;
Mov.frm = 1;
Mov.seq = '';


%set initial while loop conditions
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
runExperiment = 1;
trial = 1;
% PresentStimulus = 1;
% GetResponse = 0;
% good_check = 1;
% correct=1;
% ncorrect=0;
% alt=round(rand);
% sign=2*ceil(2*rand)-3;
% signy=2*ceil(2*rand)-3;
% steps=CFG.stepfactor;
% stepsy=CFG.stepfactor;
% intensity=CFG.first;
Sigma = CFG.sigma;
Size = CFG.stimsize;

if strcmp(CFG.method,'Adjust')
    Rot_Var = 1;
    Rot_Steps = CFG.RotStepSize;
    Rot_Vec = [0:Rot_Steps:179];
    Rotation = Rot_Vec(Rot_Var);
    
    Period = CFG.Period;
    L_StepSize = CFG.PeriodStepSize;
    
    Contrast = CFG.ContrastMax;
    C_StepSize_L = CFG.ConLStepSize;
    C_StepSize_S = CFG.ConSStepSize;
end


while (runExperiment == 1)
    uiwait;
    key = get(handles.aom_main_figure,'CurrentKey');
    
    if strcmp(CFG.method,'2d1u')
        if strcmp(key,'space')
            
            if trial>length(RanDom)
                
                % plot data?
                
                runExperiment = 0;
                uiresume;
                TerminateExp;
                message = 'DONE!';
                set(handles.aom1_state, 'String',message);

% Show Stimulus                
            else
                Current = RanDom(trial);
                
                Prefix = rand(1);
                if Prefix < .5
                    Rotation = CFG.RotStepSize;      % right tilted
                else
                    Rotation = 360-CFG.RotStepSize;     % left tilted
                end
                
                Period = Spat_Vec(Current);
                
                Fieldname1 = ['Contrast' num2str(Current)];
                Contrast = Contrast_Vec(Staircase.(Fieldname1));
                
                MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
                
                StimSettings;
                PlayMovie;
                
                GetResponse=1;
            end
            

% Evaluate Response            
        elseif GetResponse==1;
            
            Fieldname2 = ['CorrectCount' num2str(Current)];
            Fieldname3 = ['Correct' num2str(Current)];

% Answer is: "right tilted"            
            if strcmp(key,kb_FreqIn)
                
% Answer corect
                if Rotation == 45   
                    
                    message = ['This is correct!  Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast) '   Trial ' num2str(trial) ' of ' num2str(Alltrials)];
                    set(handles.aom1_state, 'String',message);

                    Staircase.(Fieldname2) = Staircase.(Fieldname2)+1;
                    Staircase.(Fieldname3) = 1;

                    if Staircase.(Fieldname2) == 2
                        Staircase.(Fieldname1) = Staircase.(Fieldname1)-1;
                        Staircase.(Fieldname2) = 0;
                    end
                    
% wrong answer                    
                else	
                    
                    message = ['Incorrect answer :(  Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast) '   Trial ' num2str(trial) ' of ' num2str(Alltrials)];
                    set(handles.aom1_state, 'String',message);
                    
                    Staircase.(Fieldname2) = 0;
                    Staircase.(Fieldname3) = 0;
                    
                    
                    Staircase.(Fieldname1) = Staircase.(Fieldname1)+1;
                    if Staircase.(Fieldname1)>length(Contrast_Vec)
                        Staircase.(Fieldname1)=length(Contrast_Vec);
                    end
                    
                end
                
                SaveData(0);
                GetResponse = 0;
                trial = trial+1;
                clear Fieldname1 Fieldname2 Fieldname3 Period Contrast
                
                
                
% Answer is: "left tilted"            
            elseif strcmp(key,kb_FreqDe)
                
% Answer corect
                if Rotation == 315   

                    message = ['This is correct!  Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast) '   Trial ' num2str(trial) ' of ' num2str(Alltrials)];
                    set(handles.aom1_state, 'String',message);
                    
                    Staircase.(Fieldname2) = Staircase.(Fieldname2)+1;
                    Staircase.(Fieldname3) = 1;

                    if Staircase.(Fieldname2) == 2
                        Staircase.(Fieldname1) = Staircase.(Fieldname1)-1;
                        Staircase.(Fieldname2) = 0;
                    end
                    
% wrong answer                    
                else	
                    
                    message = ['Incorrect answer :(  Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast) '   Trial ' num2str(trial) ' of ' num2str(Alltrials)];
                    set(handles.aom1_state, 'String',message);
                    
                    Staircase.(Fieldname2) = 0;
                    Staircase.(Fieldname3) = 0;
                    
                    
                    Staircase.(Fieldname1) = Staircase.(Fieldname1)+1;
                    if Staircase.(Fieldname1)>length(Contrast_Vec)
                        Staircase.(Fieldname1)=length(Contrast_Vec);
                    end
                    
                end
                
                SaveData(0);
                GetResponse = 0;
                trial = trial+1;
                clear Fieldname1 Fieldname2 Fieldname3 Period Contrast
                
            end
        end
        
    else
        if strcmp(key,kb_Rotation)
            if trial > 1
                Rot_Var = Rot_Var+1;	end
            
            if Rot_Var>length(Rot_Vec)
                Rot_Var = 1;    end
            
            Rotation = Rot_Vec(Rot_Var);
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            
            trial = trial+1;
            
            
        elseif strcmp(key,kb_ContrastInS)
            %         Rotation = 45*floor(rand*3);
            Contrast = Contrast+C_StepSize_S;
            if Contrast >1
                Contrast = 1;
            end
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            trial = trial+1;
            
            
        elseif strcmp(key,kb_ContrastDeS)
            %         Rotation = 45*floor(rand*3);
            Contrast = Contrast-C_StepSize_S;
            if Contrast <0
                Contrast = 0;
            end
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            trial = trial+1;
            
            
        elseif strcmp(key,kb_ContrastInL)
            %         Rotation = 45*floor(rand*3);
            Contrast = Contrast+C_StepSize_L;
            if Contrast >1
                Contrast = 1;
            end
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            trial = trial+1;
            
            
        elseif strcmp(key,kb_ContrastDeL)
            %         Rotation = 45*floor(rand*3);
            Contrast = Contrast-C_StepSize_L;
            if Contrast <0
                Contrast = 0;
            end
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            trial = trial+1;
            
            
        elseif strcmp(key,kb_FreqDe)
            %         Rotation = 45*floor(rand*3);
            Period = Period-L_StepSize;
            if Period <0
                Period = 0;
            end
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            trial = trial+1;
            
            
        elseif strcmp(key,kb_FreqIn)
            %         Rotation = 45*floor(rand*3);
            Period = Period+L_StepSize;
            MakeGaborPatch(Size,Period,Rotation,Sigma,.005,Contrast);
            
            StimSettings;
            PlayMovie;
            SaveData(0);
            
            trial = trial+1;
            
        elseif strcmp(key,'return')     % Final Adjustment
            if strcmp(CFG.method,'Adjust')
                SaveData(1);
                
                runExperiment = 0;
                uiresume;
                TerminateExp;
                message = ['Adjustment DONE! Final Settings: ' 'Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast)];
                set(handles.aom1_state, 'String',message);
            end
            
        end
        
    end
    
    if strcmp(key,'escape')     % Abort Experiment
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial)];
        set(handles.aom1_state, 'String',message);
    end
end



    function MakeGaborPatch(Size,Period,Rotation,Sigma,Trim,Contrast)
        
        CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
        
        %% Gabor
        imSize = Size;                           % image size: n X n
        
        Field = 512/CFG.fieldsize;
        lambda = Field/Period;                      % wavelength (number of pixels per cycle)
        
        theta = Rotation;                        % grating orientation
        sigma = Sigma;      % 10                 % gaussian standard deviation in pixels
        %         phase = .25;                             % phase (0 -> 1)
        phase = round(rand(1)*10)/10;
        trim = Trim;        % .005               % trim off gaussian values smaller than this
        
        X = 1:imSize;                           % X is a vector from 1 to imageSize
        X0 = (X / imSize) - .5;                 % rescale X -> -1 to 1
        
        freq = imSize/lambda;                    % compute frequency from wavelength
        phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
        
        [Xm,Ym] = meshgrid(X0, X0);             % 2D matrices
        
        thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
        Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
        Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
        XYt = [ Xt + Yt ];                      % sum X and Y components
        XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
        grating = sin( XYf + phaseRad);         % make 2D sinewave and add Contrast adjustment
        
        s = sigma / imSize;                     % gaussian width as fraction of imageSize
        
        gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
        
        gauss(gauss < trim) = 0;                 % trim around edges (for 8-bit colour displays)
        prepreGabor = grating.* gauss;           % use .* dot-product
        
        preGabor = prepreGabor+abs(min(prepreGabor(:)));    % adjust Gabor to min = 0
        Gabor=preGabor/max(preGabor(:)).*Contrast;          % adjust Gabor to max = 1 and add Contrast adjustment
        Gabor=Gabor+(.5-mean(Gabor(:)));                    % adjust to a Gabor mean of .5
        Gabor(Gabor<0)=0; Gabor(Gabor>1)=1;
        
        if CFG.check_Gabor
            Gabor = Gabor+1;
            stim_im = Gabor./2;
        else
%             Gabor(Gabor<0)=0;
            stim_im = Gabor;
        end
        
        
        if isdir([pwd,[filesep,'tempStimulus']]) == 0;
            mkdir(pwd,'tempStimulus');
            cd([pwd,[filesep,'tempStimulus']]);
            blank_im = zeros(size(stim_im,1),size(stim_im,2));
            imwrite(stim_im,'frame2.bmp');
            imwrite(blank_im,'frame3.bmp');
            %     fid = fopen('frame2.buf','w');
            %     fwrite(fid,size(stim_im,2),'uint16');
            %     fwrite(fid,size(stim_im,1),'uint16');
            %     fwrite(fid, stim_im, 'double');
            %     fclose(fid);
        else
            cd([pwd,[filesep,'tempStimulus']]);
        end
        blank_im = zeros(size(stim_im,1),size(stim_im,2));
        
        if CFG.ir_stim_color == 1;
            ones_im = zeros(size(stim_im,1),size(stim_im,2));
            ones_im = 1-stim_im;
        else
            ones_im = ones(size(stim_im,1),size(stim_im,2));
        end
        imwrite(stim_im,'frame2.bmp');
        imwrite(blank_im,'frame3.bmp');
        imwrite(ones_im,'frame4.bmp');
        
        cd ..;
    end



    function SaveData (Ending)
        response_matrix(trial).trialRotation = Rotation;
        response_matrix(trial).trialContrast = Contrast;
        response_matrix(trial).trialPeriod = Period;
        
        if strcmp(CFG.method,'2d1u')
            response_matrix(trial).CorrectCount = Staircase.(Fieldname2);
            response_matrix(trial).Correct = Staircase.(Fieldname3);
        end
        
        folder = VideoParams.videofolder;
        vidname = VideoParams.vidname;
        response_matrix(trial).video_name = [folder vidname '.avi'];
        
        save(matfname, 'response_matrix')
        
        if Ending
            psyfid = fopen(psyfname,'a');
            fprintf(psyfid,'%s %d %4.2f %d\r\n','Final Settings',Rotation,Contrast,Period);
            fclose(psyfid);
        else
            psyfid = fopen(psyfname,'a');
            fprintf(psyfid,'%s %d %4.2f %d\r\n',VideoParams.vidname,Rotation,Contrast,Period);
            fclose(psyfid);
        end
        
        %         save([cd [filesep,'lastMappingname.mat']], 'matfname','psyfname');
    end



    function startup
        
        dummy=ones(10,10);
        if isdir([pwd,'\tempStimulus']) == 0;
            mkdir(pwd,'tempStimulus');
            cd([pwd,'\tempStimulus']);
            
            imwrite(dummy,'frame2.bmp');
            %     fid = fopen('frame2.bmp','w');
            %     fwrite(fid,size(dummy,2),'uint16');
            %     fwrite(fid,size(dummy,1),'uint16');
            %     fwrite(fid, dummy, 'double');
            %     fclose(fid);
        else
            cd([pwd,'\tempStimulus']);
            delete *.*
            imwrite(dummy,'frame2.bmp');
            %     fid = fopen('frame2.buf','w');
            %     fwrite(fid,size(dummy,2),'uint16');
            %     fwrite(fid,size(dummy,1),'uint16');
            %     fwrite(fid, dummy, 'double');
            %     fclose(fid);
        end
        cd ..;
        
        
        % Get experiment config data stored in appdata for 'hAomControl'
        hAomControl = getappdata(0,'hAomControl');
        uiwait(GaborConfig);
        CFG = getappdata(hAomControl, 'CFG');
        psyfname = [];
        if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
            CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
            if CFG.ok == 1
                StimParams.stimpath = CFG.stimpath;
                VideoParams.vidprefix = CFG.vidprefix;
                %disable slider control during exp
                %         set(handles.align_slider, 'Enable', 'off');
                set(handles.aom1_state, 'String', 'Configuring Experiment...');
                if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
                    set(handles.aom1_state, 'String', 'Off - Press Start Button To Begin Experiment');
                else
                    set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
                end
                if CFG.record == 1;
                    VideoParams.videodur = CFG.videodur;
                end
                psyfname1 = set_VideoParams_PsyfileName();
                hAomControl = getappdata(0,'hAomControl');
                Parse_Load_Buffers(1);
                set(handles.image_radio1, 'Enable', 'off');
                set(handles.seq_radio1, 'Enable', 'off');
                set(handles.im_popup1, 'Enable', 'off');
                set(handles.display_button, 'String', 'Running Exp...');
                set(handles.display_button, 'Enable', 'off');
                set(handles.aom1_state, 'String', 'On - Experiment Mode - Running Experiment');
            else
                display (' ');
                display (' ');
                display (' ');
                display (' --> Experiment cancelled ');
                display (' ');
                display (' ');
                display (' ');
                TerminateExp;
                return;
                
            end
        end
    end



    function writePsyfileHeader
        
        %         global VideoParams;
        psyfname = set_VideoParams_PsyfileName();
        
        CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
        
        fieldvalues=struct2cell(CFG);
        fieldtags=fieldnames(CFG);
        fields=size(fieldvalues,1);
        tfolder = ['Video Folder: ' VideoParams.videofolder];
        
        
        psyfid = fopen(psyfname,'a');
        for k=1:fields
            if ischar(cell2mat(fieldvalues(k)))
                fprintf(psyfid,'%s\n',[char(fieldtags(k)),': ',char(cell2mat(fieldvalues(k)))]);
            else
                fprintf(psyfid,'%s\n',[char(fieldtags(k)),': ',num2str(cell2mat(fieldvalues(k)))]);
            end
        end
        
        fprintf(psyfid,'%s\n',tfolder);
        
        if psyflag == 1;
            if strcmp(CFG.method,'adjust')
                fprintf(psyfid,'%s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n', psyfname, experiment, response_paradigm, subject, pupil,field, presentdur, iti, videoprefix, videodur);
            end
        end
    end


    function StimSettings
        
        hAomControl = getappdata(0,'hAomControl');
        trialIntensity = 1;
        
        if SYSPARAMS.realsystem == 1
            StimParams.stimpath = dirname;
            StimParams.fprefix = fprefix;
            StimParams.sframe = 2;
            StimParams.eframe = 4;
            StimParams.fext = 'bmp';
            Parse_Load_Buffers(0);
        end
        
        laser_sel = 0;
        if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
            bitnumber = round(8191*(2*trialIntensity-1));
        else
            bitnumber = round(trialIntensity*1000);
        end
        
        
        
        
        Mov.frm = 1;
        Mov.duration = CFG.videodur*fps;
        
        if strcmp(CFG.method,'Adjust')
            message = ['Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast)];
        else
            message = ['Trial ' num2str(trial) ' of ' num2str(Alltrials) ' ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast)];
        end
        Mov.msg = message;
        Mov.seq = '';
        setappdata(hAomControl, 'Mov',Mov);
        
        VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%    sprintf('%03d',trial)
    end
end