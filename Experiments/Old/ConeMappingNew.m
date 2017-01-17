function ConeMappingNew
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
        return;
    end
end

%setup the keyboard constants and response mappings from config
kb_AbortConst = 'escape'; %abort constant - Esc Key
kb_BadConst = 'uparrow'; %ascii code for up arrow
% kb_NoConst = 'downarrow'; %ascii code for down arrow
kb_YesConst = 'rightarrow'; %ascii code for right arrow
kb_NoConst = 'leftarrow'; %ascii code for left arrow
kb_StimConst = 'space';

%generate (or load) trial matrix and index seqeunce for cone mapping;
if CFG.offset_script == 1;
    if exist([cd '\lastMappingname.mat'],'file') == 2; %continue last session
        load([cd '\lastMappingname.mat']);
        if exist(matfname,'file') == 2;
            load(matfname);
            if endflag == 1;
                choice = questdlg('Last mapping complete. Start new session?', ...
                    'Cone Mapping', ...
                    'Yes', 'No', 'Yes');
                switch choice
                    case 'Yes'
                        %insert code here to generate offset_script
                        [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence] = offset_mapping(CFG);
                        restart_Quest = 0;
                        psyfname = psyfname1; psyflag = 1;
                        %generate MAT file name for data saving;
                        matfname = [psyfname(1:end-4) '_threshold_data.mat'];
                        response_matrix = struct([]);
                    case 'No'
                        TerminateExp;
                end
            elseif endflag == 0;
                choice = questdlg('Continue with last experiment or start afresh?',...
                    'Cone Mapping', ...
                    'Continue with previous', 'Start new exp', 'Continue with previous');
                switch choice
                    case 'Continue with previous'
                        %continue with experiment; variables include trial_matrix,
                        %index_sequence, offset_matrix, counter, endflag
                        restart_Quest = 1; psyflag = 0;
                    case 'Start new exp',
                        %insert code here to generate offset_script
                        [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence] = offset_mapping(CFG);
                        restart_Quest = 0;
                        psyfname = psyfname1; psyflag = 1;
                        %generate MAT file name for data saving;
                        matfname = [psyfname(1:end-4) '_threshold_data.mat'];
                        response_matrix = struct([]);
                end
            else
                TerminateExp;
            end
        else
            choice = questdlg('No unfinished mapping found. Start new session?', ...
                'Cone Mapping', ...
                'Yes', 'No', 'Yes');
            switch choice
                case 'Yes'
                    %insert code here to generate offset_script
                    [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence] = offset_mapping(CFG);
                    restart_Quest = 0;
                    psyfname = psyfname1; psyflag = 1;
                    %generate MAT file name for data saving;
                    matfname = [psyfname(1:end-4) '_threshold_data.mat'];
                    response_matrix = struct([]);
                case 'No'
                    TerminateExp;
            end
        end
    else %no unfinished mapping found
        choice = questdlg('No unfinished mapping found. Start new session?', ...
            'Cone Mapping', ...
            'Yes', 'No', 'Yes');
        switch choice
            case 'Yes'
                %insert code here to generate offset_script
                [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence] = offset_mapping(CFG);
                restart_Quest = 0;
                psyfname = psyfname1; psyflag = 1;
                %generate MAT file name for data saving;
                matfname = [psyfname(1:end-4) '_threshold_data.mat'];
                response_matrix = struct([]);
                
            case 'No'
                TerminateExp;
        end
    end
    
    ntrials = numcones*size(trial_matrix,1);
    
else
    %do nothing
    numtrials = CFG.npresent+CFG.ncatch+CFG.nlapse;
%     trial_matrix = 0;
%     index_sequence = 0;
    offset_matrix = 0;
