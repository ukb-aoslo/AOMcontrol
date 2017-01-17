function BasicExp

global SYSPARAMS StimParams VideoParams; %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(BasicExpConfig);
CFG = getappdata(hAomControl, 'CFG');
psyfname = [];

if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
    CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
    if CFG.ok == 1
        StimParams.stimpath = CFG.stimpath;
        VideoParams.vidprefix = CFG.vpfx;
        set(handles.aom1_state, 'String', 'Configuring Experiment...');
        if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
            set(handles.aom1_state, 'String', 'Off - Press Start Button To Begin Experiment');
        else
            set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
        end
        if CFG.record == 1;
            VideoParams.videodur = CFG.vdur;
        end
        psyfname = set_VideoParams_PsyfileName();        
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
if CFG.stimconst == ' '
    kb_StimConst = 'space';
else
    kb_StimConst = CFG.stimconst;
end
if CFG.upconst == 'U'
    kb_UpArrow = 'uparrow';
else
    kb_UpArrow = CFG.upconst;
end
if CFG.leftconst == 'L'
    kb_LeftArrow = 'leftarrow';
else
    kb_LeftArrow = CFG.leftconst;
end
if CFG.downconst == 'D'
    kb_DownArrow = 'downarrow';
else
    kb_DownArrow = CFG.downconst;
end
if CFG.rightconst == 'R'
    kb_RightArrow = 'rightarrow';
else
    kb_RightArrow = CFG.rightconst;
end

%check if we need to process a sequence file for trial generation
if CFG.loadseq == 1 %user is interested in using a sequence file, lets check if the user selected any sequence file        
    Parse_Load_Buffers(1);
    seqfname ='';
    if ~isempty(StimParams.seqfname)
        seqfname = [StimParams.stimpath StimParams.seqfname];
    elseif ~isempty(CFG.seqpath) %seq file name from CFG window is empty, probably there is a sequence file in the stim folder
        seqfname = CFG.seqpath;  
    else
        set(handles.image_radio1, 'Enable', 'on');
        set(handles.seq_radio1, 'Enable', 'on');
        set(handles.im_popup1, 'Enable', 'on');
        set(handles.display_button, 'String', 'Config & Start');
        set(handles.display_button, 'Enable', 'on');
        set(handles.aom1_state, 'String', 'Off - Experiment Mode - Experiment Error, no valid sequence file found, try again');
        return;
    end
    %parse the sequence file
    seq = fopen(seqfname);
    counter = 0;
    while(feof(seq) == 0);
        temp = fgetl(seq);
        movie_seq{counter+1}(1:length(temp)) = temp(:); %#ok<AGROW>
        counter = counter + 1;
    end;
    fclose(seq);
    CFG.ntrials = counter;
    clear temp counter seq;
