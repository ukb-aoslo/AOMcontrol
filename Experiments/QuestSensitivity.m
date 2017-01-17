function QuestSensitivity

global SYSPARAMS StimParams VideoParams; %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

startup;

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(QuestSensitivityConfig);
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
        psyfname = set_VideoParams_PsyfileName();
        hAomControl = getappdata(0,'hAomControl');
        Parse_Load_Buffers(1);
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

%setup the keyboard constants and response mappings from config
kb_AbortConst = 'escape'; %abort constant - Esc Key
kb_BadConst = 'uparrow'; %ascii code for up arrow
% kb_NoConst = 'downarrow'; %ascii code for down arrow
kb_YesConst = 'rightarrow'; %ascii code for right arrow
kb_NoConst = 'leftarrow'; %ascii code for left arrow
%kb_StimConst = CFG.kb_StimConst;
kb_StimConst = 'space';

%set up QUEST params
thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
beta = CFG.beta;
delta = CFG.delta;
gamma=.25;
% fps = 30;
% presentdur = CFG.presentdur/1000;
ntrials = CFG.npresent;

%offsets
green_x_offset = CFG.green_x_offset; green_y_offset = CFG.green_y_offset;
red_x_offset = CFG.red_x_offset; red_y_offset = CFG.red_y_offset;

%get the stimulus parameters
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;
% fieldsize = CFG.fieldsize;

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
if CFG.method == 'q'
    %initialize QUEST
    q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma);
else
end

%write your exp specific psyfile header
if CFG.method == 'q'
    experiment = 'Experiment Name: Quest Sensitivity';
elseif CFG.method == 's'
    experiment = 'Experiment name: 2up-1down Sensitivity';
elseif CFG.method == '4'
    experiment = 'Experiment name: 4-2dB Sensitivity';
elseif CFG.method == 'm'
    experiment = 'Experiment name: MOCS';
else
end

if CFG.subject_response == 'y'
    response_paradigm = 'Response Paradigm: Yes/No';
elseif CFG.subject_response == '2'
    response_paradigm = 'Response Paradigm: 2AFC';
else
end

subject = ['Observer: ' CFG.initials];
pupil = ['Pupil Size (mm): ' CFG.pupilsize];
field = ['Field Size (deg): ' num2str(CFG.fieldsize)];
presentdur = ['Presentation Duration (ms): ' num2str(CFG.presentdur)];
iti = ['Intertrial Interval (ms): ' num2str(CFG.iti)];
videoprefix = ['Video Prefix: ' CFG.vidprefix];
videodur = ['Video Duration: ' num2str(CFG.videodur)];

psyfid = fopen(psyfname,'a');
fprintf(psyfid,'%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n', psyfname, experiment, response_paradigm, subject, pupil,field, presentdur, iti, videoprefix, videodur);

if CFG.method == 'q'
    num_trials = ['Number of Trials: ' num2str(CFG.npresent)];
    fprintf(psyfid,'%s\r\n',num_trials);
    questparams = ['QUEST: ThreshGuess: ' num2str(CFG.thresholdGuess), ' Prior SD: ' num2str(CFG.priorSD), ' %Correct: ' num2str(CFG.pCorrect/100), ' B: ' num2str(CFG.beta) ' D: ' num2str(CFG.delta)];
    fprintf(psyfid,'%s\r\n',questparams);
end

% % stimsize = 0;
% stimsize = StimParams.stimpath(1,end-2:end-1);
stimsize = CFG.stimsize;
% if CFG.method == 'q';
%     exptype = ['Sensitivity (QUEST): Circle ' num2str(stimsize)];
% elseif CFG.method == 's'
%     exptype = ['Sensitivity (2U1D): Circle ' num2str(stimsize)];
% elseif CFG.method == '4'
%     exptype = ['Sensitivity (4-2dB): Circle ' num2str(stimsize)];
% elseif CFG.method == 'm'
%     exptype = ['Sensitivity (MOCS): Circle ' num2str(stimsize)];
% else  %do nothing
% end

% experiment = ['Experiment Name: ' exptype];
% subject = ['Observer: ' CFG.initials];
% psyfid = fopen(psyfname,'a');
fprintf(psyfid,'%s\r\nVideoFolder: %s\r\n', num2str(stimsize), VideoParams.videofolder);

if CFG.method == 'q'
    fprintf(psyfid,'%s %s %s %s %s %s\r\n', 'Trial#', 'Resp.', 'QUEST Int', 'Trial Int', 'QUEST Mean', 'QUEST SD');
elseif CFG.method == 's'
    fprintf(psyfid, '%s\t %s\t %s\r\n', 'Trial#', 'Resp.', 'Test Int');
elseif CFG.method == '4'
    fprintf(psyfid, '%s\t %s\t %s\r\n', 'Trial#', 'Resp.', 'Test Int');
elseif CFG.method == 'm'
    fprintf(psyfid, '%s\t %s\t %s\r\n', 'Trial#', 'Resp.', 'Test Int');
else
end

fclose(psyfid);


SYSPARAMS.aoms_state(2)=1; % SWITCH RED ON
SYSPARAMS.aoms_state(3)=1; % SWITCH GREEN ON

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
framenum2 = 3;
framenum3 = 4;
startframe = 10; %the frame at which it starts presenting stimulus
cueframe = 5; cuedur = 2; 
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = round(fps*presentdur); %how long is the presentation
numframes = fps*CFG.videodur;
%AOM1 (RED) parameters
if CFG.red_stim_color == 1;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
elseif CFG.red_stim_color == 0;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,30-startframe+1-stimdur)];
end

% aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];

aom1pow = ones(size(aom1seq));
aom1pow(:) = 0.250;
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
aom1offx(:) = red_x_offset;
aom1offy(:) = red_y_offset;

%AOM2 (GREEN) paramaters
if CFG.green_stim_color == 1;
    aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
elseif CFG.green_stim_color == 0;
    aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,30-startframe+1-stimdur)];
end

% aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];

aom2pow = ones(size(aom1seq));
aom2pow(:) = 0.250;
aom2locx = zeros(size(aom1seq));
aom2locy = zeros(size(aom1seq));
aom2offx = zeros(size(aom1seq));
aom2offx(:) = green_x_offset;
aom2offy = zeros(size(aom1seq));
aom2offy(:) = green_y_offset;

