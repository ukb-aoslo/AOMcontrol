% 8-18-14: code to restart trial (by pressing space bar) added
% 6-5-14: edit line 496 to adjust noise contrast (.5 is pretty low, 0.6 is
% good contrast)
% 6-3-14: added option of noise (line 463) -> if noise = 1; pink noise
% present
% 5-21-14: option of interweaved gain: need to be input into config file with commas
% to separate; need to fix config to show gains when multiple options given
% 5-21-14: added reaction_time to script
% 5-19-14: tested this script at UCSF; need to verify that shown
% orientations are correct
% misnamed variables:
% CFG.beta = min step
% CFG.delta = n reversals
% CFG.priorSD = stepfactor
% 
function fem_acuity_ucb

global SYSPARAMS StimParams VideoParams;

%addpath(genpath('C:\Programs\AOMcontrol_V3_3')); %experiment file path for UCSF imaging computer

if exist('handles','var') == 0;
    handles = guihandles; else %donothing
end

startup;  % creates tempStimlus folder and dummy frame for initialization
gain_index = 1;
%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(acuity_2d1uConfig('M')); % wait for user input in Config dialog
CFG = getappdata(hAomControl, 'CFG');

psyfname = [];

if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
    CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
    if CFG.ok == 1
        %StimParams.stimpath = CFG.stimpath;
        VideoParams.vidprefix = CFG.vidprefix;
      
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
kb_AbortConst = 'escape'; %abort constant - Esc Key
kb_BadConst = 'space'; %ascii code for up arrow
kb_StimConst = 'space';
fps = 30;
ntrials = CFG.npresent;
viddurtotal = VideoParams.videodur*fps;
stimdur = floor(CFG.presentdur/(1000/fps));


%set up MSC params
gain = CFG.gain;
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;

writePsyfileHeader(psyfname); %Experiment specific psyfile header

%generate a sequence that can be used thru out the experiment
framenum = 2; %index of bitmap
startframe = 3; % frame of 30 frame sequence when to start stimulus

%IR

aom0seq = zeros(1,viddurtotal);
aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,viddurtotal-startframe+1-stimdur)];    
aom0locx = zeros(size(aom0seq));
aom0locy = zeros(size(aom0seq));

aom0pow = ones(size(aom0seq));
aom0pow(:) = 1.000;

%RED
aom1seq = zeros(1,viddurtotal);


aom1pow = ones(size(aom1seq));
aom1pow(:) = 1.000;

if length(gain)>1
    
    loop = ntrials;
    ntrials = ntrials*length(gain);
    gain_order = gain;
    while loop>1
        gain = cat(2, gain, gain_order);
        loop = loop-1;
    end
    indices = randperm(ntrials);
%    keyboard;
    gain = gain(indices);
    gainseq = ones(size(aom1seq)).*gain(gain_index);
else
    gainseq = ones(size(aom1seq)).*gain(1);
end
%keyboard;
%set up the movie parameters
Mov.frm = 1;
Mov.seq = '';
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
Mov.duration = size(aom0seq,2);
Mov.stimbeep = zeros(1,size(aom0seq,2));
Mov.gainseq = gainseq;
Mov.aom0seq = aom0seq;
Mov.aom0pow = aom0pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;
Mov.aom1seq = zeros(1,size(aom0seq,2));     %need to keep these variables
Mov.aom1pow = zeros(1,size(aom0seq,2));     %need to keep these variables
Mov.aom1offx = zeros(1,size(aom0seq,2));    %need to keep these variables
Mov.aom1offy = zeros(1,size(aom0seq,2));    %need to keep these variables
Mov.aom2seq = zeros(1,size(aom0seq,2));     %need to keep these variables
Mov.aom2pow = zeros(1,size(aom0seq,2));     %need to keep these variables
Mov.aom2offx = zeros(1,size(aom0seq,2));    %need to keep these variables
Mov.aom2offy = zeros(1,size(aom0seq,2));    %need to keep these variables
Mov.angleseq = zeros(1,size(aom0seq,2));    %need to keep these variables

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
intensity=CFG.thresholdGuess;
thresholdGuess = round(CFG.thresholdGuess);
%priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
%beta = CFG.beta;
%delta = CFG.delta;
%gamma=.25;
presentdur = CFG.presentdur/1000;
num_reversals = 0;
steps=CFG.priorSD;
stepsy=CFG.priorSD;

