function QuestVA

global  mode board netcommobj StimParams %#ok<NUSED>

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

kb_LeftConst = 28; %ascii code for left arrow
kb_RightConst = 29; %ascii code for right arrow
kb_UpConst = 30; %ascii code for up arrow
kb_DownConst = 31; %ascii code for down arrow

kb_StimConst = CFG.kb_StimConst;
kb_UpArrow = CFG.kb_UpArrow;
kb_DownArrow = CFG.kb_DownArrow;
kb_LeftArrow = CFG.kb_LeftArrow;
kb_RightArrow = CFG.kb_RightArrow;

%disable slider control during exp
set(handles.align_slider, 'Enable', 'off');
    set(handles.aom1_state, 'String', 'Starting Experiment...');

%set up QUEST params
%maxQuestCon = 5;
thresholdGuess = CFG.thresholdGuess;
priorSD = CFG.priorSD;
pCorrect = CFG.pCorrect/100;
%nIntervals = CFG.nIntervals;
beta = CFG.beta;
delta = CFG.delta;
gamma=.25;
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = fps*presentdur;
%iti = CFG.iti/1000;
ntrials = CFG.npresent;
nresponses = CFG.responses;

%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
% findices = StimParams.findices;
mapfname = StimParams.mapfname;
% fieldsize = CFG.fieldsize;

fid = fopen([dirname mapfname]);
mapping = fscanf(fid, '%f%s%f',[3,inf])';
fclose(fid);
stim = unique(mapping(:,3));%.*fieldsize;
% stepsize = stim(end)-stim(end-1);

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
%initialize QUEST
q=QuestCreate(thresholdGuess,priorSD,pCorrect,beta,delta,gamma);
 
%generate a psyfile
psyfname = GenPsyFileName;

%write header to file
GenerateHeader(psyfname);

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
vidname = ''; %#ok<NASGU>
    set(handles.aom1_onoff, 'Value', 1);
