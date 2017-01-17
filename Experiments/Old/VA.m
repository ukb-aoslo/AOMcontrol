function VA

global  StimParams mode %#ok<NUSED>


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

message = 'Starting Experiment...';
    set(handles.aom1_state, 'String',message);
%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
findices = StimParams.findices;
mapfname = StimParams.mapfname;

if CFG.stimtype == 'e'
    guess = .25;
    fid = fopen([dirname mapfname]);
    mapping = fscanf(fid, '%f%s%f',[3,inf])';
    fclose(fid);
    mocthreshest = str2num(CFG.mocthreshest); %#ok<ST2NM>
    index = 1;
    maploop = 1;
    for i = 1:size(mapping(:,3))
        if mapping(maploop,3) - mocthreshest > 0.0
           sizes(index) = mapping(maploop-2,1); %#ok<AGROW> 
           index = index+1;
           if index > 2
               break;       
           end
           maploop = size(mapping,1)/2;
        end
        maploop = maploop+1;
%         if round((mapping(i,3)*10)/9) >= mocthreshest && round((mapping(i,3)*10)/9) <= mocthreshest
%             sizes(index) = mapping(i,1);
%             index = index+1;
%         else
%         end
    end
    frames = zeros(1,24);
    frames(1:14) = min(sizes)-6:1:min(sizes)+7;
    frames(15:28) = max(sizes)-6:max(sizes)+7;
%     set(handles.aom0_state, 'String',num2str(frames));
%     pause(2);
    for i = 1:size(frames,2)
        whichframe = frames(i);
        stim(i) = mapping(whichframe-1,3); %#ok<AGROW>
    end
    stim = unique(stim);
    ntrials = size(frames,2).*CFG.npresent;
    
elseif CFG.stimtype == 's'
    guess = .5;
    fid = fopen([dirname mapfname]);
    mapping = fscanf(fid, '%f%s%f',[3,inf])';
    fclose(fid); 
    ntrials = (max(findices)-1)*CFG.npresent;
    stim = unique(mapping(:,3))';
    frames = mapping(:,1)';
elseif CFG.stimtype == 'd'
    guess = .5;
    fid = fopen([dirname mapfname]);
    mapping = fscanf(fid, '%f%f%f%f%s',[5,inf])';
    fclose(fid);
    ntrials = (max(findices)-1)*CFG.npresent;
    stim = unique(mapping(:,3))';
    %stim = stim.*fieldsize;
    frames = mapping(:,1)';
end
    newstim = zeros(3,size(stim,2));
    newstim(1,:) = stim;
    stim = newstim;

%generate a randomized sequence
sequence = GenRandSequence(frames);
Mov.lng = size(sequence,2);

%set up the movie parameters
Mov.dir = dirname;
Mov.pfx = fprefix;
Mov.suppress = 0;

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
            set(handles.aom1_state, 'String',message);
    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed       
        if PresentStimulus == 1;    
                aom0seq = sequence(trial,:);
                aom1seq = aom0seq;
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
        if CFG.stimtype == 'd'
        correctresponse = num2str(mapping(sequence(trial,1)-1,2));
        else
        correctresponse = mapping(sequence(trial,1)-1,2);
        end    
        pause(0.1);
        if(response ~= 'N')
            if response == correctresponse; %mapping(sequence(trial,1)-1,2)
                message = [Mov.msg ' - ' response ' - Correct'];
                    set(handles.aom1_state, 'String',message);
                stimulus = sequence(trial,1);
                mar = mapping(sequence(trial,1)-1,3);%*fieldsize;
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
                    set(handles.aom1_state, 'String',message);
                stimulus = sequence(trial,1);
                mar = mapping(sequence(trial,1)-1,3);%*fieldsize;
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
            ncorrect = stim(2,:);
            trials = stim(3,:);
            
            if CFG.stimtype == 'd'
                rmdir([pwd,'\temp'],'s');
                ncorrect(1) = [];
                trials(1) = [];
                sizes = stim(1,:);
                sizes(1) = [];
                thresh = weibull(trials, ncorrect, sizes, guess);    
            elseif CFG.stimtype == 'e'
                thresh = weibull(trials, ncorrect, sizes, guess);    
            end
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