%AOM0 (IR) parameters
% aom0seq = ones(size(aom1seq));
aom0seq = zeros(size(aom1seq));
% aom0seq = [zeros(1,cueframe-1) ones(1,stimdur).*framenum3 zeros(1,30-startframe+1-stimdur)];
aom0locx = zeros(size(aom1seq));
aom0locy = zeros(size(aom1seq));
aom0pow = ones(size(aom1seq));

gainseq = CFG.gain*ones(size(aom1seq));
angleseq = zeros(size(aom1seq));
stimbeep = zeros(size(aom1seq));
stimbeep(startframe+stimdur-1) = 1;
%stimbeep = [zeros(1,startframe+stimdur-1) 1 zeros(1,30-startframe-stimdur+2)];
%Set up movie parameters
Mov.duration = size(aom1seq,2);
Mov.aom0seq = aom0seq;
Mov.aom1seq = aom1seq;
Mov.aom0pow = aom0pow;
Mov.aom1pow = aom1pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;
Mov.aom2seq = aom2seq;
Mov.aom2pow = aom2pow;
Mov.aom2locx = aom2locx;
Mov.aom2locy = aom2locy;
Mov.aom2offx = aom2offx;
Mov.aom2offy = aom2offy;
Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.stimbeep = stimbeep;
Mov.frm = 1;
Mov.seq = '';

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
good_check = 1;

%generate 2afc sequence, if necessary

if CFG.subject_response == '2'
    vector = zeros(ntrials,2);
    rand_num = rand(ntrials,1);
    vector(:,1) = rand_num;
    vector((ntrials/2)+1:end, 2) = 1;
    sort_vector = sortrows(vector,1);
    trial_seq = sort_vector(:,2);
    %set stimulus parameters here to easily derive offset
    bar_y = 3;
    separation = 10;
    imsize = stimsize+2*(separation+bar_y);
    if stimsize/2 == round(stimsize/2) %even
        center = imsize/2;
    else
        center = (imsize+1)/2;
    end
    offset = center-((bar_y+1)/2);
    
else %do nothing
    trial_seq = zeros(ntrials,1); trial_seq(:) = 2;
    bar_y = 0;
    separation = 0;
    offset = 0;
end
if CFG.method == 'q'
    
    while(runExperiment ==1)
        uiwait;
        %         resp = get(handles.aom_main_figure,'CurrentCharacter');
        resp = get(handles.aom_main_figure,'CurrentKey');
        if strcmp(resp,kb_AbortConst);
            runExperiment = 0;
            uiresume;
            TerminateExp;
            message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            set(handles.aom1_state, 'String',message);
        elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
            if PresentStimulus == 1;
                %find out the new spot intensity for this trial (from QUEST)
                if (good_check == 1)
                    questIntensity=QuestQuantile(q);
                end
                
                if questIntensity > 1
                    trialIntensity = 1;
                elseif questIntensity < 0
                    trialIntensity = 0;
                else
                    trialIntensity = questIntensity;
                end
                
                createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
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
                
                if strcmp(CFG.subject_response, 'y')
                    Mov.aom1pow(:) = trialIntensity;
                elseif strcmp(CFG.subject_response, '2')
                    Mov.aom1pow(:) = 1.000;
                end
                    
                Mov.frm = 1;
                Mov.duration = CFG.videodur*fps;
                offset = abs(offset);
                if trial_seq(trial)==1;
                    offset = -(offset);
                elseif trial_seq(trial) == 0;
                    offset = abs(offset);
                else
                    offset = 0;
                end
                aom1offy2 = zeros(size(aom1seq));
                aom1offy2(:) = offset+aom1offy;
                Mov.aom1offy = aom1offy2;
                
                message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
                Mov.msg = message;
                Mov.seq = '';
                setappdata(hAomControl, 'Mov',Mov);
                
                VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
              %   command = ['UpdatePower#' num2str(laser_sel) '#' num2str(bitnumber) '#'];            %#ok<NASGU>
                   
                PlayMovie;
                PresentStimulus = 0;
                GetResponse = 1;
            end
            
        elseif(GetResponse == 1)
            if strcmp(CFG.subject_response, 'y')
                if strcmp(resp,kb_YesConst)
                    response = 1;
                    message1 = [Mov.msg ' - Stimulus seen? Yes'];
                    correct = 1;
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_NoConst)
                    response = 0;
                    message1 = [Mov.msg ' - Stimulus seen? No'];
                    correct = 0;
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
                
            elseif strcmp(CFG.subject_response, '2')
                if strcmp(resp,kb_YesConst) %ie above bar
                    response = 1;
                    message1 = [Mov.msg ' - Stimulus:  UP'];
                    if trial_seq(trial) == 1;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_NoConst) %ie below bar
                    response = 0;
                    message1 = [Mov.msg ' - Stimulus:  DOWN'];
                    if trial_seq(trial)== 0;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
            end
            if GetResponse == 0
                if good_check == 1
                    message2 = ['QUEST Test Intensity: ' num2str(trialIntensity)];
                    message = sprintf('%s\n%s', message2, message1);
                    set(handles.aom1_state, 'String',message);
                    
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a');
                    fprintf(psyfid,'%s %d %4.4f %4.4f %4.4f %4.4g\r\n',VideoParams.vidname,response,questIntensity,trialIntensity,QuestMean(q),QuestSd(q));
                    fclose(psyfid);
                    theThreshold(trial,1) = QuestMean(q); %#ok<AGROW>
%                     theThreshold(trial,1) = trialIntensity; %#ok<AGROW>
                    
                    %update QUEST
                    q = QuestUpdate(q,trialIntensity,correct);
                    
                    message3 = ['QUEST Threshold Estimate (Intensity): ' num2str(QuestMean(q),3)];
                    message = sprintf('%s\n%s', message1, message3);
                    set(handles.aom1_state, 'String',message);
                    
                    %update trial counter
                    trial = trial + 1;
                    if(trial > ntrials)
                        runExperiment = 0;
                        set(handles.aom_main_figure, 'keypressfcn','');
                        TerminateExp;
                        message = ['Off - Experiment Complete - Minimum Visible Spot Intensity: ' num2str(QuestMean(q),3) ' ± ' num2str(QuestSd(q),3)];
                        set(handles.aom1_state, 'String',message);
                        figure;
                        plot(theThreshold);
                        xlabel('Trial number');
                        ylabel('Min Vis Spot Intensity');
                        title('Threshold estimate vs. Trial Number');
                    else %continue experiment
                    end
                end
                PresentStimulus = 1;
            end
        end
    end
    