%     numcones = 1;
    ntrials = numtrials;
    response_matrix = struct([]);
    psyfname = psyfname1; psyflag = 1;
    restart_Quest = 0;
    numcones = 1;
    trial_matrix = zeros(numtrials, numcones);
    for nc = 1:numcones
        temp_mat = ones(numtrials,2);
        temp_mat(:,1)=randn(numtrials,1);
        temp_mat(1:CFG.ncatch,2) = 0; %0 indicates catch trial
        temp_mat(end-CFG.nlapse+1:end,2) = 2; %2 indicates lapse trial
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
    exp_sequence = zeros(numcones*numtrials,5);
    n = 1;
    for m = 1:size(index_sequence,3)
        for p = 1:size(index_sequence,1)
            exp_sequence(n,1) = index_sequence(p,1,m); %cone
            exp_sequence(n,2) = trial_matrix(m,index_sequence(p,1,m)); %trial_flag
            exp_sequence(n,3) = 0; %x offset
            exp_sequence(n,4) = 0; %y offset
            exp_sequence(n,5) = m;
            n = n+1;
        end
    end
    matfname = [psyfname(1:end-4) '_threshold_data.mat'];
end

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
    gamma = 0.05;
elseif CFG.subject_response == '2'
    response_paradigm = 'Response Paradigm: 2AFC';
    gamma = 0.50;
else
end

%set up QUEST params
thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
beta = CFG.beta;
delta = CFG.delta;
% ntrials = CFG.npresent;

%set up QUEST parameters
if CFG.method == 'q'
    %initialize QUEST; change to q(1:numcones) to nest multiple staircases;
    if restart_Quest ==0;
        q(1:numcones)=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma);
    else
    end
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
if psyflag == 1;
    fprintf(psyfid,'%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n', psyfname, experiment, response_paradigm, subject, pupil,field, presentdur, iti, videoprefix, videodur);
else
    %do nothing
end

if CFG.method == 'q'
    num_trials = ['Number of Trials: ' num2str(CFG.npresent)];
    questparams = ['QUEST: ThreshGuess: ' num2str(CFG.thresholdGuess), ' Prior SD: ' num2str(CFG.priorSD), ' %Correct: ' num2str(CFG.pCorrect/100), ' B: ' num2str(CFG.beta) ' D: ' num2str(CFG.delta)];
    if psyflag == 1;
        fprintf(psyfid,'%s\r\n',num_trials);
        fprintf(psyfid,'%s\r\n',questparams);
    else
        %do nothing
    end
end

% stimsize = StimParams.stimpath(1,end-2:end-1);
stimsize = CFG.stimsize;
separation = round(10*(512/(CFG.fieldsize*60)));
if psyflag == 1;
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
else
    %do nothing
end

fclose(psyfid);


SYSPARAMS.aoms_state(2)=1; % SWITCH RED ON
SYSPARAMS.aoms_state(3)=1; % SWITCH GREEN ON

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
framenum2 = 3;
framenum3 = 4;
startframe = 6; %the frame at which it starts presenting stimulus
cueframe = 5; cuedur = 2;
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = round(fps*presentdur); %how long is the presentation
numframes = fps*CFG.videodur;
%AOM1 (RED) parameters
if CFG.red_stim_color == 1;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.red_stim_color == 0;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,numframes-startframe+1-stimdur)];
end
% aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];

aom1pow = ones(size(aom1seq));
aom1pow(:) = 0.250;
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
aom2pow(:) = 0.250;
aom2offx = zeros(size(aom1seq));
aom2offx(:) = green_x_offset;
aom2offy = zeros(size(aom1seq));
aom2offy(:) = green_y_offset;

