function ConeSimulation

global SYSPARAMS StimParams VideoParams AllPaths;
if exist('handles','var') == 0;
    handles = guihandles; else %donothing
end

startup;  % creates tempStimlus folder and dummy frame for initialization

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(ConeSimulationConfig('M')); % wait for user input in Config dialog
CFG = getappdata(hAomControl, 'CFG');
psyfname = [];
matfname = [];
lastSimSet = ['lastSimSetEcc' num2str(CFG.simecc*100) '.mat'];
S4V3 = 0;
% lastSimSet = 'lastSimSet.mat';

% ------------------- Be carefull here -------------------
load('MotionPaths_Sorted2.mat')      % Choose Motion Matrix
% --------------------------------------------------------

if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
    CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
    if CFG.ok == 1
        StimParams.stimpath = CFG.stimpath;
        VideoParams.vidprefix = CFG.vidprefix;
        %disable slider control during exp
        %set(handles.align_slider, 'Enable', 'off');
        set(handles.aom1_state, 'String', 'Configuring Experiment...');
        set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
        if CFG.record == 1;
            VideoParams.videodur = CFG.videodur;
        end
        psyfname = set_VideoParams_PsyfileName();
        matfname = [psyfname(1:end-3),'mat'];
        hAomControl = getappdata(0,'hAomControl');
        Parse_Load_Buffers(1); % not sure what the argument does...
        set(handles.image_radio1, 'Enable', 'off');
        set(handles.seq_radio1, 'Enable', 'off');
        set(handles.im_popup1, 'Enable', 'off');
        set(handles.display_button, 'String', 'Running Exp...');
        set(handles.display_button, 'Enable', 'off');
        set(handles.aom1_state, 'String', 'On - Experiment Mode - Running Experiment');
    else
        return;
    end
end

%setup the keyboard constants from config
kb_StimConst = CFG.kb_StimConst;
kb_AbortConst = CFG.kb_AbortConst;
kb_Modifier = CFG.kb_Modifier;
kb_BadConst = CFG.kb_BadConst;
kb_Left = CFG.kb_Left;
kb_Right = CFG.kb_Right;
kb_hileft = CFG.kb_LeftHi;
kb_loleft = CFG.kb_LeftLo;
kb_loright = CFG.kb_RightLo;
kb_hiright = CFG.kb_RightHi;


fps = 30;
ntrials = CFG.npresent;
viddurtotal = VideoParams.videodur*fps;
stimdur = floor(CFG.presentdur);

%set up MSC params
gain = CFG.gain;
angle = CFG.angle;
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;

writePsyfileHeader; %Experiment specific psyfile header

%generate a sequence that can be used thru out the experiment
framenum = 2; %index of bitmap
startframe = 3; % frame of 30 frame sequence when to start stimulus

%IR

aom0seq = zeros(1,viddurtotal);
aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];

% if CFG.red==0 % Show in IR
%     if CFG.drift==1
%         aom0seq (startframe:startframe+CFG.drift_nframes-1) = 2:CFG.drift_nframes+1;
%     elseif CFG.scan==1
%         aom0seq = ones(1,stimdur).*framenum;
%     else
%         aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
%     end
% else
%     aom0seq = zeros(1,viddurtotal);
% end
%
% if CFG.Xoff ~= 0 || CFG.Yoff ~= 0
%     netcomm('write',SYSPARAMS.netcommobj,int8('RunSLR#'));
%     pause(1);
%     netcomm('write',SYSPARAMS.netcommobj,int8('Fix#'));
%     command = ['Locate#' num2str(CFG.Xoff) '#' num2str(CFG.Yoff) '#']; %#ok<NASGU>
%     netcomm('write',SYSPARAMS.netcommobj,int8(command));
% end
aom0locx = zeros(size(aom0seq));
aom0locy = zeros(size(aom0seq));
%aom0locx = CFG.Xoff.*ones(size(aom0seq));
%aom0locy = -CFG.Yoff.*ones(size(aom0seq)); % Attention: MSC Y coordinates are swapped relative to Matlab Figure

% if CFG.scan==1
% scanningx = 1:CFG.drift_speed:size(aom0locx,2)*CFG.drift_speed;
% %scanningx = scanningx-ceil(max(scanningx)/2);
% aom0locx = aom0locx + scanningx;
% end

aom0pow = ones(size(aom0seq));
aom0pow(:) = 1.000;


%RED
aom1seq = zeros(1,viddurtotal);
% if CFG.red==1 % Show in RED
%     if CFG.drift==1
%         aom1seq (startframe:startframe+CFG.drift_nframes-1) = 2:CFG.drift_nframes+1;
%     else
%         aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
%     end
% else
%     aom1seq = zeros(1,viddurtotal);
% end

aom1pow = ones(size(aom1seq));
aom1pow(:) = 1.000;
% aom1offx = CFG.tcaX.*ones(size(aom1seq));
% aom1offy = -CFG.tcaY.*ones(size(aom1seq));


%GREEN
aom2seq = zeros(1,viddurtotal);
aom2pow = ones(size(aom2seq));
aom2pow(:) = 1.000;
% aom2offx = CFG.tcaX.*ones(size(aom2seq));
% aom2offy = -CFG.tcaY.*ones(size(aom2seq));


if CFG.gainclamp
    gainseq = [ones(1,startframe-1).*gain zeros(1,stimdur) ones(1,30-startframe+1-stimdur).*gain];
else
    gainseq = ones(size(aom1seq)).*gain;
end

angleseq = ones(size(aom1seq)).*angle;

%set up the movie parameters
Mov.frm = 1;
Mov.seq = '';
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
Mov.duration = size(aom0seq,2);
Mov.stimbeep = zeros(1,size(aom0seq,2));
Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.aom0seq = aom0seq;
Mov.aom1seq = aom1seq;
Mov.aom2seq = aom2seq;
Mov.aom0pow = aom0pow;
Mov.aom1pow = aom1pow;
Mov.aom2pow = aom2pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;
% Mov.aom1offx = aom1offx;
% Mov.aom1offy = aom1offy;
% Mov.aom2offx = aom2offx;
% Mov.aom2offy = aom2offy;


%set initial while loop conditions
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
good_check = 1;
correct=1;
ncorrect=0;
% alt=round(rand);
sign=2*ceil(2*rand)-3;
signy=2*ceil(2*rand)-3;
steps=CFG.stepfactor;
stepsy=CFG.stepfactor;
intensity=CFG.first;

offsety=0;

exact=intensity;

MoveIt = CFG.moveoptotype;


if CFG.random  %Make interleaved (static/dynamic) stimulus order
    if ~strcmp(CFG.method,'ConstPsy')
        ntrials = ntrials*2;
        All=[0 0 0 1 1 1];
        i4 = [0 0 1 1];
        i2 = [0 1];
        RanDom = [];
        
        HowMany = floor(ntrials/length(All));
        
        for idx = 1:HowMany % rand permutate 000111 list
            Pre_Choice=All(randperm(6));
            RanDom(idx*6-5:idx*6)=Pre_Choice;
        end
        if mod(ntrials,6)==4 % add if ntrials*2 not divideable by 6
            RanDom = [RanDom i4(randperm(4))];
        elseif mod(ntrials,6)==2
            RanDom = [RanDom i2(randperm(2))];
        end
    end
else
    RanDom = [];
end


if CFG.fixedstimsize
    if ~exist ('StimulusBuffer','var')
       
        if ~CFG.repeatset %Check if repeated set is desired
        tic
        hui=gca;
        offset = (zeros(ntrials,1))';
        alt = (zeros(ntrials,1))';
        P4th = (zeros(ntrials,1))';

        for ii = 1:ntrials
            pre_alt=round(rand);
            [offset(ii),alt(ii)]=newAlt(intensity, correct,pre_alt);
            
            
            if CFG.random
                [StimulusBuffer(:,:,:,ii),P4th(ii)]= computeNextStimulus(offset(ii),alt(ii),handles,RanDom(ii),[]);
            else
                [StimulusBuffer(:,:,:,ii),P4th(ii)]= computeNextStimulus(offset(ii),alt(ii),handles,RanDom,[]);
            end
            
            
            cla(hui);
            
            patch([0,512,512,0],[0,0,512,512],[0,0,0],'Parent',hui,'Erasemode','normal');
            patch([0,512*ii/ntrials,512*ii/ntrials,0],[0,0,20,20],[0,1,0],'Parent',hui,'Erasemode','normal');
            drawnow;
        end
        toc
        cla (hui)
        
        if S4V3
            save(lastSimSet,'StimulusBuffer','P4th','alt','offset','RanDom','MoveIt');
        end
        
        else  % load existing stimulus set
            load(lastSimSet);
            cla(gca);
        end
    end

    