else
    StartUp;
    StimParams.stimpath = [cd '\tempStimulus\']; %CFG.stimpath;
    StimParams.fprefix = 'frame';
    StimParams.fext = 'bmp';
    StimParams.findices = 2:29;
    %look for a mapping file
    w = cd;
    cd(CFG.stimpath);
    [e, f] = dos('dir *.map /s /b');
    f = f(1:strfind(f,char(10))-1);
    ind = strfind(f,'\');
    StimParams.mapfname =  f(ind(size(ind,2))+1:size(f,2));
    cd(w);
    clear e f w ind;
    %generate a sequence that can be used thru out the experiment
    %set up the movie params
    fps = 30;
    tdur = round(fps*(CFG.tdur/1000)); %how long is the presentation    
    pdur = round(fps*(CFG.pdur/1000)); %how long is the stimulus be present    
    startframe = round(tdur/2)-round(pdur/2); %the frame at which it starts presenting stimulus        
    
    %Set up movie parameters
    Mov.duration = tdur;
    %IR params (aom0)
    Mov.aom0pow = ones(1,tdur);
    Mov.aom0locx = zeros(1,tdur);
    Mov.aom0locy = zeros(1,tdur);
    %red params (aom1)
    Mov.aom1seq = zeros(1,tdur);
    Mov.aom1pow = zeros(1,tdur);
    Mov.aom1offx = zeros(1,tdur);
    Mov.aom1offy = zeros(1,tdur);
       
    Mov.gainseq = ones(1,tdur);
    Mov.angleseq = zeros(1,tdur);
    Mov.stimbeep = zeros(1,tdur);
    Mov.stimbeep(startframe+pdur-1) = 1;
    
    Mov.frm = 1;
    Mov.seq = '';
end

%set up the movie parameters
Mov.dir = StimParams.stimpath;
Mov.suppress = 0;
Mov.pfx = StimParams.fprefix;

% load mapping file
fid = fopen([CFG.stimpath StimParams.mapfname]);
mapping = textscan(fid, '%d%c%f');
fclose(fid);
clear fid;

experiment = 'Experiment Name: Basic Experiment';
subject = ['Observer: ' CFG.initials];
pupil = ['Pupil Size (mm): ' CFG.psize];
field = ['Field Size (deg): ' num2str(CFG.fsize)];
presentdur = ['Presentation Duration (ms): ' num2str(CFG.pdur)];
iti = ['Intertrial Interval (ms): ' num2str(CFG.tdur)];
videoprefix = ['Video Prefix: ' CFG.vpfx];
videofolder = ['Video Folder: ' VideoParams.videofolder];
mapfile = ['Mapping File: ' CFG.stimpath StimParams.mapfname];
videodur = ['Video Duration: ' num2str(CFG.vdur)];
num_trials = ['Number of Trials: ' num2str(CFG.ntrials)];

psyfid = fopen(psyfname,'a');
if CFG.loadseq == 1
    seqfname = ['Sequence File: ' CFG.stimpath StimParams.seqfname];
    fprintf(psyfid,'%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n', psyfname, experiment, subject, pupil,field, presentdur, iti, videoprefix, videofolder, videodur, mapfile, seqfname);
else
    fprintf(psyfid,'%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n', psyfname, experiment, subject, pupil,field, presentdur, iti, videoprefix, videodur, mapfile);
end
fclose(psyfid);
clear experiment subject pupil field presentdur iti videoprefix videofolder mapfile videodur num_trials

SYSPARAMS.aoms_state(2)=0; % SWITCH RED OFF

if SYSPARAMS.realsystem == 1
    command = 'StimulusOn#0#';
    if SYSPARAMS.board == 'm'
        MATLABAomControl32(command);
    else
        netcomm('write',SYSPARAMS.netcommobj,int8(command));
    end
end

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');

while(runExperiment ==1)
        uiwait;
        resp = get(handles.aom_main_figure,'CurrentKey');
    
     if strcmp(resp,kb_AbortConst);
            runExperiment = 0;
            uiresume;
            message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(CFG.ntrials)];
            set(handles.aom1_state, 'String',message);
            
    elseif strcmp(resp,kb_StimConst)    % check if present stimulus button was pressed
            if PresentStimulus == 1
                if CFG.loadseq == 1 %send new sequence
                    Mov.seq = char(movie_seq{trial});
                else %generate a random index between frame indices and create a sequence
                    curfindex = round(rand(1)*size(StimParams.findices,2))+1;
                    copyfile([CFG.stimpath StimParams.fprefix num2str(curfindex) '.' StimParams.fext], [StimParams.stimpath StimParams.fprefix '2.' StimParams.fext]);
                    if SYSPARAMS.realsystem == 1
                        StimParams.sframe = 2;
                        StimParams.eframe = 2;
                        StimParams.fext = 'bmp';
                        Parse_Load_Buffers(0);
                    end                    
                    Mov.aom0seq = [ones(1,startframe-1) ones(1,pdur).*2 ones(1,30-startframe+1-pdur)];                   
                    Mov.seq = '';
                end
                message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(CFG.ntrials)];
                Mov.msg = message;
                setappdata(hAomControl, 'Mov',Mov);
                VideoParams.vidname = [CFG.vpfx '_' sprintf('%03d',trial)];
                PlayMovie;
                PresentStimulus = 0;
                GetResponse = 1;
            end            
            
    elseif(GetResponse == 1)
        if strcmp(resp,kb_UpArrow)
            response = 'U';
            message1 = [Mov.msg ' - E Orientation: UP'];
            GetResponse = 0;
        elseif strcmp(resp,kb_RightArrow)
            response = 'R';
            message1 = [Mov.msg ' - E Orientation: Right'];
            GetResponse = 0;
        elseif strcmp(resp,kb_DownArrow)
            response = 'D';
            message1 = [Mov.msg ' - E Orientation: Down'];
            GetResponse = 0;
        elseif strcmp(resp,kb_LeftArrow)
            response = 'L';
            message1 = [Mov.msg ' - E Orientation: Left'];
            GetResponse = 0;
        end
        
        if GetResponse == 0
            if CFG.loadseq == 1
                Mov = getappdata(hAomControl, 'Mov');
            end
            if CFG.loadseq == 1
                actstimind = max(Mov.aom0seq);
            else
                actstimind = curfindex;
            end
            message = '';
            if response == mapping{2}(actstimind-1) %correct
                message = [message1 ' - Correct'];
            else
                message = [message1 ' - Incorrect'];
            end
            set(handles.aom1_state, 'String',message);
            %write response to psyfile
            psyfid = fopen(psyfname,'a');
            fprintf(psyfid,'%d\t%s\t%d\t%c\t%1.2f\t%c\r\n',trial,VideoParams.vidname,actstimind,mapping{2}(actstimind-1),mapping{3}(actstimind-1),response);
            fclose(psyfid);
            %update trial counter
            trial = trial + 1;
            if(trial > CFG.ntrials)
                runExperiment = 0;
                set(handles.aom_main_figure, 'keypressfcn','');
                message = ['Off - Experiment Complete - Minimum Visible Spot Intensity: ' num2str(QuestMean(q),3) ' ± ' num2str(QuestSd(q),3)];
                set(handles.aom1_state, 'String',message);
                figure;
                plot(theThreshold);
                xlabel('Trial number');
                ylabel('Min Vis Spot Intensity');
                title('Threshold estimate vs. Trial Number');
            else %continue experiment
            end
            PresentStimulus = 1;
        end
    end
end

%do clean up
clear CFG GetResponse PresentStimulus actstimind kb_AbortConst kb_UpArrow kb_RightArrow kb_DownArrow kb_LeftArrow kb_StimConst mapping message message1 movie_seq psyfid psyfname resp response runExperiment seqfname trial;
rmappdata(getappdata(0,'hAomControl'), 'CFG');
TerminateExp;

function StartUp
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
else
    cd([pwd,'\tempStimulus']);
    delete ('*.*');
end
cd ..;