function Vernier

global SYSPARAMS StimParams VideoParams;
if exist('handles','var') == 0;
    handles = guihandles; else %donothing
end

startup;  % creates tempStimlus folder and dummy frame for initialization

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(VernierConfig('M')); % wait for user input in Config dialog
CFG = getappdata(hAomControl, 'CFG');
psyfname = [];

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

if (CFG.drift==1 || CFG.scan==1)
    stimdur = floor(CFG.drift_nframes);
    
else
    stimdur = floor(CFG.presentdur);
end

%viddurtotal = stimdur;

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

if CFG.red==0 % Show in IR
    if CFG.drift==1 
        aom0seq (startframe:startframe+CFG.drift_nframes-1) = 2:CFG.drift_nframes+1;
    elseif CFG.scan==1 
        aom0seq = ones(1,stimdur).*framenum;
    else
        aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
    end
else
    aom0seq = zeros(1,viddurtotal);
end

if CFG.Xoff ~= 0 || CFG.Yoff ~= 0        
    netcomm('write',SYSPARAMS.netcommobj,int8('RunSLR#'));
    pause(1);
    netcomm('write',SYSPARAMS.netcommobj,int8('Fix#'));
    command = ['Locate#' num2str(CFG.Xoff) '#' num2str(CFG.Yoff) '#']; %#ok<NASGU>
    netcomm('write',SYSPARAMS.netcommobj,int8(command));
end
aom0locx = zeros(size(aom0seq));
aom0locy = zeros(size(aom0seq));
%aom0locx = CFG.Xoff.*ones(size(aom0seq));
%aom0locy = -CFG.Yoff.*ones(size(aom0seq)); % Attention: MSC Y coordinates are swapped relative to Matlab Figure

if CFG.scan==1
scanningx = 1:CFG.drift_speed:size(aom0locx,2)*CFG.drift_speed;
%scanningx = scanningx-ceil(max(scanningx)/2);
aom0locx = aom0locx + scanningx;
end

aom0pow = ones(size(aom0seq));
aom0pow(:) = 1.000;


%RED
aom1seq = zeros(1,viddurtotal);
if CFG.red==1 % Show in RED
    if CFG.drift==1
        aom1seq (startframe:startframe+CFG.drift_nframes-1) = 2:CFG.drift_nframes+1;
    else
        aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
    end
else
    aom1seq = zeros(1,viddurtotal);
end

aom1pow = ones(size(aom1seq));
aom1pow(:) = 1.000;
aom1offx = CFG.tcaX.*ones(size(aom1seq));
aom1offy = -CFG.tcaY.*ones(size(aom1seq));


%GREEN
aom2seq = zeros(1,viddurtotal);
aom2pow = ones(size(aom2seq));
aom2pow(:) = 1.000;
aom2offx = CFG.tcaX.*ones(size(aom2seq));
aom2offy = -CFG.tcaY.*ones(size(aom2seq));


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
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;
Mov.aom2offx = aom2offx;
Mov.aom2offy = aom2offy;


%set initial while loop conditions
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
good_check = 1;
correct=1;
ncorrect=0;
alt=round(rand);
sign=2*ceil(2*rand)-3;
signy=2*ceil(2*rand)-3;
steps=CFG.stepfactor;
stepsy=CFG.stepfactor;
intensity=CFG.first;

if strcmp(CFG.method,'adjust')
    offset=intensity*sign;
    
    if CFG.bisection==1
        offset=0;
    end
    
    if CFG.twoD==1
        ntrials=ntrials*2;
        offsety=(CFG.dotseparation/2.5)*signy;
        lastup=0;
        lastdown=0;
        reversaly=0;
        lastoffsety=offsety;
    else
        offsety=0;
    end
    lastoffset=offset;
    lastright=0;
    lastleft=0;
    reversal=0;
    nreverse=0;
else
    offsety=0;
end

exact=intensity;
dotSize=CFG.dotsize;
dotSeparation=CFG.dotseparation;
%rawData=zeros(ntrials,5);


if CFG.drift==1
    createStimulus(0,0,0,0,0)
end


while(runExperiment ==1)
    uiwait;
    % resp = get(handles.aom_main_figure,'CurrentCharacter');
    modifier = get(handles.aom_main_figure,'CurrentModifier');
    key = get(handles.aom_main_figure,'CurrentKey');
    
