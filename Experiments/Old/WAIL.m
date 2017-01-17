function WAIL
global board netcommobj StimParams %#ok<NUSED>

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

kb_ULConst = 55; %ascii code for left arrow
kb_URConst = 57; %ascii code for right arrow
kb_LLConst = 49; %ascii code for up arrow
kb_LRConst = 51; %ascii code for down arrow

kb_StimConst = CFG.kb_StimConst;
kb_UpperL = CFG.kb_UpArrow;
kb_UpperR = CFG.kb_DownArrow;
kb_LowerL = CFG.kb_LeftArrow;
kb_LowerR = CFG.kb_RightArrow;

%disable slider control during exp
set(handles.align_slider, 'Enable', 'off');

message = 'Starting Experiment...';
    set(handles.aom1_state, 'String',message);

%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
% findices = StimParams.findices;
%ntrials = max(findices-1)*CFG.npresent;
ntrials = 4*CFG.npresent;
mapfname = StimParams.mapfname;


fid = fopen([dirname mapfname]);
mapping = fscanf(fid, '%s',[2,4])';
fclose(fid);
%mapping(:,2) = mapping(:,2)./5;

% stim = unique(mapping(:,2))';
% newstim = zeros(3,size(stim,2));
% newstim(1,:) = stim;
% stim = newstim;

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
%generate a randomized sequence
sequence = makeWailSequence(CFG.npresent);
Mov.lng = (CFG.presentdur/1000)*30+1;
%generate a psyfile
psyfname = GenPsyFileName;
%write header to file
GenerateHeader(psyfname);

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
videoname = '';
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');

while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        
            set(handles.aom1_state, 'String',message);
        
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            
            randnumber = round(rand(1) * 1000);
            if randnumber < 100
                randnumber = randnumber + round(rand(1) * 10)+100; %#ok<NASGU>
            else if randnumber >= 1000
                    randnumber = floor(randnumber / 10); %#ok<NASGU>
                end
            end
            if trial < 10
                videoname = strcat('Trial_000',num2str(trial));
            else
                if (trial < 100) && (trial >= 10)
                    videoname = strcat('Trial_00',num2str(trial));
                else
                    videoname = strcat('Trial_0',num2str(trial));
                end
            end
            
            command = ['GRVID#' videoname '#'];%#ok<NASGU> %sends custom filename & initiates recording
            if board == 'm'
                %MATLABAomControl32(command);
            else
                %netcomm('write',netcommobj,int8(command));
            end
            Mov.frm = 1;
            Mov.sfr = 1;
            
            seq = sequence(trial,:); % 1 here will be i
            Mov.seq = seq;
            %add the sequence here
            
            Mov.efr = sequence(trial,end); %again here will be i
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            setappdata(hAomControl, 'Mov',Mov);
            PlayMovie;
            PresentStimulus = 0;
            GetResponse = 1;
        end    
    elseif(GetResponse == 1)
        if(resp == kb_ULConst)
            response = kb_UpperL;
        elseif(resp == kb_URConst)
            response = kb_UpperR;
        elseif(resp == kb_LLConst)
            response = kb_LowerL;
        elseif(resp == kb_LRConst)
            response = kb_LowerR;
        else
            response = 'N';
        end;
        
        %see if response is correct and display (or provide feedback)
        
        if(response ~= 'N')
            psyfid = fopen(psyfname,'a');
            stimulus = mapping(seq(2)-1,:);
            datetime = fix(clock);
            yr = num2str(datetime(1));
            mo = num2str(datetime(2));
            day= num2str(datetime(3));
            hr = num2str(datetime(4));
            min = num2str(datetime(5));
            sec = num2str(datetime(6));
            datetime = [yr '_' mo '_' day '_' hr '_' min '_' sec];
            %fprintf(psyfid,'%s\t%s\t%s\t%s\n',stimulus,response,videoname, datetime);
            fprintf(psyfid,'%d\t%s\t%s\t%s\n',sequence(trial,2),response,videoname, datetime);
            fclose(psyfid);
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials) ' Stimulus: ' stimulus ' Response: ' response];
                set(handles.aom1_state, 'String',message);
            trial = trial + 1;
            
            GetResponse = 0;
            PresentStimulus = 1;
            
            %write response to psyfile
            
            
            if(trial > ntrials)
                runExperiment = 0;
                set(handles.aom_main_figure, 'keypressfcn','');
                TerminateExp;
                message = sprintf('Off - Experiment Complete');
                    set(handles.aom1_state, 'String',message);
            else %continue experiment
            end
        end
    end
end