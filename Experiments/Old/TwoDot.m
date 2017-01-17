function TwoDot(handles)

global board mode StimParams videofolder netcommobj %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');

%setup the keyboard constants and response mappings from config
kb_AbortConst = 27; %abort constant - Esc Key
kb_BadConst = 30; %ascii code for up arrow
% kb_SeeOne = 31; %ascii code for down arrow
kb_SeeTwo = 29; %ascii code for right arrow
kb_SeeOne = 28; %ascii code for left arrow
kb_StimConst = CFG.kb_StimConst;

%disable slider control during exp
set(handles.align_slider, 'Enable', 'off');
if StimParams.aom == 0;
    set(handles.aom0_state, 'String', 'Starting Experiment...');
else
    set(handles.aom1_state, 'String', 'Starting Experiment...');
end

%set up QUEST params
%maxQuestCon = 5;
% thresholdGuess = CFG.thresholdGuess;
% priorSD = CFG.priorSD;
% pCorrect = CFG.pCorrect/100;
% % nIntervals = CFG.nIntervals;
% beta = CFG.beta;
% delta = CFG.delta;
% gamma=.25;
% fps = 30;
% presentdur = CFG.presentdur/1000;
% iti = CFG.iti/1000;
ntrials = CFG.npresent;
% nresponses = CFG.responses;

%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
% findices = StimParams.findices;
% mapfname = StimParams.mapfname;
% fieldsize = CFG.fieldsize;

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
aom = StimParams.aom;
Mov.aom = aom;

% %initialize QUEST
% q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma);

%generate a psyfile
psyfname = GenPsyFileName;
%write header to file
GenerateHeader(psyfname);

%generate a sequence that can be used thru out the experiment
%set up the movie params
% framenum = 2; %the index of your bitmap
startframe = 5; %the frame at which it starts presenting stimulus
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = round(fps*presentdur); %how long is the presentation

%generate trial sequence for simple 2 vs 1 (no thresholding)
num_conditions = 2;
tpc = ntrials/num_conditions;
frame_matrix = zeros(ntrials, 1);
frame_matrix(1:tpc,1) = 2;
frame_matrix(tpc+1:end,1) = 3;
trial_sequence = randperm(ntrials)';

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
vidname = '';
if aom == 0;
    set(handles.aom0_onoff, 'Value', 1);
    aom0_onoff_Callback;
elseif aom == 1;
    set(handles.aom1_onoff, 'Value', 1);
    aom1_onoff_Callback;
end
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
good_check = 1;

while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        expdone;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        
        if StimParams.aom == 0;
            set(handles.aom0_state, 'String',message);
        elseif StimParams.aom == 1;
            set(handles.aom1_state, 'String',message);
        end
        
        if CFG.filter(1) ~= 'n'
            rmdir([pwd,'\temp'],'s');
        else
        end
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            trial_param = trial_sequence(trial);
            framenum = 2*(frame_matrix(trial_param))-1;