%AOM0 (IR) parameters
aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % just for TCA shift confirmation purposes:
% aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,numframes-startframe+1-stimdur)];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% aom0seq = zeros(size(aom1seq));
%for cuing in IR;
% aom0seq = [zeros(1,cueframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
aom0locx = zeros(size(aom1seq));
aom0locy = zeros(size(aom1seq));
aom0pow = ones(size(aom1seq));

gainseq = zeros(size(aom1seq))+CFG.gain;
angleseq = zeros(size(aom1seq));
stimbeep = zeros(size(aom1seq));
stimbeep(startframe+stimdur-1) = 1;
%stimbeep = [zeros(1,startframe+stimdur-1) 1 zeros(1,numframes-startframe-stimdur+2)];
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
Mov.aom2offx = aom2offx;
Mov.aom2offy = aom2offy;
Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.stimbeep = stimbeep;
Mov.frm = 1;
Mov.seq = '';

%set initial while loop conditions
runExperiment = 1;
% trial = 1;
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
    %     separation = 10;
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

if exist('trial', 'var') == 1;
    if endflag == 1;
        trial = 1;
    else
        %do nothing
    end
elseif exist('trial', 'var') == 0;
    trial = 1;
else
    %do nothing
end
    

if CFG.method == 'q'
    while(runExperiment ==1)
        uiwait;
        resp = get(handles.aom_main_figure,'CurrentKey');
        if strcmp(resp,kb_AbortConst);
            runExperiment = 0;
            uiresume;
            TerminateExp;
            message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            set(handles.aom1_state, 'String',message);
            save(matfname, 'response_matrix', 'endflag','trial', 'numcones', 'trial_matrix', 'offset_matrix', 'exp_sequence','q');%, 'CFG');
            save([cd '\lastMappingname.mat'], 'matfname', 'psyfname');
            
        elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
            if PresentStimulus == 1;
                %find out which cone we're targeting
                nc = exp_sequence(trial,1);
                line_num = exp_sequence(trial,5);
                
                %determine x- and y-offsets
                y_off = exp_sequence(trial,4);
                x_off = exp_sequence(trial,3);    
                
                %determine trial flag (0 = catch; 1 = QUEST; 2 = lapse)
                trial_flag = exp_sequence(trial,2);
                
                %find out the new spot intensity for this trial (from quest)
                if trial_flag == 1; %part of quest staircase
                    if (good_check == 1)
                        questIntensity=questQuantile(q(nc));
                    end
                    
                    if questIntensity > 1 %AOM limits between 0 and 1;
                        trialIntensity = 1;
                    elseif questIntensity < 0
                        trialIntensity = 0;
                    else
                        trialIntensity = questIntensity;
                    end
                elseif trial_flag == 0; %catch trial
                    trialIntensity = 0;
                    questIntensity = 0;
                elseif trial_flag == 2; %lapse trial
                    trialIntensity = 1;
                    questIntensity = 1;
                end
                
                %create stimulus on the fly
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
%use aom1 offsets
                %AOM1 (RED) offsets for cone mapping
                if CFG.red_stim_color == 1;
                    aom1offx = zeros(1,size(aom1seq,2));
                    aom1offx(1,:) = x_off;%+red_x_offset; %TCA correction
                    Mov.aom1offx = aom1offx;
                    aom1offy = zeros(1,size(aom1seq,2));
                    aom1offy(1,:) = y_off;%red_y_offset-y_off;%+red_y_offset;  %TCA correction
                    Mov.aom1offy = aom1offy;
                elseif CFG.red_stim_color == 0;
                    aom1offx = zeros(1,size(aom1seq,2));
                    Mov.aom1offx = aom1offx;
                    aom1offy = zeros(1,size(aom1seq,2));
                    Mov.aom1offy = aom1offy;
                end
                
                %AOM2 (GREEN) offsets for cone mapping
                if CFG.green_stim_color == 1;
                    aom2offx = zeros(1,size(aom1seq,2));
                    aom2offx(1,:) = x_off;%+green_x_offset; %TCA correction
                    Mov.aom2offx = aom2offx;
                    aom2offy = zeros(1,size(aom1seq,2));
                    aom2offy(1,:) = y_off;%green_y_offset-y_off;%+green_y_offset; %TCA correction
                    Mov.aom2offy = aom2offy;
                elseif CFG.green_stim_color == 0;
                    aom2offx = zeros(1,size(aom1seq,2));
                    Mov.aom2offx = aom2offx;
                    aom2offy = zeros(1,size(aom1seq,2));
                    Mov.aom2offy = aom2offy;
                end
% %or use aom0loc commands                 
%                 %AOM1 (RED) offsets for cone mapping
%                 if CFG.red_stim_color == 1;
%                     aom0locx = zeros(1,size(aom1seq,2));
%                     aom0locx(1,:) = x_off;
%                     Mov.aom0locx = aom0locx;
%                     aom0locy = zeros(1,size(aom1seq,2));
%                     aom0locy(1,:) = y_off;
%                     Mov.aom0locy = aom0locy;
%                 elseif CFG.red_stim_color == 0;
%                     aom0locx = zeros(1,size(aom1seq,2));
%                     Mov.aom0locx = aom0locx;
%                     aom0locy = zeros(1,size(aom1seq,2));
%                     Mov.aom0locy = aom0locy;
%                 end
%                 
%                 %AOM2 (GREEN) offsets for cone mapping
%                 if CFG.green_stim_color == 1;
%                     aom2offx = zeros(1,size(aom1seq,2));
%                     aom2offx(1,:) = x_off;
%                     Mov.aom2offx = aom2offx;
%                     aom2offy = zeros(1,size(aom1seq,2));
%                     aom2offy(1,:) = y_off;
%                     Mov.aom2offy = aom2offy;
%                 elseif CFG.green_stim_color == 0;
%                     aom2offx = zeros(1,size(aom1seq,2));
%                     Mov.aom2offx = aom2offx;
%                     aom2offy = zeros(1,size(aom1seq,2));
%                     Mov.aom2offy = aom2offy;
%                 end
                
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
                    
                    %update QUEST
                    if trial_flag == 1;
                        q(nc) = QuestUpdate(q(nc),trialIntensity,correct);
                    else
                        %do nothing
                    end
                    
                    %save data in response_matrix for writing to
                    %.mat file
                    response_matrix(line_num,nc).trialIntensity = trialIntensity;
                    response_matrix(line_num,nc).questIntensity = questIntensity;
                    response_matrix(line_num,nc).response = response;
                    response_matrix(line_num,nc).questMean = QuestMean(q(nc));
                    response_matrix(line_num,nc).questSD = QuestSD(q(nc));
                    response_matrix(line_num,nc).trial_flag = trial_flag;
                    folder = VideoParams.videofolder; vidname = VideoParams.vidname;
                    response_matrix(line_num,nc).video_name = [folder vidname '.avi'];
                    endflag = 0;
                    %write response to psyfile
                    psyfid = fopen(psyfname,'a');
                    fprintf(psyfid,'%s %d %4.4f %4.4f %4.4f %4.4g\r\n',VideoParams.vidname,response,questIntensity,trialIntensity,QuestMean(q(nc)),QuestSd(q(nc)));
                    fclose(psyfid);
                    theThreshold(trial,1) = QuestMean(q(nc)); %#ok<AGROW>
                    theThreshold(trial,2) = trialIntensity; %#ok<AGROW>
                    message3 = ['QUEST Threshold Estimate (Intensity): ' num2str(QuestMean(q(nc)),3)];
                    message = sprintf('%s\n%s', message1, message3);
                    set(handles.aom1_state, 'String',message);
%                     name = [cd '\lastMapping.mat'];
                    save(matfname, 'response_matrix', 'endflag', 'trial', 'numcones', 'trial_matrix', 'offset_matrix', 'exp_sequence','q');%,'CFG');
                    save([cd '\lastMappingname.mat'], 'matfname', 'psyfname');
                    %update trial counter
                    trial = trial + 1;
                    if(trial > ntrials)
                        runExperiment = 0;
                        endflag = 1;
                        set(handles.aom_main_figure, 'keypressfcn','');
                        TerminateExp;
                        message = ['Off - Experiment Complete - Minimum Visible Spot Intensity: ' num2str(QuestMean(q(nc)),3) ' ± ' num2str(QuestSd(q(nc)),3)];
                        set(handles.aom1_state, 'String',message);
                        