elseif strcmp(CFG.method,'ConstPsy')
    
    if ~CFG.repeatset %Check if repeated set is desired
%         maxSize = 10;   %intensity
%         minSize = 2;    %intensity
        SizeVec = [1:6,8];      % minSize:2:maxSize;
        NumInts = length(SizeVec);
        IntVec_A = zeros(1,ntrials*NumInts);
        IntVec_B = zeros(1,ntrials*NumInts);
        
        % Rand vector: stimulus intensity
        for iex = 1:ntrials % rand permutate intensities list
            Pre_Choice_A=SizeVec(randperm(NumInts));
            IntVec_A(iex*NumInts-(NumInts-1):iex*NumInts)=Pre_Choice_A;     % generate interleaved and pseudo rand intensities for static
            Pre_Choice_B=SizeVec(randperm(NumInts));
            IntVec_B(iex*NumInts-(NumInts-1):iex*NumInts)=Pre_Choice_B;     % generate interleaved and pseudo rand intensities for dynamic
        end
        
        % Rand vector: static-dynamic
        Ntrials = NumInts*ntrials*2;
        All=[0 0 0 1 1 1];
        i4 = [0 0 1 1];
        i2 = [0 1];
        RanDom = [];
        
        HowMany = floor(Ntrials/length(All));
        
        for ifx = 1:HowMany % rand permutate 000111 list
            Pre_Choice=All(randperm(6));
            RanDom(ifx*6-5:ifx*6)=Pre_Choice;
        end
        if mod(Ntrials,6)==4 % add if ntrials*2 not divideable by 6
            RanDom = [RanDom i4(randperm(4))];
        elseif mod(Ntrials,6)==2
            RanDom = [RanDom i2(randperm(2))];
        end
        
        % Stimulus Buffer Generation
        C_A = 1; %Counter Static
        C_B = 1; %Counter Dynamix
        P4th = (zeros(Ntrials,1))';
        alt = (zeros(Ntrials,1))';
        offset = (zeros(Ntrials,1))';
        hui=gca;
        
        for igx = 1:length(RanDom)
            alt(igx)=90*floor(rand*4);
            if RanDom (igx)
                [StimulusBuffer(:,:,:,igx),P4th(igx)]= computeNextStimulus(IntVec_B(C_B),alt(igx),handles,RanDom(igx),[]);
                offset(igx)=IntVec_B(C_B);
                C_B = C_B+1;
            else
                [StimulusBuffer(:,:,:,igx),P4th(igx)]= computeNextStimulus(IntVec_A(C_A),alt(igx),handles,RanDom(igx),[]);
                offset(igx)=IntVec_A(C_A);
                C_A = C_A+1;
            end
            
            cla(hui);
            
            patch([0,512,512,0],[0,0,512,512],[0,0,0],'Parent',hui,'Erasemode','normal');
            patch([0,512*igx/Ntrials,512*igx/Ntrials,0],[0,0,20,20],[0,1,0],'Parent',hui,'Erasemode','normal');
            drawnow;
            
        end
        cla (hui)
        
        if S4V3
            save(lastSimSet,'StimulusBuffer','P4th','alt','offset','RanDom','MoveIt');
        end
        
        ntrials = Ntrials;
        
    else  % load existing stimulus set
        load(lastSimSet);
        ntrials = size(StimulusBuffer,4);
        cla(gca);
    end
    
    
else
    if strcmp(CFG.method,'2d1u') && ~exist ('StimulusBuffer','var')
        alt=round(rand);
        [offset,alt]=newAlt(intensity, correct,alt);
        [StimulusBuffer, P4th] = computeNextStimulus(offset,alt,handles,[],[]);

    end
end
beep


while(runExperiment ==1)
    uiwait;
    % resp = get(handles.aom_main_figure,'CurrentCharacter');
    modifier = get(handles.aom_main_figure,'CurrentModifier');
    key = get(handles.aom_main_figure,'CurrentKey');
    
    
    if strcmp(key,kb_AbortConst)   % Abort Experiment
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);
        
    elseif strcmp(key,kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            
%             if strcmp(CFG.method,'2d1u')
%                 [offset alt]=newAlt(intensity, correct,alt);
%             end
            
            % createStimulus(offset,alt);
            
            %             if SYSPARAMS.realsystem == 1
            %                 StimParams.stimpath = dirname;
            %                 StimParams.fprefix = fprefix;
            %                 StimParams.sframe = 2;
            %
            %                 if CFG.drift==1
            %                     StimParams.eframe = 30;
            %                 else
            %                     StimParams.eframe = 2;
            %                 end
            %
            % %                 StimParams.fext = 'bmp';
            %                 StimParams.fext = 'buf';
            %                 Parse_Load_Buffers(0);
            %             end
            
            Mov.frm = 1;
            % Mov.duration = CFG.videodur*fps;
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            % Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);
            
            VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%
            % PlayMovie;
            
            % displayFigure(offset,alt);
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                showBuffer(StimulusBuffer);
            else
                showBuffer(StimulusBuffer(:,:,:,trial));
            end
                
            
            
            % PresentStimulus = 0;
            GetResponse = 1;
        end
        
    elseif(GetResponse == 1)
        
        
        if strcmp(key,'rightarrow');  % Right response
            response = 0;
            GetResponse = 0;
            good_check = 1;
            displayBlank;
                        
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                alt_trial=alt;
                offset_trial=offset;
                P4th_trial=P4th;
            else
                alt_trial=alt(trial);
                offset_trial=offset(trial);
                P4th_trial=P4th(trial);
            end
            
            if alt_trial==0   % Correct response
                message1 = [Mov.msg ' - RIGHT Response - Correct '];
                ncorrect=ncorrect+1;
                correct=1;
                
                if offset_trial>=CFG.minstep*CFG.stepfactor && ncorrect==2
                    exact=exact/CFG.stepfactor;
                    if ~CFG.fixedstimsize
                    intensity=round(exact); end
                    ncorrect=0;
                end
                
            else        % False response
                message1 = [Mov.msg ' - RIGHT Response - Incorrect'];
                exact=exact*CFG.stepfactor;
                    if ~CFG.fixedstimsize
                
                intensity=round(exact);end
                ncorrect=0;
                correct=0;
            end
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                [offset alt]=newAlt(intensity, correct,alt);
                StimulusBuffer = computeNextStimulus(offset,alt,handles,[],[]);
            end
            beep
            
            
        elseif strcmp(key,'uparrow');  % UP response
            response = 90;
            GetResponse = 0;
            good_check = 1;
            displayBlank;
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                alt_trial=alt;
                offset_trial=offset;
                P4th_trial=P4th;
            else
                alt_trial=alt(trial);
                offset_trial=offset(trial);
                P4th_trial=P4th(trial);
            end
            
            if alt_trial==90   % Correct response
                message1 = [Mov.msg ' - UP Response - Correct '];
                ncorrect=ncorrect+1;
                correct=1;
                
                if offset_trial>=CFG.minstep*CFG.stepfactor && ncorrect==2
                    exact=exact/CFG.stepfactor;
                        if ~CFG.fixedstimsize
                
                    intensity=round(exact);end
                    ncorrect=0;
                end
            else        % False response
                message1 = [Mov.msg ' - UP Response - Incorrect'];
                exact=exact*CFG.stepfactor;
                    if ~CFG.fixedstimsize
                
                intensity=round(exact);end
                ncorrect=0;
                correct=0;
            end
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                [offset alt]=newAlt(intensity, correct,alt);
                StimulusBuffer = computeNextStimulus(offset,alt,handles,[],[]);
            end
            beep
            
        elseif strcmp(key,'leftarrow');  % Left response
            response = 180;
            GetResponse = 0;
            good_check = 1;
            displayBlank;
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                alt_trial=alt;
                offset_trial=offset;
                P4th_trial=P4th;
            else
                alt_trial=alt(trial);
                offset_trial=offset(trial);
                P4th_trial=P4th(trial);
            end
            
            if alt_trial==180   % Correct response
                message1 = [Mov.msg ' - LEFT Response - Correct '];
                ncorrect=ncorrect+1;
                correct=1;
                
                if offset_trial>=CFG.minstep*CFG.stepfactor && ncorrect==2
                    exact=exact/CFG.stepfactor;
                        if ~CFG.fixedstimsize
                
                    intensity=round(exact);end
                    ncorrect=0;
                end
            else        % False response
                message1 = [Mov.msg ' - LEFT Response - Incorrect'];
                exact=exact*CFG.stepfactor;
                    if ~CFG.fixedstimsize
                
                intensity=round(exact);end
                ncorrect=0;
                correct=0;
            end
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                [offset alt]=newAlt(intensity, correct,alt);
                StimulusBuffer = computeNextStimulus(offset,alt,handles,[],[]);
            end
            beep
            
        elseif strcmp(key,'downarrow');  % Down response
            response = 270;
            GetResponse = 0;
            good_check = 1;
            correct=1;
            displayBlank;
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                alt_trial=alt;
                offset_trial=offset;
                P4th_trial=P4th;
            else
                alt_trial=alt(trial);
                offset_trial=offset(trial);
                P4th_trial=P4th(trial);
            end
            
            if alt_trial==270   % Correct response
                message1 = [Mov.msg ' - DOWN Response - Correct '];
                ncorrect=ncorrect+1;
                
                if offset_trial>=CFG.minstep*CFG.stepfactor && ncorrect==2
                    exact=exact/CFG.stepfactor;
                        if ~CFG.fixedstimsize
                
                    intensity=round(exact);end
                    ncorrect=0;
                end
            else        % False response
                message1 = [Mov.msg ' - DOWN Response - Incorrect'];
                exact=exact*CFG.stepfactor;
                    if ~CFG.fixedstimsize
                
                intensity=round(exact);end
                ncorrect=0;
                correct=0;
            end
            
            if strcmp(CFG.method,'2d1u') && ~CFG.fixedstimsize
                [offset alt]=newAlt(intensity, correct,alt);
                StimulusBuffer = computeNextStimulus(offset,alt,handles,[],[]);
            end
            beep
            
            
        elseif strcmp(key,kb_BadConst)
            GetResponse = 0;
            response = 2;
            good_check = 0;
        end;
        
        
        if GetResponse == 0
            if good_check == 1
                message2 = ['Current offset [pixel]: ' num2str(offset_trial)];
                message = sprintf('%s \n%s %s', message1, message2, ['   Path_' num2str(P4th_trial)]);
                set(handles.aom1_state, 'String',message);
               
                %write response to psyfile
