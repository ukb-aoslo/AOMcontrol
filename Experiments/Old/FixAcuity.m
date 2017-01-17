function FixAcuity

global  board netcommobj mode StimParams %#ok<NUSED>

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

%get the stimulus parameters
initials = CFG.initials;
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
findices = StimParams.findices;
mapfname = StimParams.mapfname;
fieldsize = CFG.fieldsize;
fieldsize = 1; %%%%%%%%%%%%%%%TO MAKE SHUANGS EXPERIMENT WORK!
threshold = CFG.threshold;
threshold = threshold;
nresponses = 4;
ntrials = CFG.ntrials;
mindur = CFG.mindur;
maxdur = CFG.maxdur;
fps = 30;
trialdur = CFG.trialdur.*fps;
maxframes = round(maxdur/1000.*fps);
minframes = round(mindur/1000.*fps);
fid = fopen([dirname mapfname]);
mapping = fscanf(fid, '%f%s%f',[3,inf])';
fclose(fid);
stimulus = find(mapping(:,3).*fieldsize == threshold);
stimulus = stimulus+1;
%set up the movie parameters
Mov.dir = dirname;
Mov.pfx = fprefix;
Mov.suppress = 1;

error = 0;
index = 1;
if isempty(stimulus) == 1
    newmap = mapping(:,3).*fieldsize;
    while(newmap(index) < threshold);
        index = index+1;
        if index == size(newmap,1)
            error = 1;
            break
        else       
        end
    end
    if error == 1
        %do nothing
    else
        stimulus = [mapping(index,1) mapping(index+1,1) mapping(index+2,1) mapping(index+3,1)]';
    end
else
end

if error == 1
    %error message
    if aom == 0;
        TerminateExp;
        set(handles.aom0_state, 'String', 'Error: No stimulus near threshold found.');
        runExperiment = 0;     
    elseif aom == 1;
        TerminateExp;
        set(handles.aom1_state, 'String', 'Error: No stimulus near threshold found.');
        runExperiment = 0;       
    end
else
    runExperiment = 1;
end
        

%generate a psyfile
psyfname = GenPsyFileName;

%write header to file
GenerateHeader(psyfname);

%set initial while loop conditions

trial = 1;
seq = [];
responses = [];
correct = [];
totalchanges = 0;
totalcorrect = 0;
percentcorrect = 0;
PresentStimulus = 1;
GetResponse = 0;
vidname = '';
SaveData = 0;
nchanges = 1;
if runExperiment == 1
if aom == 0;
    set(handles.aom0_onoff, 'Value', 1);
    aom0_onoff_Callback;
elseif aom == 1;
    set(handles.aom1_onoff, 'Value', 1);
    aom1_onoff_Callback;
end
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
else
end
while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');

    if(resp == kb_AbortConst);

        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];

        if StimParams.aom == 0;
            set(handles.aom0_state, 'String',message);
        elseif StimParams.aom == 1;
            set(handles.aom1_state, 'String',message);
        end

    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
        command = ['GRVID#' vidname '#'];
        if board == 'm'
            %MATLABAomControl32(command);
        else
            %netcomm('write',netcommobj,int8(command));
        end
        if PresentStimulus == 1;
            while size(seq,2) < trialdur
                whichstim = round(rand.*(nresponses-1))+1;
                stim = stimulus(whichstim);
                stimdur = round(rand.*maxframes);
                if stimdur >= minframes;
                    if stimdur+size(seq,2) <= trialdur;
                        seq = [seq ones(1,stimdur).*stim];
                    elseif stimdur+size(seq,2) >= trialdur;
                        dif = trialdur-size(seq,2);
                        if dif >= minframes;
                            seq = [seq ones(1,dif).*stim];
                        elseif dif <= minframes;
                            lastframe = seq(end);
                            seq = [seq ones(1,dif).*lastframe];
                        end
                    elseif size(seq,2) == trialdur;
                    end
                elseif stimdur <= minframes;
                end
            end
            changes = 1;
            trialstims = [];
            for i = 1:numel(seq)-1;
                if seq(i) == seq(i+1);
                    changes = changes;
                    %no change
                elseif seq(i) ~= seq(i+1)         
                    trialstims(changes) = seq(i);
                    changes = changes+1;
                else
                end
            end
            trialstims(changes) = seq(i);
            seq = [seq 1];

            %set up the movie params
            Mov.frm = 1;
            Mov.sfr = 1;
            Mov.seq = seq;
            Mov.efr = 0;
            Mov.lng = trialdur+1;
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            setappdata(hAomControl, 'Mov',Mov);

            PlayMovie;

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
            if nchanges < changes
                if response == mapping(find(mapping(:,1) == trialstims(nchanges)),2);
                    responses = [responses response];
                    correct = [correct 1];
                    totalchanges = totalchanges + 1;
                    totalcorrect = totalcorrect + 1;
                    percentcorrect = totalcorrect/totalchanges;
                    nchanges = nchanges+1;
                    message = [Mov.msg ' - ' response ' - Correct. Total Correct: ' num2str(percentcorrect.*100) '%'];
                    if StimParams.aom == 0;
                        set(handles.aom0_state, 'String',message);
                    elseif StimParams.aom == 1;
                        set(handles.aom1_state, 'String',message);
                    end

                else
                    responses = [responses response];
                    correct = [correct 0];
                    totalchanges = totalchanges + 1;
                    totalcorrect = totalcorrect + 0;
                    percentcorrect = totalcorrect/totalchanges;
                    nchanges = nchanges+1;
                    message = [Mov.msg ' - ' response ' - Incorrect. Total Correct: ' num2str(percentcorrect.*100) '%'];
                    if StimParams.aom == 0;
                        set(handles.aom0_state, 'String',message);
                    elseif StimParams.aom == 1;
                        set(handles.aom1_state, 'String',message);
                    end
                end
            elseif nchanges == changes;
                %write response to psyfile
                vidsuffix = num2str(trial);
                if size(vidsuffix,2) == 1
                    vidsuffix = ['P000' vidsuffix];
                elseif size(vidsuffix,2) == 2
                    vidsuffix = ['P00' vidsuffix];
                elseif size(vidserial,2) == 3
                    vidsuffix = ['P0' vidsuffix];
                else
                    vidsuffix = ['P' vidsuffix];
                end
                vidname = [initials,'_',vidsuffix,'.avi'];

                psyfid = fopen(psyfname,'a');
                fprintf(psyfid,'%2.0f\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\n',trial,num2str(seq),num2str(trialstims),responses, vidname,num2str(correct));
                fclose(psyfid);

                nchanges = 1;
                responses = [];
                trialstims = [];
                correct = [];

                message = [Mov.msg ' - Completed. Total Correct: ' num2str(percentcorrect.*100) '%'];
                    
                    if aom == 0
                        set(handles.aom0_state, 'String',message);
                    elseif aom == 1
                        set(handles.aom0_state, 'String',message);
                    end
                trial = trial + 1;

                if(trial > ntrials)
                    runExperiment = 0;
                    set(handles.aom_main_figure, 'keypressfcn','');
                    
                    message = ['Off - Experiment Total Correct: ' num2str(percentcorrect.*100) '%'];
                    
                    if aom == 0
                        set(handles.aom0_state, 'String',message);
                    elseif aom == 1
                        set(handles.aom0_state, 'String',message);
                    end
                    TerminateExp;
                else %continue experiment
                end
                seq = [];
                GetResponse = 0;
                PresentStimulus = 1;
                GetResponse = 0;
                PresentStim = 0;
            end
        end
    end
end