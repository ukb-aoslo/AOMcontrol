function BasicAuto

global  StimParams mode %#ok<NUSED>


if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');
Mov = getappdata(hAomControl, 'Mov');

%set up auto response timing
repeat = CFG.repeat; %how long to wait for response in seconds before

%setup the keyboard constants and response mappings from config
kb_AbortConst = 27; %abort constant - Esc Key

kb_LeftConst = 28; %ascii code for left arrow
kb_RightConst = 29; %ascii code for right arrow
kb_UpConst = 30; %ascii code for up arrow
kb_DownConst = 31; %ascii code for down arrow

%need to check these ascii codes for numeric keypad
kb_1Const = 49;
kb_2Const = 50;
kb_3Const = 51;
kb_4Const = 52;
kb_5Const = 53;
kb_6Const = 54;
kb_7Const = 55;
kb_8Const = 56;
kb_9Const = 57;
kb_ZConst = 122;
kb_XConst = 120;

% kb_StimConst = CFG.kb_StimConst;
kb_UpArrow = CFG.kb_UpArrow;
kb_DownArrow = CFG.kb_DownArrow;
kb_LeftArrow = CFG.kb_LeftArrow;
kb_RightArrow = CFG.kb_RightArrow;
kb_1 = CFG.kb_1;
kb_2 = CFG.kb_2;
kb_3 = CFG.kb_3;
kb_4 = CFG.kb_4;
kb_5 = CFG.kb_5;
kb_6 = CFG.kb_6;
kb_7 = CFG.kb_7;
kb_8 = CFG.kb_8;
kb_9 = CFG.kb_9;


%disable slider control during exp
set(handles.align_slider, 'Enable', 'off');
set(handles.aom1_state, 'String', 'Starting Experiment...');

%get the stimulus parameters
dirname = StimParams.dirname;
fprefix = StimParams.fprefix;
% findices = StimParams.findices;
mapfname = StimParams.mapfname;
% grabvid = CFG.record;

fid = fopen([dirname mapfname]);
mapping = fscanf(fid, '%s',[1,inf])';
fclose(fid);

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;

%parse the sequence file
seqfname = StimParams.seqfname;
seq = fopen([dirname seqfname]);
counter = 1;
aomzeroseq = [];
aomoneseq = [];
while(feof(seq) == 0);
    temp = fgetl(seq);
    movie_seq{counter}(1:length(temp)) = temp(:); %#ok<AGROW>
    count = 1;
    while (any(temp))
        [chopped,temp] = strtok(temp); %#ok<STTOK>
        commapos = findstr(',', chopped);
        aom0seq = str2num(chopped(1:commapos-1)); %#ok<ST2NM>
        aom1seq = str2num(chopped(commapos+1:size(chopped,2))); %#ok<ST2NM>
        if isempty(aom0seq) || isempty(aom1seq)
            %do nothing
        else
            aomzeroseq(count) = aom0seq; %#ok<AGROW>
            aomoneseq(count) = aom1seq; %#ok<AGROW>
            count = count+1;
        end
    end
    aom0_seq(counter,:) = aomzeroseq; %#ok<AGROW>
    aom1_seq(counter,:) = aomoneseq; %#ok<AGROW>
    aomzeroseq = [];
    aomoneseq = [];
    counter = counter + 1;
end;
fclose(seq);
Mov.aom0seq = aom0_seq;
Mov.aom1seq = aom1_seq;
Mov.lng = size(aom0_seq,2); %movie length IN FRAMES