%                 MPath = ['Path_' num2str(P4th_trial)];
                psyfid = fopen(psyfname,'a+');%
                fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\r\n',num2str(trial),num2str(offset_trial),num2str(alt_trial),...
                    num2str(response),num2str(correct),num2str(P4th_trial),num2str(MoveIt));
                rawData(trial,:)=[trial offset_trial alt_trial response correct P4th_trial MoveIt];
                fclose(psyfid);
               
                
                %update trial counter
                trial = trial + 1;
                
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    TerminateExp;
                    message = ['Off - Experiment Complete - Last Absolute Offset: ' num2str(abs(offset_trial))];
                    set(handles.aom1_state, 'String',message);
                    plotResult(rawData, psyfname)
                    
                    save(matfname,'rawData','StimulusBuffer');
                end
            end
            PresentStimulus = 1;
        end
    end
    
    
    
end
%do clean up
clear CFG GetResponse PresentStimulus actstimind kb_AbortConst kb_UpArrow kb_RightArrow kb_DownArrow kb_LeftArrow kb_StimConst mapping message message1 movie_seq psyfid psyfname resp response runExperiment seqfname trial;
rmappdata(getappdata(0,'hAomControl'), 'CFG');



function [offset alt]=newAlt(intensity, correct, alt) %#ok<*INUSD>

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

offset=intensity;
alt=90*floor(rand*4);  %random rotation about [0,90,180,270] degrees

function writePsyfileHeader

global VideoParams;
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


%
%
% experiment = 'Experiment Name: Vernier';
% subject = ['Observer: ' CFG.initials];
% field = ['Field Size (deg): ' num2str(CFG.fieldsize)];
% presentdur = ['Presentation Duration (frames): ' num2str(CFG.presentdur)];
% tbarheight= ['Bar Height [Pixel]: ' num2str(CFG.barheight)];
% tdotsize= ['Bar/Dot Size [Pixel]: ' num2str(CFG.dotsize)];
% tdotseparation= ['Bar/Dot Separation [Pixel]: ' num2str(CFG.dotseparation)];
% videoprefix = ['Video Prefix: ' CFG.vidprefix];
% videodur = ['Video Duration: ' num2str(CFG.videodur)];
% tstimulus = ['Optotype: ' CFG.optotype];
% method = ['Psychophysical method: ' CFG.method];
% tchannel = ['Red channel: ' num2str(CFG.red)];
% tgain = ['Gain: ' num2str(CFG.gain)];
% tangle = ['Angle: ' num2str(CFG.angle)];

% fprintf(psyfid,'%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n\n',...
%     psyfname, experiment, subject, field,...
%     presentdur, tstimulus, tbarheight, tdotsize,...
%     tdotseparation, videoprefix, videodur, method,...
%     tchannel, tgain, tangle, tfolder);

if strcmp(CFG.method,'adjust')
    fprintf(psyfid,'%s\t %s\t %s\t %s\r\n', 'Trial', 'Offset', 'Reversal?', 'Response (left:negative, higher value = higher confidence)' );   % Add header for data table here (columnwise)
elseif strcmp(CFG.method,'2d1u')
    fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\r\n', 'Trial', 'Offset', 'Alternative', 'Response', 'Correct?' );   % Add header for data table here (columnwise)
end

fclose(psyfid);

function createStimulus(offset,alt)

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');


n_frames=1;

%
% gap=(offset);
% padw=gap;
% e=zeros(gap*5,gap*5);
% e(gap+1:2*gap,gap+1:end)=1;
% e(3*gap+1:4*gap,gap+1:end)=1;
% padh=ones(padw,size(e,2));
% padv=ones(size(e,1)+2*padw,padw);
% E=[padh;e;padh];
% E=[padv E padv];
% E=imrotate(E,alt);
% canv=E;

%
% % Axes geometry determining figure size
% previewPosition = get(gca,'Position');
previewHeight = 300;
previewWidth = 300;

% % Colors
% optoR = CFG.optoR;
% optoG = CFG.optoG;
% optoB = CFG.optoB;
% backR = CFG.backR;
% backG = CFG.backG;
% backB = CFG.backB;

gap = offset;

%% make E
padw=gap;
e=zeros(gap*5,gap*5);
e(gap+1:2*gap,gap+1:end)=1;
e(3*gap+1:4*gap,gap+1:end)=1;
padh=ones(padw,size(e,2));
padv=ones(size(e,1)+2*padw,padw);
E=[padh;e;padh];
E=[padv E padv];
E=imrotate(E,alt); % This is controlling the random opening
canv=E;
padheight=previewHeight-size(canv,1);
padhl=floor(padheight/2);
padhu=ceil(padheight/2);
padwidth=previewWidth-size(canv,2);
padwl=floor(padwidth/2);
padwr=ceil(padwidth/2);
padt=ones(padhl,size(canv,2));
padb=ones(padhu,size(canv,2));
padl=ones(previewHeight,padwl);
padr=ones(previewHeight,padwr);
prev=[padt;canv;padb];
prev=[padl prev padr];
prev=imresize(prev,[previewHeight previewWidth]);

PreviewBuffer = prev;

% PreviewBuffer = cat(3,zeros(size(prev,1),size(prev,2)),zeros(size(prev,1),size(prev,2)),zeros(size(prev,1),size(prev,2)));
% 
% for m = 1: size(prev,1)
%     for n = 1: size(prev,2)
%         if prev(m,n)
%             PreviewBuffer(m,n,1)=backR;
%             PreviewBuffer(m,n,2)=backG;
%             PreviewBuffer(m,n,3)=backB;
%         else
%             PreviewBuffer(m,n,1)=optoR;
%             PreviewBuffer(m,n,2)=optoG;
%             PreviewBuffer(m,n,3)=optoB;
%         end
%     end
% end


