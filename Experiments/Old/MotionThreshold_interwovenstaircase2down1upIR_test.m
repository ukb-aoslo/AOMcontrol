function MotionThreshold_interwovenstaircase2down1upIR_test

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
            %set(handles.align_slider, 'Enable', 'off');
            set(handles.aom1_state, 'String', 'Configuring Experiment...');
            set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
            if CFG.record == 1;                
                VideoParams.videodur = CFG.videodur;
            end            
            psyfname = set_VideoParams_PsyfileName();
            hAomControl = getappdata(0,'hAomControl');
            Parse_Load_Buffers(0);
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
% thresholdGuess = 40;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
beta = CFG.beta;
delta = CFG.delta;
gamma=.25;
fps = 30;
presentdur = CFG.presentdur/1000;
ntrials = 4.*CFG.npresent;
viddurtotal = VideoParams.videodur*fps;
staircasefactor = 1.5; %1.5;

gainseqint = [ones(CFG.npresent,1).*-1; ones(CFG.npresent,1).*0.05; ones(CFG.npresent,1); ones(CFG.npresent,1).*2];
for randgain = 1:max(size(gainseqint))
    gainseqint(randgain,2)=rand();
end
gainseqint=sortrows(gainseqint,2);
gainseqint=gainseqint(:,1)';
gain = gainseqint(1);

%set up MSC params
% gain = CFG.gain;
angle = CFG.angle;
if SYSPARAMS.realsystem == 1
    command = ['Gain#' num2str(gain) '#'];
    netcomm('write',SYSPARAMS.netcommobj,int8(command));    
    command = ['Angle#' num2str(angle) '#'];
    netcomm('write',SYSPARAMS.netcommobj,int8(command));
end

%define the initial stimulus trajectory
locxy_candcc = CircleTrajectory(thresholdGuess,viddurtotal);
clocorcountercloc = round(rand);
if clocorcountercloc==1
    locx = locxy_candcc(1,:);
    locy = locxy_candcc(2,:);
else
    locx = locxy_candcc(3,:);
    locy = locxy_candcc(4,:);
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
experiment = ['Experiment Name: Motion Threshold'];
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
    questparams = ['Staircase: Threshold Guess: ' num2str(CFG.thresholdGuess), '     Intervals: ' num2str(CFG.npresent), '     Step Size: ' num2str(staircasefactor)];
    fprintf(psyfid,'%s\n',questparams);
end
fprintf(psyfid,'Gain: %s\nAngle: %s\nVideo Folder: %s\n\n', 'definedintrials',num2str(angle),VideoParams.videofolder);

% define gain and angle for the trial(s) here?
psyfid = fopen(psyfname,'a'); % 
fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\r\n', 'Trial #', 'Actual', 'Correct', 'CorrectCounter', 'Trial Radius', 'Staircase Radius', 'Gain');
fclose(psyfid);

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
fps = 30;
presentdur = CFG.presentdur/1000;
Mov.duration = viddurtotal;
aom1seq = zeros(1,viddurtotal); 
aom1pow = ones(size(aom1seq));
aom1pow(:) = 0.000;
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
aom0seq = ones(size(aom1seq)).*framenum;
aom0seq(end) = 0;
aom0locx = round(locx);
aom0locy = round(locy);
aom0pow = ones(size(aom1seq));
aom0pow(:) = 1.000;
gainseq = ones(size(aom1seq)).*gain;
angleseq = ones(size(aom1seq)).*angle;

Mov.stimbeep = zeros(1,size(aom0seq,2));
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
Mov.frm = 1;
Mov.seq = '';

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
good_check = 1;
trialRadiusminus1 = thresholdGuess;
trialRadius0 = thresholdGuess;
trialRadius1 = thresholdGuess;
trialRadius2 = thresholdGuess;
staircaseRadiusminus1 = trialRadiusminus1;
staircaseRadius0 = trialRadius0;
staircaseRadius1 = trialRadius1;
staircaseRadius2 = trialRadius2;
correctminus1 = 0;
correct0 = 0;
correct1 = 0;
correct2 = 0;
% lastcorrect = 0;
correctcounterminus1 = 0;
correctcounter0 = 0;
correctcounter1 = 0;
correctcounter2 = 0;

while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    gain = gainseqint(trial);
    
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            
            if gain == -1
                correct = correctminus1;
                correctcounter = correctcounterminus1;
                trialRadius = trialRadiusminus1;
                staircaseRadius = staircaseRadiusminus1;
            elseif gain == 0.05
                correct = correct0;
                correctcounter = correctcounter0;
                trialRadius = trialRadius0;
                staircaseRadius = staircaseRadius0;
            elseif gain == 1
                correct = correct1;
                correctcounter = correctcounter1;
                trialRadius = trialRadius1;
                staircaseRadius = staircaseRadius1;
            elseif gain == 2
                correct = correct2;
                correctcounter = correctcounter2;
                trialRadius = trialRadius2;
                staircaseRadius = staircaseRadius2;
            end
    
            %find out the new spot intensity for this trial (from QUEST)
            if staircaseRadius > 255 %
                trialRadius = 255;
            elseif staircaseRadius < 1 %
                trialRadius = 1;
            else 
                trialRadius = staircaseRadius;
            end          
            
            %update stimulus trajectory
            [locxy_candcc,seqonoff] = CircleTrajectory(trialRadius,viddurtotal);
            clocorcountercloc = round(rand);
            if clocorcountercloc==1
                locx = locxy_candcc(1,:); %Clockwise
                locy = locxy_candcc(2,:);
            else
                locx = locxy_candcc(3,:); %Counter-Clockwise
                locy = locxy_candcc(4,:);
            end
            
            aom0locx(:) = round(locx);
            aom0locy(:) = round(locy);
            seqonoff(end) = 0;