elseif CFG.method == 's'
    
    t1 = clock;
    good_check = 1;
    
    trialIntensity = thresholdGuess; %starting threshold for staircase
    flag = 0;
    maxInt = 1.0; minInt = 0;
    
    stepsize = CFG.priorSD;
    
    while(runExperiment ==1)
        uiwait;
        %         resp = get(handles.aom_main_figure,'CurrentCharacter');
        resp = get(handles.aom_main_figure,'CurrentKey');
        if strcmp(resp,kb_AbortConst);
            runExperiment = 0;
            uiresume;
            TerminateExp;
            message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            set(handles.aom1_state, 'String',message);
        elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
            if PresentStimulus == 1;
                if trial == 1
                    trialIntensity = thresholdGuess;
                else
                end
                createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
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
                
                if strcmp(CFG.subject_response, 'y')
                    Mov.aom1pow(:) = trialIntensity;
                elseif strcmp(CFG.subject_response, '2')
                    Mov.aom1pow(:) = 1.000;
                end
                
                Mov.frm = 1;
                Mov.duration = CFG.videodur*fps;
                offset = abs(offset);
                if trial_seq(trial)==1;
                    offset = -(offset);
                elseif trial_seq(trial) == 0;
                    offset = abs(offset);
                else
                    offset = 0;
                end
                
                aom1offy2 = zeros(size(aom1seq));
                aom1offy2(:) = offset+aom1offy;
                Mov.aom1offy = aom1offy2;
                
                message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
                Mov.msg = message;
                Mov.seq = '';
                setappdata(hAomControl, 'Mov',Mov);
                
                VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
                %   command = ['UpdatePower#' num2str(laser_sel) '#' num2str(bitnumber) '#'];            %#ok<NASGU>
                PlayMovie;
                PresentStimulus = 0;
                GetResponse = 1;
            end
            
        elseif(GetResponse == 1)
            if strcmp(CFG.subject_response, 'y')
                if strcmp(resp,kb_YesConst)
                    response = 1;
                    message1 = [Mov.msg ' - Stimulus seen? Yes'];
                    if flag == 0;
                        flag = 1; %repeat level a second time if seen
                        lastIntensity = trialIntensity;
                    elseif flag ==1; %reduce intensity b/c seen once before
                        flag = 0; %reset flag to zero
                        if trialIntensity == minInt;
                            lastIntensity = trialIntensity;
                            trialIntensity = 0;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity-stepsize;
                        end
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                    
                elseif strcmp(resp,kb_NoConst)
                    response = 0;
                    message1 = [Mov.msg ' - Stimulus seen? No'];
                    
                    if trialIntensity == maxInt
                        lastIntensity = trialIntensity;
                        trialIntensity = 1;
                    else
                        lastIntensity = trialIntensity;
                        trialIntensity = trialIntensity+stepsize;
                    end
                    flag = 0;
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                    
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                    
                end;
            elseif strcmp(CFG.subject_response, '2')
                if strcmp(resp,kb_YesConst) %ie above bar
                    response = 1;
                    message1 = [Mov.msg ' - Stimulus:  UP'];
                    if trial_seq(trial) == 1; %ie, correct response
                        if flag == 0;
                            flag = 1;
                            lastIntensity = trialIntensity;
                        elseif flag == 1;
                            flag = 0;
                            if trialIntensity == minInt;
                                lastIntensity = trialIntensity;
                                trialIntensity = 0;
                            else
                                lastIntensity = trialIntensity;
                                trialIntensity = trialIntensity-stepsize;
                            end
                        end
                    elseif trial_seq(trial) == 0; %ie incorrect response
                        response = 0;
                        message1 = [Mov.msg ' - Stimulus:  DOWN'];
                        if trialIntensity == maxInt
                            lastIntensity = trialIntensity;
                            trialIntensity = 1;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity+stepsize;
                        end
                        flag = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_NoConst) %ie below bar
                    response = 0;
                    message1 = [Mov.msg ' - Stimulus:  DOWN'];
                    if trial_seq(trial) == 0; %ie, correct response
                        if flag == 0;
                            flag = 1;
                            lastIntensity = trialIntensity;
                        elseif flag == 1;
                            flag = 0;
                            if trialIntensity == minInt;
                                lastIntensity = trialIntensity;
                                trialIntensity = 0;
                            else
                                lastIntensity = trialIntensity;
                                trialIntensity = trialIntensity-stepsize;
                            end
                        end
                    elseif trial_seq(trial) == 1; %ie incorrect response
                        response = 0; 
                        message1 = [Mov.msg ' - Stimulus:  UP'];
                        if trialIntensity == maxInt
                            lastIntensity = trialIntensity;
                            trialIntensity = 1;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity+stepsize;
                        end
                        flag = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
            end
            if GetResponse == 0
                if good_check == 1
                    if trial == 1
                        message2 = ['Intensity Tested: ' num2str(trialIntensity)];
                    else
                        message2 = ['Intensity Tested: ' num2str(lastIntensity)];
                    end
                    message = sprintf('%s\n%s', message1, message2);
                    set(handles.aom1_state, 'String',message);
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a+');
                    if trial == 1;
                        fprintf(psyfid,'%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(response),lastIntensity);
                        theThreshold(trial,1) = lastIntensity; %#ok<AGROW>
                    else
                        fprintf(psyfid,'%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(response),lastIntensity);
                        theThreshold(trial,1) = lastIntensity; %#ok<AGROW>
                    end
                    %                 fprintf(psyfid,'%s\t%s\t%4.4f\t%4.4f\t%4.4f\t%4.4f\r\n',VideoParams.vidname,num2str(response),questIntensity,trialIntensity,QuestMean(q),QuestSd(q));
                    %                 fclose(psyfid);
                    
                    %update trial counter
                    trial = trial + 1;
                    if(trial > ntrials)
                        t2 = clock; time_elapsed = etime(t2,t1); %in seconds
                        fprintf(psyfid, '%s\t%4.4f\r\n', 'Time elapsed: ', time_elapsed);
                        fclose(psyfid);
                        runExperiment = 0;
                        set(handles.aom_main_figure, 'keypressfcn','');
                        TerminateExp;
                        message = ['Off - Experiment Complete - Last Intensity Tested: ' num2str(theThreshold(end,1))];
                        set(handles.aom1_state, 'String',message);
                        figure;
                        plot(theThreshold);
                        xlabel('Trial number');
                        ylabel('Spot Intensity');
                        title('Test Intensity vs. Trial Number');
                        ylim([minInt maxInt]);
                    else %continue experiment
                    end
                end
                PresentStimulus = 1;
            end
        end
    end
    
elseif CFG.method == '4'
    good_check = 1;
    trialIntensity = thresholdGuess; %starting threshold for staircase
    rev_count = 0; iteration = 0;
    maxInt = 1.0; minInt = 0; tnum = 1;
    stepsize = 4; %in dB (initially)
    max_count = 0;
    t1 = clock;
    
    while(runExperiment ==1)
        uiwait;
        %         resp = get(handles.aom_main_figure,'CurrentCharacter');
        resp = get(handles.aom_main_figure,'CurrentKey');
        if strcmp(resp,kb_AbortConst);
            runExperiment = 0;
            uiresume;
            TerminateExp;
            message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            set(handles.aom1_state, 'String',message);
        elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
            if PresentStimulus == 1;
                createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
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
                
                if strcmp(CFG.subject_response, 'y')
                    Mov.aom1pow(:) = trialIntensity;
                elseif strcmp(CFG.subject_response, '2')
                    Mov.aom1pow(:) = 1.000;
                end
                
                Mov.frm = 1;
                Mov.duration = CFG.videodur*fps;
                offset = abs(offset);
                if trial_seq(trial)==1;
                    offset = -(offset);
                elseif trial_seq(trial) == 0;
                    offset = abs(offset);
                    
                else
                    offset = 0;
                end
                aom1offy(:) = offset;
                Mov.aom1offy = aom1offy;
                
                message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
                Mov.msg = message;
                Mov.seq = '';
                setappdata(hAomControl, 'Mov',Mov);
                
                VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
                %   command = ['UpdatePower#' num2str(laser_sel) '#' num2str(bitnumber) '#'];            %#ok<NASGU>
                PlayMovie;
                PresentStimulus = 0;
                GetResponse = 1;
            end
            
        elseif(GetResponse == 1)
            if strcmp(resp,kb_YesConst)
                if strcmp(CFG.subject_response, 'y');
                    response = 1; %stimulus seen
                    message1 = [Mov.msg ' - Stimulus seen? Yes'];
                    if tnum == 1;  %first trial
                        if trialIntensity < minInt;
                            trialIntensity = 0;
                            last_resp = 1; tnum = 0;
                        else
                            trialIntensity = trialIntensity*(10^(-stepsize/10));
                            last_resp = 1; tnum = 0;
                        end
                        
                    elseif last_resp == response;   %subsequent trial, no reversal
                        if rev_count == 0; %no reversal yet
                            if trialIntensity < minInt;
                                trialIntensity = 0;
                                last_resp = 1;
                            else
                                trialIntensity = trialIntensity*(10^(-stepsize/10));
                                last_resp = 1;
                            end
                        elseif rev_count == 1;  %working top-down after a reversal; keep going until a no
                            if trialIntensity < minInt;
                                trialIntensity = 0;
                                last_resp = 1;
                            else
                                trialIntensity = trialIntensity*(10^(-stepsize/10));
                                last_resp = 1;
                            end
                        end
                        
                    elseif last_resp ~= response;   % a yes following a no
                        if rev_count == 0;   %started with no or a string of no's; first reversal
                            stepsize = 2;
                            if trialIntensity < minInt;
                                trialIntensity = 0;
                                last_resp = 1; rev_count = 1;
                            else
                                trialIntensity = trialIntensity*(10^(-stepsize/10));
                                last_resp = 1; rev_count = 1;
                            end
                            
                        elseif rev_count == 1   %terminate loop on a yes (down then up);
                            rev_count = 0; iteration = iteration + 1; tnum = 1;
                            thresh(iteration) = (trialIntensity+(trialIntensity*(10^(-stepsize/10))))/2;
                            stepsize = 4;
                            if iteration<3;
                                trialIntensity = trialIntensity*(10^(stepsize/10)); %move starting point 4db up from last level
                            else
                            end
                        end
                        
                    end
                elseif strcmp(CFG.subject_response, '2')
                    response = 1; %stimulus seen as UP
                    if trial_seq(trial) == 1;
                        correct = 1;
                    elseif trial_seq(trial) == 0;
                        correct = 0;
                    end
                    message1 = [Mov.msg ' - Stimulus: UP'];
                    if tnum == 1;  %first trial
                        if trial_seq(trial) == 1; %CORRECT
                            if trialIntensity < minInt;
                                trialIntensity = 0;
                                last_resp = 1; tnum = 0; last_corr = 1;
                            else
                                trialIntensity = trialIntensity*(10^(-stepsize/10));
                                last_resp = 1; tnum = 0; last_corr = 1;
                            end
                        elseif trial_seq(trial) == 0; %INCORRECT
                            if trialIntensity > maxInt;
                                trialIntensity = 1;
                                max_count = max_count+1;
                                last_resp = 1; tnum = 0; last_corr = 0;
                            else
                                trialIntensity = trialIntensity*(10^(stepsize/10));
                                last_resp = 1; tnum = 0; last_corr = 0;
                            end
                        end
                    elseif last_corr == correct;   %subsequent trial, no reversal
                        if rev_count == 0; %no reversal yet
                            if trial_seq(trial) == 1;   %CORRECT
                                if trialIntensity < minInt;
                                    trialIntensity = 0;
                                    last_resp = 1; last_corr = 1;
                                else
                                    trialIntensity = trialIntensity*(10^(-stepsize/10));
                                    last_resp = 1; last_corr = 1;
                                end
                            elseif trial_seq(trial) == 0;   %INCORRECT
                                %add in INCORRECT
                                if trialIntensity > maxInt
                                    max_count = max_count+1;
                                    last_resp = 1; last_corr = 0;
                                else
                                    trialIntensity = trialIntensity*(10^(stepsize/10));
                                    last_resp = 1; last_corr = 0;
                                end
                            end
                        elseif rev_count == 1;  %working top-down after a reversal; keep going until a no
                            if trial_seq(trial) == 1; %CORRECT
                                if trialIntensity < minInt;
                                    trialIntensity = 0;
                                    last_resp = 1; last_corr = 1;
                                else
                                    trialIntensity = trialIntensity*(10^(-stepsize/10));
                                    last_resp = 1; last_corr = 1;
                                end
                            elseif trial_seq(trial) == 0; %INCORRECT
                                if trialIntensity > maxInt
                                    max_count = max_count+1;
                                    last_resp = 1; last_corr = 0;
                                else
                                    trialIntensity = trialIntensity*(10^(stepsize/10));
                                    last_resp = 1; last_corr = 0;
                                end
                            end
                        end
                        
                    elseif last_corr ~= correct;   % a yes following a no
                        if rev_count == 0;   %started with no or a string of no's; first reversal
                            stepsize = 2;
                            if trial_seq(trial) == 1;  %CORRECT
                                if trialIntensity < minInt;
                                    trialIntensity = 0;
                                    last_resp = 1; rev_count = 1; last_corr = 1;
                                else
                                    trialIntensity = trialIntensity*(10^(-stepsize/10));
                                    last_resp = 1; rev_count = 1; last_corr = 1;
                                end
                            elseif trial_seq(trial) == 0;  %INCORRECT
                                if trialIntensity > maxInt
                                    max_count = max_count+1;
                                    last_resp = 1; last_corr = 0;
                                else
                                    trialIntensity = trialIntensity*(10^(stepsize/10));
                                    last_resp = 1; last_corr = 0;
                                end
                            end
                            
                        elseif rev_count == 1   %terminate loop on a yes (down then up);
                            rev_count = 0; iteration = iteration + 1; tnum = 1;
                            if trial_seq(trial) == 1; %correct
                                thresh(iteration) = (trialIntensity+(trialIntensity*(10^(-stepsize/10))))/2;
                            elseif trial_seq(trial) == 0; %incorrect
                                thresh(iteration) = (trialIntensity+(trialIntensity*(10^(stepsize/10))))/2;
                            end
                            stepsize = 4;
                            if iteration<3;
                                trialIntensity = trialIntensity*(10^(stepsize/10)); %move starting point 4db up from last level
                            else
                            end
                        end
                        
                    end
                end
                
                
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
                
            elseif strcmp(resp,kb_NoConst)
                if strcmp(CFG.subject_response, 'y')
                    response = 0;  %stimulus not seen
                    message1 = [Mov.msg ' - Stimulus seen? No'];
                    
                    if tnum == 1;  %first trial
                        if trialIntensity > maxInt;
                            trialIntensity = 1;
                            max_count = max_count+1;
                            last_resp = 0; tnum = 0;
                        else
                            trialIntensity = trialIntensity*(10^(stepsize/10));
                            last_resp = 0; tnum = 0;
                        end
                        
                        
                    elseif last_resp == response;   %subsequent trial, no reversal
                        if rev_count == 0; %no reversal yet; starting with a string of no's
                            if trialIntensity > maxInt;
                                trialIntensity = 1;
                                max_count = max_count+1; last_resp = 0;
                            else
                                trialIntensity = trialIntensity*(10^(stepsize/10)); last_resp = 0;
                            end
                            
                        elseif rev_count == 1;  %working bottom-up after a reversal; keep going until a yes
                            if trialIntensity > maxInt;
                                trialIntensity = 1;
                                max_count = max_count+1; last_resp = 0;
                            else
                                trialIntensity = trialIntensity*(10^(stepsize/10)); last_resp = 0;
                            end
                            
                        end
                        
                    elseif last_resp ~= response;   % a no following a yes
                        if rev_count == 0;   %started with yes or a string of yeses; first reversal
                            stepsize = 2;
                            if trialIntensity > maxInt;
                                trialIntensity = 1;
                                max_count = max_count+1; last_resp = 0; rev_count = 1;
                            else
                                trialIntensity = trialIntensity*(10^(stepsize/10)); last_resp = 0; rev_count = 1;
                            end
                            
                        elseif rev_count == 1   %terminate loop on a no (up then down);
                            rev_count = 0; iteration = iteration + 1; tnum = 1;
                            thresh(iteration)=(trialIntensity+(trialIntensity*(10^(stepsize/10))))/2;
                            stepsize = 4;
                            if iteration<3;
                                trialIntensity = trialIntensity*(10^(stepsize/10)); %move starting point 4db up from last level
                            else
                            end
                        end
                        
                    end
                    
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                    
                elseif strcmp(CFG.subject_response, '2')
                    response = 0; %stimulus seen as DOWN
                    if trial_seq(trial) == 1;
                        correct = 0;
                    elseif trial_seq(trial) == 0;
                        correct = 1;
                    end
                    message1 = [Mov.msg ' - Stimulus: DOWN'];
                    if tnum == 1;  %first trial
                        if trial_seq(trial) == 0; %CORRECT
                            if trialIntensity < minInt;
                                trialIntensity = 0;
                                last_resp = 0; tnum = 0; last_corr = 1;
                            else
                                trialIntensity = trialIntensity*(10^(-stepsize/10));
                                last_resp = 0; tnum = 0; last_corr = 1;
                            end
                        elseif trial_seq(trial) == 1; %INCORRECT
                            if trialIntensity > maxInt;
                                trialIntensity = 1;
                                max_count = max_count+1;
                                last_resp = 0; tnum = 0; last_corr = 0;
                            else
                                trialIntensity = trialIntensity*(10^(stepsize/10));
                                last_resp = 0; tnum = 0; last_corr = 0;
                            end
                        end
                    elseif last_corr == correct;   %subsequent trial, no reversal
                        if rev_count == 0; %no reversal yet
                            if trial_seq(trial) == 0;   %CORRECT
                                if trialIntensity < minInt;
                                    trialIntensity = 0;
                                    last_resp = 0; last_corr = 1;
                                else
                                    trialIntensity = trialIntensity*(10^(-stepsize/10));
                                    last_resp = 0; last_corr = 1;
                                end
                            elseif trial_seq(trial) == 1;   %INCORRECT
                                %add in INCORRECT
                                if trialIntensity > maxInt
                                    max_count = max_count+1;
                                    last_resp = 0; last_corr = 0;
                                else
                                    trialIntensity = trialIntensity*(10^(stepsize/10));
                                    last_resp = 0; last_corr = 0;
                                end
                            end
                        elseif rev_count == 1;  %working top-down after a reversal; keep going until a no
                            if trial_seq(trial) == 0; %CORRECT
                                if trialIntensity < minInt;
                                    trialIntensity = 0;
                                    last_resp = 0; last_corr = 1;
                                else
                                    trialIntensity = trialIntensity*(10^(-stepsize/10));
                                    last_resp = 0; last_corr = 1;
                                end
                            elseif trial_seq(trial) == 1; %INCORRECT
                                if trialIntensity > maxInt
                                    max_count = max_count+1;
                                    last_resp = 0; last_corr = 0;
                                else
                                    trialIntensity = trialIntensity*(10^(stepsize/10));
                                    last_resp = 0; last_corr = 0;
                                end
                            end
                        end
                        
                    elseif last_corr ~= correct;   % a yes following a no
                        if rev_count == 0;   %started with no or a string of no's; first reversal
                            stepsize = 2;
                            if trial_seq(trial) == 0;  %CORRECT
                                if trialIntensity < minInt;
                                    trialIntensity = 0;
                                    last_resp = 0; rev_count = 1; last_corr = 1;
                                else
                                    trialIntensity = trialIntensity*(10^(-stepsize/10));
                                    last_resp = 0; rev_count = 1; last_corr = 1;
                                end
                            elseif trial_seq(trial) == 1;  %INCORRECT
                                if trialIntensity > maxInt
                                    max_count = max_count+1;
                                    last_resp = 0; last_corr = 0;
                                else
                                    trialIntensity = trialIntensity*(10^(stepsize/10));
                                    last_resp = 0; last_corr = 0;
                                end
                            end
                            
                        elseif rev_count == 1   %terminate loop on a yes (down then up);
                            rev_count = 0; iteration = iteration + 1; tnum = 1;
                            if trial_seq(trial) == 0; %correct
                                thresh(iteration) = (trialIntensity+(trialIntensity*(10^(-stepsize/10))))/2;
                            elseif trial_seq(trial) == 1; %incorrect
                                thresh(iteration) = (trialIntensity+(trialIntensity*(10^(stepsize/10))))/2;
                            end
                            stepsize = 4;
                            if iteration<3;
                                trialIntensity = trialIntensity*(10^(stepsize/10)); %move starting point 4db up from last level
                            else
                            end
                        end
                        
                    end
                end
                
            elseif strcmp(resp,kb_BadConst)
                GetResponse = 0;
                response = 2;
                good_check = 0;
            end
            
            if GetResponse == 0
                if good_check == 1
                    message2 = ['4-2 Threshold Estimate (Intensity): ' num2str(trialIntensity)];
                    message = sprintf('%s\n%s', message1, message2);
                    set(handles.aom1_state, 'String',message);
                    
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a+');
                    fprintf(psyfid,'%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(response),trialIntensity);
                    %                 fclose(psyfid);
                    
                    theThreshold(trial,1) = trialIntensity; %#ok<AGROW>
                    
                    
                    %update trial counter
                    trial = trial + 1;
                    if max_count == 3 %terminate trial after three attempts at ceiling
                        iteration = 3;
                        thresh(:) = 1;
                        est_thresh = mean(thresh(:));
                        runExperiment = 0;
                        set(handles.aom_main_figure, 'keypressfcn','');
                        TerminateExp;
                        fprintf(psyfid, '%s\t%4.4f\r\n', 'Average Thresh: ', est_thresh);
                        fclose(psyfid);
                        %
                    else
                    end
                    
                    if(iteration == 3)
                        est_thresh = mean(thresh(:));
                        t2 = clock; time_elapsed = etime(t2,t1);
                        runExperiment = 0;
                        set(handles.aom_main_figure, 'keypressfcn','');
                        TerminateExp;
                        
                        figure;
                        plot(theThreshold); %plot(1:trial, mean(thresh(:)));
                        xlabel('Trial number');
                        ylabel('Test Intensity');
                        title('Test Intensity vs. Trial Number');
                        
                        if mean(thresh(:))<1
                            fprintf('Threshold Estimate: %s\n', num2str(mean(thresh(:))));
                        else
                            fprintf('Threshold Estimate: Absolute scotoma; adjust red laser power');
                        end
                        fprintf(psyfid, '%s\t%4.4f\r\n', 'Time elapsed: ', time_elapsed);
                        fprintf(psyfid, '%s\t%4.4f\r\n', 'Average Thresh: ', est_thresh);
                        fclose(psyfid);
                    else %continue experiment
                    end
                    
                end
                PresentStimulus = 1;
            end
        end
    end
    
elseif CFG.method == 'm'
    
    %set initial while loop conditions
    runExperiment = 1;
    trial = 1;
    PresentStimulus = 1;
    GetResponse = 0;
    set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
    good_check = 1;
    num_levels = CFG.beta; trialsperlevel = CFG.delta;
    ntrials = num_levels.*trialsperlevel;
    range = CFG.priorSD/100;
    psy_matrix = zeros(ntrials, 3);
    
    if range == 1.0;
        Intensity_Vector = (0:range/(num_levels-1):1.0)';
    else
        Intensity_Vector = (thresholdGuess-(range/2):range/(num_levels-1):thresholdGuess+(range/2))';
    end
    
    test_vector = rand(ntrials,1);
    test_vector(:,2) = 0;
    n = 1;
    for int = 1:num_levels;
        test_vector(n:trialsperlevel*int,2) = int;
        n = n+trialsperlevel;
    end
    
    test_sequence = sortrows(test_vector);
    test_sequence(:,1)= [];
    
    while(runExperiment ==1)
        uiwait;
        resp = get(handles.aom_main_figure,'CurrentKey');
        if strcmp(resp,kb_AbortConst);
            runExperiment = 0;
            uiresume;
            TerminateExp;
            message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            set(handles.aom1_state, 'String',message);
        elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
            if PresentStimulus == 1;
                
                trialLevel = test_sequence(trial);
                trialIntensity = Intensity_Vector(trialLevel);
                
                createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
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
                
                if strcmp(CFG.subject_response, 'y')
                    Mov.aom1pow(:) = trialIntensity;
                elseif strcmp(CFG.subject_response, '2')
                    Mov.aom1pow(:) = 1.000;
                end
                
                Mov.frm = 1;
                Mov.duration = CFG.videodur*fps;
                offset = abs(offset);
                if trial_seq(trial)==1;
                    offset = -(offset);
                elseif trial_seq(trial) == 0;
                    offset = abs(offset);
                else
                    offset = 0;
                end
                
                aom1offy(:) = offset;
                Mov.aom1offy = aom1offy;
                message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
                Mov.msg = message;
                Mov.seq = '';
                setappdata(hAomControl, 'Mov',Mov);
                
                VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
                %   command = ['UpdatePower#' num2str(laser_sel) '#' num2str(bitnumber) '#'];            %#ok<NASGU>
                PlayMovie;
                PresentStimulus = 0;
                GetResponse = 1;
            end
            
        elseif(GetResponse == 1)
            if strcmp(CFG.subject_response, 'y')
                if strcmp(resp,kb_YesConst)
                    response = 1;
                    message1 = [Mov.msg ' - Stimulus seen? Yes'];
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                    psy_matrix(trial,1) = trialIntensity; psy_matrix(trial,2) = response;
                    if trialIntensity > 0
                        psy_matrix(trial,3) = trialIntensity*response;
                    else
                        trialIntensity = 0.00001;
                        psy_matrix(trial,3) = trialIntensity*response;
                    end
                    
                elseif strcmp(resp,kb_NoConst)
                    response = 0;
                    message1 = [Mov.msg ' - Stimulus seen? No'];
                    %                 correct = 0;
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                    psy_matrix(trial,1) = trialIntensity; psy_matrix(trial,2) = response;
                    if trialIntensity > 0
                        psy_matrix(trial,3) = trialIntensity*response;
                    else
                        trialIntensity = 0.00001;
                        psy_matrix(trial,3) = trialIntensity*response;
                    end
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
            elseif strcmp(CFG.subject_response, '2')
                if strcmp(resp,kb_YesConst) %ie above bar
                    response = 1;
                    message1 = [Mov.msg ' - Stimulus:  UP'];
                    if trial_seq(trial) == 1;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    psy_matrix(trial,1) = trialIntensity; psy_matrix(trial,2) = correct;
                    if trialIntensity > 0
                        psy_matrix(trial,3) = trialIntensity*correct;
                    else
                        trialIntensity = 0.00001;
                        psy_matrix(trial,3) = trialIntensity*correct;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_NoConst) %ie below bar
                    response = 0;
                    message1 = [Mov.msg ' - Stimulus:  DOWN'];
                    %mar = mapping(stimulus,3);
                    if trial_seq(trial)== 0;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    psy_matrix(trial,1) = trialIntensity; psy_matrix(trial,2) = correct;
                    if trialIntensity > 0
                        psy_matrix(trial,3) = trialIntensity*correct;
                    else
                        trialIntensity = 0.00001;
                        psy_matrix(trial,3) = trialIntensity*correct;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
            end
            if GetResponse == 0
                if good_check == 1
                    %                 message2 = ['QUEST Test Intensity: ' num2str(QuestMean(q),3)];
                    %                 message = sprintf('%s\n%s', message1, message2);
                    %                 set(handles.aom1_state, 'String',message);
                    
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a+');
                    fprintf(psyfid,'%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(response),trialIntensity);
                    fclose(psyfid);
                    theThreshold(trial,1) = trialIntensity; %#ok<AGROW>
                    %update QUEST
                    %                     q = QuestUpdate(q,trialIntensity,correct);
                    
                    message3 = ['Intensity Tested: ' num2str(trialIntensity)];
                    message = sprintf('%s\n%s', message1, message3);
                    set(handles.aom1_state, 'String',message);
                    
                    %update trial counter
                    trial = trial + 1;
                    if(trial > ntrials)
                        runExperiment = 0;
                        set(handles.aom_main_figure, 'keypressfcn','');
                        TerminateExp;
                        %                         message = ['Off - Experiment Complete - Minimum Visible Spot Intensity: ' num2str(QuestMean(q),3) ' ± ' num2str(QuestSd(q),3)];
                        %                         set(handles.aom1_state, 'String',message);
                        pfit_matrix = zeros(num_levels, 3);
                        
                        for n = 1:num_levels
                            intensity = Intensity_Vector(n);
                            if intensity == 0;
                                intensity = 0.00001;
                            else
                            end
                            [row col] = find(psy_matrix(:,3)==intensity);
                            count = size(row,1);
                            pfit_matrix(n,3) = count/trialsperlevel;
                        end
                        pfit_matrix(:,1) = Intensity_Vector; pfit_matrix(:,2) = trialsperlevel;
                        disp(pfit_matrix);
                        figure;
                        plot(pfit_matrix(:,1), pfit_matrix(:,3), 'rx');
                        xlabel('Test Intensity');
                        ylabel('Proportion Seen');
                        title('Psychometric Function (MOCS)');
                    else %continue experiment
                    end
                end
                PresentStimulus = 1;
            end
        end
    end
    
end


function createStimulus(trialIntensity, trial_seq, trial, bar_y, separation)
% global offset
CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
if strcmp(CFG.subject_response, '2')
    stimsize = CFG.stimsize;
    bar_y = 3;
    separation = 10;
    imsize = bar_y*2+separation*2+stimsize;
    stim_im = zeros(imsize, imsize);
    if strcmp(CFG.stim_shape, 'Square')
        
        if (stimsize/2)==round(stimsize/2) %stimsize even
            center = imsize/2;
            halfstim = stimsize/2;
            stim_im(center-halfstim:center+halfstim-1, center-halfstim:center+halfstim-1) = 1;
        elseif (stimsize/2)~=round(stimsize/2) %stimsize odd
            center = (imsize+1)/2;
            halfstim = (stimsize-1)/2;
            stim_im(center-halfstim:center+halfstim, center-halfstim:center+halfstim) = 1;
        else %do nothing
        end
        
        stim_im = stim_im.*trialIntensity;
        stim_im(1:bar_y, :) = 1;
        
    elseif strcmp(CFG.stim_shape, 'Circle')
        if (stimsize/2)~=round(stimsize/2) %stimsize odd
            armlength = (stimsize-1)/2;
            center = (imsize+1)/2;
            for radius = 1:armlength
                theta = (0:0.001:2*pi);
                xcircle = radius*cos(theta)+ center; ycircle = radius*sin(theta)+ center;
                xcircle = round(xcircle); ycircle = round(ycircle);
                nn = size(xcircle); nn = nn(2);
                xymat = [xcircle' ycircle'];
                for point = 1:nn
                    row = xymat(point,2); col2 = xymat(point,1);
                    stim_im(row,col2)= 1;
                end
            end
            stim_im(center, center)=1;
            stim_im = stim_im.*trialIntensity;
            stim_im(1:bar_y, :) = 1;
            
        elseif (stimsize/2)==(round(stimsize/2)) %stimsize even
            stim_im = zeros(imsize+1, imsize+1);
            armlength = (stimsize)/2;
            center = (imsize+2)/2;
            for radius = 1:armlength
                theta = (0:0.001:2*pi);
                xcircle = radius*cos(theta)+ center; ycircle = radius*sin(theta)+ center;
                xcircle = round(xcircle); ycircle = round(ycircle);
                nn = size(xcircle); nn = nn(2);
                xymat = [xcircle' ycircle'];
                for point = 1:nn
                    row = xymat(point,2); col2 = xymat(point,1);
                    stim_im(row,col2)= 1;
                end
            end
            stim_im(center, center)=1;
            stim_im(center,:) = []; stim_im(:,center)=[];
            stim_im = stim_im.*trialIntensity;
            stim_im(1:bar_y, :) = 1;
        else %do nothing
        end
        
    else  %do nothing
    end
    
    %     offset = center-((bar_y+1)/2);
    if trial_seq(trial)==1  %invert image for trial_seq = 1;
        stim_im = imrotate(stim_im,180); %ie UP
        %         offset = -offset;
    else %do nothing
    end
    
elseif strcmp(CFG.subject_response, 'y')
    
    stimsize = CFG.stimsize;
    imsize = stimsize;
    stim_im = zeros(imsize, imsize);
    if strcmp(CFG.stim_shape, 'Square')
        stim_im = zeros(imsize+2,imsize+2);
        stim_im(1:end-1,1:end-1) = 1;
        stim_im = stim_im.*trialIntensity;
        
    elseif strcmp(CFG.stim_shape, 'Circle')
        if (stimsize/2)~=round(stimsize/2) %stimsize odd
            armlength = (stimsize-1)/2;
            center = (imsize+1)/2;
            for radius = 1:armlength
                theta = (0:0.001:2*pi);
                xcircle = radius*cos(theta)+ center; ycircle = radius*sin(theta)+ center;
                xcircle = round(xcircle); ycircle = round(ycircle);
                nn = size(xcircle); nn = nn(2);
                xymat = [xcircle' ycircle'];
                for point = 1:nn
                    row = xymat(point,2); col2 = xymat(point,1);
                    stim_im(row,col2)= 1;
                end
            end
            stim_im(center, center)=1;
            stim_im = stim_im.*trialIntensity;
            
            
        elseif (stimsize/2)==(round(stimsize/2)) %stimsize even
            stim_im = zeros(imsize+1, imsize+1);
            armlength = (stimsize)/2;
            center = (imsize+2)/2;
            for radius = 1:armlength
                theta = (0:0.001:2*pi);
                xcircle = radius*cos(theta)+ center; ycircle = radius*sin(theta)+ center;
                xcircle = round(xcircle); ycircle = round(ycircle);
                nn = size(xcircle); nn = nn(2);
                xymat = [xcircle' ycircle'];
                for point = 1:nn
                    row = xymat(point,2); col2 = xymat(point,1);
                    stim_im(row,col2)= 1;
                end
            end
            stim_im(center, center)=1;
            stim_im(center,:) = []; stim_im(:,center)=[];
            stim_im = stim_im.*trialIntensity;
        else %do nothing
        end
        
    else  %do nothing
    end
    
end

% spacing = stimsize*1.5;
% 
% ir_im = ones(spacing*3, spacing*3);
% 
% ir_im(1:spacing, 1:spacing) = 0;
% ir_im(1:spacing, spacing*2+1:end) =0;
% ir_im(spacing*2+1:end, 1:spacing) = 0;
% ir_im(spacing*2+1:end, spacing*2+1:end) = 0;

ir_im = ones(21, 21);
ir_im(:,9:13)=0;
ir_im(9:13,:)=0;

% figure, imshow(stim_im)

if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    %     tic
    blank_im = zeros(size(stim_im,1),size(stim_im,2));
    imwrite(stim_im,'frame2.bmp');
    imwrite(blank_im,'frame3.bmp');
%     fid = fopen('frame2.buf','w');
%     fwrite(fid,size(stim_im,2),'uint16');
%     fwrite(fid,size(stim_im,1),'uint16');
%     fwrite(fid, stim_im, 'double');
%     fclose(fid);
else
    cd([pwd,'\tempStimulus']);
end
blank_im = zeros(size(stim_im,1),size(stim_im,2));
imwrite(stim_im,'frame2.bmp');
imwrite(blank_im,'frame3.bmp');
imwrite(ir_im,'frame4.bmp');
% fid = fopen('frame2.buf','w');
% fwrite(fid,size(stim_im,2),'uint16');
% fwrite(fid,size(stim_im,1),'uint16');
% fwrite(fid, stim_im, 'double');
% fclose(fid);
cd ..;



function startup

dummy=ones(10,10);
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    
    imwrite(dummy,'frame2.bmp');
%     fid = fopen('frame2.buf','w');
%     fwrite(fid,size(dummy,2),'uint16');
%     fwrite(fid,size(dummy,1),'uint16');
%     fwrite(fid, dummy, 'double');
%     fclose(fid);
else
    cd([pwd,'\tempStimulus']);
    delete ('*.*');
    imwrite(dummy,'frame2.bmp');
%     fid = fopen('frame2.buf','w');
%     fwrite(fid,size(dummy,2),'uint16');
%     fwrite(fid,size(dummy,1),'uint16');
%     fwrite(fid, dummy, 'double');
%     fclose(fid);
end
cd ..;