offsety=0; % from if else statement above (line 217)
exact=intensity;
rawData=zeros(ntrials,7);
staircase_dir=0;
rev_thresholds=0;
reaction_time=0;
%q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma);


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
        
        
    elseif strcmp(key,kb_StimConst)&& (GetResponse==0)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            %find out the new lettersize for this trial (from QUEST)
            %questSize=QuestQuantile(q);
            %offset = round(questSize);
            %[offset alt]=newAlt(offset, correct,alt);
            [offset alt]=newAlt(intensity, correct,alt);
            createStimulus(offset,alt,offsety);
            
            if SYSPARAMS.realsystem == 1
                StimParams.stimpath = dirname;
                StimParams.fprefix = fprefix;
                StimParams.sframe = 2;
                StimParams.eframe = 2;

                StimParams.fext = 'buf';
                Parse_Load_Buffers(0);
            end
            
            Mov.frm = 1;
          
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            % Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);
            
            VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%
            PlayMovie;
            tic;
            PresentStimulus = 0;
            GetResponse = 1;
        end
        
    elseif(GetResponse == 1)
        previous = intensity;
        if strcmp(key,'rightarrow');  % Right response
            reaction_time = toc;
            response = 0;
            GetResponse = 0;
            good_check = 1;       
            if alt==0   % Correct response
                message1 = [Mov.msg ' - RIGHT Response - Correct '];
                ncorrect=ncorrect+1;
                correct=1;
              
                if offset>=CFG.beta*CFG.priorSD && ncorrect==2
                    exact=exact/CFG.priorSD;
                    intensity=round(exact);
                    ncorrect=0;
                    if staircase_dir == 1
                        num_reversals = num_reversals +1;
                        rev_thresholds(num_reversals) = previous;
                    end
                    staircase_dir = -1;      
                end
            else        % False response
                message1 = [Mov.msg ' - RIGHT Response - Incorrect'];
                exact=exact*CFG.priorSD;
                intensity=round(exact);
                ncorrect=0;
                correct=0;
                if staircase_dir == -1
                    num_reversals = num_reversals +1;
                    rev_thresholds(num_reversals) = previous;
                end
                staircase_dir = 1;
            end
                    
        elseif strcmp(key,'uparrow');  % UP response
            reaction_time = toc;
            response = 90;
            GetResponse = 0;
            good_check = 1;
                    
            if alt==90   % Correct response
                message1 = [Mov.msg ' - UP Response - Correct '];
                ncorrect=ncorrect+1;
                correct=1;
                        
                if offset>=CFG.beta*CFG.priorSD && ncorrect==2
                    exact=exact/CFG.priorSD;
                    intensity=round(exact);
                    ncorrect=0;
                    if staircase_dir == 1
                        num_reversals = num_reversals +1;
                        rev_thresholds(num_reversals) = previous;
                    end
                    staircase_dir = -1;
                end
            else        % False response
                message1 = [Mov.msg ' - UP Response - Incorrect'];
                exact=exact*CFG.priorSD;
                intensity=round(exact);
                ncorrect=0;
                correct=0;
                if staircase_dir == -1
                    num_reversals = num_reversals +1;
                    rev_thresholds(num_reversals) = previous;
                end
                staircase_dir = 1;
            end
                    
        elseif strcmp(key,'leftarrow');  % Left response
            reaction_time = toc;
            response = 180;
            GetResponse = 0;
            good_check = 1;
                    
            if alt==180   % Correct response
                message1 = [Mov.msg ' - LEFT Response - Correct '];
                ncorrect=ncorrect+1;
                correct=1;
                        
                if offset>=CFG.beta*CFG.priorSD && ncorrect==2
                    exact=exact/CFG.priorSD;
                    intensity=round(exact);
                    ncorrect=0;
                    if staircase_dir == 1
                        num_reversals = num_reversals +1;
                        rev_thresholds(num_reversals) = previous;
                    end
                    staircase_dir = -1;
                end
            else        % False response
                message1 = [Mov.msg ' - LEFT Response - Incorrect'];
                exact=exact*CFG.priorSD;
                intensity=round(exact);
                ncorrect=0;
                correct=0;
                if staircase_dir == -1
                    num_reversals = num_reversals +1;
                    rev_thresholds(num_reversals) = previous;
                end
                staircase_dir = 1;
            end
                    
        elseif strcmp(key,'downarrow');  % Down response
            reaction_time = toc;
            response = 270;
            GetResponse = 0;
            good_check = 1;
            correct=1;
                    
            if alt==270   % Correct response
                message1 = [Mov.msg ' - DOWN Response - Correct '];
                ncorrect=ncorrect+1;
                        
                if offset>=CFG.beta*CFG.priorSD && ncorrect==2
                    exact=exact/CFG.priorSD;
                    intensity=round(exact);
                    ncorrect=0;
                    if staircase_dir == 1
                        num_reversals = num_reversals +1;
                        rev_thresholds(num_reversals) = previous;
                    end
                    staircase_dir = -1;                  
                end
            else        % False response
                message1 = [Mov.msg ' - DOWN Response - Incorrect'];
                exact=exact*CFG.priorSD;
                intensity=round(exact);
                ncorrect=0;
                correct=0;
                if staircase_dir == -1
                    num_reversals = num_reversals +1;
                    rev_thresholds(num_reversals) = previous;
                end
                staircase_dir = 1;
            end
                    
        elseif strcmp(key,kb_BadConst)
            GetResponse = 0;
            response = 2;
            good_check = 0;
    
        end
                                     
    if GetResponse == 0
        if good_check == 1
            message2 = ['Current offset [pixel]: ' num2str(offset)];
            message = sprintf('%s\n%s', message1, message2);
            set(handles.aom1_state, 'String',message);
                
            %write response to psyfile
            psyfid = fopen(psyfname,'a+');
