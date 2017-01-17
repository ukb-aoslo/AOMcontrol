function ContrastThresholdGabor_thresh

global SYSPARAMS StimParams VideoParams;
if exist('handles','var') == 0;
    handles = guihandles; else %donothing
end

startup;  % creates tempStimlus folder and dummy frame for initialization

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
% uiwait(VernierConfig('M')); % wait for user input in Config dialog
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
% thresholdGuess = 40;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
beta = CFG.beta;
delta = CFG.delta;
gamma=.25;
fps = 30;
presentdur = CFG.presentdur/1000;
ntrials = 4.*CFG.npresent;
% ntrials = 4.*20;
viddurtotal = VideoParams.videodur*fps;
staircasefactor = 1.2; %1.5;
% horizorvert = 1;

gainseqint = [ones(CFG.npresent,1).*0.5; ones(CFG.npresent,1).*0.05; ones(CFG.npresent,1); ones(CFG.npresent,1).*1.5];
% gainseqint = [ones(CFG.npresent,1).*1; ones(CFG.npresent,1).*1; ones(CFG.npresent,1); ones(CFG.npresent,1).*1];
% gainseqint = [ones(CFG.npresent,1).*0; ones(CFG.npresent,1).*0; zeros(CFG.npresent,1); ones(CFG.npresent,1).*0];
for randgain = 1:max(size(gainseqint))
    gainseqint(randgain,2)=rand();
end
gainseqint=sortrows(gainseqint,2);
gainseqint=gainseqint(:,1)';
gain = gainseqint(1);

%No 2AFC sequence
    trial_seq = zeros(ntrials,1); trial_seq(:) = 2;
    bar_y = 0;
    separation = 0;
    offset = 0;

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
locx = zeros(1,viddurtotal);
locy = zeros(1,viddurtotal);

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
fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\r\n', 'Trial #', 'Actual', 'Correct', 'CorrectCounter', 'Trial Contrast', 'Staircase Contrast', 'Gain');
fclose(psyfid);

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
startframe = 5; %the frame at which it starts presenting stimulus
stimdur = 5; %round(fps*presentdur); %how long is the presentation
% framenum = 2:1:(viddurtotal+1);
fps = 30;
presentdur = CFG.presentdur/1000;
Mov.duration = viddurtotal;
% aom1seq = [ones(1,startframe-1) ones(1,stimdur).*framenum ones(1,CFG.videodur*fps-startframe+1-stimdur)];
aom1seq = zeros(1,viddurtotal); 
% aom1seq = ones(1,viddurtotal); 
aom1seq(end) = 0;
aom1pow = ones(size(aom1seq));
aom1pow(:) = SYSPARAMS.aompowerLvl(2);
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
% aom0seq = ones(1,viddurtotal).*framenum; 
% aom0seq(end) = 0;
% aom0seq = [ones(1,startframe-1) ones(1,stimdur).*framenum
% ones(1,CFG.videodur*fps-startframe+1-stimdur)];
aom0seq = [ones(1,startframe-1) ones(1,stimdur).*framenum ones(1,viddurtotal-startframe+1-stimdur)];
aom0seq(end) = 0;
% aom0locx = round(locx);
% aom0locy = round(locy);
aom0locx = ones(size(aom1seq)).*round(rand*20-10);
aom0locy = ones(size(aom1seq)).*round(rand*20-10);
aom0pow = ones(size(aom1seq));
aom0pow(:) = SYSPARAMS.aompowerLvl(1);
gainseq = ones(size(aom1seq)).*gain;
angleseq = ones(size(aom1seq)).*angle;
stimbeep = zeros(1,size(aom0seq,2));
% stimbeep(9) = 1;

