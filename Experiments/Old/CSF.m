function CSF

global system board netcommobj %#ok<NUSED>
global StimParams 

if exist('handles','var','var') == 0;
    handles = guihandles;
else
    %donothing
end
%disable slider control during exp
set(handles.align_slider, 'Enable', 'off');
set(handles.aom0_state, 'String', 'Starting Experiment...');

%maxDeviceCon = 1;
%minDeviceCon = 0;
%maxDeviceCon = (LMax-LBackground)/LBackground; need to determine these values 
%minDeviceCon = (LMin-LBackground)/LBackground; by calibration of AOM
%maxQuestCon = min(maxDeviceCon,-minDeviceCon);
maxQuestCon = 1;
%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');

% system = get(handles.aoslo1_menu, 'checked');
% if system(2) == 'n'
%     system = 1;
% elseif system(2) == 'f'
%     system = 2;
% else
%     %error
% end
CFG.system = system;
setappdata(hAomControl, 'CFG',CFG);

thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
nIntervals = CFG.nIntervals;
beta = CFG.beta;
delta = CFG.delta;
gamma=1/nIntervals;
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = fps*presentdur;
iti = CFG.iti/1000;
ntrials = CFG.npresent;

%set up the movie parameters
dirname = [pwd,'\temp\'];
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = 'frame';
Mov.lng = stimdur+1;

%set stim params
StimParams.dirname = dirname;
StimParams.fprefixes = 'frame';
StimParams.findices =[2:3]; %#ok<NBRAK>
cycles = 8;
beep = sin(2*pi*0.012*[0:3600]); %#ok<NBRAK>

%setup the keyboard constants and response mappings from config
kb_AbortConst = 27; %abort constant - Esc Key

kb_LeftConst = 28; %ascii code for left arrow
kb_RightConst = 29; %ascii code for right arrow
kb_UpConst = 30; %ascii code for up arrow
kb_DownConst = 31; %ascii code for down arrow
kb_StimConst = CFG.kb_StimConst;
kb_UpArrow = CFG.kb_UpArrow;
kb_DownArrow = CFG.kb_DownArrow;
kb_LeftArrow = CFG.kb_LeftArrow;
kb_RightArrow = CFG.kb_RightArrow;

%initialize QUEST
q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma);

%generate a psyfile
theThreshold = zeros(ntrials,1);
psyfname = GenPsyFileName;

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
vidname = ''; %#ok<NASGU>
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');

