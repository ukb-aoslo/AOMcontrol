function QuestVA_2

global SYSPARAMS StimParams VideoParams; %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

startup;

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(VA_Config);
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
        VideoParams.vidrecord = 0;
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
kb_UpConst = 'uparrow'; %ascii code for up arrow
kb_DownConst = 'downarrow'; %ascii code for down arrow
kb_RightConst = 'rightarrow'; %ascii code for right arrow
kb_LeftConst = 'leftarrow'; %ascii code for left arrow
% kb_StimConst = CFG.kb_StimConst;
kb_BadConst = 'control';
kb_StimConst = 'space';

%set up QUEST params
thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
beta = CFG.beta;
delta = CFG.delta;
gamma=.25;
ntrials = CFG.npresent;

%get the stimulus parameters
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;
fieldsize = CFG.fieldsize;
xscale = CFG.xscale;
yscale = CFG.yscale;

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
    experiment = 'Experiment Name: Quest VA';
elseif CFG.method == 's'
    experiment = 'Experiment name: 2down-1up Sensitivity';
else
end

if CFG.subject_response == '2'
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
    questparams = ['QUEST: Threshold Guess: ' num2str(CFG.thresholdGuess), ' Prior SD: ' num2str(CFG.priorSD), ' Percent Correct: ' num2str(CFG.pCorrect/100), ' Intervals: ' num2str(CFG.npresent), ' Beta: ' num2str(CFG.beta) ' Delta: ' num2str(CFG.delta)];
    fprintf(psyfid,'%s\r\n',questparams);
end

stimsize = CFG.stimsize;
if CFG.method == 'q';
    exptype = ['VA (QUEST): Circle ' stimsize];
elseif CFG.method == 's'
    exptype = ['VA (2U1D): Circle ' stimsize];
else  %do nothing
end

experiment = ['Experiment Name: ' exptype];
subject = ['Observer: ' CFG.initials];
psyfid = fopen(psyfname,'a');
fprintf(psyfid,'%s\r\n%s\r\n%s\r\nVideoFolder: %s\r\n', psyfname, experiment, subject, VideoParams.videofolder);

if CFG.method == 'q'
    fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\r\n', 'Trial#', 'Test Orient.', 'Resp.', 'Correct', 'QUEST Int', 'Trial Int', 'QUEST Mean', 'QUEST SD');
elseif CFG.method == 's'
    fprintf(psyfid, '%s\t %s\t %s\t %s\r\n', 'Trial#', 'Test Orient.', 'Resp.', 'Test Int');
else
end