%           est_thresh = QuestMean(q);
           
            fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\r\n',num2str(trial),num2str(offset),num2str(alt),num2str(response),num2str(correct),num2str(reaction_time),num2str(gain(gain_index)));
            rawData(trial,:)=[trial offset alt response correct reaction_time gain(gain_index)];

            fclose(psyfid);
            trial = trial + 1;
                  
            if or(((trial > ntrials)&& ntrials~=0), ((num_reversals>CFG.delta)&& ntrials==0)) 
                runExperiment = 0;
                set(handles.aom_main_figure, 'keypressfcn','');
                TerminateExp;
                message = ['Off - Experiment Complete - Last Absolute Offset: ' num2str(abs(offset))];
                set(handles.aom1_state, 'String',message);
            else %continue experiment
                
                if length(gain)>1
                    gain_index = gain_index+1;
                    gainseq = ones(size(aom1seq)).*gain(gain_index);
                else
                    gainseq = ones(size(aom1seq)).*gain(1);
                end
                Mov.gainseq = gainseq;
            end
        end
        PresentStimulus = 1;
    end
end
end    
plotResult(rawData, psyfname);
if (ntrials ==0)&& not(strcmp(key,'escape'))
    final_thresh= num2str(sum(rev_thresholds(num_reversals-4:num_reversals))/5);
    psyfid = fopen(psyfname,'a+');
    fprintf(psyfid,'%s\t %s\r\n','Final Threshold:',final_thresh);        
    fclose(psyfid);
    fprintf('%s\t %s\n', 'Final threshold is: ',final_thresh);
end
%do clean up
clear CFG GetResponse PresentStimulus actstimind kb_AbortConst kb_UpArrow kb_RightArrow kb_DownArrow kb_LeftArrow kb_StimConst mapping message message1 movie_seq psyfid psyfname resp response runExperiment seqfname trial;
% rmappdata(getappdata(0,'hAomControl'), 'CFG'); %NEED TO FIX THIS


function [offset alt]=newAlt(intensity, correct, alt) %#ok<*INUSD>

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

offset=intensity;
alt=90*floor(rand*4);  %random rotation about [0,90,180,270] degrees 



function writePsyfileHeader(psyfname)

global VideoParams;

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