% 
%             %find out the new spot intensity for this trial (from QUEST)
%             if (good_check == 1)
%                 questSeparation=QuestQuantile(q);
%             end
% 
%             if questSeparation > 20
%                 trialSeparation = 20;
%             elseif questSeparation < 0
%                 trialSeparation = 0;
%             else
%                 trialSeparation = questSeparation;
%             end
%             
%             framenum = round(trialSeparation)+2;
            aom1seq = [ones(1,startframe-1) ones(1,stimdur).*framenum ones(1,30-startframe+1-stimdur)];  %IR sequence
            aom0seq = zeros(size(aom1seq));  %Red sequence
            
            for i = 1:length(aom0seq)   %construct sequence couplets
                if i == 1
                    seq = [num2str(aom0seq(i)) ',' num2str(aom1seq(i)) sprintf('\t')];
                elseif i>1 && i<length(aom0seq)
                    seq = [seq num2str(aom0seq(i)) ',' num2str(aom1seq(i)) sprintf('\t')]; %#ok<AGROW>
                elseif i == length(aom0seq)
                    seq = [seq num2str(aom0seq(i)) ',' num2str(aom1seq(i))]; %#ok<AGROW>
                end
            end
            command = ['Sequence' '#' seq '#'];
            %netcomm('write',netcommobj,int8(command));
            Mov.aom0seq = aom0seq;
            Mov.aom1seq = aom1seq;
            % Mov.frm = 1;
            % Mov.sfr = 1;
            Mov.seq = seq;
            % Mov.efr = 0;
            Mov.frm = 1;
            Mov.sfr = 1;
            Mov.efr = 0;
            Mov.lng = CFG.videodur*fps;
            
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            setappdata(hAomControl, 'Mov',Mov);
            
            vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
            %             command = ['UpdatePower#' num2str(laser_sel) '#' num2str(bitnumber) '#'];            %#ok<NASGU>
            PlayMovie;
            
            if board == 'm'
                %MATLABAomControl32(command);
                command = ['GRVID#' vidname '#']; %#ok<NASGU>
                %MATLABAomControl32(command);
            else
                %netcomm('write',netcommobj,int8(command));
                command = ['GRVIDT#' vidname '#']; %#ok<NASGU>
                %netcomm('write',netcommobj,int8(command));
            end
            
            PresentStimulus = 0;
            GetResponse = 1;
        end
        
    elseif(GetResponse == 1)
        if(resp == kb_SeeOne)
            response = 1;
            message1 = [Mov.msg ' - ONE'];
            %mar = mapping(stimulus,3);
            %             correct = 1;
            GetResponse = 0;
            good_check = 1;  %indicates if it was a good trial
            if framenum==3   %i.e. one dot seen as one
                correct = 1;
            else
                correct = 0;
            end
        elseif(resp == kb_SeeTwo)
            response = 2;
            message1 = [Mov.msg ' - TWO'];
            %mar = mapping(stimulus,3);
            %             correct = 0;
            GetResponse = 0;
            good_check = 1;  %indicates if it was a good trial
            if framenum==3   %i.e. one dot, seen as two
                correct = 0;    %make separation smaller
            else
                correct = 1;    %make separation larger
            end
        elseif(resp == kb_BadConst)
            GetResponse = 0;
            response = 3;
            good_check = 0;
            
        end;
        if GetResponse == 0
            if good_check == 1
%                                 message2 = ['QUEST Threshold Estimate (Separation -- Pixels): ' num2str(QuestMean(q),3)];
%                                 message = sprintf('%s\n%s', message1, message2);
%                                 if StimParams.aom == 0;
%                                     set(handles.aom0_state, 'String',message);
%                                 elseif StimParams.aom == 1;
%                                     set(handles.aom1_state, 'String',message);
%                                 elseif StimParams.aom == 2;
%                                     set(handles.aom1_state, 'String',message);
%                                 end
                                
                                %write response to psyfile
                                psyfid = fopen(psyfname,'a+');
                                fprintf(psyfid,'%s\t%s\t%s\t%s\r\n',vidname,num2str(framenum),num2str(response), num2str(correct));
%                                 fprintf(psyfid,'%s\t%s\t%4.4f\t%4.4f\t%4.4f\t%4.4f\r\n',vidname,num2str(response),questSeparation,trialSeparation,QuestMean(q),QuestSd(q));
                                fclose(psyfid);
%                                 theThreshold(trial,1) = QuestMean(q); %#ok<AGROW>
%                                 %update QUEST
%                                 q = QuestUpdate(q,trialSeparation,correct);
                                
                                %update trial counter
                                trial = trial + 1;
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    expdone;
%                                         message = ['Off - Experiment Complete - Minimum Visible Separation: ' num2str(QuestMean(q),3) ' ± ' num2str(QuestSd(q),3)];
%                                         if aom == 0
%                                             set(handles.aom0_state, 'String',message);
%                                         elseif aom == 1
%                                             set(handles.aom1_state, 'String',message);
%                                         end
%                                         figure;
%                                         plot(theThreshold);
%                                         xlabel('Trial number');
%                                         ylabel('Min Vis Spot Separation');
%                                         title('Threshold estimate vs. Trial Number');
                    if CFG.filter(1) ~= 'n'
                        rmdir([pwd,'\temp'],'s');
                    else
                    end
                else %continue experiment
                end
            end
            PresentStimulus = 1;
        end
    end
end