% CONE SIMULATION  -----------------
if CFG.simulation
    
    width = previewWidth;
    height = previewHeight;
    conefield = zeros(height,width); % start with empty canvas
    eccentricity = CFG.simecc; % get ecc from input
    jitter = CFG.simregularity; % get regularity parameter from input (0 = perfect hex)
    pixelpitch = CFG.pixelpitch; % used to calculate cone spacing
    viewingdistance = CFG.viewingdistance; % used to calculate cone spacing
    pixelmagnification = 60*atand(pixelpitch/viewingdistance); % Arcmin/pixel
    
    a1 = 1.6570; s1 = -0.0222; a2 = -1.0490; s2 = 0.4358; % Best Fit Roorda lab data basis, May 2013
    spacing = a1*exp(-s1.*eccentricity)+a2*exp(-s2.*eccentricity);% in arcmin
    spacing = floor(spacing/pixelmagnification); % now in pixel
    
    border = 15;
    nconesi = length(1+border:spacing:height-border);
    nconesj = length(1+border:spacing:width-border);
    ncones = nconesi*nconesj;
    
    randjitter = rand(ncones,2);
    randjitter = floor(jitter/2-randjitter*jitter);
    
    n = 0;
    indexcount = 1;
    
    for i=1+border:spacing:height-border
        
        for j=1+border:spacing:width-border
            if mod(n,2)==0
                conefield(i+randjitter(indexcount,1),j+randjitter(indexcount,2)+floor(spacing/2))=1;
            else
                conefield(i+randjitter(indexcount,1),j+randjitter(indexcount,2))=1;
            end;
            indexcount = indexcount + 1;
        end;
        n=n+1;
    end;
    
    gfcones=fspecial('gaussian',50,2);
    conefield=imfilter(conefield,gfcones,'replicate');
    
    gfopto=fspecial('gaussian',25,2.5);
    PreviewBuffer = imfilter(PreviewBuffer,gfopto,'replicate');
    
    % Shifting around
    deltac = 2-4*rand;  % Shift in X (negative because of shift algorithm)
    deltar = 2-4*rand;  % Shift in Y
    f=im2double(conefield);
    phase = 2; [nr,nc]=size(f);
    Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
    Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
    [Nc,Nr] = meshgrid(Nc,Nr);
    g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
    conefield=abs(g);
    
    
    % Mulitplication and normalization of Stimulus with Conefield
    PreviewBuffer(:,:,1) = PreviewBuffer(:,:,1).*conefield;
    PreviewBuffer(:,:,2) = PreviewBuffer(:,:,2).*conefield;
    PreviewBuffer(:,:,3) = PreviewBuffer(:,:,3).*conefield;
    PreviewBuffer(:,:,1) = PreviewBuffer(:,:,1)./max(max((PreviewBuffer(:,:,1))));
    PreviewBuffer(:,:,2) = PreviewBuffer(:,:,2)./max(max((PreviewBuffer(:,:,2))));
    PreviewBuffer(:,:,3) = PreviewBuffer(:,:,3)./max(max((PreviewBuffer(:,:,3))));
    
end
% -----------------

canv = PreviewBuffer(:,:,1);


if ~isempty(canv(canv>1)) % to avoid ripple
    canv(canv>1)=1;
end


cd([pwd,'\tempStimulus']);

imwrite(canv,'frame2.bmp');
fid = fopen('frame2.buf','w');
fwrite(fid,size(canv,2),'uint16');
fwrite(fid,size(canv,1),'uint16');
fwrite(fid, canv, 'double');
fclose(fid);

cd ..;

function startup

dummy=ones(10,10);
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    
    imwrite(dummy,'frame2.bmp');
    fid = fopen('frame2.buf','w');
    fwrite(fid,size(dummy,2),'uint16');
    fwrite(fid,size(dummy,1),'uint16');
    fwrite(fid, dummy, 'double');
    fclose(fid);
else
    cd([pwd,'\tempStimulus']);
    delete *.bmp
    delete *.buf
    imwrite(dummy,'frame2.bmp');
    fid = fopen('frame2.buf','w');
    fwrite(fid,size(dummy,2),'uint16');
    fwrite(fid,size(dummy,1),'uint16');
    fwrite(fid, dummy, 'double');
    fclose(fid);
end
cd ..;

function plotResult(rawData, psyfname)

hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');


data=abs(rawData);
%trial_n=data(:,1);
stim_int=abs(data(:,2));
%     stim_alt=data(:,3);
%     resp_cor=data(:,4);

% Initial parameters
fixes=struct;
fixes.fix=1;
fixes.up=20;
fixes.uLevel=1.0;
fixes.uN=1;
fixes.low=0.001;
fixes.lLevel=0.25;
fixes.lN=100;
runs=100;
% End initials

% Stats
% nstimr=sum(stim_alt);
%     pstimr=nstimr/max(trial_n);
%  nrespr=length([intersect(find(resp_cor==1),find(stim_alt==1));intersect(find(resp_cor==0),find(stim_alt==0))]);
%    prespr=nrespr/max(trial_n);

% Compute result matrix
stimuli=unique(sort(stim_int));
nstimuli=size(stimuli,1);
% result = zeros(nstimuli,3,'double');
result_dyn=zeros(nstimuli,3,'double');
result_stat=zeros(nstimuli,3,'double');
rightcor=zeros(nstimuli,1,'double');
righttotal=zeros(nstimuli,1,'double');
rightfalse=zeros(nstimuli,1,'double');
leftfalse=zeros(nstimuli,1,'double');
leftcor=zeros(nstimuli,1,'double');

for i=1:size(data,1);
    pos = find(stimuli==data(i,2));
    if data(i,5)==1 && data(i,6)==0
        result_stat(pos,2)=result_stat(pos,2)+1;
    elseif data(i,5)==1
        result_dyn(pos,2)=result_dyn(pos,2)+1;
    end
    
    if data(i,3)==1 && data(i,4)==1
        rightcor(pos,1)=rightcor(pos,1)+1;end
    
    if data(i,3)==0 && data(i,4)==1
        leftcor(pos,1)=leftcor(pos,1)+1;end
    
    if data(i,3)==1 && data(i,4)==0
        rightfalse(pos,1)=rightfalse(pos,1)+1;end
    
    if data(i,3)==0 && data(i,4)==0
        leftfalse(pos,1)=leftfalse(pos,1)+1;end
    
    if (data(i,3)==1)
        righttotal(pos,1)=righttotal(pos,1)+1;end
    
%     result_stat(pos,3)=result_stat(pos,3)+1;
    result_stat(:,1)=stimuli;
%     result_dyn(pos,3)=result_dyn(pos,3)+1;
    result_dyn(:,1)=stimuli;
end

for ihx=1:nstimuli
    result_stat(ihx,3)=sum(data(:,6)==0 & data(:,2)==stimuli(ihx));       % number trials
    result_dyn(ihx,3)= sum(data(:,6)~=0 & data(:,2)==stimuli(ihx));       % number trials
end

if strcmp(CFG.method,'ConstPsy')
    ncorrect_stat = result_stat(:,2);
    ncorrect_dyn = result_dyn(:,2);
else
    ncorrect_stat = sum(result_stat(:,2));
    ncorrect_dyn = sum(result_dyn(:,2));
end

for i=1:nstimuli;
    result_stat(i,2)= result_stat(i,2)/result_stat(i,3);
    result_dyn(i,2)= result_dyn(i,2)/result_dyn(i,3);
end;

result_stat = [result_stat ncorrect_stat]; 
result_dyn = [result_dyn ncorrect_dyn];

results_static= num2str(result_stat,'   %1.3f');
results_dynamic= num2str(result_dyn,'   %1.3f');

if result_stat(1,3)~=0 && result_dyn(1,3)==0
    display(results_static);
    result = [stimuli (ncorrect_stat)/result_stat(1,3) result_stat(1,3) (ncorrect_stat)];
elseif result_dyn(1,3)~=0 && result_stat(1,3)==0
    display(results_dynamic);
    result = [stimuli (ncorrect_dyn)/result_dyn(1,3) result_dyn(1,3) (ncorrect_dyn)];
elseif result_stat(1,3)~=0 && result_dyn(1,3)~=0
    display(results_static);
    display(results_dynamic);
    if ~strcmp(CFG.method,'ConstPsy')
        result = [stimuli (ncorrect_stat+ncorrect_dyn)/(result_stat(1,3)+result_stat(1,3))...
            (result_stat(1,3)+result_stat(1,3)) (ncorrect_stat+ncorrect_dyn)];
    end
end


% % Compute bias matrix
% %  stimuluslevel= result(:,1)';
% lefttotal=result(:,3)-righttotal;
% HIT=rightcor./righttotal;
% FA=rightfalse./lefttotal;
% MISS=leftfalse./righttotal;
% CREJ=leftcor./lefttotal;
% for zt=1:length(HIT)
%     if HIT(zt)<FA(zt)
%         HIT(zt)=1-HIT(zt);
%         FA(zt)=1-FA(zt);
%     end
% end
% 
% bias=struct;
% bias.Result=result;
% bias.HitRate=HIT;
% bias.FalseAlarmRate=FA;
% bias.MissRate=MISS;
% bias.CorrRejRate=CREJ;

