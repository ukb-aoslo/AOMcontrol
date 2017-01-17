function SaccTumbE

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
set(handles.aom0_state, 'String', 'Starting Experiment...');

%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
findices = StimParams.findices;
ntrials = (max(findices) - 10) * CFG.npresent;
ntrials = ntrials / 4;
message = num2str(ntrials);
set(handles.aom0_state, 'String',message);

mapfname = StimParams.mapfname;

fid = fopen([dirname mapfname]);
mapping = fscanf(fid, '%s')';
fclose(fid);
message = mapping;

set(handles.aom0_state, 'String',message);
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
sequence = makeSaccTumbESequence(ntrials);
Mov.lng = (CFG.presentdur/1000)*30+1;
%generate a psyfile
psyfname = GenPsyFileName;

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
videoname = '';
%set(AOMcontrol, 'KeyPressFcn','uiresume');
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

            randnumber = round(rand(1) * 10000);
            if randnumber < 10000
                randnumber = randnumber + round(rand(1) * 100)+1000;
            else if randnumber >= 10000
                    randnumber = floor(randnumber / 10);
                end
            end
            if trial < 10
                videoname = strcat('Trial_0000',num2str(trial),num2str(randnumber));
            else
                if (trial < 100) && (trial >= 10)
                    videoname = strcat('Trial_000',num2str(trial),num2str(randnumber));
                else
                    if (trial < 1000) && (trial >= 100)
                        videoname = strcat('Trial_00',num2str(trial),num2str(randnumber));
                    else
                        videoname = strcat('Trial_0',num2str(trial),num2str(randnumber));
                    end
                end
            end
            
            command = ['GRVID#' videoname '#'];
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
            psyfid = fopen(psyfname,'a');
            stimulus = mapping(seq(16) - 1,:);
            datetime = fix(clock);
            yr = num2str(datetime(1));
            mo = num2str(datetime(2));
            day= num2str(datetime(3));
            hr = num2str(datetime(4));
            min = num2str(datetime(5));
            sec = num2str(datetime(6));
            datetime = [yr '.' mo '.' day '_' hr '-' min '-' sec];
            fprintf(psyfid,'%s\t%s\t%s\t%s\n',stimulus,response,videoname, datetime);
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
            set(handles.aom0_state, 'String',message);      
        else %continue experiment      
        end
        %update trial counter
        
        
        end
    end
end