%                         %plot threshold estimate vs trial number for each
%                         %cone
%                         for col = 1:size(response_matrix,2);
%                             for row = 1:size(response_matrix,1);
%                                 trialMatrix(row,col) = response_matrix(row,col).trialIntensity;
%                                 questMatrix(row,col) = response_matrix(row,col).questIntensity;
%                                 respMatrix(row,col) = response_matrix(row,col).response;
%                                 threshMatrix(row,col) = response_matrix(row,col).questMean;
%                                 sdMatrix(row,col) = response_matrix(row,col).questSD;
%                                 flagMatrix(row,col) = response_matrix(row,col).trial_flag;
%                             end
%                         end                        
%                         for n = 1:size(flagMatrix,2)
%                             [row] = find(flagMatrix(:,n)==1);
%                             questMatrix2(:,n) = questMatrix(row,n);
%                             clear row
%                         end                        
%                         fontsize = 14; markersize = 6; fwidth = 350; fheight = 350;
%                         f1 = figure('Position', [400 200 fwidth fheight]); a1 = axes; hold(a1,'all');
%                         xlabel('Trial number','FontSize',fontsize);
%                         ylabel('Threshold estimate (au)','FontSize',fontsize);
%                         xlim([0 size(flagMatrix,2)]),ylim([-1.2 1.2]), axis square
%                         set(a1,'YTick',[-1 -0.5 0 0.5 1.0],'XTick',[1:1:size(flagMatrix,2)]);
%                         set(a1,'FontSize',fontsize);
%                         set(a1,'LineWidth',1,'TickLength',[0.025 0.025]);
%                         set(a1,'Color','none');
%                         set(f1,'Color',[1 1 1]);
%                         set(f1,'PaperPositionMode','auto');
%                         set(f1, 'renderer', 'painters');
%                         hold on
%                         for ii=1:size(questMatrix2,1)
%                             plot(questMatrix2(:,ii));
%                         end

                        save(matfname, 'response_matrix', 'endflag','trial', 'numcones', 'trial_matrix', 'offset_matrix', 'exp_sequence','q');%,'CFG');
                        save([cd '\lastMappingname.mat'], 'matfname', 'psyfname');
                    else %continue experiment
                    end
                end
                PresentStimulus = 1;
            end
        end
        
    end
    %