% fprefix = StimParams.fprefix;
% findices = StimParams.findices;
ntrials = size(movie_seq,2);
Mov.dir = [dirname '\'];
Mov.suppress = 0;
%generate a psyfile
psyfname = GenPsyFileName;
%write header to file
GenerateHeader(psyfname);
initials = CFG.initials;
%Stimuli wav file
wavfile = [pwd '\beep.wav'];
[y,Fs,bits] = wavread(wavfile); %#ok<NASGU>

%set initial while loop conditions
runExperiment = 1;
trial = 1;
vidserial = 1;
PresentStimulus = 1;
GetResponse = 0;
abort = 0;
response = '0';
resp = 48; %#ok<NASGU>
set(handles.aom_main_figure,'CurrentCharacter','0');
t = repeat;
PauseExperiment = 0;
while(runExperiment ==1)
    if(abort == 1);
        runExperiment = 0;
        TerminateExp;
        message = ['Experiment Aborted - Trial ' num2str(trial)-1 ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);
    elseif(PresentStimulus == 1 && t>=repeat && PauseExperiment == 0)    % check if present stimulus button was pressed       
            Mov.frm = 1;
            Mov.sfr = 1;
            seq = movie_seq{trial};
            Mov.seq = char(seq);
            efr = str2num(seq);
            Mov.efr = efr(end);
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
            Mov.msg = message;
            setappdata(hAomControl, 'Mov',Mov);
            wavplay(y,Fs,'sync');
            PlayMovie;            
            PresentStimulus = 0;
            GetResponse = 1;
            t=0;
            tic;
    elseif(GetResponse == 1)           
        while t<=repeat;
            uiwait(handles.aom_main_figure, 1);
            resp = uint8(get(handles.aom_main_figure,'CurrentCharacter'));
            if resp == 48;
                t = toc;
                response = '0';
            elseif resp ~= 48;
                if(resp == kb_UpConst)
                    response = kb_UpArrow;
                elseif(resp == kb_DownConst)
                    response = kb_DownArrow;
                elseif(resp == kb_LeftConst)
                    response = kb_LeftArrow;
                elseif(resp == kb_RightConst)
                    response = kb_RightArrow;
                elseif(resp == kb_1Const)
                    response = kb_1;
                elseif(resp == kb_2Const)
                    response = kb_2;
                elseif(resp == kb_3Const)
                    response = kb_3;
                elseif(resp == kb_4Const)
                    response = kb_4;
                elseif(resp == kb_5Const)
                    response = kb_5;
                elseif(resp == kb_6Const)
                    response = kb_6;
                elseif(resp == kb_7Const)
                    response = kb_7;
                elseif(resp == kb_8Const)
                    response = kb_8;
                elseif(resp == kb_9Const)
                    response = kb_9;
                elseif(resp == kb_ZConst)
                    PauseExperiment = 1;
                elseif(resp == kb_XConst)
                    PauseExperiment = 2;
                elseif(resp == kb_AbortConst)
                    response = 'Esc';
                    abort = 1;
                else
                    response = 'N';
                end;
                t=toc;              
            end
        end
        if PauseExperiment == 0
            if response == mapping(trial)
                message = [Mov.msg ' - ' response ' - Correct'];
                set(handles.aom1_state, 'String',message);               
            else
                message = [Mov.msg ' - ' response ' - Incorrect'];
                set(handles.aom1_state, 'String',message);
            end
            set(handles.aom_main_figure,'CurrentCharacter','0');
            resp = 48; %#ok<NASGU>
            
            %write response to psyfile
            vidsuffix = num2str(vidserial);
            if size(vidsuffix,2) == 1
                vidsuffix = ['P000' vidsuffix]; %#ok<AGROW>
            elseif size(vidsuffix,2) == 2
                vidsuffix = ['P00' vidsuffix]; %#ok<AGROW>
            elseif size(vidserial,2) == 3
                vidsuffix = ['P0' vidsuffix]; %#ok<AGROW>
            else
                vidsuffix = ['P' vidsuffix]; %#ok<AGROW>
            end
            vidname = [initials,'_',vidsuffix,'.avi'];
            psyfid = fopen(psyfname,'a');
            fprintf(psyfid,'%2.0f\t%s\t%s\n',trial,response,vidname);
            fclose(psyfid);

            %update trial counter
            trial = trial + 1;
            vidserial = vidserial+1;
            GetResponse = 0;
            PresentStimulus = 1;            
        elseif PauseExperiment == 1
            message = [Mov.msg ' - Experiment Paused'];
            set(handles.aom1_state, 'String',message);
            vidserial = vidserial+1;
            t=0;
            tic;
        elseif PauseExperiment == 2
            message = [Mov.msg ' - Experiment Resumed'];
            set(handles.aom1_state, 'String',message);
            PauseExperiment = 0;
            set(handles.aom_main_figure,'CurrentCharacter','0');
            resp = 48; %#ok<NASGU>
            t=toc;
            GetResponse = 0;
            PresentStimulus = 1;
        end

        if(trial > ntrials)
            runExperiment = 0;
            TerminateExp;
            message = sprintf('Off - Experiment Complete.');
            set(handles.aom1_state, 'String',message);
        else %continue experiment
        end        
    end
end