%     %%%% This part is for modifying spatial parameters *****************
%     if strcmp(modifier,kb_Modifier)                                 %
%         if strcmp(key,'uparrow')                                    %
%             dotSeparation=dotSeparation+1;                          %
%             display(dotSeparation);                                 %
%             createStimulus(offset,dotSize,dotSeparation,alt,offsety);           %
%             if SYSPARAMS.realsystem == 1
%                 StimParams.stimpath = dirname;
%                 StimParams.fprefix = fprefix;
%                 StimParams.sframe = 2;
%                 StimParams.eframe = 2;
%                 StimParams.fext = 'bmp';
%                 Parse_Load_Buffers(1);
%             end
%             Mov.frm = 1;
%             Mov.seq = '';
%             setappdata(hAomControl, 'Mov',Mov);
%             PlayMovie;
%         end
%         
%         if strcmp(key,'downarrow')
%             dotSeparation=dotSeparation-1;
%             display(dotSeparation);
%             createStimulus(offset,dotSize,dotSeparation,alt,offsety);
%             if SYSPARAMS.realsystem == 1
%                 StimParams.stimpath = dirname;
%                 StimParams.fprefix = fprefix;
%                 StimParams.sframe = 2;
%                 StimParams.eframe = 2;
%                 StimParams.fext = 'bmp';
%                 Parse_Load_Buffers(1);
%             end
%             Mov.frm = 1;
%             Mov.seq = '';
%             setappdata(hAomControl, 'Mov',Mov);
%             PlayMovie;
%         end
%         
%         if strcmp(key,'leftarrow')
%             dotSize=dotSize-1;
%             display(dotSize);
%             createStimulus(offset,dotSize,dotSeparation,alt,offsety);
%             if SYSPARAMS.realsystem == 1
%                 StimParams.stimpath = dirname;
%                 StimParams.fprefix = fprefix;
%                 StimParams.sframe = 2;
%                 StimParams.eframe = 2;
%                 StimParams.fext = 'bmp';
%                 Parse_Load_Buffers(1);
%             end
%             Mov.frm = 1;
%             Mov.seq = '';
%             setappdata(hAomControl, 'Mov',Mov);
%             PlayMovie;
%         end
%         
%         if strcmp(key,'rightarrow')
%             dotSize=dotSize+1;
%             display(dotSize);
%             createStimulus(offset,dotSize,dotSeparation,alt,offsety);
%             if SYSPARAMS.realsystem == 1
%                 StimParams.stimpath = dirname;
%                 StimParams.fprefix = fprefix;
%                 StimParams.sframe = 2;
%                 StimParams.eframe = 2;
%                 StimParams.fext = 'bmp';
%                 Parse_Load_Buffers(1);
%             end
%             Mov.frm = 1;
%             Mov.seq = '';
%             setappdata(hAomControl, 'Mov',Mov);
%             PlayMovie;
%         end                                                         %
%         %
%     end                                                             %
%     % End modifying part only ***************************************
    
    
    
    if strcmp(key,kb_AbortConst)   % Abort Experiment
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);
        
        
    elseif strcmp(key,kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            
            if strcmp(CFG.method,'2d1u')
                [offset alt]=newAlt(intensity, correct,alt);
            end
            
            %             if strcmp(CFG.method,'adjust')
            %                 if trial==10 || trial==20
            %                     offset = offset*4;
            %                     steps = steps*(2^nreverse);
            %                     nreverse = 0;
            %                 end
            %             end
            
            createStimulus(offset,dotSize,dotSeparation,alt,offsety);
            
            if SYSPARAMS.realsystem == 1
                StimParams.stimpath = dirname;
                StimParams.fprefix = fprefix;
                StimParams.sframe = 2;
                
                if CFG.drift==1
                    StimParams.eframe = 30;
                else
                    StimParams.eframe = 2;
                end
                
%                 StimParams.fext = 'bmp';
                StimParams.fext = 'buf';
                Parse_Load_Buffers(0);
            end
            
            Mov.frm = 1;
            % Mov.duration = CFG.videodur*fps;
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            % Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);
            
            VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%
            PlayMovie;
            % PresentStimulus = 0;
            GetResponse = 1;
        end
        
    elseif(GetResponse == 1)
        
        if strcmp(CFG.method,'adjust')
            if strcmp(key,kb_hileft);  % High LEFT response
                
                response = -2;
                responsey = 0;
                message1 = [Mov.msg ' - LEFT Response'];
                GetResponse = 0;
                good_check = 1;
                lastoffset = offset;
                reversal = 0;
                
                if lastright == 1
                    lastright = 0;
                    if steps >= CFG.minstep*2   % no smaller steps than 100th of first step
                        if strcmp(CFG.stim,'subp')
                            steps = round(100*steps/2)/100;
                        else
                            steps = round(steps/2);
                        end
                        nreverse = nreverse + 1;
                    end
                    
                    reversal = 1;
                    
                end
                
                offset = offset + 2*steps;
                lastleft = 1;
                
            end
            
            %             if strcmp(key,kb_loleft);  % Low LEFT response
            %
            %                 response = -1;
            %                 message1 = [Mov.msg ' - LEFT Response - Low confidence'];
            %                 GetResponse = 0;
            %                 good_check = 1;
            %                 lastoffset = offset;
            %                 reversal = 0;
            %
            %
            %                 if lastright == 1
            %                     lastright = 0;
            %                     if steps >= CFG.minstep*2   % no smaller steps than 100th of first step
            %                         if strcmp(CFG.stim,'subp')
            %                             steps = round(100*steps/2)/100;
            %                         else
            %                             steps = round(steps/2);
            %                         end
            %                         nreverse = nreverse + 1;
            %                     end
            %
            %                     reversal = 1;
            %
            %                 end
            %
            %
            %                 offset = offset + steps;
            %                 lastleft = 1;
            %
            %             end
            
            %             if strcmp(key,kb_loright);  % Low RIGHT response
            %
            %                 response = 1;
            %                 message1 = [Mov.msg ' - RIGHT Response '];
            %                 GetResponse = 0;
            %                 good_check = 1;
            %                 lastoffset = offset;
            %                 reversal = 0;
            %
            %                 if lastleft == 1
            %                     lastleft = 0;
            %                     if steps >= CFG.minstep*2   % no smaller steps than 100th of first step
            %                         if strcmp(CFG.stim,'subp')
            %                             steps = round(100*steps/2)/100;
            %                         else
            %                             steps = round(steps/2);
            %                         end
            %                         nreverse = nreverse + 1;
            %                     end
            %                     reversal = 1;
            %
            %                 end
            %
            %                 offset = offset - steps;
            %                 lastright = 1;
            %
            %             end
            
            if strcmp(key,kb_hiright);  % High RIGHT response
                
                response = 2;
                responsey = 0;
                message1 = [Mov.msg ' - RIGHT Response '];
                GetResponse = 0;
                good_check = 1;
                lastoffset = offset;
                reversal = 0;
                
                if lastleft == 1
                    lastleft = 0;
                    if steps >= CFG.minstep*2   % no smaller steps than 100th of first step
                        if strcmp(CFG.stim,'subp')
                            steps = round(100*steps/2)/100;
                        else
                            steps = round(steps/2);
                        end
                        nreverse = nreverse + 1;
                    end
                    reversal = 1;
                    
                end
                
                offset = offset - 2*steps;
                
                lastright = 1;
            end
            %             elseif strcmp(key,kb_BadConst)
            %                 GetResponse = 0;
            %                 response = 2;
            %                 good_check = 0;
            %             end;
            
            
            if CFG.twoD==1
                
                if strcmp(key,'uparrow');  % UP response
                    
                    response = 0;
                    responsey = 2;
                    message1 = [Mov.msg ' - UP Response '];
                    GetResponse = 0;
                    good_check = 1;
                    lastoffsety = offsety;
                    reversaly = 0;
                    
                    if lastdown == 1
                        lastdown = 0;
                        if stepsy >= CFG.minstep*2
                            if strcmp(CFG.stim,'subp')
                                stepsy = round(100*stepsy/2)/100;
                            else
                                stepsy = round(stepsy/2);
                            end
                            nreverse = nreverse + 1;
                        end
                        reversaly = 1;
                        
                    end
                    
                    offsety = offsety - 2*stepsy;
                    
                    lastup = 1;
                end
                
                
                if strcmp(key,'downarrow');  % UP response
                    
                    response = 0;
                    responsey = -2;
                    message1 = [Mov.msg ' - DOWN Response '];
                    GetResponse = 0;
                    good_check = 1;
                    lastoffsety = offsety;
                    reversaly = 0;
                    
                    if lastup == 1
                        lastup = 0;
                        if stepsy >= CFG.minstep*2
                            if strcmp(CFG.stim,'subp')
                                stepsy = round(100*stepsy/2)/100;
                            else
                                stepsy = round(stepsy/2);
                            end
                            nreverse = nreverse + 1;
                        end
                        reversaly = 1;
                        
                    end
                    
                    offsety = offsety + 2*stepsy;
                    
                    lastdown = 1;
                end
                
                
                
            end
            
            
            
        end
        
        
        if strcmp(CFG.method,'2d1u')
            
            
            if strcmp(CFG.optotype,'E')
                
                if strcmp(key,'rightarrow');  % Right response
                    response = 0;
                    GetResponse = 0;
                    good_check = 1;
                    
                    if alt==0   % Correct response
                        message1 = [Mov.msg ' - RIGHT Response - Correct '];
                        ncorrect=ncorrect+1;
                        correct=1;
                        
                        if offset>=CFG.minstep*CFG.stepfactor && ncorrect==2
                            exact=exact/CFG.stepfactor;
                            intensity=round(exact);
                            ncorrect=0;
                        end
                    else        % False response
                        message1 = [Mov.msg ' - RIGHT Response - Incorrect'];
                        exact=exact*CFG.stepfactor;
                        intensity=round(exact);
                        ncorrect=0;
                        correct=0;
                    end
                    
                elseif strcmp(key,'uparrow');  % UP response
                    response = 90;
                    GetResponse = 0;
                    good_check = 1;
                    
                    if alt==90   % Correct response
                        message1 = [Mov.msg ' - UP Response - Correct '];
                        ncorrect=ncorrect+1;
                        correct=1;
                        
                        if offset>=CFG.minstep*CFG.stepfactor && ncorrect==2
                            exact=exact/CFG.stepfactor;
                            intensity=round(exact);
                            ncorrect=0;
                        end
                    else        % False response
                        message1 = [Mov.msg ' - UP Response - Incorrect'];
                        exact=exact*CFG.stepfactor;
                        intensity=round(exact);
                        ncorrect=0;
                        correct=0;
                    end
                    
                elseif strcmp(key,'leftarrow');  % Left response
                    response = 180;
                    GetResponse = 0;
                    good_check = 1;
                    
                    if alt==180   % Correct response
                        message1 = [Mov.msg ' - LEFT Response - Correct '];
                        ncorrect=ncorrect+1;
                        correct=1;
                        
                        if offset>=CFG.minstep*CFG.stepfactor && ncorrect==2
                            exact=exact/CFG.stepfactor;
                            intensity=round(exact);
                            ncorrect=0;
                        end
                    else        % False response
                        message1 = [Mov.msg ' - LEFT Response - Incorrect'];
                        exact=exact*CFG.stepfactor;
                        intensity=round(exact);
                        ncorrect=0;
                        correct=0;
                    end
                    
                elseif strcmp(key,'downarrow');  % Down response
                    response = 270;
                    GetResponse = 0;
                    good_check = 1;
                    correct=1;
                    
                    if alt==270   % Correct response
                        message1 = [Mov.msg ' - DOWN Response - Correct '];
                        ncorrect=ncorrect+1;
                        
                        if offset>=CFG.minstep*CFG.stepfactor && ncorrect==2
                            exact=exact/CFG.stepfactor;
                            intensity=round(exact);
                            ncorrect=0;
                        end
                    else        % False response
                        message1 = [Mov.msg ' - DOWN Response - Incorrect'];
                        exact=exact*CFG.stepfactor;
                        intensity=round(exact);
                        ncorrect=0;
                        correct=0;
                    end
                    
                elseif strcmp(key,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end
                
                
                
            else
                
                if strcmp(key,kb_Right) %Right Arrow
                    
                    if alt==0  % Correct Response
                        response = 0;
                        message1 = [Mov.msg ' - Right Response - Correct'];
                        %mar = mapping(stimulus,3);
                        correct = 1;
                        GetResponse = 0;
                        good_check = 1;  %indicates if it was a good trial
                        
                        ncorrect=ncorrect+1;
                        
                        if strcmp(CFG.stim,'subp')
                            if ncorrect==2
                                exact=exact/CFG.stepfactor;
                                intensity=round(100*exact)/100;
                                ncorrect=0;
                            end
                        else
                            
                            if intensity>=CFG.stepfactor && ncorrect==2
                                
                                if CFG.stepfactor==1
                                    intensity=intensity-CFG.stepfactor;
                                else
                                    exact=exact/CFG.stepfactor;
                                    intensity=round(exact);
                                end
                                ncorrect=0;
                            end
                            
                            
                        end
                        
                        
                    else       % False Response
                        response = 0;
                        message1 = [Mov.msg ' - Right Response - Incorrect'];
                        %mar = mapping(stimulus,3);
                        correct = 0;
                        GetResponse = 0;
                        good_check = 1;  %indicates if it was a good trial
                        
                        ncorrect=0;
                        
                        if strcmp(CFG.stim,'subp')
                            exact=exact*CFG.stepfactor;
                            intensity=round(100*exact)/100;
                        else
                            if intensity<=9
                                if CFG.stepfactor==1
                                    intensity=intensity+CFG.stepfactor;
                                else
                                    exact=exact*CFG.stepfactor;
                                    intensity=round(exact);
                                end
                            end
                        end
                        
                    end
                    
                elseif strcmp(key,kb_Left) %Left Arrow
                    
                    if alt==1  % Correct Response
                        response = 1;
                        message1 = [Mov.msg ' - Left Response - Correct'];
                        %mar = mapping(stimulus,3);
                        correct = 1;
                        GetResponse = 0;
                        good_check = 1;  %indicates if it was a good trial
                        
                        ncorrect=ncorrect+1;
                        
                        if strcmp(CFG.stim,'subp')
                            if  ncorrect==2
                                exact=exact/CFG.stepfactor;
                                intensity=round(100*exact)/100;
                                ncorrect=0;
                            end
                        else
                            if intensity>=CFG.stepfactor && ncorrect==2
                                if CFG.stepfactor==1
                                    intensity=intensity-CFG.stepfactor;
                                else
                                    exact=exact/CFG.stepfactor;
                                    intensity=round(exact);
                                end
                                ncorrect=0;
                            end
                        end
                        
                        
                    else   % False Response
                        response = 1;
                        message1 = [Mov.msg ' - Left Response - Incorrect'];
                        %mar = mapping(stimulus,3);
                        correct = 0;
                        GetResponse = 0;
                        good_check = 1;  %indicates if it was a good trial
                        
                        ncorrect=0;
                        if strcmp(CFG.stim,'subp')
                            exact=exact*CFG.stepfactor;
                            intensity=round(100*exact)/100;
                        else
                            if intensity<=9
                                if CFG.stepfactor==1
                                    intensity=intensity+CFG.stepfactor;
                                else
                                    exact=exact*CFG.stepfactor;
                                    intensity=round(exact);
                                end
                            end
                        end
                        
                    end
                    
                elseif strcmp(key,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
            end
        end
        
        
        
        
        
        
        if GetResponse == 0
            if good_check == 1
                message2 = ['Current offset [pixel]: ' num2str(offset)];
                message = sprintf('%s\n%s', message1, message2);
                set(handles.aom1_state, 'String',message);
                
                %write response to psyfile
                psyfid = fopen(psyfname,'a+');%
                %fprintf(psyfid,'%s\t %s\t %s\r\n',VideoParams.vidname,num2str(offset),num2str(response));
                if strcmp(CFG.method,'adjust')
                    if CFG.twoD==1
                        fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\r\n',num2str(trial),num2str(lastoffset),num2str(reversal),num2str(response),num2str(lastoffsety),num2str(reversaly),num2str(responsey));
                        rawData(trial,:)=[trial lastoffset reversal response lastoffsety reversaly responsey];
                    else
                        fprintf(psyfid,'%s\t %s\t %s\t %s\r\n',num2str(trial),num2str(lastoffset),num2str(reversal),num2str(response));
                        rawData(trial,:)=[trial lastoffset reversal response 0];
                    end
                elseif strcmp(CFG.method,'2d1u')
                    fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\r\n',num2str(trial),num2str(offset),num2str(alt),num2str(response),num2str(correct));
                    rawData(trial,:)=[trial offset alt response correct];
                    
                end
                fclose(psyfid);
                %theThreshold(trial,1) = intensity; %#ok<AGROW>
                
                %update QUEST
                %                 q = QuestUpdate(q,trialRadius,correct);
                
                %update trial counter
                trial = trial + 1;
                
                
                
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    TerminateExp;
                    message = ['Off - Experiment Complete - Last Absolute Offset: ' num2str(abs(offset))];
                    set(handles.aom1_state, 'String',message);
                    if strcmp(CFG.method,'2d1u')
                        plotResult(rawData, psyfname)
                    elseif strcmp(CFG.method,'adjust')
                        display(rawData)
                        plotResult(rawData, psyfname)
                    end
                    
                else %continue experiment
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

if strcmp(CFG.optotype,'E')
    offset=intensity;
    alt=90*floor(rand*4);  %random rotation about [0,90,180,270] degrees
    
else
    offset=intensity;
    sign=rand-0.5;
    if sign<0
        offset=-offset;
        alt=1;
    else
        alt=0;
    end
end

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



function createStimulus(offset,dotSize,dotSeparation,alt,offsety)



CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

% if SYSPARAMS.realsystem == 1 % swap for subject's view vs. Fundus view
%     offset=offset;
% end
gaussw=CFG.gaussw;

if CFG.drift==1
    
    cd([pwd,'\tempStimulus']);
    
    % width=100;
    n_frames=CFG.drift_nframes;
    imSize = CFG.drift_width;                           % image size: n X n
    cpd=CFG.drift_cpd;                      % target spatial frequency        
    spp=3600*CFG.fieldsize/512;             % arcsec per pixel
    lambda = round((30*60/cpd)/spp/2);      % wavelength (number of pixels per cycle)
    theta = CFG.drift_angle;                % drift orientation in deg
    speed=CFG.drift_speed;                  % drift speed pix/frame
    anglex=cosd(CFG.drift_angle);
    angley=sind(CFG.drift_angle);
    window = 0.15;
    sigma = imSize*window;                             % gaussian standard deviation in pixels
    phase = 0;                              % phase (0 -> 1)
          
    gf=fspecial('gaussian',lambda+1,3);     % Dotblur locally
    gf=gf/max(gf(:));
    gf2=fspecial('gaussian',imSize,sigma);  % Gaussian window on stimulus
    gf2=gf2/max(max(gf2));
    
    %%%% Pattern for drifting noise
    downscale=round(imSize/lambda);
    ind=(rand(downscale,downscale));
    dotsize=round(imSize/downscale);
    patt=zeros(downscale*dotsize,downscale*dotsize);
    for i=1:downscale
        for j=1:downscale
            patt(i*dotsize-(dotsize-1):i*dotsize,j*dotsize-(dotsize-1):j*dotsize)=ind(i,j);
        end
    end
    patt=imresize(patt,[imSize imSize]);
       
    
    i=1;
    for i=1:n_frames
        deltac = i*anglex*speed;  % Shift in X (negative because of shift algorithm)
        deltar = i*angley*speed;       % Shift in Y
        f=im2double(patt);
        phase = 2;
        [nr,nc]=size(f);
        Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
        Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
        [Nc,Nr] = meshgrid(Nc,Nr);
        g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
        g=abs(g);
        
        g=imfilter(g,gf,'replicate');
        g=g.*gf2;
        g=g/max(g(:));
         g(imSize/2-5:imSize/2+5,imSize/2-5:imSize/2+5)=0;
        
        g=imcomplement(g);
        % eval(['pat',num2str(i),'=g;'])
        canv=g;
    
    if CFG.positive == 1
    canv=imcomplement(canv);
    end

        
    eval(['imwrite(canv,''frame',num2str(i+1),'.bmp'');'])
    eval(['fid = fopen(''frame',num2str(i+1),'.buf'',''w'');'])
     fwrite(fid,size(canv,2),'uint16');
     fwrite(fid,size(canv,1),'uint16');
     fwrite(fid, canv, 'double');
     fclose(fid);
   
    end
    

    
else
    n_frames=1;
    
    if strcmp(CFG.optotype,'3dots')
        
        canvh=6+dotSize*3+dotSeparation*2;  %3 pixel margin at each side
        %canvw=canvh;   % the whole thing is square (TODO: re-think because of stabilization constraints)
        if CFG.bisection==1
            canvw=dotSize+6;
        else
            canvw=dotSize+6+26;
        end
        
        %canv=ones(canvh,canvw);  % create empty canvas
        
        flank=ones(6+dotSize,canvw);  % top and bottom part of stimulus
        flankw=(floor((canvw-dotSize)/2)+1:floor((canvw-dotSize)/2)+dotSize);
        flankh=(4:4+dotSize-1);
        flank(flankh,flankw)=0;
        if strcmp(CFG.stim,'subp')
            gf=fspecial('gaussian',10,gaussw);
            flank=imfilter(flank,gf,'replicate');
        end
        
        probe=ones(2*dotSeparation+dotSize-6,canvw);
        
        if strcmp(CFG.stim,'subp')
            probew=(floor((canvw-dotSize)/2)+1:floor((canvw-dotSize)/2)+dotSize);
        else
            probew=(floor((canvw-dotSize)/2)+offset+1:floor((canvw-dotSize)/2)+dotSize+offset);
        end
        
        probeh=(dotSeparation-2:dotSeparation-2+dotSize-1);
        probe(probeh,probew)=0;
        
        if strcmp(CFG.stim,'subp')
            gf=fspecial('gaussian',10,gaussw);
            probe=imfilter(probe,gf,'replicate');
            deltac = -offset;  % Shift in X (negative because of shift algorithm)
            deltar = offsety;       % Shift in Y
            f=im2double(probe);
            phase = 2;
            [nr,nc]=size(f);
            Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
            Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
            [Nc,Nr] = meshgrid(Nc,Nr);
            g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
            probe=abs(g);
        end
        
        canv=[flank;probe;flank];
        
        
    elseif strcmp(CFG.optotype,'2bars')
        
        barheight=CFG.barheight;
        orientationAngle = CFG.orientationAngle;  % ##### JBF ADDED 2/29/12 #####
         
        canvh=6+barheight*2+dotSeparation;  %3 pixel margin at each side
        canvw=canvh;   % the whole thing is square (TODO: re-think because of stabilization constraints)
        canvw=dotSize+6+26;
        %canv=ones(canvh,canvw);  % create empty canvas
        
        flank=ones(6+barheight,canvw);  % top and bottom part of stimulus
        flankw=(floor((canvw-dotSize)/2):floor((canvw-dotSize)/2)+dotSize-1);
        flankh=(4:4+barheight-1);
        flank(flankh,flankw)=0;
        if strcmp(CFG.stim,'subp')
            gf=fspecial('gaussian',11,gaussw);
            flank=imfilter(flank,gf,'replicate');
        end
        
        if CFG.i==1
            probe=ones(6+dotSize+dotSeparation-3,canvw);
            probeh=(4:4+dotSize-1);
        else
            probe=ones(6+barheight+dotSeparation-3,canvw);
            probeh=(4:4+barheight-1);
        end
        
        if strcmp(CFG.stim,'subp')
            probew=(floor((canvw-dotSize)/2):floor((canvw-dotSize)/2)+dotSize-1);
        else
            probew=(floor((canvw-dotSize)/2)+offset:floor((canvw-dotSize)/2)+dotSize-1+offset);
        end
        
        probe(probeh,probew)=0;
        
        if strcmp(CFG.stim,'subp')
            gf=fspecial('gaussian',11,gaussw);
            probe=imfilter(probe,gf,'replicate');
            deltac = -offset;  % Shift in X (negative because of shift algorithm)
            deltar = 0;       % Shift in Y
            f=im2double(probe);
            phase = 2;
            [nr,nc]=size(f);
            Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
            Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
            [Nc,Nr] = meshgrid(Nc,Nr);
            g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
            probe=abs(g);
        end
        
        canv=[probe;flank];
       
        %ROTATE STIMULUS BY orientationAngle
        %--------------------------------------------- 
        %reverse image values (to make white on black, b/c imrotate 'loose' fills in new area with zeros)
        canv = 1 - canv;        
        %rotate image
        canv = imrotate(canv, orientationAngle,'bicubic','loose'); %beware of pixel values outside the original range      
        %crop values greater than zero (aka crop the stimulus, getting rid of all near-zero values)
        [nzRow, nzCol, val] = find(canv > .001); 
        canv = canv(min(nzRow):max(nzRow), min(nzCol):max(nzCol));       
        %reverse image values (back to black on white)
        canv = 1 - canv;
        

        
    elseif strcmp(CFG.optotype,'grid')  %Fixed Amsler-Grid type stimulus
        n = CFG.barheight;
        zell=ones(dotSeparation+ceil(dotSize/2),dotSeparation+ceil(dotSize/2));
        
        if dotSize>=dotSeparation
            dotSize=dotSeparation-1;
        end
        zell(ceil(dotSeparation/2)-floor(dotSize/2):ceil(dotSeparation/2)-floor(dotSize/2)+dotSize-1,ceil(dotSeparation/2)-floor(dotSize/2):ceil(dotSeparation/2)-floor(dotSize/2)+dotSize-1)=0;
        
        if strcmp(CFG.stim,'subp')
            gf=fspecial('gaussian',11,gaussw);
            probe=imfilter(zell,gf,'replicate');
            zell=probe;
        end
        
        row=zell;
        for k = 1:n-1
            row=[row zell];
        end
        canv=row;
        for k = 1:n-1
            canv=[canv;row];
        end
        
    elseif strcmp(CFG.optotype,'E')
        
        gap=(offset);
        padw=gap;
        e=zeros(gap*5,gap*5);
        e(gap+1:2*gap,gap+1:end)=1;
        e(3*gap+1:4*gap,gap+1:end)=1;
        
        padh=ones(padw,size(e,2));
        padv=ones(size(e,1)+2*padw,padw);
        
        E=[padh;e;padh];
        E=[padv E padv];
        
        E=imrotate(E,alt);
        
        if strcmp(CFG.stim,'subp')
            f = fspecial('gaussian',10,gaussw);
            E = imfilter(E,f,'replicate');
        end
        canv=E;
    end
    
if CFG.flipv == 1
    canv=flipud(canv);
end

if CFG.positive == 1
    canv=imcomplement(canv);
end

if ~isempty(canv(canv>1)) % to avoid ripple
canv(canv>1)=1;
end


cd([pwd,'\tempStimulus']);

% imwrite(canv,'frame2.bmp');
fid = fopen('frame2.buf','w');
fwrite(fid,size(canv,2),'uint16');
fwrite(fid,size(canv,1),'uint16');
fwrite(fid, canv, 'double');
fclose(fid);
end

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

% *****************************************************************
% *****************************************************************
if strcmp(CFG.method,'adjust') % the 2 methods have different plots
    % *****************************************************************
    % *****************************************************************
    
    data=rawData;
    
    if CFG.twoD==1
        
        datay=data;
        datay(datay(:,7)==0,:)=[];
        datay(:,2:4)=[];
        
        stim_inty=abs(datay(:,2));
        stim_intscy=datay(:,2);
        reversey=datay(datay(:,3)==1,:);
        reversey=reversey(3:end,2);
        stimuliy=unique(sort(stim_intscy));
        nstimuliy=size(stimuliy,1);
        resulty=zeros(nstimuliy,3,'double');
        
        for i=1:size(datay,1);
            pos = find(stimuliy==datay(i,2));
            if datay(i,2)<0 && datay(i,4)<0
                resulty(pos,2)=resulty(pos,2)+1;
            elseif datay(i,2)>0 && datay(i,4)>0
                resulty(pos,2)=resulty(pos,2)+1;
            end
            resulty(pos,3)=resulty(pos,3)+1;
            resulty(:,1)=stimuliy;
        end
        
        for i=1:nstimuliy;
            resulty(i,2)= resulty(i,2)/resulty(i,3);
            if resulty(i,1)<0
                resulty(i,2)=1-resulty(i,2);
            end
        end;
        
        resulty(resulty(:,1)==0,:)=[];
        resulttexty= num2str(resulty,'   %1.3f');
        display(resulttexty);
        
    end
    
    datax=data;
    datax(datax(:,4)==0,:)=[];
        
    if CFG.twoD==1
        datax(:,5:7)=[];
    end
    
    if CFG.bisection==1
        datax=datay;
    end
    
    
    stim_intx=abs(datax(:,2));
    stim_intscx=datax(:,2);
    reversex=datax(datax(:,3)==1,:);
    reversex=reversex(3:end,2);
    stimulix=unique(sort(stim_intscx));
    nstimulix=size(stimulix,1);
    resultx=zeros(nstimulix,3,'double');
    
    for i=1:size(datax,1);
        pos = find(stimulix==datax(i,2));
        if datax(i,2)<0 && datax(i,4)<0
            resultx(pos,2)=resultx(pos,2)+1;
        elseif datax(i,2)>0 && datax(i,4)>0
            resultx(pos,2)=resultx(pos,2)+1;
        end
        resultx(pos,3)=resultx(pos,3)+1;
        resultx(:,1)=stimulix;
    end
    
    for i=1:nstimulix;
        resultx(i,2)= resultx(i,2)/resultx(i,3);
        if resultx(i,1)<0
            resultx(i,2)=1-resultx(i,2);
        end
    end;
    
    resultx(resultx(:,1)==0,:)=[];
    
    resulttextx= num2str(resultx,'   %1.3f');
    display(resulttextx);
    
    
    figure('Position',[475 518 800 351]);
    subplot(1,2,1);
    stairs(stim_intscx,'k');
    hold on
    plot(stim_intscx,...
        'Marker','o',...
        'LineStyle','none',...
        'MarkerEdgeColor',[0.0 0.0 0.0],...
        'MarkerFaceColor',[0.5 0.5 0.5],...
        'MarkerSize',4);
    text(0.94*size(stim_intscx,1),stim_intscx(end)+1,['n = ',num2str(size(stim_intscx,1))],...
        'FontSize',7.5,...
        'Color','r');
    xlabel('Trial number');
    ylabel('Offset [Pixel]');
    title(['Mean reversal [Pixel] = ',num2str(mean(reversex))]);
    xlim([0 size(stim_intscx,1)*1.1]);
    
    if min(stim_intscx)<0; minfac=1.05;
    else minfac=0.95; end
    
    if max(stim_intscx)<0; maxfac=0.95;
    else maxfac=1.05; end
    
    if min(stim_intscx)==0; minzero=0.5;
    else minzero = 0; end
    
    if max(stim_intscx)==0; maxzero=0.5;
    else maxzero = 0; end
    
    ylim([(min(stim_intscx)*minfac)-minzero (max(stim_intscx)*maxfac)+maxzero]);
    axis square
    hold off
    
    subplot(1,2,2);
    
    if CFG.plotcomplex==0
        
        %     if strcmp(CFG.stim,'subp') && CFG.stepfactor~=1
        %         semilogx(result(:,1),result(:,2),...
        %             'LineStyle','none');
        %         xlimlo=min(result(:,1))/CFG.stepfactor;
        %         xlimhi=max(result(:,1))*CFG.stepfactor;
        %     else
        plot(resultx(:,1),resultx(:,2),'k');
        xlimlo=min(resultx(:,1))*1.1;
        xlimhi=max(resultx(:,1))*1.1;
        %     end
        
        xlabel('Offset [Pixel]');
        ylabel('Discrimination performance');
        title('Psychometric Function');
        xlim([xlimlo xlimhi]);
        ylim([-0.05 1.05]);
        axis square
        hold on
        
        markerSize=8*resultx(:,3)./max(resultx(:,3));
        for k = 1: size(resultx,1)
            plot(resultx(k,1),resultx(k,2),...
                'Marker','o',...
                'LineStyle','none',...
                'MarkerEdgeColor',[0.0 0.0 0.0],...
                'MarkerFaceColor',[0.5 0.5 0.5],...
                'MarkerSize',markerSize(k));
            text(resultx(k,1),resultx(k,2)-0.04,num2str(resultx(k,3)),...
                'FontSize',7.5,...
                'Color','r');
            hold on
        end
        hold off
        set(gca,'Layer','Top');
        set(gcf,'PaperPositionMode','auto')
        
    elseif CFG.plotcomplex==1
        
        % Pfit will run in its folder only
        dirtext=pwd; temptext=which('pfit');
        if exist(temptext,'file')==0; error('Script halted: install pfit first');
        else pfittext=temptext(1:length(temptext)-6); cd (pfittext); end
        
        % Call PFIT
        [fit fullfit]=pfit(resultx,'Runs',100,'n_intervals',1,'LAMBDA_LIMITS',[0 0.2]);
        display(resulttextx);
        cd (dirtext);
        
        psyfit=struct;
        psyfit.filename=psyfname;
        psyfit.raw=rawData;
        psyfit.result=resultx;
        psyfit.resulttext=resulttextx;
        %psyfit.bias=bias;
        psyfit.fit=fit;
        psyfit.fullfit=fullfit;
        %psyfit.fixes=fixes;
        
        save([psyfit.filename(1:end-4),'_psyfitX.mat'],'psyfit');
        
        alpha= psyfit.fit.params.est(1);
        beta= psyfit.fit.params.est(2);
        gamma= psyfit.fit.params.est(3);
        lambda= psyfit.fit.params.est(4);
        schw=psyfit.fit.thresholds.est(2);
        limu=psyfit.fit.thresholds.lims(2,2);
        limo=psyfit.fit.thresholds.lims(3,2);
        JND=abs(psyfit.fit.thresholds.est(2)-psyfit.fit.thresholds.est(1));
        PSE=schw;
        
        
        xfit=[-30:0.05:30];
        ylog = 1 ./ (1 + exp((alpha - xfit) ./ beta));
        ypsi = gamma + (1 - gamma - lambda) * ylog;
        yschw=1 ./ (1 + exp((alpha - schw) ./ beta));
        yschw= gamma + (1 - gamma - lambda) * yschw;
        
        x=psyfit.result(:,1);
        y=psyfit.result(:,2);
        z=psyfit.result(:,3);
        
        xlimlo=schw-5;
        xlimhi=schw+5;
        
        plot(xfit,ypsi,'k','LineWidth',1)
        xlabel('Offset in X [Pixel]');
        ylabel('Discrimination performance');
        title(['PSE:  ',num2str(PSE,'%1.2f'),'  JND: ',num2str(JND,'%1.2f')]);
        xlim([xlimlo xlimhi]);
        ylim([-0.05 1.05]);
        axis square
        hold on
        
        
        
        plot(schw,yschw,'ok','LineWidth',1)
        line([limu limo],[yschw yschw],'Color',[0 0 0],'LineWidth',1)
        
        
        
        
        markerSize=8*z./max(z);
        markerSize=markerSize*(1/min(markerSize));
        
        for k = 1: size(x,1)
            plot(x(k),y(k),...
                'Marker','o',...
                'LineStyle','none',...
                'MarkerEdgeColor',[0.0 0.0 0.0],...
                'MarkerFaceColor',[0.5 0.5 0.5],...
                'MarkerSize',markerSize(k));
            if xlimlo<=x(k)<=xlimhi
                text(x(k),y(k)-0.04,num2str(z(k)),...
                    'FontSize',7.5,...
                    'Color','r');
            end
            hold on
        end
        hold off
        set(gca,'Layer','Top');
        set(gcf,'PaperPositionMode','auto')
        
        
        if CFG.twoD==1
            
            
            figure('Position',[475 518 800 351]);
            subplot(1,2,1);
            stairs(stim_intscy,'k');
            hold on
            plot(stim_intscy,...
                'Marker','o',...
                'LineStyle','none',...
                'MarkerEdgeColor',[0.0 0.0 0.0],...
                'MarkerFaceColor',[0.5 0.5 0.5],...
                'MarkerSize',4);
            text(0.94*size(stim_intscy,1),stim_intscy(end)+1,['n = ',num2str(size(stim_intscy,1))],...
                'FontSize',7.5,...
                'Color','r');
            xlabel('Trial number');
            ylabel('Offset [Pixel]');
            title(['Mean reversal [Pixel] = ',num2str(mean(reversey))]);
            xlim([0 size(stim_intscy,1)*1.1]);
            
            if min(stim_intscy)<0; minfac=1.05;
            else minfac=0.95; end
            
            if max(stim_intscy)<0; maxfac=0.95;
            else maxfac=1.05; end
            
            if min(stim_intscy)==0; minzero=0.5;
            else minzero = 0; end
            
            if max(stim_intscy)==0; maxzero=0.5;
            else maxzero = 0; end
            
            ylim([(min(stim_intscy)*minfac)-minzero (max(stim_intscy)*maxfac)+maxzero]);
            axis square
            hold off
            
            subplot(1,2,2);
            
            % Pfit will run in its folder only
            dirtext=pwd; temptext=which('pfit');
            if exist(temptext,'file')==0; error('Script halted: install pfit first');
            else pfittext=temptext(1:length(temptext)-6); cd (pfittext); end
            
            % Call PFIT
            [fit fullfit]=pfit(resulty,'Runs',100,'n_intervals',1,'LAMBDA_LIMITS',[0 0.2]);
            display(resulttexty);
            cd (dirtext);
            
            psyfit=struct;
            psyfit.filename=psyfname;
            psyfit.raw=rawData;
            psyfit.result=resulty;
            psyfit.resulttext=resulttexty;
            %psyfit.bias=bias;
            psyfit.fit=fit;
            psyfit.fullfit=fullfit;
            % psyfit.fixes=fixes;
            
            save([psyfit.filename(1:end-4),'_psyfitY.mat'],'psyfit');
            
            alpha= psyfit.fit.params.est(1);
            beta= psyfit.fit.params.est(2);
            gamma= psyfit.fit.params.est(3);
            lambda= psyfit.fit.params.est(4);
            schw=psyfit.fit.thresholds.est(2);
            limu=psyfit.fit.thresholds.lims(2,2);
            limo=psyfit.fit.thresholds.lims(3,2);
            JND=abs(psyfit.fit.thresholds.est(2)-psyfit.fit.thresholds.est(1));
            PSE=schw;
            
            
            xfit=[-15:0.05:15];
            ylog = 1 ./ (1 + exp((alpha - xfit) ./ beta));
            ypsi = gamma + (1 - gamma - lambda) * ylog;
            yschw=1 ./ (1 + exp((alpha - schw) ./ beta));
            yschw= gamma + (1 - gamma - lambda) * yschw;
            
            x=psyfit.result(:,1);
            y=psyfit.result(:,2);
            z=psyfit.result(:,3);
            
            xlimlo=schw-5;
            xlimhi=schw+5;
            
            plot(xfit,ypsi,'k','LineWidth',1)
            xlabel('Offset in Y [Pixel]');
            ylabel('Discrimination performance');
            title(['PSE:  ',num2str(PSE,'%1.2f'),'  JND: ',num2str(JND,'%1.2f')]);
            xlim([xlimlo xlimhi]);
            ylim([-0.05 1.05]);
            axis square
            hold on
            
            
            
            plot(schw,yschw,'ok','LineWidth',1)
            line([limu limo],[yschw yschw],'Color',[0 0 0],'LineWidth',1)
            
            
            
            
            markerSize=8*z./max(z);
            markerSize=markerSize*(1/min(markerSize));
            
            
            for k = 1: size(x,1)
                if markerSize(k)<=2
                    markerSize(k)=2;
                end
                plot(x(k),y(k),...
                    'Marker','o',...
                    'LineStyle','none',...
                    'MarkerEdgeColor',[0.0 0.0 0.0],...
                    'MarkerFaceColor',[0.5 0.5 0.5],...
                    'MarkerSize',markerSize(k));
                if xlimlo<=x(k)<=xlimhi
                    text(x(k),y(k)-0.04,num2str(z(k)),...
                        'FontSize',7.5,...
                        'Color','r');
                end
                hold on
            end
            hold off
            set(gca,'Layer','Top');
            set(gcf,'PaperPositionMode','auto')
            
        end
        
    end
    % *****************************************************************
    % *******************************************************************
elseif strcmp(CFG.method,'2d1u') % the 2 methods have different plots
    % *******************************************************************
    % *****************************************************************
    
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
    if strcmp(CFG.optotype,'E')
        fixes.lLevel=0.25;
    else
        fixes.lLevel=0.5;
    end
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
    result=zeros(nstimuli,3,'double');
    rightcor=zeros(nstimuli,1,'double');
    righttotal=zeros(nstimuli,1,'double');
    rightfalse=zeros(nstimuli,1,'double');
    leftfalse=zeros(nstimuli,1,'double');
    leftcor=zeros(nstimuli,1,'double');
    
    for i=1:size(data,1);
        pos = find(stimuli==data(i,2));
        if data(i,5)==1
            result(pos,2)=result(pos,2)+1;end
        
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
        
        result(pos,3)=result(pos,3)+1;
        result(:,1)=stimuli;
    end
    for i=1:nstimuli;
        result(i,2)= result(i,2)/result(i,3);
    end;
    
    resulttext= num2str(result,'   %1.3f');
    display(resulttext);
    
    % Compute bias matrix
    %  stimuluslevel= result(:,1)';
    lefttotal=result(:,3)-righttotal;
    HIT=rightcor./righttotal;
    FA=rightfalse./lefttotal;
    MISS=leftfalse./righttotal;
    CREJ=leftcor./lefttotal;
    for zt=1:length(HIT)
        if HIT(zt)<FA(zt)
            HIT(zt)=1-HIT(zt);
            FA(zt)=1-FA(zt);
        end
    end
    
    bias=struct;
    bias.Result=result;
    bias.HitRate=HIT;
    bias.FalseAlarmRate=FA;
    bias.MissRate=MISS;
    bias.CorrRejRate=CREJ;
    
    if CFG.plotcomplex == 0
        
        %%%%%%%%%%%%%%%% Simple Plot: Staircase + Intensity vs Performance
        figure('Position',[475 518 800 351]);
        subplot(1,2,1);
        stairs(abs(stim_int),'k');
        hold on
        plot(abs(stim_int),...
            'Marker','o',...
            'LineStyle','none',...
            'MarkerEdgeColor',[0.0 0.0 0.0],...
            'MarkerFaceColor',[0.5 0.5 0.5],...
            'MarkerSize',4);
        text(0.94*size(stim_int,1),stim_int(end)+2,['n = ',num2str(size(stim_int,1))],...
            'FontSize',7.5,...
            'Color','r');
        xlabel('Trial number');
        ylabel('Offset [Pixel]');
        title('Staircase');
        xlim([0 size(stim_int,1)*1.1]);
        ylim([-0.5 max(abs(stim_int))*1.05]);
        axis square
        hold off
        
        
        subplot(1,2,2);
        if strcmp(CFG.stim,'subp') && CFG.stepfactor~=1
            semilogx(result(:,1),result(:,2),...
                'LineStyle','none');
            xlimlo=min(result(:,1))/CFG.stepfactor;
            xlimhi=max(result(:,1))*CFG.stepfactor;
        elseif strcmp(CFG.optotype,'E')
            semilogx(result(:,1),result(:,2),...
                'LineStyle','none');
            xlimlo=min(result(:,1))/CFG.stepfactor;
            xlimhi=max(result(:,1))*CFG.stepfactor;
        else
            plot(result(:,1),result(:,2),'k');
            xlimlo=-0.5;
            xlimhi=max(result(:,1))*1.1;
        end
        
        % Histogram
        x=result(:,1);
        z=result(:,3);
        h=stem(x,0.35+(z./(max(z)*4)));
        set(h, 'Color',[0.8 0.8 0.8],...
            'Marker','none',...
            'LineWidth',4);
        hold on
        axis square
        
        xlabel('Offset [Pixel]');
        ylabel('Discrimination performance');
        title('Psychometric Function');
        
        xlim([xlimlo xlimhi]);
        
        ylim([0.35 1.05]);
        if strcmp(CFG.optotype,'E')
            ylim([0.05 1.05]);
        end
        
        axis square
        hold on
        markerSize=8*result(:,3)./max(result(:,3));
        for k = 1: size(result,1)
            plot(result(k,1),result(k,2),...
                'Marker','o',...
                'LineStyle','none',...
                'MarkerEdgeColor',[0.0 0.0 0.0],...
                'MarkerFaceColor',[0.5 0.5 0.5],...
                'MarkerSize',markerSize(k));
            text(result(k,1),result(k,2)-0.04,num2str(result(k,3)),...
                'FontSize',7.5,...
                'Color','r');
            hold on
        end
        hold off
        set(gca,'Layer','Top');
        set(gcf,'PaperPositionMode','auto')
        
        
        
        
        
    elseif CFG.plotcomplex == 1   % do the folllowing only when ticked in Config window
        
        
        % Fix upper and lower asymptote
        if fixes.fix==1
            result = [fixes.low fixes.lLevel fixes.lN; result];
            result =[result; fixes.up fixes.uLevel fixes.uN];
        end
        
        % Pfit will run in its folder only
        dirtext=pwd; temptext=which('pfit');
        if exist(temptext,'file')==0; error('Script halted: install pfit first');
        else pfittext=temptext(1:length(temptext)-6); cd (pfittext); end
        
        % Call PFIT
        if strcmp(CFG.optotype,'E')
            [fit fullfit]=pfit(result,'Runs',runs,'n_intervals',4,'LAMBDA_LIMITS',[0 0.2]);
            
        else
            [fit fullfit]=pfit(result,'Runs',runs,'LAMBDA_LIMITS',[0 0.2]);
        end
        display(resulttext);
        cd (dirtext);
        
        % Delete asymptote fixation from result matrix
        if fixes.fix==1
            result(1,:)=[];
            result(end,:)=[];
        end
        
        
        psyfit=struct;
        psyfit.filename=psyfname;
        psyfit.raw=rawData;
        psyfit.result=result;
        psyfit.resulttext=resulttext;
        psyfit.bias=bias;
        psyfit.fit=fit;
        psyfit.fullfit=fullfit;
        psyfit.fixes=fixes;
        
        save([psyfit.filename(1:end-4),'_psyfit.mat'],'psyfit');
        
        
        % 01 - Psychometric Function
        
        alpha= psyfit.fit.params.est(1);
        beta= psyfit.fit.params.est(2);
        gamma= psyfit.fit.params.est(3);
        lambda= psyfit.fit.params.est(4);
        schw=psyfit.fit.thresholds.est(2);
        limu=psyfit.fit.thresholds.lims(2,2);
        limo=psyfit.fit.thresholds.lims(3,2);
        
        %xfit=[min(psyfit.result(:,1))/20:0.05:max(psyfit.result(:,1))*10];
        if strcmp(CFG.optotype,'E')
            xfit=0.1:0.01:20;
        else
            xfit=0.01:0.01:10;
        end
        
        ylog = 1 ./ (1 + exp((alpha - xfit) ./ beta));
        % yweib = 1 - exp(-(xfit ./ alpha) .^ beta);
        % ygumb = 1 - exp(-exp((xfit - alpha) ./ beta));
        ypsi = gamma + (1 - gamma - lambda) * ylog;
        
        yschw=1 ./ (1 + exp((alpha - schw) ./ beta));
        yschw= gamma + (1 - gamma - lambda) * yschw;
        
        % Full simulation data = multiple PFs
        %         a=psyfit.fullfit.params.sim(:,1);
        %         b=psyfit.fullfit.params.sim(:,2);
        %          g=psyfit.fullfit.params.sim(:,3);
        %          l=psyfit.fullfit.params.sim(:,4);
        %         runs=length(a);
        %         %matr=ones(runs,1);
        %xs=matr*xfit;
        
        %         for ii=1:runs
        %             ylog = 1 ./ (1 + exp((a(ii) - xfit) ./ b(ii)));
        %             %ypsiFull(ii,:) = g(ii) + (1 - g(ii) - l(ii)) * ylog;
        %         end
        
        x=psyfit.result(:,1);
        %         y=psyfit.result(:,2);
        z=psyfit.result(:,3);
        %         maxSize=max(psyfit.result(:,3));
        %         maxN=15;
        %         minN=2;
        
        figure('ActivePositionProperty','OuterPosition','OuterPosition',[75 200 1000 400]);
        
        subplot(1,3,1);
        stairs(abs(stim_int),'k');
        hold on
        plot(abs(stim_int),...
            'Marker','o',...
            'LineStyle','none',...
            'MarkerEdgeColor',[0.0 0.0 0.0],...
            'MarkerFaceColor',[0.5 0.5 0.5],...
            'MarkerSize',4);
        text(0.94*size(stim_int,1),stim_int(end)+2,['n = ',num2str(size(stim_int,1))],...
            'FontSize',7.5,...
            'Color','r');
        xlabel('Trial number');
        ylabel('Offset [Pixel]');
        title('Staircase');
        xlim([0 size(stim_int,1)*1.1]);
        ylim([-0.5 max(abs(stim_int))*1.05]);
        axis square
        hold off
        
        
        subplot(1,3,2);
        if strcmp(CFG.stim,'subp') && CFG.stepfactor~=1
            semilogx(result(:,1),result(:,2),...
                'LineStyle','none');
            xlimlo=min(result(:,1))/CFG.stepfactor;
            xlimhi=max(result(:,1))*CFG.stepfactor;
        elseif strcmp(CFG.optotype,'E')
            semilogx(result(:,1),result(:,2),...
                'LineStyle','none');
            xlimlo=min(result(:,1))/CFG.stepfactor;
            xlimhi=max(result(:,1))*CFG.stepfactor;
        else
            plot(result(:,1),result(:,2),'k');
            xlimlo=-0.5;
            xlimhi=max(result(:,1))*1.1;
        end
        
        xlabel('Offset [Pixel]');
        ylabel('Discrimination performance');
        title('Psychometric Function');
        
        xlim([xlimlo xlimhi]);
        if strcmp(CFG.optotype,'E')
            ylim([0.05 1.05]);
        else
            ylim([0.35 1.05]);
        end
        axis square
        hold on
        
        % Histogram
        h=stem(x,0.35+(z./(max(z)*4)));
        set(h, 'Color',[0.8 0.8 0.8],...
            'Marker','none',...
            'LineWidth',4);
        hold on
        axis square
        
        
        plot(xfit,ypsi,'k','LineWidth',1)
        %
        %     title(psyfit.filename)
        title(['Threshold:  ',num2str(schw,'%1.3f'),' @ ',num2str(yschw,'%1.2f')]);
        
        % text(0.1,1,['Thr:  ',num2str(schw,'%1.3f'),' @ ',num2str(yschw,'%1.2f')]);
        %text(0.5,0.96,['CI: [',num2str(limu,'%1.3f'),',',num2str(limo,'%1.3f'),']']);
        %text(0.5,0.92,['N = ',num2str(sum(psyfit.result(:,3)),'%3.0i')]);
        % text(10,0.75,['n stim RIGHT = ',num2str(nstimr,'%3i')]);
        % text(10,0.72,['n resp RIGHT = ',num2str(nrespr,'%3i')]);
        %text(0.5,0.88,psyfit.resulttext,'FontSize',[6],...
        %     'HorizontalAlignment','left',...
        %         'VerticalAlignment','top');
        
        %         if psyfit.fixes.fix
        %             fixly=psyfit.fixes.lLevel-0.02;
        %             fixlx=0.1;
        %             fixuy=psyfit.fixes.uLevel+0.02;
        %             fixux=9;
        %
        %             text(fixlx,fixly,[num2str(psyfit.fixes.low),...
        %                 ',',num2str(psyfit.fixes.lLevel),',',num2str(psyfit.fixes.lN)],...\
        %                 'FontSize',[6],'Color',[1 0 0]);
        %             text(fixux,fixuy,[num2str(psyfit.fixes.up),...
        %                 ',',num2str(psyfit.fixes.uLevel),',',num2str(psyfit.fixes.uN)],...\
        %                 'FontSize',[6],'Color',[1 0 0]);
        %         end
        
        plot(schw,yschw,'ok','LineWidth',2)
        line([limu limo],[yschw yschw],'Color',[0 0 0],'LineWidth',2)
        
        
        markerSize=8*result(:,3)./max(result(:,3));
        for k = 1: size(result,1)
            plot(result(k,1),result(k,2),...
                'Marker','o',...
                'LineStyle','none',...
                'MarkerEdgeColor',[0.0 0.0 0.0],...
                'MarkerFaceColor',[0.5 0.5 0.5],...
                'MarkerSize',markerSize(k));
            text(result(k,1),result(k,2)-0.04,num2str(result(k,3)),...
                'FontSize',7.5,...
                'Color','r');
            hold on
        end
        
        set(gca,'Layer','Top');
        hold off
        
        
        
        % 03 - Bias plot ---------------------------------------
        % Iso-bias curves
        xc=0:0.05:1;
        ISO_bias1=[0.0 -1.0 -0.75 -0.50 -0.25 -0.10]; %%% negative = bias to HORIZONTAL = lower part in ROC%%%
        ISO_bias2=[1. 0.75 0.50 0.25 0.10]; %%% positive = bias to VERTICAL = upper part in ROC%%%
        
        x_bias1=zeros(length(xc),length(ISO_bias1));
        y_bias1=zeros(length(xc),length(ISO_bias1));
        x_bias2=zeros(length(xc),length(ISO_bias1));
        y_bias2=zeros(length(xc),length(ISO_bias1));
        
        for i=1:1:length(ISO_bias1)
            yc=(1+ ISO_bias1(i))*xc;
            y_bias1(:,i)=1-((1-yc).*xc)./(1-xc.*yc);
            x_bias1(:,i)=1-(yc-1)./(xc.*yc-1);
        end
        for i=1:1:length(ISO_bias2)
            yc=(1- ISO_bias2(i))*xc;
            y_bias2(:,i)=1-((1-yc).*xc)./(1-xc.*yc);
            x_bias2(:,i)=1-(yc-1)./(xc.*yc-1);
        end
        
        %%% ROC CURVES %%%
        xc=-3:0.05:3;
        n1= cdf( 'Normal',xc,0,1);
        sensitivity=[0 0.34 0.70 1.2 1.8]; % d-prime
        n1function=zeros(length(xc),length(sensitivity));
        n2function=zeros(length(xc),length(sensitivity));
        for i=1:1:length(sensitivity)
            n1function(:,i)=n1;
            n2function(:,i)= cdf( 'Normal' ,xc,sensitivity(i),1);
        end
        
        
        subplot(1,3,3)
        
        plot(psyfit.bias.FalseAlarmRate(1),psyfit.bias.HitRate(1),...
            'MarkerSize',8,...
            'Marker','o',...
            'LineStyle','none',...
            'LineWidth',1,...
            'MarkerEdgeColor',[0.0 0.0 0.0],...
            'MarkerFaceColor',[0.5 0.5 0.5]);
        text(psyfit.bias.FalseAlarmRate(1)+0.02,psyfit.bias.HitRate(1)-0.02,[num2str(psyfit.result(1,1)),',',num2str(psyfit.result(1,3))],'FontSize',7)
        axis([-.05 1.05 -.05 1.05])
        hold on
        
        for z=2:size(psyfit.bias.HitRate,1)
            plot(psyfit.bias.FalseAlarmRate(z),psyfit.bias.HitRate(z),...
                'MarkerSize',8,...
                'Marker','o',...
                'LineStyle','none',...
                'LineWidth',1,...
                'MarkerEdgeColor',[0.0 0.0 0.0],...
                'MarkerFaceColor',[0.5 0.5 0.5]);
            text(psyfit.bias.FalseAlarmRate(z)+0.02,psyfit.bias.HitRate(z)-0.02,[num2str(psyfit.result(z,1)),',',num2str(psyfit.result(z,3))],'FontSize',7)
        end
        xlabel('False alarm rate, p(1|0)');
        ylabel('Hit rate, p(1|1)');
        title('ROC')
        
        plot(x_bias1,y_bias1, 'k-' )
        for zz=2:length(ISO_bias1)
            text(((0.07*zz)-0.15),0.30,num2str(abs(ISO_bias1(zz))),'FontSize',6);
        end
        text(0.069*(length(ISO_bias1)+1)-0.15,0.3,'bias','FontSize',6);
        
        plot(n2function, n1function, 'Color',[0.7 0.7 0.7])
        for zz=1:length(sensitivity)
            text(0.65,(0.55+0.09*zz),num2str(sensitivity(zz)),'FontSize',6,...
                'Color',[0.7 0.7 0.7]);
        end
        text(0.65,0.60,'d-prime','FontSize',6,...
            'Color',[0.7 0.7 0.7]);
        axis square
        grid off
        
        set(gcf,'PaperPositionMode','auto')
        
    end
end

print(gcf,'-depsc2',[psyfit.filename(1:end-4),'_PLOT']);
print(gcf,'-dpng',[psyfit.filename(1:end-4),'_PLOT']);