elseif CFG.method == 's' %do nothing, for now
    
%     t1 = clock;
%     good_check = 1;
%     
%     trialIntensity = thresholdGuess; %starting threshold for staircase
%     flag = 0;
%     maxInt = 1.0; minInt = 0;
%     
%     stepsize = CFG.priorSD;
%     
%     while(runExperiment ==1)
%         uiwait;
%         %         resp = get(handles.aom_main_figure,'CurrentCharacter');
%         resp = get(handles.aom_main_figure,'CurrentKey');
%         if strcmp(resp,kb_AbortConst);
%             runExperiment = 0;
%             uiresume;
%             TerminateExp;
%             message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
%             set(handles.aom1_state, 'String',message);
%         elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
%             if PresentStimulus == 1;
%                 if trial == 1
%                     trialIntensity = thresholdGuess;
%                 else
%                 end
%                 createStimulus(trialIntensity,trial_seq,trial,bar_y,separation);
%                 if SYSPARAMS.realsystem == 1
%                     StimParams.stimpath = dirname;
%                     StimParams.fprefix = fprefix;
%                     StimParams.sframe = 2;
%                     StimParams.eframe = 4;
%                     StimParams.fext = 'bmp';
%                     Parse_Load_Buffers(0);
%                 end
%                 
%                 laser_sel = 0;
%                 if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
%                     bitnumber = round(8191*(2*trialIntensity-1));
%                 else
%                     bitnumber = round(trialIntensity*1000);
%                 end
%                 
%                 if strcmp(CFG.subject_response, 'y')
%                     Mov.aom1pow(:) = trialIntensity;
%                 elseif strcmp(CFG.subject_response, '2')
%                     Mov.aom1pow(:) = 1.000;
%                 end
%                 
%                 Mov.frm = 1;
%                 Mov.duration = CFG.videodur*fps;
%                 offset = abs(offset);
%                 if trial_seq(trial)==1;
%                     offset = -(offset);
%                 elseif trial_seq(trial) == 0;
%                     offset = abs(offset);
%                 else
%                     offset = 0;
%                 end
%                 
%                 aom1offy2 = zeros(size(aom1seq));
%                 aom1offy2(:) = offset+aom1offy;
%                 Mov.aom1offy = aom1offy2;
%                 
%                 message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
%                 Mov.msg = message;
%                 Mov.seq = '';
%                 setappdata(hAomControl, 'Mov',Mov);
%                 
%                 VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
%                 %   command = ['UpdatePower#' num2str(laser_sel) '#' num2str(bitnumber) '#'];            %#ok<NASGU>
%                 PlayMovie;
%                 PresentStimulus = 0;
%                 GetResponse = 1;
%             end
%             
%         elseif(GetResponse == 1)
%             if strcmp(CFG.subject_response, 'y')
%                 if strcmp(resp,kb_YesConst)
%                     response = 1;
%                     message1 = [Mov.msg ' - Stimulus seen? Yes'];
%                     if flag == 0;
%                         flag = 1; %repeat level a second time if seen
%                         lastIntensity = trialIntensity;
%                     elseif flag ==1; %reduce intensity b/c seen once before
%                         flag = 0; %reset flag to zero
%                         if trialIntensity == minInt;
%                             lastIntensity = trialIntensity;
%                             trialIntensity = 0;
%                         else
%                             lastIntensity = trialIntensity;
%                             trialIntensity = trialIntensity-stepsize;
%                         end
%                     end
%                     GetResponse = 0;
%                     good_check = 1;  %indicates if it was a good trial
%                     
%                 elseif strcmp(resp,kb_NoConst)
%                     response = 0;
%                     message1 = [Mov.msg ' - Stimulus seen? No'];
%                     
%                     if trialIntensity == maxInt
%                         lastIntensity = trialIntensity;
%                         trialIntensity = 1;
%                     else
%                         lastIntensity = trialIntensity;
%                         trialIntensity = trialIntensity+stepsize;
%                     end
%                     flag = 0;
%                     GetResponse = 0;
%                     good_check = 1;  %indicates if it was a good trial
%                     
%                 elseif strcmp(resp,kb_BadConst)
%                     GetResponse = 0;
%                     response = 2;
%                     good_check = 0;
%                     
%                 end;
%                 correct = response;
%             elseif strcmp(CFG.subject_response, '2')
%                 if strcmp(resp,kb_YesConst) %ie above bar
%                     response = 1; correct = 1;
%                     message1 = [Mov.msg ' - Stimulus:  UP'];
%                     if trial_seq(trial) == 1; %ie, correct response
%                         if flag == 0;
%                             flag = 1;
%                             lastIntensity = trialIntensity;
%                         elseif flag == 1;
%                             flag = 0;
%                             if trialIntensity == minInt;
%                                 lastIntensity = trialIntensity;
%                                 trialIntensity = 0;
%                             else
%                                 lastIntensity = trialIntensity;
%                                 trialIntensity = trialIntensity-stepsize;
%                             end
%                         end
%                     elseif trial_seq(trial) == 0; %ie incorrect response
%                         response = 0; correct = 0;
%                         message1 = [Mov.msg ' - Stimulus:  DOWN'];
%                         if trialIntensity == maxInt
%                             lastIntensity = trialIntensity;
%                             trialIntensity = 1;
%                         else
%                             lastIntensity = trialIntensity;
%                             trialIntensity = trialIntensity+stepsize;
%                         end
%                         flag = 0;
%                     end
%                     GetResponse = 0;
%                     good_check = 1;  %indicates if it was a good trial
%                 elseif strcmp(resp,kb_NoConst) %ie below bar
%                     response = 0; correct = 1;
%                     message1 = [Mov.msg ' - Stimulus:  DOWN'];
%                     if trial_seq(trial) == 0; %ie, correct response
%                         if flag == 0;
%                             flag = 1;
%                             lastIntensity = trialIntensity;
%                         elseif flag == 1;
%                             flag = 0;
%                             if trialIntensity == minInt;
%                                 lastIntensity = trialIntensity;
%                                 trialIntensity = 0;
%                             else
%                                 lastIntensity = trialIntensity;
%                                 trialIntensity = trialIntensity-stepsize;
%                             end
%                         end
%                     elseif trial_seq(trial) == 1; %ie incorrect response
%                         response = 0; correct = 0;
%                         message1 = [Mov.msg ' - Stimulus:  UP'];
%                         if trialIntensity == maxInt
%                             lastIntensity = trialIntensity;
%                             trialIntensity = 1;
%                         else
%                             lastIntensity = trialIntensity;
%                             trialIntensity = trialIntensity+stepsize;
%                         end
%                         flag = 0;
%                     end
%                     GetResponse = 0;
%                     good_check = 1;  %indicates if it was a good trial
%                 elseif strcmp(resp,kb_BadConst)
%                     GetResponse = 0;
%                     response = 2;
%                     good_check = 0;
%                 end;
%             end
%             if GetResponse == 0
%                 if good_check == 1
%                     if trial == 1
%                         message2 = ['Intensity Tested: ' num2str(trialIntensity)];
%                     else
%                         message2 = ['Intensity Tested: ' num2str(lastIntensity)];
%                     end
%                     message = sprintf('%s\n%s', message1, message2);
%                     set(handles.aom1_state, 'String',message);
%                     %write response to psyfile
%                     psyfid = fopen(psyfname,'a+');
%                     %                     if trial == 1;
%                     fprintf(psyfid,'%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(response),lastIntensity);
%                     theThreshold(trial,1) = lastIntensity; %#ok<AGROW>
%                     theThreshold(trial,2) = correct; %#ok<AGROW>
%                     %                     else
%                     %                         fprintf(psyfid,'%s\t%s\t%4.4f\r\n',VideoParams.vidname,num2str(response),lastIntensity);
%                     %                         theThreshold(trial,1) = lastIntensity; %#ok<AGROW>
%                     %                     end
%                     %                 fprintf(psyfid,'%s\t%s\t%4.4f\t%4.4f\t%4.4f\t%4.4f\r\n',VideoParams.vidname,num2str(response),questIntensity,trialIntensity,QuestMean(q(nc)),QuestSd(q(nc)));
%                     %                 fclose(psyfid);
%                     
%                     %update trial counter
%                     trial = trial + 1;
%                     if(trial > ntrials)
%                         t2 = clock; time_elapsed = etime(t2,t1); %in seconds
%                         fprintf(psyfid, '%s\t%4.4f\r\n', 'Time elapsed: ', time_elapsed);
%                         fclose(psyfid);
%                         runExperiment = 0;
%                         set(handles.aom_main_figure, 'keypressfcn','');
%                         TerminateExp;
%                         message = ['Off - Experiment Complete - Last Intensity Tested: ' num2str(theThreshold(end,1))];
%                         set(handles.aom1_state, 'String',message);
%                         figure;
%                         plot(theThreshold(:,1));
%                         xlabel('Trial number');
%                         ylabel('Spot Intensity');
%                         title('Test Intensity vs. Trial Number');
%                         ylim([minInt maxInt]);
%                         
%                         %                         if CFG.computefit_check == 1;
%                         %run fitting regime
%                         theThreshold(:,:)
%                         test_matrix = sortrows(theThreshold, 1);
%                         min_test = min(test_matrix(:,1)); max_test = max(test_matrix(:,1));
%                         stepsize = CFG.priorSD;
%                         levels = min_test:stepsize:max_test;
%                         for n = 1:size(levels,2)
%                             level = levels(n);
%                             m = 1;
%                             for nn = 1:size(test_matrix,1)
%                                 tlev = test_matrix(nn,1);
%                                 if tlev == level
%                                     tvec(m,1) = test_matrix(nn,2); %#ok<AGROW>
%                                     m = m+1;
%                                 else
%                                 end
%                             end
%                             pf_matrix(n,1) = level; pf_matrix(n,2) = sum(tvec); pf_matrix(n,3) = size(tvec,1); %#ok<AGROW>
%                         end
%                         pf_matrix;
%                         %                         else
%                         %                             %do nothing
%                         %                         end
%                     else %continue experiment
%                     end
%                 end
%                 PresentStimulus = 1;
%             end
%         end
%     end
end






function createStimulus(trialIntensity, trial_seq, trial, bar_y, separation)
% global offset
CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
if strcmp(CFG.subject_response, '2')
    stimsize = CFG.stimsize;
    bar_y = 3;
    %     separation = 10;
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

% ir_im = ones(21, 21);
% ir_im(:,9:13)=0;
% ir_im(9:13,:)=0;

ir_im = ones(size(stim_im,1), size(stim_im,2));

%ir_im = zeros(size(stim_im,1), zeros(stim_im,2));

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