%     if CFG.plotcomplex == 0 % Engage once fitting is ready with PALAMEDES

% %%%%%%%%%%%%%%%% Simple Plot: Staircase + Intensity vs Performance
% figure('Position',[475 518 800 351]);
% subplot(1,2,1);
% stairs(abs(stim_int),'k');
% hold on
% plot(abs(stim_int),...
%     'Marker','o',...
%     'LineStyle','none',...
%     'MarkerEdgeColor',[0.0 0.0 0.0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',4);
% text(0.94*size(stim_int,1),stim_int(end)+2,['n = ',num2str(size(stim_int,1))],...
%     'FontSize',7.5,...
%     'Color','r');
% xlabel('Trial number');
% ylabel('Gap size [Pixel]');
% title('Staircase');
% xlim([0 size(stim_int,1)*1.1]);
% ylim([-0.5 max(abs(stim_int))*1.05]);
% axis square
% hold off
% 
% 
% subplot(1,2,2);
% 
% semilogx(result(:,1),result(:,2),...
%     'LineStyle','none');
% xlimlo=min(result(:,1))/CFG.stepfactor;
% xlimhi=max(result(:,1))*CFG.stepfactor;
% 
% 
% % Histogram
% x=result(:,1);
% z=result(:,3);
% h=stem(x,0.35+(z./(max(z)*4)));
% set(h, 'Color',[0.8 0.8 0.8],...
%     'Marker','none',...
%     'LineWidth',4);
% hold on
% axis square
% 
% xlabel('Gap size [Pixel]');
% ylabel('Discrimination performance');
% title('Psychometric Function');
% 
% xlim([xlimlo xlimhi]);
% 
% ylim([0.05 1.05]);
% 
% axis square
% hold on
% markerSize=8*result(:,3)./max(result(:,3));
% for k = 1: size(result,1)
%     plot(result(k,1),result(k,2),...
%         'Marker','o',...
%         'LineStyle','none',...
%         'MarkerEdgeColor',[0.0 0.0 0.0],...
%         'MarkerFaceColor',[0.5 0.5 0.5],...
%         'MarkerSize',markerSize(k));
%     text(result(k,1),result(k,2)-0.04,num2str(result(k,3)),...
%         'FontSize',7.5,...
%         'Color','r');
%     hold on
% end
% hold off
% set(gca,'Layer','Top');
% set(gcf,'PaperPositionMode','auto')
% 
% 
% 
% 
% 
% %     elseif CFG.plotcomplex == 1   % do the folllowing only when ticked in Config window
% %
% %
% %         % Fix upper and lower asymptote
% %         if fixes.fix==1
% %             result = [fixes.low fixes.lLevel fixes.lN; result];
% %             result =[result; fixes.up fixes.uLevel fixes.uN];
% %         end
% %
% %         % Pfit will run in its folder only
% %         dirtext=pwd; temptext=which('pfit');
% %         if exist(temptext,'file')==0; error('Script halted: install pfit first');
% %         else pfittext=temptext(1:length(temptext)-6); cd (pfittext); end
% %
% %         % Call PFIT
% %         if strcmp(CFG.optotype,'E')
% %             [fit fullfit]=pfit(result,'Runs',runs,'n_intervals',4,'LAMBDA_LIMITS',[0 0.2]);
% %
% %         else
% %             [fit fullfit]=pfit(result,'Runs',runs,'LAMBDA_LIMITS',[0 0.2]);
% %         end
% %         display(resulttext);
% %         cd (dirtext);
% %
% %         % Delete asymptote fixation from result matrix
% %         if fixes.fix==1
% %             result(1,:)=[];
% %             result(end,:)=[];
% %         end
% %
% %
% %         psyfit=struct;
% %         psyfit.filename=psyfname;
% %         psyfit.raw=rawData;
% %         psyfit.result=result;
% %         psyfit.resulttext=resulttext;
% %         psyfit.bias=bias;
% %         psyfit.fit=fit;
% %         psyfit.fullfit=fullfit;
% %         psyfit.fixes=fixes;
% %
% %         save([psyfit.filename(1:end-4),'_psyfit.mat'],'psyfit');
% %
% %
% %         % 01 - Psychometric Function
% %
% %         alpha= psyfit.fit.params.est(1);
% %         beta= psyfit.fit.params.est(2);
% %         gamma= psyfit.fit.params.est(3);
% %         lambda= psyfit.fit.params.est(4);
% %         schw=psyfit.fit.thresholds.est(2);
% %         limu=psyfit.fit.thresholds.lims(2,2);
% %         limo=psyfit.fit.thresholds.lims(3,2);
% %
% %         %xfit=[min(psyfit.result(:,1))/20:0.05:max(psyfit.result(:,1))*10];
% %         if strcmp(CFG.optotype,'E')
% %             xfit=0.1:0.01:20;
% %         else
% %             xfit=0.01:0.01:10;
% %         end
% %
% %         ylog = 1 ./ (1 + exp((alpha - xfit) ./ beta));
% %         % yweib = 1 - exp(-(xfit ./ alpha) .^ beta);
% %         % ygumb = 1 - exp(-exp((xfit - alpha) ./ beta));
% %         ypsi = gamma + (1 - gamma - lambda) * ylog;
% %
% %         yschw=1 ./ (1 + exp((alpha - schw) ./ beta));
% %         yschw= gamma + (1 - gamma - lambda) * yschw;
% %
% %         % Full simulation data = multiple PFs
% %         %         a=psyfit.fullfit.params.sim(:,1);
% %         %         b=psyfit.fullfit.params.sim(:,2);
% %         %          g=psyfit.fullfit.params.sim(:,3);
% %         %          l=psyfit.fullfit.params.sim(:,4);
% %         %         runs=length(a);
% %         %         %matr=ones(runs,1);
% %         %xs=matr*xfit;
% %
% %         %         for ii=1:runs
% %         %             ylog = 1 ./ (1 + exp((a(ii) - xfit) ./ b(ii)));
% %         %             %ypsiFull(ii,:) = g(ii) + (1 - g(ii) - l(ii)) * ylog;
% %         %         end
% %
% %         x=psyfit.result(:,1);
% %         %         y=psyfit.result(:,2);
% %         z=psyfit.result(:,3);
% %         %         maxSize=max(psyfit.result(:,3));
% %         %         maxN=15;
% %         %         minN=2;
% %
% %         figure('ActivePositionProperty','OuterPosition','OuterPosition',[75 200 1000 400]);
% %
% %         subplot(1,3,1);
% %         stairs(abs(stim_int),'k');
% %         hold on
% %         plot(abs(stim_int),...
% %             'Marker','o',...
% %             'LineStyle','none',...
% %             'MarkerEdgeColor',[0.0 0.0 0.0],...
% %             'MarkerFaceColor',[0.5 0.5 0.5],...
% %             'MarkerSize',4);
% %         text(0.94*size(stim_int,1),stim_int(end)+2,['n = ',num2str(size(stim_int,1))],...
% %             'FontSize',7.5,...
% %             'Color','r');
% %         xlabel('Trial number');
% %         ylabel('Offset [Pixel]');
% %         title('Staircase');
% %         xlim([0 size(stim_int,1)*1.1]);
% %         ylim([-0.5 max(abs(stim_int))*1.05]);
% %         axis square
% %         hold off
% %
% %
% %         subplot(1,3,2);
% %         if strcmp(CFG.stim,'subp') && CFG.stepfactor~=1
% %             semilogx(result(:,1),result(:,2),...
% %                 'LineStyle','none');
% %             xlimlo=min(result(:,1))/CFG.stepfactor;
% %             xlimhi=max(result(:,1))*CFG.stepfactor;
% %         elseif strcmp(CFG.optotype,'E')
% %             semilogx(result(:,1),result(:,2),...
% %                 'LineStyle','none');
% %             xlimlo=min(result(:,1))/CFG.stepfactor;
% %             xlimhi=max(result(:,1))*CFG.stepfactor;
% %         else
% %             plot(result(:,1),result(:,2),'k');
% %             xlimlo=-0.5;
% %             xlimhi=max(result(:,1))*1.1;
% %         end
% %
% %         xlabel('Offset [Pixel]');
% %         ylabel('Discrimination performance');
% %         title('Psychometric Function');
% %
% %         xlim([xlimlo xlimhi]);
% %         if strcmp(CFG.optotype,'E')
% %             ylim([0.05 1.05]);
% %         else
% %             ylim([0.35 1.05]);
% %         end
% %         axis square
% %         hold on
% %
% %         % Histogram
% %         h=stem(x,0.35+(z./(max(z)*4)));
% %         set(h, 'Color',[0.8 0.8 0.8],...
% %             'Marker','none',...
% %             'LineWidth',4);
% %         hold on
% %         axis square
% %
% %
% %         plot(xfit,ypsi,'k','LineWidth',1)
% %         %
% %         %     title(psyfit.filename)
% %         title(['Threshold:  ',num2str(schw,'%1.3f'),' @ ',num2str(yschw,'%1.2f')]);
% %
% %         % text(0.1,1,['Thr:  ',num2str(schw,'%1.3f'),' @ ',num2str(yschw,'%1.2f')]);
% %         %text(0.5,0.96,['CI: [',num2str(limu,'%1.3f'),',',num2str(limo,'%1.3f'),']']);
% %         %text(0.5,0.92,['N = ',num2str(sum(psyfit.result(:,3)),'%3.0i')]);
% %         % text(10,0.75,['n stim RIGHT = ',num2str(nstimr,'%3i')]);
% %         % text(10,0.72,['n resp RIGHT = ',num2str(nrespr,'%3i')]);
% %         %text(0.5,0.88,psyfit.resulttext,'FontSize',[6],...
% %         %     'HorizontalAlignment','left',...
% %         %         'VerticalAlignment','top');
% %
% %         %         if psyfit.fixes.fix
% %         %             fixly=psyfit.fixes.lLevel-0.02;
% %         %             fixlx=0.1;
% %         %             fixuy=psyfit.fixes.uLevel+0.02;
% %         %             fixux=9;
% %         %
% %         %             text(fixlx,fixly,[num2str(psyfit.fixes.low),...
% %         %                 ',',num2str(psyfit.fixes.lLevel),',',num2str(psyfit.fixes.lN)],...\
% %         %                 'FontSize',[6],'Color',[1 0 0]);
% %         %             text(fixux,fixuy,[num2str(psyfit.fixes.up),...
% %         %                 ',',num2str(psyfit.fixes.uLevel),',',num2str(psyfit.fixes.uN)],...\
% %         %                 'FontSize',[6],'Color',[1 0 0]);
% %         %         end
% %
% %         plot(schw,yschw,'ok','LineWidth',2)
% %         line([limu limo],[yschw yschw],'Color',[0 0 0],'LineWidth',2)
% %
% %
% %         markerSize=8*result(:,3)./max(result(:,3));
% %         for k = 1: size(result,1)
% %             plot(result(k,1),result(k,2),...
% %                 'Marker','o',...
% %                 'LineStyle','none',...
% %                 'MarkerEdgeColor',[0.0 0.0 0.0],...
% %                 'MarkerFaceColor',[0.5 0.5 0.5],...
% %                 'MarkerSize',markerSize(k));
% %             text(result(k,1),result(k,2)-0.04,num2str(result(k,3)),...
% %                 'FontSize',7.5,...
% %                 'Color','r');
% %             hold on
% %         end
% %
% %         set(gca,'Layer','Top');
% %         hold off
% %
% %
% %
% %         % 03 - Bias plot ---------------------------------------
% %         % Iso-bias curves
% %         xc=0:0.05:1;
% %         ISO_bias1=[0.0 -1.0 -0.75 -0.50 -0.25 -0.10]; %%% negative = bias to HORIZONTAL = lower part in ROC%%%
% %         ISO_bias2=[1. 0.75 0.50 0.25 0.10]; %%% positive = bias to VERTICAL = upper part in ROC%%%
% %
% %         x_bias1=zeros(length(xc),length(ISO_bias1));
% %         y_bias1=zeros(length(xc),length(ISO_bias1));
% %         x_bias2=zeros(length(xc),length(ISO_bias1));
% %         y_bias2=zeros(length(xc),length(ISO_bias1));
% %
% %         for i=1:1:length(ISO_bias1)
% %             yc=(1+ ISO_bias1(i))*xc;
% %             y_bias1(:,i)=1-((1-yc).*xc)./(1-xc.*yc);
% %             x_bias1(:,i)=1-(yc-1)./(xc.*yc-1);
% %         end
% %         for i=1:1:length(ISO_bias2)
% %             yc=(1- ISO_bias2(i))*xc;
% %             y_bias2(:,i)=1-((1-yc).*xc)./(1-xc.*yc);
% %             x_bias2(:,i)=1-(yc-1)./(xc.*yc-1);
% %         end
% %
% %         %%% ROC CURVES %%%
% %         xc=-3:0.05:3;
% %         n1= cdf( 'Normal',xc,0,1);
% %         sensitivity=[0 0.34 0.70 1.2 1.8]; % d-prime
% %         n1function=zeros(length(xc),length(sensitivity));
% %         n2function=zeros(length(xc),length(sensitivity));
% %         for i=1:1:length(sensitivity)
% %             n1function(:,i)=n1;
% %             n2function(:,i)= cdf( 'Normal' ,xc,sensitivity(i),1);
% %         end
% %
% %
% %         subplot(1,3,3)
% %
% %         plot(psyfit.bias.FalseAlarmRate(1),psyfit.bias.HitRate(1),...
% %             'MarkerSize',8,...
% %             'Marker','o',...
% %             'LineStyle','none',...
% %             'LineWidth',1,...
% %             'MarkerEdgeColor',[0.0 0.0 0.0],...
% %             'MarkerFaceColor',[0.5 0.5 0.5]);
% %         text(psyfit.bias.FalseAlarmRate(1)+0.02,psyfit.bias.HitRate(1)-0.02,[num2str(psyfit.result(1,1)),',',num2str(psyfit.result(1,3))],'FontSize',7)
% %         axis([-.05 1.05 -.05 1.05])
% %         hold on
% %
% %         for z=2:size(psyfit.bias.HitRate,1)
% %             plot(psyfit.bias.FalseAlarmRate(z),psyfit.bias.HitRate(z),...
% %                 'MarkerSize',8,...
% %                 'Marker','o',...
% %                 'LineStyle','none',...
% %                 'LineWidth',1,...
% %                 'MarkerEdgeColor',[0.0 0.0 0.0],...
% %                 'MarkerFaceColor',[0.5 0.5 0.5]);
% %             text(psyfit.bias.FalseAlarmRate(z)+0.02,psyfit.bias.HitRate(z)-0.02,[num2str(psyfit.result(z,1)),',',num2str(psyfit.result(z,3))],'FontSize',7)
% %         end
% %         xlabel('False alarm rate, p(1|0)');
% %         ylabel('Hit rate, p(1|1)');
% %         title('ROC')
% %
% %         plot(x_bias1,y_bias1, 'k-' )
% %         for zz=2:length(ISO_bias1)
% %             text(((0.07*zz)-0.15),0.30,num2str(abs(ISO_bias1(zz))),'FontSize',6);
% %         end
% %         text(0.069*(length(ISO_bias1)+1)-0.15,0.3,'bias','FontSize',6);
% %
% %         plot(n2function, n1function, 'Color',[0.7 0.7 0.7])
% %         for zz=1:length(sensitivity)
% %             text(0.65,(0.55+0.09*zz),num2str(sensitivity(zz)),'FontSize',6,...
% %                 'Color',[0.7 0.7 0.7]);
% %         end
% %         text(0.65,0.60,'d-prime','FontSize',6,...
% %             'Color',[0.7 0.7 0.7]);
% %         axis square
% %         grid off
% %
% %         set(gcf,'PaperPositionMode','auto')
% %
% %     end
% 
% 
% % % SAVING TO FILE:
% % print(gcf,'-depsc2',[psyfit.filename(1:end-4),'_PLOT']);
% % print(gcf,'-dpng',[psyfit.filename(1:end-4),'_PLOT']);



% function  displayFigure(offset,alt)

function  [StimulusBuffer,P4th] = computeNextStimulus(offset,alt,handles,RanDom,trial)

% handles = guihandles;
CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
% axes(get(handles.im_panel1, 'Child'));

if ~isempty(RanDom)
    CFG.dynamic=RanDom;
end

% previewPosition = get(gca,'Position');

previewHeight = 150;
previewWidth = 150;
gap = offset;

% % make E
e=zeros(gap*5,gap*5);
e(gap+1:2*gap,gap+1:end)=1;
e(3*gap+1:4*gap,gap+1:end)=1;
E=imrotate(e,alt);
PreviewBuffer=ones(previewHeight,previewWidth);
ylo = floor(previewHeight/2)-floor(gap*5/2);
yhi = ylo-1+gap*5;
xlo = floor(previewWidth/2)-floor(gap*5/2);
xhi = xlo-1+gap*5;
PreviewBuffer(ylo:yhi,xlo:xhi)=E;

if CFG.stiminvert
    PreviewBuffer=PreviewBuffer.*(-1)+1;
end

if ~CFG.simulation
    StimulusBuffer(:,:,:,1) = repmat (im2uint8(PreviewBuffer),[1 1 22]);
    P4th=0;
end



% CONE SIMULATION
% -------------------------------------------------------------------
% -------------------------------------------------------------------

if CFG.simulation
    
    width = previewWidth;
    height = previewHeight;
    eccentricity = CFG.simecc; % get ecc from input
    jitter = CFG.simregularity; % get regularity parameter from input (0 = perfect hex)
    a1 = 1.6570; s1 = -0.0222; a2 = -1.0490; s2 = 0.4358; % Best Fit Roorda lab data basis, May 2013
    spacing = a1*exp(-s1.*eccentricity)+a2*exp(-s2.*eccentricity);% in arcmin
    spacing = floor((400/60)*spacing);     % in pixel
    border = 8;
    nconesi = length(1+border:spacing:height-border);
    nconesj = length(1+border:spacing:width-border);
    ncones = nconesi*nconesj;
    randjitter = rand(ncones,2);
    randjitter = floor(jitter/2-randjitter*jitter);
   
    n = 0;
    indexcount = 1;
    
    for i=1+border:spacing:height-border
        for j=1+border:spacing:width-border
            if mod(n,2)==0
                xc(indexcount,:)=(j+randjitter(indexcount,2)+floor(spacing/2));
                yc(indexcount,:)=(i+randjitter(indexcount,1));
            else
                xc(indexcount,:)=(j+randjitter(indexcount,2));
                yc(indexcount,:)=(i+randjitter(indexcount,1));
            end;
            indexcount = indexcount + 1;
        end;
        n=n+1;
    end;
    xc = xc-floor(previewWidth/2); % Position around origin before rotation
    yc = yc-floor(previewHeight/2);
    
    % Rotation about random angle [-30:1:30]
    rotationangle = floor(-30+rand(1)*60);
    nSize = size(xc);
    theta = rotationangle * pi/180;
    mRot = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    vRot = [xc(:) yc(:)]*mRot;
    xcr = reshape(vRot(:,1), nSize);
    ycr = reshape(vRot(:,2), nSize);
    
    xcr = floor(xcr+(previewWidth/2)); % Reposition and cropping
    ycr = floor(ycr+(previewHeight/2));
    cones = [ycr xcr];
    cones(logical((ycr<=0+border)+(xcr<=0+border)+(ycr>=previewHeight-border)+(xcr>=previewWidth-border)),:)=[];
    
    yi = cones(:,1);
    xi = cones(:,2);
    
    spotSize=2*spacing;
    Aperture = 3.1243/2.35482;       % in pixel --- computed by "get_fwhm_curcio.m": ecc = 1°, scaling = 400
    Aperture = CFG.simaperture*Aperture;
    spot = single(fspecial('gaussian', spotSize, Aperture)); %generate Gaussian (SpotSize=ConeSize pixels wide)
    spot = spot./max(spot(:)); %normalize Gaussian
   
    
    if CFG.dynamic
        
        % Create list of new cone positions
        increment = CFG.motiongain; % GAIN for walk, could be random
        numberofframes = 22;
        maxexcur = CFG.motionmax;
        
        r=[0 0]; % startposition
        
        if CFG.realmotion
            [rnew,P4th] = getmotion(trial); % real motion from AOSLO experiments, random choice from 7 paths
        else
            P4th = -1;
            for t= 1:1:numberofframes  %make Brownian motion path
                B1=rand(1,2); B=B1>0.5;
                if B==1  % walk the 4 directions
                    rnew(t,:)=r+[increment 0];
                elseif B(1)==1
                    rnew(t,:)=r+[0 increment];
                elseif B(2)==1
                    rnew(t,:)=r+[-increment 0];
                else
                    rnew(t,:)=r+[0 -increment];
                end
                
                if rnew(t,1)>=maxexcur || rnew(t,1)<=-maxexcur  % avoid too much drift, i.e. introduce 'microsaccades' towards origin
                    rnew(t,1) = 0+(1-rand*2);
                elseif rnew(t,2)>=maxexcur || rnew(t,2)<=-maxexcur
                    rnew(t,2)= 0+(1-rand*2);
                end
                r=rnew(t,:) ;
            end
        end
        
        Factor=floor(size(spot,1)/2);
        InnerSegment=round(Aperture/0.48);
        [Cols,Rows] = meshgrid(1:previewWidth, 1:previewHeight);
        
        [ColsS,RowsS] = meshgrid(1:spotSize, 1:spotSize);
        AllMat=(ColsS-(spotSize/2)).^2+(RowsS-(spotSize/2)).^2 <= InnerSegment.^2;
        AllC = sum(sum(AllMat.*spot));
        
        
        for nf = 1:length(rnew)
            PreviewBuffer1=zeros(previewWidth,previewHeight);
            
            deltac = -rnew(nf,1);  % Shift in X (negative because of shift algorithm)
            deltar = rnew(nf,2);  % Shift in Y
            
            f=im2double(PreviewBuffer(:,:,1));
            if CFG.moveoptotype
                phase = 2;
                [nr,nc,dump]=size(f);
                Nr = ifftshift([-fix(nr/2):ceil(nr/2)-1]);
                Nc = ifftshift([-fix(nc/2):ceil(nc/2)-1]);
                [Nc,Nr] = meshgrid(Nc,Nr);
                g (:,:,1) = ifft2(fft2(f(:,:,1)).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
                Hallo_E=abs(g);
            else
                Hallo_E=abs(f);
                
                yi = cones(:,1)+ deltar;
                xi = cones(:,2)- deltac;
                
                ConeCoords = [xi,yi];
                ToSmall=(ConeCoords<(Factor+1));
                ToLarge=(ConeCoords>150-(Factor+1));
                KickList_A = ToSmall+ToLarge;
                KickList_B = any(KickList_A,2);     % entry = 1 -> delete this cone
                xi(KickList_B,:)=[];
                yi(KickList_B,:)=[];

            end
            
            patchintensity = [];    % clear values and size
            patchintensity = zeros(length(xi),1);
            
            for cone = 1:size(xi,1)
                ConeMat=(Cols-xi(cone)).^2+(Rows-yi(cone)).^2 <= InnerSegment.^2;
                if rem(length(spot),2)~=0; %odd spotsize
                    if sum(sum(ConeMat.*Hallo_E))>=1;
                        
                        PreviewBuffer1(yi(cone)-Factor:yi(cone)+Factor,...
                            (xi(cone))-(Factor):(xi(cone))+Factor-1,2) = spot;    %UseSpot
                        
                        ActCone = PreviewBuffer1(:,:,2).*ConeMat;
                        EtoCone = ActCone.*Hallo_E;    % ones(150,150);
                        EVal = sum(EtoCone(:));
                        
                        CorrVal = EVal/AllC;
                        
                        PreviewBuffer1(:,:,2)=PreviewBuffer1(:,:,2).*CorrVal;
                        PreviewBuffer1=sum(PreviewBuffer1,3);
                        
                        
                        % EDIT to have intensity vector for voronoi
                        patchintensity(cone,1) = CorrVal;
                    end
                    
                else
                    if sum(sum(ConeMat.*Hallo_E))>=1;
                        
                        PreviewBuffer1(yi(cone)-Factor:yi(cone)+Factor-1,...
                            (xi(cone))-(Factor):(xi(cone))+Factor-1,2) = spot;   %UseSpot
                        
                        ActCone = PreviewBuffer1(:,:,2).*ConeMat;
                        EtoCone = ActCone.*Hallo_E;    % ones(150,150);
                        EVal = sum(EtoCone(:));
                        
                        CorrVal = EVal/AllC;
                        
                        
                        PreviewBuffer1(:,:,2)=PreviewBuffer1(:,:,2).*CorrVal;
                        PreviewBuffer1=sum(PreviewBuffer1,3);
                        
                        
                        % EDIT to have intensity vector for voronoi
                        patchintensity(cone,1) = CorrVal;
                    end
                end
            end
            
            
            
            %-------------------- EDIT: add Voronoi display option
            if CFG.voronoi
                width = previewWidth; height = previewHeight;
                if CFG.stiminvert
                    VI = zeros(height,width); % Target image, empty for now
                else
                    VI = ones(height,width); % Target image, empty for now
                end
                [VIx,VIy] = meshgrid(1:width,1:height);  % Prepare image coordinates
                
                dt = DelaunayTri(xi,yi);
                [V,C] = voronoiDiagram(dt);
                
                for j = 1:length(C)
                    if ~sum((V(C{j},1))>=min([width height]))>0 && ~sum((V(C{j},1))<0)>0 % Exclude border cones with too far spread vertices
                        in = inpolygon(VIx,VIy,V(C{j},1),V(C{j},2)); % Find matrix index inside single polygons
                        VI(in) = patchintensity(j); % Fill image matrix with activation intensity
                    end
                end
                PreviewBuffer2 = VI;
                %-------------------- END: add Voronoi display option
                
                
            else
                PreviewBuffer2(:,:,1) = PreviewBuffer1(:,:,1);
                PreviewBuffer2(PreviewBuffer2>=1) = 1;
            end
            
            
            StimulusBuffer(:,:,nf,1) = im2uint8(PreviewBuffer2);
            
        end
        
        return
    end
    
    
    
    
    
    %%% STATIC Stimuli
    %%% --------------------------------------------------------------
    %%% --------------------------------------------------------------
    
    if ~CFG.dynamic
        
        P4th = 0;
        
        Factor=floor(size(spot,1)/2);
        InnerSegment=round(Aperture/0.48);
        [Cols,Rows] = meshgrid(1:previewWidth, 1:previewHeight);
        
        [ColsS,RowsS] = meshgrid(1:spotSize, 1:spotSize);
        AllMat=(ColsS-(spotSize/2)).^2+(RowsS-(spotSize/2)).^2 <= InnerSegment.^2;
        AllC = sum(sum(AllMat.*spot));
        patchintensity = zeros(length(xi),1);
        PreviewBuffer1=zeros(previewWidth,previewHeight);
        
        Hallo_E=PreviewBuffer;
        
        for cone = 1:size(xi,1)
            if rem(length(spot),2)~=0; %odd spotsize
                ConeMat=(Cols-cones(cone,2)).^2+(Rows-cones(cone,1)).^2 <= InnerSegment.^2;
                
                if sum(sum(ConeMat.*Hallo_E))>=1;
                    
                    PreviewBuffer1(yi(cone)-Factor:yi(cone)+Factor,...
                        (xi(cone))-(Factor):(xi(cone))+Factor-1,2) = spot;    %UseSpot
                    
                    ActCone = PreviewBuffer1(:,:,2).*ConeMat;
                    EtoCone = ActCone.*Hallo_E;    % ones(150,150);
                    EVal = sum(EtoCone(:));
                    
                    CorrVal = EVal/AllC;
                    
                    PreviewBuffer1(:,:,2)=PreviewBuffer1(:,:,2).*CorrVal;
                    PreviewBuffer1=sum(PreviewBuffer1,3);
                    % EDIT to have intensity vector for voronoi
                    patchintensity(cone,1) = CorrVal;
                end
                
            else
                ConeMat=(Cols-cones(cone,2)).^2+(Rows-cones(cone,1)).^2 <= InnerSegment.^2;
                
                if sum(sum(ConeMat.*Hallo_E))>=1;
                    
                    PreviewBuffer1(yi(cone)-Factor:yi(cone)+Factor-1,...
                        (xi(cone))-(Factor):(xi(cone))+Factor-1,2) = spot;   %UseSpot
                    
                    ActCone = PreviewBuffer1(:,:,2).*ConeMat;
                    EtoCone = ActCone.*Hallo_E;    % ones(150,150);
                    EVal = sum(EtoCone(:));
                    
                    CorrVal = EVal/AllC;
                    
                    PreviewBuffer1(:,:,2)=PreviewBuffer1(:,:,2).*CorrVal;
                    PreviewBuffer1=sum(PreviewBuffer1,3);
                    % EDIT to have intensity vector for voronoi
                    patchintensity(cone,1) = CorrVal;
                end
            end
        end
        
        
        %-------------------- EDIT: add Voronoi display option
        if CFG.voronoi
            width = previewWidth; height = previewHeight;
            if CFG.stiminvert
                VI = zeros(height,width); % Target image, empty for now
            else
                VI = ones(height,width); % Target image, empty for now
            end
            [VIx,VIy] = meshgrid(1:width,1:height);  % Prepare image coordinates
            
            dt = DelaunayTri(xi,yi);
            [V,C] = voronoiDiagram(dt);
            
            for j = 1:length(C)
                if ~sum((V(C{j},1))>=min([width height]))>0 && ~sum((V(C{j},1))<0)>0 % Exclude border cones with too far spread vertices
                    in = inpolygon(VIx,VIy,V(C{j},1),V(C{j},2)); % Find matrix index inside single polygons
                    VI(in) = patchintensity(j); % Fill image matrix with activation intensity
                end
            end
            PreviewBuffer2 = VI;
            %-------------------- END: add Voronoi display option
            
        else
            PreviewBuffer2(:,:,1) = PreviewBuffer1(:,:,1);
            PreviewBuffer2(PreviewBuffer2>=1) = 1;
        end
        
        StimulusBuffer(:,:,:,1) = repmat (im2uint8(PreviewBuffer2),[1 1 22]);
        
        return
    end
end




function showBuffer(StimulusBuffer)

% handles = guihandles;
CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

% Padding for the 512 x 512 figure in AOMcontrol
padheight=512-size(StimulusBuffer(:,:,1),1);
padhl=floor(padheight/2);
padhu=ceil(padheight/2);
padwidth=512-size(StimulusBuffer(:,:,1),2);
padwl=floor(padwidth/2);
padwr=ceil(padwidth/2);

padt=zeros(padhl,size(StimulusBuffer(:,:,1),2));
padb=zeros(padhu,size(StimulusBuffer(:,:,1),2));
padl=zeros(512,padwl);
padr=zeros(512,padwr);

StimBuffer(:,:,1)=[padt;StimulusBuffer(:,:,1);padb];
ShowStimulus(:,:,1)=[padl StimBuffer(:,:,1) padr];


tic
hi = imshow(ShowStimulus(:,:,1));                     % hi = imshow(StimulusBuffer(:,:,:,1));
if size(StimulusBuffer,3)==1                            % if size(StimulusBuffer,4)==1
    pause(CFG.presentdur*0.001)                     % pause(CFG.presentdur*0.001)
end                                                     % end

if ~(size(StimulusBuffer,3)==1)                        % if ~(size(StimulusBuffer,4)==1)
    
    for idx=2:size(StimulusBuffer,3) % quicker          % for idx=2:size(StimulusBuffer,4)
        
        % Padding for the 512 x 512 figure in AOMcontrol
        padheight=512-size(StimulusBuffer(:,:,1),1);
        padhl=floor(padheight/2);
        padhu=ceil(padheight/2);
        padwidth=512-size(StimulusBuffer(:,:,1),2);
        padwl=floor(padwidth/2);
        padwr=ceil(padwidth/2);
                
        padt=zeros(padhl,size(StimulusBuffer(:,:,1),2));
        padb=zeros(padhu,size(StimulusBuffer(:,:,1),2));
        padl=zeros(512,padwl);
        padr=zeros(512,padwr);
                
        StimBuffer(:,:,1)=[padt;StimulusBuffer(:,:,idx);padb];
        ShowStimulus(:,:,1)=[padl StimBuffer(:,:,1) padr];
        
        set(hi,'CData',ShowStimulus(:,:,1));        % set(hi,'CData',StimulusBuffer(:,:,:,idx));
        pause(0.025);                                   % pause(0.025);
        drawnow;                                      	% drawnow;
    end
end
toc
displayBlank




function displayBlank

% handles = guihandles;
% CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
% h = axes(get(handles.im_panel1, 'Child'));

field_R=zeros(512,512);
field_G=zeros(512,512);
field_B=zeros(512,512);
    
BlankBuffer(:,:,1) = field_R;
BlankBuffer(:,:,2) = field_G;
BlankBuffer(:,:,3) = field_B;

imshow(BlankBuffer)


function [motionpath,P4th] = getmotion(trial)
global AllPaths

if isempty(trial)
    HowMuch = size(AllPaths,3);
    IsTheFish = 1+round(rand(1)*(HowMuch-1));
    motionpath = AllPaths(:,:,IsTheFish);
    P4th = IsTheFish;
else
    motionpath = AllPaths(:,:,trial);
    P4th = trial;
end