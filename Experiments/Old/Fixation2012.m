function Fixation

global SYSPARAMS StimParams VideoParams; %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(QuestSensitivityConfig('M'));
CFG = getappdata(hAomControl, 'CFG');
psyfname = [];

if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
        CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
        if CFG.ok == 1            
            StimParams.stimpath = CFG.stimpath;
            VideoParams.vidprefix = CFG.vidprefix;
            %disable slider control during exp
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
kb_AbortConst = 27; %abort constant - Esc Key
kb_BadConst = 30; %ascii code for up arrow
% kb_NoConst = 31; %ascii code for down arrow
kb_YesConst = 29; %ascii code for right arrow
kb_NoConst = 28; %ascii code for left arrow
kb_StimConst = CFG.kb_StimConst;

%set up QUEST params
thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
beta = CFG.beta;
delta = CFG.delta;
gamma=.25;
fps = 30;
presentdur = CFG.presentdur/1000;
ntrials = CFG.npresent;
viddurtotal = VideoParams.videodur*fps;
staircasefactor = 1.5;

%set up MSC params
gain = CFG.gain;
angle = CFG.angle;
if SYSPARAMS.realsystem == 1
    command = ['Gain#' num2str(gain) '#'];
    netcomm('write',SYSPARAMS.netcommobj,int8(command));    
    command = ['Angle#' num2str(angle) '#'];
    netcomm('write',SYSPARAMS.netcommobj,int8(command));
end

%get the stimulus parameters
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;
fieldsize = CFG.fieldsize;

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
%initialize QUEST
% q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma); 

%write your exp specific psyfile header
experiment = ['Experiment Name: Fixation'];
subject = ['Observer: ' CFG.initials];
pupil = ['Pupil Size (mm): ' CFG.pupilsize];
field = ['Field Size (deg): ' num2str(CFG.fieldsize)];
presentdur = ['Presentation Duration (ms): ' num2str(CFG.presentdur)];
iti = ['Intertrial Interval (ms): ' num2str(CFG.iti)];
videoprefix = ['Video Prefix: ' CFG.vidprefix];
videodur = ['Video Duration: ' num2str(CFG.videodur)];

psyfid = fopen(psyfname,'a');
fprintf(psyfid,'%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n', psyfname, experiment, subject, pupil,field, presentdur, iti, videoprefix, videodur);

if CFG.method == 'q'
    num_trials = ['Number of Trials: ' num2str(CFG.npresent)];
    fprintf(psyfid,'%s\n',num_trials);
% % %     questparams = ['Staircase: Threshold Guess: ' num2str(CFG.thresholdGuess), '     Intervals: ' num2str(CFG.npresent), '     Step Size: ' num2str(staircasefactor)];
% % %     fprintf(psyfid,'%s\n',questparams);
end
fprintf(psyfid,'Gain: %s\nAngle: %s\nVideo Folder: %s\n\n', num2str(gain),num2str(angle),VideoParams.videofolder);

% define gain and angle for the trial(s) here?
% % % psyfid = fopen(psyfname,'a'); % 
% % % fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\r\n', 'Trial #', 'Actual', 'Correct', 'CorrectCounter', 'Trial Radius', 'Staircase Radius');
% % % fclose(psyfid);

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
fps = 30;
presentdur = CFG.presentdur/1000;
Mov.duration = viddurtotal;
aom1seq = zeros(1,viddurtotal); 
stimbeep = zeros(size(aom1seq));
aom1pow = ones(size(aom1seq));
aom1pow(:) = 0.000;
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
aom0seq = zeros(size(aom1seq)).*framenum;
aom0seq(1:10:end)=framenum;
aom0seq(2:10:end)=framenum;
aom0seq(3:10:end)=framenum;
aom0seq(4:10:end)=framenum;
aom0seq(5:10:end)=framenum;
aom0seq(6:10:end)=framenum;
aom0seq(7:10:end)=framenum;
aom0seq(end) = 0;
aom0locx = ones(size(aom1seq)).*round(rand*30-15);
aom0locy = ones(size(aom1seq)).*round(rand*30-15);
aom0pow = ones(size(aom1seq));
aom0pow(:) = 1.000;
gainseq = ones(size(aom1seq)).*gain;
angleseq = ones(size(aom1seq)).*angle;

Mov.aom0seq = aom0seq;
Mov.aom1seq = aom1seq;
Mov.aom0pow = aom0pow;
Mov.aom1pow = aom1pow;
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
trialRadius = thresholdGuess;
staircaseRadius = trialRadius;
correct = 0;
% lastcorrect = 0;
correctcounter = 0;

while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            %find out the new spot intensity for this trial (from QUEST)          
            
            Mov.frm = 1;
            Mov.duration = CFG.videodur*fps;
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);

            VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%                                     
            PlayMovie;
            PresentStimulus = 0;
            GetResponse = 0;
        end      
        
%     lastcorrect = correct;    
        if GetResponse == 0
               
                %update trial counter
                trial = trial + 1;
                aom0locx = ones(size(aom1seq)).*round(rand*30-15);
                aom0locy = ones(size(aom1seq)).*round(rand*30-15);
                Mov.aom0locx = aom0locx;
                Mov.aom0locy = aom0locy;
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    TerminateExp;
                    message = ['Off - Experiment Complete'];
                    set(handles.aom1_state, 'String',message);
                    figure;
                end
         end
            PresentStimulus = 1;
    end
end