Mov.stimbeep = stimbeep;
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
trialContrast0 = thresholdGuess;
trialContrast0half = thresholdGuess;
trialContrast1 = thresholdGuess;
trialContrast1half = thresholdGuess;
staircaseContrast0 = trialContrast0;
staircaseContrast0half = trialContrast0half;
staircaseContrast1 = trialContrast1;
staircaseContrast1half = trialContrast1half;
correct0 = 0;
correct0half = 0;
correct1 = 0;
correct1half = 0;
% lastcorrect = 0;
correctcounter0 = 0;
correctcounter0half = 0;
correctcounter1 = 0;
correctcounter1half = 0;

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
            
                if gain == 0.5
                    correct = correct0half;
                    correctcounter = correctcounter0half;
                    trialContrast = trialContrast0half;
                    staircaseContrast = staircaseContrast0half;
                elseif gain == 0.05 %0.05
                    correct = correct0;
                    correctcounter = correctcounter0;
                    trialContrast = trialContrast0;
                    staircaseContrast = staircaseContrast0;
                elseif gain == 1
                    correct = correct1;
                    correctcounter = correctcounter1;
                    trialContrast = trialContrast1;
                    staircaseContrast = staircaseContrast1;
                elseif gain == 1.5
                    correct = correct1half;
                    correctcounter = correctcounter1half;
                    trialContrast = trialContrast1half;
                    staircaseContrast = staircaseContrast1half;
                end
    
            %find out the new spot intensity for this trial (from QUEST)
            if staircaseContrast > 1; %255 %
                trialContrast = 1; %255;
            elseif staircaseContrast < 0.1;% 1 %
                trialContrast = 0.1; %1;
            else 
                trialContrast = staircaseContrast;
            end          

            horizorvert = round(rand);

                createStimulus(trialContrast,horizorvert,fieldsize);
                if SYSPARAMS.realsystem == 1
                    StimParams.stimpath = dirname;
                    StimParams.fprefix = fprefix;
                    StimParams.sframe = 2; %2;
                    StimParams.eframe = 2;
                    StimParams.fext = 'buf';
                    Parse_Load_Buffers(0);
%                     Parse_Load_Buffers(0);
                end
            
            %update stimulus trajectory
            locx = zeros(1,viddurtotal);
            locy = zeros(1,viddurtotal);
            
            gainseq = ones(size(aom1seq)).*gain;
            Mov.gainseq = gainseq;
            Mov.frm = 1;
            Mov.duration = CFG.videodur*fps;
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials) ' gain ' num2str(gain) ' trialContrast ' num2str(trialContrast) ' stairrad ' num2str(staircaseContrast)];
            Mov.msg = message;
            Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);

            VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%
%             pause(2);
%             t1 = clock;
            PlayMovie;
%             waitforbuttonpress
%             t3 =clock;
%             trialtime = etime(t3,t1);
            PresentStimulus = 0;
            GetResponse = 1;
        end      
        
%     lastcorrect = correct;    
    elseif(GetResponse == 1)
        if(resp == kb_YesConst) %Right Arrow (Up-right Diagonal)
            if horizorvert==1 %right
%                 response = 1;
                message1 = [Mov.msg ' - Right Response - Correct'];
                %mar = mapping(stimulus,3);
                correct = 1;
                correctcounter = correctcounter + correct;
                if (correctcounter == 2)
                    staircaseContrast=staircaseContrast/staircasefactor;
                    correctcounter = 0;
                end
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
            else
%                 response = 0;
                message1 = [Mov.msg ' - Right Response - Incorrect'];
                %mar = mapping(stimulus,3);
                correct = 0;
                correctcounter = 0;
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
                staircaseContrast=staircaseContrast*staircasefactor;
            end                
        elseif(resp == kb_NoConst) %Left Arrow (Up-Left Diagonal)
            if horizorvert==0 %left
%                 response = 1;
                message1 = [Mov.msg ' - Left Response - Correct'];
                %mar = mapping(stimulus,3);
                correct = 1;
                correctcounter = correctcounter + correct;
                if (correctcounter == 2)
                    staircaseContrast=staircaseContrast/staircasefactor;
                    correctcounter = 0;
                end
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
            else
%                 response = 0;
                message1 = [Mov.msg ' - Left Response - Incorrect'];
                %mar = mapping(stimulus,3);
                correct = 0;
                correctcounter = 0;
                GetResponse = 0;
                good_check = 1;  %indicates if it was a good trial
                staircaseContrast=staircaseContrast*staircasefactor;
            end     
        elseif(resp == kb_BadConst)
            GetResponse = 0;
%             response = 2;
            message1 = [Mov.msg ' - Bad Trial'];
            correct = 3;
            good_check = 0;            
        end;
        if GetResponse == 0
                message2 = ['Staircase Threshold Estimate: ' num2str(staircaseContrast)];
                message = sprintf('%s\n%s', message1, message2);
                set(handles.aom1_state, 'String',message);
                
                %write response to psyfile
                psyfid = fopen(psyfname,'a+');%                 
                fprintf(psyfid,'%s\t%s\t%s\t%s\t%4.4f\t%4.4f\t%4.4f\r\n',VideoParams.vidname,num2str(horizorvert),num2str(correct),num2str(correctcounter),trialContrast,staircaseContrast,gain);

                fclose(psyfid);