while(runExperiment ==1)

        if aom == 0;
            if get(handles.aom0_onoff, 'Value') == 1;
            set(handles.aom0_onoff, 'Value', 0);
            aom0_onoff_Callback;
            else
            end
        elseif aom == 1;
            if get(handles.aom1_onoff, 'Value') == 1;
            set(handles.aom1_onoff, 'Value', 0);
            aom1_onoff_Callback;
            else
            end
        end
   
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        rmdir([pwd,'\temp'],'s');
        TerminateExp;
        message = ['Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom0_state, 'String',message);
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
        command = ['GRVID#' vidname '#']; %#ok<NASGU>
        if board == 'm'
            %MATLABAomControl32(command);
        else
            %netcomm('write',netcommobj,int8(command));
        end

        if PresentStimulus == 1;
            %reset movie parameters for gui presentation
            Mov.frm = 1;
            Mov.sfr = 1;
            Mov.efr = 3; 
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            setappdata(hAomControl, 'Mov',Mov);
            %find out the new contrast value for this trial (from QUEST)
            trialCon=10^QuestQuantile(q); 
            trialCon=min(maxQuestCon,trialCon);
            %make the new grating and load it into the buffer
            MakeGrating(trialCon,cycles);
            pause(0.05);
            %set(handles.aom0_state, 'String',num2str(trialCon));
            %pause(3);
            
%            commandstring = ['Load#',num2str(aom),'#0#',pname,'#',fprefix,'#',findex,'#',findex,'#',fext,'#'];

            command = ['Load#0#0#' dirname '#frame#2#3#buf#']; %#ok<NASGU>
            if board == 'm'
                %MATLABAomControl32(command);
            else
                %netcomm('write',netcommobj,int8(command));
            end
            
            %show the stimuli
            whatInterval = Randi(nIntervals);
            if whatInterval == 1;
                seq = ones(1,stimdur);
                seq = seq.*2;
                seq = [seq 0]; %#ok<AGROW>
                Mov.seq = seq;
                setappdata(hAomControl, 'Mov',Mov);
                Snd('Play',beep,44000);
                PlayMovie;
                Mov.frm = 1;
                seq = [ones(1,stimdur+1)]; %#ok<NBRAK>
                seq = seq.*3;
                seq = [seq 0]; %#ok<AGROW>
                Mov.seq = seq;
                setappdata(hAomControl, 'Mov',Mov);
                pause(iti);
                Snd('Play',beep,44000);
                PlayMovie;
            elseif whatInterval == 2;
                seq = [ones(1,stimdur+1)]; %#ok<NBRAK>
                seq = seq.*3;
                seq = [seq 0]; %#ok<AGROW>
                Mov.seq = seq;
                setappdata(hAomControl, 'Mov',Mov);
                Snd('Play',beep,44000);
                PlayMovie;
                Mov.frm = 1;
                seq = ones(1,stimdur);
                seq = seq.*2;
                seq = [seq 0];                 %#ok<AGROW>
                Mov.seq = seq;
                setappdata(hAomControl, 'Mov',Mov);
                pause(iti);
                Snd('Play',beep,44000);
                PlayMovie;
            end
            PresentStimulus = 0;
            GetResponse = 1;
        end 

    elseif(GetResponse == 1)
        if(resp == kb_UpConst)
            response = kb_UpArrow;
        elseif(resp == kb_DownConst)
            response = kb_DownArrow;
        elseif(resp == kb_LeftConst)
            response = kb_LeftArrow;
        elseif(resp == kb_RightConst)
            response = kb_RightArrow;
        else
            response = 'N';
        end;

        %see if response is correct and display (or provide feedback)

        if(response ~= 'N')
            if response == num2str(whatInterval)
                message = [Mov.msg ' - Interval ' response ' - Correct'];
                set(handles.aom0_state, 'String',message);
                correct = 1;
            else
                message = [Mov.msg ' - Interval ' response ' - Incorrect'];
                set(handles.aom0_state, 'String',message);
                correct = 0;
            end

        q = QuestUpdate(q,log10(trialCon),correct);
        
        %write response to psyfile
        psyfid = fopen(psyfname,'a');
        fprintf(psyfid,'%4.4f\t%s\t%1.0f\t%4.4f\t%4.4f\n',log10(trialCon),response,correct,QuestMean(q),QuestSd(q));
        theThreshold(trial,1) = QuestMean(q);
        fclose(psyfid);
        
        %update trial counter
        trial = trial + 1;

        if(trial > ntrials)
            runExperiment = 0;
            set(handles.aom_main_figure, 'keypressfcn','');
            TerminateExp;
            figure;
            plot(theThreshold);
            xlabel('Trial number');
            ylabel('Log contrast threshold');
            title('Threshold estimate vs. Trial Number');
            rmdir([pwd,'\temp'],'s');
            message = ['Experiment Complete.  Threshold estimate is ' num2str(QuestMean(q)) ' ± ' num2str(QuestSd(q)) ' (mean ± SD in log units)'];
            set(handles.aom0_state, 'String',message);            
            
        else %continue experiment      
        end
        GetResponse = 0;
        PresentStimulus = 1;
        
        end
    end
end
% 
% 
% %quest data for CSF experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CFG.nIntervals = str2num(get(handles.nIntervals, 'String'));
% CFG.beta = str2num(get(handles.beta, 'String'));
% CFG.delta = str2num(get(handles.delta, 'String'));
% CFG.responses = str2num(get(handles.responses, 'String'));
% CFG.pCorrect = str2num(get(handles.pCorrect, 'String'));
% CFG.thresholdGuess = str2num(get(handles.thresholdGuess, 'String'));
% CFG.priorSD = str2num(get(handles.priorSD, 'String'));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%spatial filter parameters%%%%%%%%%%%%%%%%%%%%%%%
% if get(handles.filter_checkbox, 'Value') == 0;
%     CFG.filter = 'none';
% elseif get(handles.filter_checkbox, 'Value') == 1;
%     if get(handles.window_radio, 'Value') == 1;
%         CFG.filter = 'window';
%         CFG.cutoff = str2num(get(handles.cutoff,'String'));
%         CFG.filtersize = str2num(get(handles.filtersize,'String'));
%     elseif get(handles.ideal_radio, 'Value') == 1;
%         CFG.filter = 'ideal';        
%         CFG.cutoff = str2num(get(handles.cutoff,'String'));
%     end
% end
% 
% %write out experiment conditions to psyfile header