fclose(psyfid);

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
startframe = 5; %the frame at which it starts presenting stimulus
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = round(fps*presentdur); %how long is the presentation
% aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
aom0seq = [zeros(1,startframe-1) zeros(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];
aom1seq =  [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];%zeros(size(aom0seq));
Mov.duration = size(aom1seq,2);
aom1pow = zeros(size(aom1seq));
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
% aom0seq = ones(size(aom1seq));

aom0locx = zeros(size(aom1seq));
aom0locy = zeros(size(aom1seq));
aom0pow = ones(size(aom1seq));
gainseq = zeros(size(aom1seq));
angleseq = zeros(size(aom1seq));
stimbeep = zeros(size(aom1seq));
stimbeep(end) = 1;
Mov.aom0seq = aom0seq;
Mov.aom1seq = aom1seq;
Mov.aom0pow = aom0pow;
Mov.aom1pow = aom0pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;
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

%generate 4afc sequence, if necessary

if CFG.subject_response == '2'
    vector = zeros(ntrials,2);
    rand_num = rand(ntrials,1);
    vector(:,1) = rand_num;
    vector((ntrials/4)+1:(2*ntrials/4), 2) = 1;
    vector((2*ntrials/4)+1:(3*ntrials/4),2) = 2;
    vector((3*ntrials/4)+1:end,2) = 3;
    sort_vector = sortrows(vector,1);
    trial_seq = sort_vector(:,2);
    %set stimulus parameters here to easily derive offset
    bar_y = 0;
    separation = thresholdGuess;
    %     imsize = stimsize+2*(separation+bar_y);
    %     if stimsize/2 == round(stimsize/2) %even
    %         center = imsize/2;
    %     else
    %         center = (imsize+1)/2;
    %     end
    offset =0;
    
else %do nothing
    trial_seq = zeros(ntrials,1);
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
                
                if questIntensity > 100
                    trialIntensity = 100;
                elseif questIntensity < 0
                    trialIntensity = 0;
                else
                    trialIntensity = questIntensity;
                end
                separation = round(trialIntensity);
                createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
                if SYSPARAMS.realsystem == 1
                    StimParams.stimpath = dirname;
                    StimParams.fprefix = fprefix;
                    StimParams.sframe = 2;
                    StimParams.eframe = 2;
                    StimParams.fext = 'bmp';
                    Parse_Load_Buffers(0);
                end
                
                laser_sel = 0;
                if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
                    bitnumber = round(8191*(2*trialIntensity-1));
                else
                    bitnumber = round(trialIntensity*1000);
                end
                
                Mov.aom1pow(:) = 1;
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
                %do nothing
                
            elseif strcmp(CFG.subject_response, '2')
                if strcmp(resp,kb_RightConst) %ie RIGHT
                    response = 0;
                    message1 = [Mov.msg ' - Subject Response:  RIGHT'];
                    if trial_seq(trial) == 0;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp, kb_DownConst) %ie DOWN
                    response = 1;
                    message1 = [Mov.msg ' - Subject Response:  LEFT'];
                    %mar = mapping(stimulus,3);
                    if trial_seq(trial)== 1;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_LeftConst) %ie LEFT
                    response = 2;
                    message1 = [Mov.msg ' - Subject Response:  LEFT'];
                    %mar = mapping(stimulus,3);
                    if trial_seq(trial)== 2;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp, kb_UpConst); %ie UP
                    response = 3;
                    message1 = [Mov.msg ' - Subject Response:  UP'];
                    %mar = mapping(stimulus,3);
                    if trial_seq(trial)== 3;
                        correct = 1;
                    else
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;
                elseif strcmp(resp,kb_BadConst)
                    GetResponse = 0;
                    response = 2;
                    good_check = 0;
                end;
            end
            if GetResponse == 0
                if good_check == 1
                    
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a+');
                    fprintf(psyfid,'%s\t%s\t%s\t%s\t%4.4f\t%4.4f\t%4.4f\t%4.4f\r\n',VideoParams.vidname,num2str(trial_seq(trial)),num2str(response),num2str(correct),questIntensity,trialIntensity,QuestMean(q),QuestSd(q));
                    fclose(psyfid);
                    theThreshold(trial,1) = QuestMean(q); %#ok<AGROW>
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
    maxInt = 100.0; minInt = 0;
    
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
                separation = trialIntensity;
                createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
                if SYSPARAMS.realsystem == 1
                    StimParams.stimpath = dirname;
                    StimParams.fprefix = fprefix;
                    StimParams.sframe = 2;
                    StimParams.eframe = 2;
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
                %removed -- do nothing
            elseif strcmp(CFG.subject_response, '2')
                if strcmp(resp,kb_RightConst) %ie RIGHT
                    response = 0;
                    message1 = [Mov.msg ' - Subject Response:  RIGHT'];
                    if trial_seq(trial) == 0; %ie, correct response
                        if flag == 0;
                            flag = 1;
                            lastIntensity = trialIntensity;
                        elseif flag == 1;
                            flag = 0;
                            if trialIntensity == minInt;
                                lastIntensity = trialIntensity;
                                trialIntensity = minInt;
                            else
                                lastIntensity = trialIntensity;
                                trialIntensity = trialIntensity-stepsize;
                            end
                        end
                        correct = 1;
                    elseif trial_seq(trial) ~= 0; %ie incorrect response
                        response = 0;
                        message1 = [Mov.msg ' - Subject Response:  RIGHT'];
                        if trialIntensity == maxInt
                            lastIntensity = trialIntensity;
                            trialIntensity = maxInt;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity+stepsize;
                        end
                        flag = 0;
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_DownConst) %ie DOWN
                    response = 1;
                    message1 = [Mov.msg ' - Subject Response:  DOWN'];
                    if trial_seq(trial) == 1; %ie, correct response
                        if flag == 0;
                            flag = 1;
                            lastIntensity = trialIntensity;
                        elseif flag == 1;
                            flag = 0;
                            if trialIntensity == minInt;
                                lastIntensity = trialIntensity;
                                trialIntensity = minInt;
                            else
                                lastIntensity = trialIntensity;
                                trialIntensity = trialIntensity-stepsize;
                            end
                        end
                        correct = 1;
                    elseif trial_seq(trial) ~= 1; %ie incorrect response
                        response = 1;
                        message1 = [Mov.msg ' - Subject Response:  DOWN'];
                        if trialIntensity == maxInt
                            lastIntensity = trialIntensity;
                            trialIntensity = maxInt;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity+stepsize;
                        end
                        flag = 0;
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_LeftConst) %ie LEFT
                    response = 2;
                    message1 = [Mov.msg ' - Subject Response:  LEFT'];
                    if trial_seq(trial) == 2; %ie, correct response
                        if flag == 0;
                            flag = 1;
                            lastIntensity = trialIntensity;
                        elseif flag == 1;
                            flag = 0;
                            if trialIntensity == minInt;
                                lastIntensity = trialIntensity;
                                trialIntensity = minInt;
                            else
                                lastIntensity = trialIntensity;
                                trialIntensity = trialIntensity-stepsize;
                            end
                        end
                        correct = 1;
                    elseif trial_seq(trial) ~= 2; %ie incorrect response
                        response = 2;
                        message1 = [Mov.msg ' - Subject Response:  LEFT'];
                        if trialIntensity == maxInt
                            lastIntensity = trialIntensity;
                            trialIntensity = maxInt;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity+stepsize;
                        end
                        flag = 0;
                        correct = 0;
                    end
                    GetResponse = 0;
                    good_check = 1;  %indicates if it was a good trial
                elseif strcmp(resp,kb_UpConst) %ie UP
                    response = 3;
                    message1 = [Mov.msg ' - Subject Response:  UP'];
                    if trial_seq(trial) == 3; %ie, correct response
                        if flag == 0;
                            flag = 1;
                            lastIntensity = trialIntensity;
                        elseif flag == 1;
                            flag = 0;
                            if trialIntensity == minInt;
                                lastIntensity = trialIntensity;
                                trialIntensity = minInt;
                            else
                                lastIntensity = trialIntensity;
                                trialIntensity = trialIntensity-stepsize;
                            end
                        end
                        correct = 1;
                    elseif trial_seq(trial) ~= 3; %ie incorrect response
                        response = 3;
                        message1 = [Mov.msg ' - Subject Response:  UP'];
                        if trialIntensity == maxInt
                            lastIntensity = trialIntensity;
                            trialIntensity = maxInt;
                        else
                            lastIntensity = trialIntensity;
                            trialIntensity = trialIntensity+stepsize;
                        end
                        flag = 0;
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
                    if trial == 1
                        message2 = ['Intensity Tested: ' num2str(lastIntensity)];
                    else
                        message2 = ['Intensity Tested: ' num2str(lastIntensity)];
                    end
                    message = sprintf('%s\n%s', message1, message2);
                    set(handles.aom1_state, 'String',message);
                    
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a+');
                    if CFG.fieldsize == 0.9;
                        MARconvert=2.1094;
                    elseif CFG.fieldsize == 1.2;
                        MARconvert=2.8125;
                    else MARconvert=1;
                    end
                    
                    if trial == 1;
                        fprintf(psyfid,'%s\t%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(trial_seq(trial)),num2str(response),lastIntensity);
                        theThreshold(trial,1) = trialIntensity*MARconvert; %#ok<AGROW>
                    else
                        fprintf(psyfid,'%s\t%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(trial_seq(trial)),num2str(response),lastIntensity);
                        theThreshold(trial,1) = lastIntensity*MARconvert; %#ok<AGROW>
                    end
                    
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
                        xlabel('Trial Number');
                        ylabel('Stroke Width (pixels)');
                        %                         title('MAR vs. Trial Number');
                    else %continue experiment
                    end
                end
                PresentStimulus = 1;
            end
        end
    end
    
elseif CFG.method == '4'
    %do nothing for this experiment
elseif CFG.method == 'm'
    %do nothing for this experiment
end


function createStimulus(trialIntensity, trial_seq, trial, bar_y, separation)
% global offset
CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
if strcmp(CFG.subject_response, '2')
    %     stimsize = CFG.stimsize;
    %     bar_y = 0;
    %     separation = 10;
    separation = round(separation);
    if separation == 0;
        separation = 1;
    else
    end
    imsize = separation*5;
    stim_im = zeros(imsize, imsize);
    stim_im(separation+1:2*separation, separation+1:end) = 1;
    stim_im(3*separation+1:4*separation, separation+1:end) = 1;

    %KEY: 0 = right; 1 = down; 2 = left; 3 = up;
    %     offset = center-((bar_y+1)/2);
    if trial_seq(trial)==1  %invert image for trial_seq = 1;
        stim_im = imrotate(stim_im,-90); %ie DOWN
    elseif trial_seq(trial) == 2; %ie LEFT
        stim_im = imrotate(stim_im, 180);
    elseif trial_seq(trial) == 3; %ie UP
        stim_im = imrotate(stim_im, 90);
    else %do nothing
    end
    
else %do nothing
end

% figure, imshow(stim_im)
stim_im = 1-stim_im;
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    %     tic
    imwrite(stim_im,'frame2.bmp');
    fid = fopen('frame2.buf','w');
    fwrite(fid,size(stim_im,2),'uint16');
    fwrite(fid,size(stim_im,1),'uint16');
    fwrite(fid, stim_im, 'double');
    fclose(fid);
else
    cd([pwd,'\tempStimulus']);
end
imwrite(stim_im,'frame2.bmp');
fid = fopen('frame2.buf','w');
fwrite(fid,size(stim_im,2),'uint16');
fwrite(fid,size(stim_im,1),'uint16');
fwrite(fid, stim_im, 'double');
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
    imwrite(dummy,'frame2.bmp');
    fid = fopen('frame2.buf','w');
    fwrite(fid,size(dummy,2),'uint16');
    fwrite(fid,size(dummy,1),'uint16');
    fwrite(fid, dummy, 'double');
    fclose(fid);
end
cd ..;