%                 theThreshold(trial,1) = staircaseRadius; %#ok<AGROW>
                    if gain == 0.5
                        correct0half = correct;
                        correctcounter0half = correctcounter;
                        trialContrast0half = staircaseContrast;
                        staircaseContrast0half = staircaseContrast;
                        theThreshold0half(trial,1) = staircaseContrast; %#ok<AGROW>
                    elseif gain == 0.05
                        correct0 = correct;
                        correctcounter0 = correctcounter;
                        trialContrast0 = staircaseContrast;
                        staircaseContrast0 = staircaseContrast;
                        theThreshold0(trial,1) = staircaseContrast; %#ok<AGROW>
                    elseif gain == 1
                        correct1 = correct;
                        correctcounter1 = correctcounter;
                        trialContrast1 = staircaseContrast;
                        staircaseContrast1 = staircaseContrast;
                        theThreshold1(trial,1) = staircaseContrast; %#ok<AGROW>
                    elseif gain == 1.5
                        correct1half = correct;
                        correctcounter1half = correctcounter;
                        trialContrast1half = staircaseContrast;
                        staircaseContrast1half = staircaseContrast;
                        theThreshold1half(trial,1) = staircaseContrast; %#ok<AGROW>
                    end
                
                %update trial counter
                trial = trial + 1;
                aom0locx = ones(size(aom1seq)).*round(rand*20-10);
                aom0locy = ones(size(aom1seq)).*round(rand*20-10);
                Mov.aom0locx = aom0locx;
                Mov.aom0locy = aom0locy;
                                
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    TerminateExp;
                    message = ['Off - Experiment Complete - Minimum Visible Spot Intensity: ' num2str(staircaseContrast)];
                    set(handles.aom1_state, 'String',message);
                    figure;
                    theThreshold0 = theThreshold0(any(theThreshold0,2),:);
                    theThreshold0half = theThreshold0half(any(theThreshold0half,2),:);
                    theThreshold1 = theThreshold1(any(theThreshold1,2),:);
                    theThreshold1half = theThreshold1half(any(theThreshold1half,2),:);
                    subplot(2,2,1), plot(theThreshold0,'.-'); ylim([0.5 1]);
                    subplot(2,2,2), plot(theThreshold0half,'.-'); ylim([0.5 1]);
                    subplot(2,2,3), plot(theThreshold1,'.-'); ylim([0.5 1]);
                    subplot(2,2,4), plot(theThreshold1half,'.-'); ylim([0.5 1]);
%                     plot(theThreshold);
                    xlabel('Trial number');
                    ylabel('Min Vis Spot Intensity');
                    title('Threshold estimate vs. Trial Number');
                end
         end
            PresentStimulus = 1;
    end
end

function startup

dummy=ones(10,10);
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    
    imwrite(dummy,'frame2.bmp');
else
    cd([pwd,'\tempStimulus']);
    delete('*.*');
    imwrite(dummy,'frame2.bmp');
end
cd ..;

function createStimulus(trialContrast,horizorvert,fieldsize)

horizorvert2 = horizorvert;
if horizorvert2==1
    CFG.drift_angle=45;  
else
    CFG.drift_angle=-45;  
end
CFG.drift_speed=0; 

% fieldsize = 1.2;        % in deg. Could and should take this from the config window
imSize = 64; %32; %150;                           % image size: n X n
fieldsizeDeg = imSize*fieldsize/512;
cpd=16; %20;                                  % target spatial frequency      
cpfield = cpd*fieldsizeDeg/2;
% lambda = round((30*60/cpd)/8.5/2);      % wavelength (number of pixels per cycle)
lambda = round(imSize/cpfield);
theta = CFG.drift_angle;                % drift orientation in deg

window = 0.5; %0.22;
sigma = imSize*window;                             % gaussian standard deviation in pixels
phase = 0;                              % phase (0 -> 1)

gf2=fspecial('gaussian',imSize,sigma);
gf2=gf2/max(max(gf2));

X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = 2*(X / imSize) - 1;                 % rescale X -> -1 to 1'
freq = cpfield;                         % compute frequency from wavelength
[Xm Ym] = meshgrid(X0, X0);               % 2D matrices
% [x,y] = meshgrid(-100:100, -100:100);
thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency

% i=1;
% figure
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
else
    cd([pwd,'\tempStimulus']);
    delete('*.*');
end

    contrast=trialContrast;
    grating = gf2.*contrast.*sin(XYf);
  %    grating = contrast.*sin(XYf);
    grating(grating<0) = 0;

%     imshow(grating);
    g=1-grating;
       
    name = 'frame2.bmp';
    bufname = 'frame2.buf';  
    
    imwrite(g,name);
    fid = fopen(bufname,'w');
    fwrite(fid,size(g,2),'uint16');
    fwrite(fid,size(g,1),'uint16');
    fwrite(fid, g, 'double');
    fclose(fid);
%     i=i+1;
cd ..;