%    aom1_onoff_Callback;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');

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
            %find out the new lettersize for this trial (from QUEST)
            questSize=QuestQuantile(q);

            %This makes the next trial size equal to the next smallest
            %size letter
            if questSize > stim(end)
                trialSize = stim(end);
            elseif questSize < stim(end) && questSize > stim(end-1)
                trialSize = stim(end-1);
            elseif questSize < stim(end-1) && questSize > stim(end-2)
                trialSize = stim(end-2);
            elseif questSize < stim(end-2) && questSize > stim(end-3);
                trialSize = stim(end-3);
            elseif questSize < stim(end-3) && questSize > stim(end-4);
                trialSize = stim(end-4);
            elseif questSize < stim(end-4) && questSize > stim(end-5);
                trialSize = stim(end-5);
            elseif questSize < stim(end-5) && questSize > stim(end-6);
                trialSize = stim(end-6);
            elseif questSize < stim(end-6) && questSize > stim(end-7);
                trialSize = stim(end-7);
            elseif questSize < stim(end-7) && questSize > stim(end-8);
                trialSize = stim(end-8);
            elseif questSize < stim(end-8) && questSize > stim(end-9)
                trialSize = stim(end-9);
            elseif questSize < stim(end-9) && questSize > stim(end-10)
                trialSize = stim(end-10);
            elseif questSize < stim(end-10) && questSize > stim(end-11);
                trialSize = stim(end-11);
            elseif questSize < stim(end-11) && questSize > stim(end-12);
                trialSize = stim(end-12);
            elseif questSize < stim(end-12) && questSize > stim(end-13);
                trialSize = stim(end-13);
            elseif questSize < stim(end-13) && questSize > stim(end-14);
                trialSize = stim(end-14);
            elseif questSize < stim(end-14) && questSize > stim(end-15);
                trialSize = stim(end-15);
            elseif questSize < stim(end-15) && questSize > stim(end-16);
                trialSize = stim(end-16);
            elseif questSize < stim(end-16) && questSize > stim(end-17);
                trialSize = stim(end-17);
            elseif questSize < stim(end-17) && questSize > stim(end-18);
                trialSize = stim(end-18);
            elseif questSize < stim(end-18) && questSize > stim(end-19);
                trialSize = stim(end-19);
            elseif questSize < stim(end-19);
                trialSize = stim(end-19);
            else
            end

            %stimulus = find(mapping(:,3).*fieldsize == trialSize);
            stimulus = find(mapping(:,3) == trialSize);

            whichstim = round(rand.*(nresponses-1))+1;

            stimulus = stimulus(whichstim);

            framenum = mapping(stimulus,1);%% have to add one here b/c frames start at 2 now

            
            %set up the movie params
            
                aom0seq = [ones(1,stimdur).*framenum 1];
                aom1seq = ones(length(aom0seq));
                for i = 1:length(aom0seq)
                    if i == 1
                        seq = [num2str(aom0seq(i)) ',' num2str(aom1seq(i)) sprintf('\t')];
                    elseif i>1 && i<length(aom0seq)
                        seq = [seq sprintf('\t') num2str(aom0seq(i)) ',' num2str(aom1seq(i)) sprintf('\t')]; %#ok<AGROW>
                    elseif i == length(aom0seq)
                        seq = [seq sprintf('\t') num2str(aom0seq(i)) ',' num2str(aom1seq(i))]; %#ok<AGROW>
                    end
                end
                Mov.aom0seq = aom0seq;
                Mov.aom1seq = aom1seq;
                Mov.frm = 1;
                Mov.sfr = 1;
                Mov.seq = seq;
                Mov.efr = 0;

            Mov.lng = stimdur+1;
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            setappdata(hAomControl, 'Mov',Mov);

            PlayMovie;
            vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
            command = ['GRVID#' vidname '#']; %#ok<NASGU>
            if board == 'm'
                %MATLABAomControl32(command);
            else
                %netcomm('write',netcommobj,int8(command));
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
            if response == mapping(stimulus,2)
                message1 = [Mov.msg ' - ' response ' - Correct'];
                message2 = ['QUEST Threshold Estimate (MAR): ' num2str(QuestMean(q),3)];
                message = sprintf('%s\n%s', message1, message2);
                    set(handles.aom1_state, 'String',message);
                mar = mapping(stimulus,3);
                correct = 1;
            else
                message1 = [Mov.msg ' - ' response ' - Incorrect'];
                message2 = ['QUEST Threshold Estimate (MAR): ' num2str(QuestMean(q),3)];
                message = sprintf('%s\n%s', message1, message2);
                    set(handles.aom1_state, 'String',message);
                mar = mapping(stimulus,3);
                correct = 0;
            end



            %write response to psyfile
            psyfid = fopen(psyfname,'a');
            fprintf(psyfid,'%2.0f\t%s\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%1.0f\n',framenum,response,questSize,mar,QuestMean(q),QuestSd(q),correct);
            fclose(psyfid);
            theThreshold(trial,1) = QuestMean(q); %#ok<AGROW>

            %update QUEST
            q = QuestUpdate(q,trialSize,correct);

            %update trial counter
            trial = trial + 1;

            if(trial > ntrials)
                runExperiment = 0;


                set(handles.aom_main_figure, 'keypressfcn','');
                TerminateExp;
                message = ['Off - Experiment Complete - MAR: ' num2str(QuestMean(q),3) ' ± ' num2str(QuestSd(q),3)];

                    set(handles.aom1_state, 'String',message);
                figure;
                plot(theThreshold);
                xlabel('Trial number');
                ylabel('MAR (Arc Minutes)');
                title('Threshold estimate vs. Trial Number');
                if CFG.filter(1) ~= 'n'
                    rmdir([pwd,'\temp'],'s');
                else
                end

            else %continue experiment
            end
            GetResponse = 0;
            PresentStimulus = 1;

        end
    end
end