%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TwoPtVA

global serialPort StimParams mode


if exist('handles') == 0;
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

message = 'Starting Experiment...';
set(handles.aom1_state, 'String',message);
%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
findices = StimParams.findices;
ntrials = (max(findices)-1)*CFG.npresent;
mapfname = StimParams.mapfname;
fieldsize = CFG.fieldsize;

fid = fopen([dirname mapfname]);
mapping = fscanf(fid, '%i%s%f%i',[4,inf])';
fclose(fid);


stim = unique(mapping(:,3))';
stim = stim.*fieldsize;
newstim = zeros(3,size(stim,2));
newstim(1,:) = stim;
stim = newstim;

stepsize = stim(end)-stim(end-1);

%set up the movie parameters
Mov.dir = dirname;
Mov.pfx = fprefix;
Mov.suppress = 0;
aom = StimParams.aom;
Mov.aom = aom;
%generate a randomized sequence
sequence = GenRandSequence;
Mov.lng = size(sequence,2);

%generate a psyfile
psyfname = GenPsyFileName;
%write header to file
GenerateHeader(psyfname);
%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');

while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter'); 
    
    if(resp == kb_AbortConst);
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        if StimParams.aom == 0;
                set(handles.aom0_state, 'String',message);
            elseif StimParams.aom == 1;
                set(handles.aom1_state, 'String',message);
            end
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed

        initialize_SerialPort;
        command = ['GRVID' sprintf('%10d',1)];
        fprintf(serialPort,command);   % send command over serial port to imaging software
        fclose(serialPort);

        if PresentStimulus == 1;
            Mov.frm = 1;
            Mov.sfr = 1;
            seq = sequence(trial,:);
            Mov.seq = seq;
            Mov.efr = sequence(trial,end); 
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
            if response == mapping(sequence(trial,1)-1,2)
                message = [Mov.msg ' - ' response ' - Correct'];
                set(handles.aom0_state, 'String',message);
                stimulus = sequence(trial,1);
                mar = mapping(sequence(trial,1)-1,3)*fieldsize;
                correct = 1;
                for i = 1:size(stim,2)
                    if stim(1,i) == mar;
                        stim(2,i) = stim(2,i)+1;
                        stim(3,i) = stim(3,i)+1;
                    else
                    end
                end
            else
                message = [Mov.msg ' - ' response ' - Incorrect'];
                stimulus = sequence(trial,1);
                set(handles.aom0_state, 'String',message);
                mar = mapping(sequence(trial,1)-1,3)*fieldsize;
                correct = 0;
                for i = 1:size(stim,2)
                    if stim(1,i) == mar;
                        stim(3,i) = stim(3,i)+1;
                    else
                    end
                end
            end

        %write response to psyfile
        psyfid = fopen(psyfname,'a');
        fprintf(psyfid,'%2.0f\t%s\t%4.4f\t%1.0f\n',stimulus,response,mar,correct);
        fclose(psyfid);

        %update trial counter
        trial = trial + 1;

        if(trial > ntrials)
            runExperiment = 0;
            set(handles.aom_main_figure, 'keypressfcn','');                     
            TerminateExp;
            rmdir([pwd,'\temp'],'s');
            sizes = stim(1,:);
            ncorrect = stim(2,:);
            trials = stim(3,:);
            thresh = weibull(trials, ncorrect, sizes, guess);
 
            message = sprintf('Off - Experiment Complete - MAR: %4.2f',thresh);
            set(handles.aom0_state, 'String',message);
      
            %dlmwrite('stim.txt', stim, '\t');
        else %continue experiment      
        end
        GetResponse = 0;
        PresentStimulus = 1;
        
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%