%             Mov.aom1seq = seqonoff;
            Mov.aom0seq = seqonoff.*framenum;
            Mov.aom0locx = aom0locx;
            Mov.aom0locy = aom0locy;    

            gainseq = ones(size(aom1seq)).*gain;
            Mov.gainseq = gainseq;
            Mov.frm = 1;
            Mov.duration = CFG.videodur*fps;
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials) ' gain ' num2str(gain)];
            Mov.msg = message;
            Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);

            VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%                                     
            PlayMovie;
            PresentStimulus = 0;
            GetResponse = 1;
        end      
        
%     lastcorrect = correct;    
    elseif(GetResponse == 1)
        if(resp == kb_YesConst) %Right Arrow (Clockwise)
            if clocorcountercloc==0
%                 response = 1;
                message1 = [Mov.msg ' - Clockwise Response - Correct'];
                %mar = mapping(stimulus,3);
                correct = 1;
                correctcounter = correctcounter + correct;
                if (correctcounter == 2)
                    staircaseRadius=staircaseRadius/staircasefactor;
                    correctcounter = 0;
                end
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
            else
%                 response = 0;
                message1 = [Mov.msg ' - Clockwise Response - Incorrect'];
                %mar = mapping(stimulus,3);
                correct = 0;
                correctcounter = 0;
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
                staircaseRadius=staircaseRadius*staircasefactor;
            end                
        elseif(resp == kb_NoConst) %Left Arrow (Counter-Clockwise)
            if clocorcountercloc==1
%                 response = 1;
                message1 = [Mov.msg ' - Counter-clockwise Response - Correct'];
                %mar = mapping(stimulus,3);
                correct = 1;
                correctcounter = correctcounter + correct;
                if (correctcounter == 2)
                    staircaseRadius=staircaseRadius/staircasefactor;
                    correctcounter = 0;
                end
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
            else
%                 response = 0;
                message1 = [Mov.msg ' - Counter-clockwise Response - Incorrect'];
                %mar = mapping(stimulus,3);
                correct = 0;
                correctcounter = 0;
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
                staircaseRadius=staircaseRadius*staircasefactor;
            end     
        elseif(resp == kb_BadConst)
            GetResponse = 0;
%             response = 2;
            message1 = [Mov.msg ' - Bad Trial'];
            correct = 3;
            good_check = 0;            
        end;
        if GetResponse == 0
                message2 = ['Staircase Threshold Estimate: ' num2str(staircaseRadius)];
                message = sprintf('%s\n%s', message1, message2);
                set(handles.aom1_state, 'String',message);
                
                %write response to psyfile
                psyfid = fopen(psyfname,'a+');%                 
                   fprintf(psyfid,'%s\t%s\t%s\t%s\t%4.4f\t%4.4f\t%4.4f\r\n',VideoParams.vidname,num2str(clocorcountercloc),num2str(correct),num2str(correctcounter),trialRadius,staircaseRadius,gain);

                fclose(psyfid);
                theThreshold(trial,1) = staircaseRadius; %#ok<AGROW>
                if gain == -1
                        correctminus1 = correct;
                        correctcounterminus1 = correctcounter;
                        trialRadiusminus1 = trialRadius;
                        staircaseRadiusminus1 = staircaseRadius;
                elseif gain == 0.05
                        correct0 = correct;
                        correctcounter0 = correctcounter;
                        trialRadius0 = trialRadius;
                        staircaseRadius0 = staircaseRadius;
                elseif gain == 1
                        correct1 = correct;
                        correctcounter1 = correctcounter;
                        trialRadius1 = trialRadius;
                        staircaseRadius1 = staircaseRadius;
                elseif gain == 2
                        correct2 = correct;
                        correctcounter2 = correctcounter;
                        trialRadius2 = trialRadius;
                        staircaseRadius2 = staircaseRadius;
                end
                                               
                %update trial counter
                trial = trial + 1;
                                
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    TerminateExp;
                    message = ['Off - Experiment Complete - Minimum Visible Spot Intensity: ' num2str(staircaseRadius)];
                    set(handles.aom1_state, 'String',message);
                    figure;
                    plot(theThreshold);
                    xlabel('Trial number');
                    ylabel('Min Vis Spot Intensity');
                    title('Threshold estimate vs. Trial Number');
                end
         end
            PresentStimulus = 1;
    end
end

function [locations,length] = CircleTrajectory(radius, videolength)

r = radius; %4; %pixels
StimFreq = 0.5; %1; %hertz
FrameRate = 30; %frames/sec
StimPerCycle = FrameRate/StimFreq;
Seconds = videolength; %1;

% CounterClockwise
ThetaStep = 2*pi/(StimPerCycle);
CurrentTheta = round(rand*StimPerCycle)*ThetaStep;
locxcc = zeros(1,Seconds);
locycc = locxcc;
locxc = zeros(1,Seconds);
locyc = locxcc;
present = zeros(1,Seconds);

for n = 1:Seconds
    [locxcc(n),locycc(n)] = pol2cart(CurrentTheta,r);
    locxcc(n)=round(locxcc(n));
    locycc(n)=round(locycc(n));
    present(n)=1;
    CurrentTheta = CurrentTheta + ThetaStep;
end

% Clockwise
ThetaStep = -2*pi/(StimPerCycle);
CurrentTheta = round(rand*StimPerCycle)*ThetaStep;
for n = 1:Seconds
    [locxc(n),locyc(n)] = pol2cart(CurrentTheta,r);
    locxc(n)=round(locxc(n));
    locyc(n)=round(locyc(n));
    present(n)=1;
    CurrentTheta = CurrentTheta + ThetaStep;
end
locations = [locxc; locyc; locxcc; locycc;];
length = [present];