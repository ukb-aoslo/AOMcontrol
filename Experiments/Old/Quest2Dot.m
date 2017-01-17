function Quest2Dot(handles)

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
set(handles.aom1_state, 'String', 'Starting Experiment...');

%set up QUEST params
%maxQuestCon = 5;
thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
% nIntervals = CFG.nIntervals;
beta = CFG.beta;
delta = CFG.delta;
gamma=0;        %changed -- W. Tuten, 4/5/2011
fps = 30;
presentdur = CFG.presentdur/1000;
range = 40;
grain = 1;
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

%initialize QUEST
q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma,[grain],[range]);

%write header to file
psyfname = GeneratePsyFileHeader();

%generate a sequence that can be used thru out the experiment
%set up the movie params
% framenum = 2; %the index of your bitmap
startframe = 5; %the frame at which it starts presenting stimulus
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = round(fps*presentdur); %how long is the presentation

% %generate trial sequence for simple 2 vs 1 (no thresholding)
% num_conditions = 2;
% tpc = ntrials/num_conditions;
% frame_matrix = zeros(ntrials, 1);
% frame_matrix(1:tpc,1) = 2;
% frame_matrix(tpc+1:end,1) = 3;
% trial_sequence = randperm(ntrials)';

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
vidname = '';
set(handles.aom1_onoff, 'Value', 1);
%aom1_onoff_Callback;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
good_check = 1;
flag = 0;
maxSep = 20; minSep = 0;
trialSeparation = 20;
stepsize = 2;

%generate trial sequence for simple 2 vs 1 (no thresholding)
num_conditions = 2;
tpc = ntrials/num_conditions;
frame_matrix = zeros(ntrials, 1);
% frame_matrix(1:tpc,1) = 2;
frame_matrix(tpc+1:end,1) = 1;  %0 = bar; 1 = two pt
trial_sequence = randperm(ntrials)';

while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);        
        
        if CFG.filter(1) ~= 'n'
            rmdir([pwd,'\temp'],'s');
        else
        end
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
%             trial_param = trial_sequence(trial);
%             framenum = frame_matrix(trial_param);

            %find out the new spot intensity for this trial (from QUEST)
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
            alt = frame_matrix(trial_sequence(trial),1);
%             alt = 1; %for 2-pt only, no bar
            if alt == 0
                %framenum = 2*(round(trialSeparation)+2)-1;  %call negative images (i.e. for IR modulation) which have odd framenumbers
                framenum = (4*trialSeparation) +2; %bar
            elseif alt ==1
                framenum = (4*trialSeparation)+4; %two-pt
            end
            framenum = 2;
            aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,30-startframe+1-stimdur)];  %IR sequence
           % aom1pow = contains the power values for each IRR frame (any number in [0-1000])
            aom1seq = ones(size(aom0seq));  %Red sequence
           % aom0offsx = contains xoffs of Red wrt IR
           % aom0offsy = contains yoffs of Red wrt IR
           % aom0pow = contains the power values for each Red frame (any number in [0-1000])
           % stimlocx = contains new stimulus x location for each frame
           % stimlocy = contains new stimulus y location for each frame
           % aomsgain = contains the gain value of the stimulus tracking (any real number between [-3.0, 3.0])
           
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
            response = 1;   %make bigger
            message1 = [Mov.msg ' - ONE'];
            %mar = mapping(stimulus,3);
            %             correct = 1;
            if alt ==0;
                correct = 1;
                if flag == 0
                    flag = 1;
                elseif flag ==1
                    flag = 0;                    
                    if trialSeparation ~= minSep
                        trialSeparation = trialSeparation-stepsize;
                    else
                    end
                end
            elseif alt ==1
                correct = 0;
                flag = 0;
                if trialSeparation < maxSep-(stepsize/2)
                    trialSeparation = trialSeparation+stepsize;
                else
                    %at ceiling; stays same
                end
            end
            GetResponse = 0;
            good_check = 1;  %indicates if it was a good trial
%             flag = 0;

                
%             if framenum>3   %i.e. two dots, but seen as one
%                 correct = 0;
%             else
%                 correct = 0;
%             end
%             correct = 0;
        elseif(resp == kb_SeeTwo)
            response = 2;
            message1 = [Mov.msg ' - TWO'];
            %mar = mapping(stimulus,3);
            %             correct = 0;
            GetResponse = 0;
            good_check = 1;  %indicates if it was a good trial
%             if framenum>2   %i.e. two dots, seen as two
%                 correct = 1;    %make separation smaller
%             else
%                 correct = 0;    %make separation larger
%             end
            if alt ==1;
                correct = 1;
                if flag == 0
                    flag = 1;
                elseif flag ==1
                    flag = 0;                    
                    if trialSeparation ~= minSep
                        trialSeparation = trialSeparation-stepsize;
                    else
                    end
                end
            elseif alt ==0
                correct = 0;
                flag = 0;
                if trialSeparation < maxSep-(stepsize/2)
                    trialSeparation = trialSeparation+stepsize;
                else
                    %at ceiling; stays same
                end
            end


%             if flag == 0
%                 trialSeparation = trialSeparation; %repeat trial to confirm seeing
%                 flag =1;
%             elseif flag ==1;
%                 if trialSeparation ~= minSep
%                 trialSeparation = trialSeparation-stepsize;
%                 flag = 0;
%                 else
%                 end
%             end
% 
%                 correct = 1;

        elseif(resp == kb_BadConst) %repeat trial
            GetResponse = 0;
            response = 3;
            good_check = 0;
            
        end;
        if GetResponse == 0
            if good_check == 1
%                                 message2 = ['QUEST Threshold Estimate (Separation -- Pixels): ' num2str(QuestMean(q),3)];
                                message2 = ['Trial Separation (Pixels): ' num2str(trialSeparation)];
                                message = sprintf('%s\n%s', message1, message2);
                                set(handles.aom1_state, 'String',message);
                                
                                %write response to psyfile
                                psyfid = fopen(psyfname,'a+');
                                fprintf(psyfid,'%s\t%s\t%s\t%s\r\n',vidname,num2str(trialSeparation),num2str(alt),num2str(correct));
%                                 fprintf(psyfid,'%s\t%s\t%4.4f\t%4.4f\t%4.4f\t%4.4f\r\n',vidname,num2str(response),questSeparation,trialSeparation,QuestMean(q),QuestSd(q));
                                fclose(psyfid);
%                                 theThreshold(trial,1) = QuestMean(q); %#ok<AGROW>
                                theThreshold(trial,1) = trialSeparation; theThreshold(trial,2) = correct;
                                %update QUEST
%                                 q = QuestUpdate(q,trialSeparation,correct);
                                
                                %update trial counter
                                trial = trial + 1;
                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    TerminateExp;
%                                         message = ['Off - Experiment Complete - Minimum Visible Separation: ' num2str(QuestMean(q),3) ' ± ' num2str(QuestSd(q),3)];
%                                         if aom == 0
%                                             set(handles.aom0_state, 'String',message);
%                                         elseif aom == 1
%                                             set(handles.aom1_state, 'String',message);
%                                         end
                                        
                                        figure;
                                        plot(theThreshold(:,1));
                                        xlabel('Trial number');
                                        ylabel('Min Vis Spot Separation');
                                        title('Threshold estimate vs. Trial Number');
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