fieldvalues=struct2cell(CFG);
fieldtags=fieldnames(CFG);
fields=size(fieldvalues,1);
tfolder = ['Video Folder: ' VideoParams.videofolder];


psyfid = fopen(psyfname,'a');
%for k=1:fields
%    if ischar(cell2mat(fieldvalues(k)))
%        fprintf(psyfid,'%s\n',[char(fieldtags(k)),': ',char(cell2mat(fieldvalues(k)))]);
%    else
%        fprintf(psyfid,'%s\n',[char(fieldtags(k)),': ',num2str(cell2mat(fieldvalues(k)))]);
%    end
%end

fprintf(psyfid,'%s\n',tfolder);


experiment = 'Experiment Name: Acuity, UCB';
subject = ['Observer: ' CFG.initials];
field = ['Field Size (deg): ' num2str(CFG.fieldsize)];
presentdur = ['Presentation Duration (frames): ' num2str(CFG.presentdur)];
videoprefix = ['Video Prefix: ' CFG.vidprefix];
videodur = ['Video Duration: ' num2str(CFG.videodur)];
%tgain = ['Gain: ' num2str(CFG.gain)];

fprintf(psyfid,'%s\r%s\r%s\r%s\r%s\r%s\r%s\n\n\n\r',...
    psyfname, experiment, subject, field,...
    presentdur, videoprefix, videodur);

fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\r\n', 'Trial', 'Offset', 'Alternative', 'Response', 'Correct?', 'Reaction Time','Gain');   % Add header for data table here (columnwise)

fclose(psyfid);
 


function createStimulus(offset,alt,offsety)


noise = 0; %if want stimulus with white noise, set to 1

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

n_frames=1;
 
gap=(offset);
if noise
    padw=round(4*gap);
else
    padw=gap;
end
e=zeros(gap*5,gap*5);
e(gap+1:2*gap,gap+1:end)=1;
e(3*gap+1:4*gap,gap+1:end)=1;
        
padh=ones(padw,size(e,2));
padv=ones(size(e,1)+2*padw,padw);
        
E=[padh;e;padh];
E=[padv E padv];        
E=imrotate(E,alt);

if noise
    [m n] =size(E);
    %random_matrix = rand(m,n);
    pink_noise = spatialPattern([m n],-1);
    pink_noise = pink_noise - min(pink_noise(:));
    pink_noise = pink_noise ./ max(pink_noise(:));
 
    pink_noise = pink_noise.^.5;
    E_randpadding = times(pink_noise, E);
    %i_m = 1;
    %i_n = 1;
    %for i_m =1:gap:m-1
    %    for i_n=1:gap:n-1
    %        if E_randpadding(i_m, i_n) ~= 0
    %            if E_randpadding(i_m, i_n) > noise_density
    %                E_randpadding(i_m:i_m+gap-1, i_n:i_n+gap-1) = 1;
    %            else
    %                E_randpadding(i_m:i_m+gap-1, i_n:i_n+gap-1) = rand;
    %            end
    %        else
    %        end
    %    end
    %end
    E = E_randpadding;
else
end

canv=E;
cd([pwd,'\tempStimulus']);

imwrite(canv,'frame02.bmp');
fid = fopen('frame02.buf','w');
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
    
    imwrite(dummy,'frame02.bmp');
    fid = fopen('frame02.buf','w');
    fwrite(fid,size(dummy,2),'uint16');
    fwrite(fid,size(dummy,1),'uint16');
    fwrite(fid, dummy, 'double');
    fclose(fid);
else
    cd([pwd,'\tempStimulus']);
    delete *.bmp
    delete *.buf
    imwrite(dummy,'frame02.bmp');
    fid = fopen('frame02.buf','w');
    fwrite(fid,size(dummy,2),'uint16');
    fwrite(fid,size(dummy,1),'uint16');
    fwrite(fid, dummy, 'double');
    fclose(fid);
end
cd ..;


function plotResult(rawData, psyfname)
global VideoParams;

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

    

        
    %%%%%%%%%%%%%%%% Simple Plot: Staircase + Intensity vs Performance
    figure('Position',[475 518 800 351]);
    hplot= subplot(1,1,1);
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
    saveas(hplot,[VideoParams.videofolder 'staircase.jpg']);    
        
 
   
  