function WAIL_NPV %runs using FPGA only
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
% ntrials = 4*CFG.npresent;

locfname = StimParams.mapfname;
fid = fopen([dirname locfname]);
xylocs = fscanf(fid, '%d%d',[2,inf])';
fclose(fid);
ntrials = size(xylocs, 1);
%netcomm('write',netcommobj,int8('Fixate#'));

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;
%generate a psyfile
psyfname = GenPsyFileName;
%write header to file
GenerateHeader(psyfname);

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2; %the index of your bitmap
startframe = 5; %the frame at which it starts presenting stimulus
fps = 30;
presentdur = CFG.presentdur/1000;
stimdur = round(fps*presentdur); %how long is the presentation
aom1seq = [ones(1,startframe-1) ones(1,stimdur).*framenum ones(1,CFG.videodur*fps-startframe+1-stimdur)];
aom0seq = zeros(size(aom1seq));
for i = 1:length(aom0seq)
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
Mov.frm = 1;
Mov.sfr = 1;
Mov.seq = seq;
Mov.efr = 0;

%set initial while loop conditions
runExperiment = 1;
trial = 1;
PresentStimulus = 1;
GetResponse = 0;
vidname = '';
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
            
            command = ['Locate#' num2str(xylocs(trial,1)) '#' num2str(xylocs(trial,2)) '#']; %#ok<NASGU>
            %netcomm('write',netcommobj,int8(command));            
            vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
            command = ['GRVIDT#' vidname '#'];%#ok<NASGU> %sends custom filename & initiates recording
            %netcomm('write',netcommobj,int8(command));
            Mov.frm = 1;
            Mov.sfr = 1;
            Mov.efr = 0;
            Mov.lng = CFG.videodur*fps;
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
            fprintf(psyfid,'%s\t%d\t%d\t%s\r\n',vidname,xylocs(trial,1),xylocs(trial,2),response);
            fclose(psyfid);
            message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials) ' Stimulus Loc: (' num2str(xylocs(trial,1)) ',' num2str(xylocs(trial,2)) ') Response: ' response];
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