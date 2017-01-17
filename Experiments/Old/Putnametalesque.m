function Putnametalesque

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

trialdur = CFG.trialdur;

pname = get(handles.set_imdir, 'UserData');
fprefix = 'fixation';
findex = '2';
fext = 'bmp';
commandstring = ['Load#',0,'#0#',pname,'#',fprefix,'#',findex,'#',findex,'#',fext,'#'];
if board == 'm'
    %MATLABAomControl32(commandstring);
else
    %netcomm('write',netcommobj,int8(commandstring));
end
commandstring = ['Update#0#2#'];
if board == 'm'
    %MATLABAomControl32(commandstring);
else
    %netcomm('write',netcommobj,int8(commandstring));
end
fullpath = [pname,fprefix,findex,'.',fext];
frame = imread(fullpath);

    set(handles.aom1_onoff, 'Enable', 'on');
    set(handles.aom1_onoff, 'Value', 1);
    a = imread('on.bmp');
    set(handles.aom1_onoff, 'Cdata', a);
    h = get(handles.im_panel1, 'Child');
    hAomControl = getappdata(0,'hAomControl');
    setappdata(hAomControl, 'aom1image', fullpath);

set(handles.align_slider, 'Enable', 'on');
set(h,'Visible', 'on');
axes(h); %#ok<MAXES>
imshow(frame);
tone=CFG.tone/1000;
markinterval = trialdur-tone;
[y,Fs,bits] = wavread('beep');

ntrials = CFG.ntrials;
set(handles.aom1_state, 'String', 'Starting Experiment...');
 
%generate a psyfile
psyfname = GenPsyFileName;

%write header to file
GenerateHeader(psyfname);
initials = CFG.initials;
%set initial while loop conditions
runExperiment = 1;
trial = 1;
vidserial = 1;
PresentStimulus = 1;
GetResponse = 0;
MarkFrame = 0;
vidname = '';
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

    elseif(resp == kb_StimConst)    % check if present stimulus button was pressed

        if PresentStimulus == 1;
            message = ['On - Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
                set(handles.aom1_state, 'String',message);
            vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];
            command = ['GRVID#' vidname '#'];            
            if board == 'm'
                %MATLABAomControl32(command);
            else
                %netcomm('write',netcommobj,int8(command));
            end
            tic;
            waitfortone = 1;
            while waitfortone == 1;
                if toc <= tone;
                elseif toc>=tone;
                    wavplay(y,Fs,'sync');
                    waitfortone = 0;
                end
            end
            PresentStimulus = 0;
            set(handles.aom_main_figure, 'CurrentCharacter', '0');
            MarkFrame = 1;
            message = 'On - Running Experiment - Waiting to mark frame...';
                set(handles.aom1_state, 'String',message);
            tic;
        end
        
    elseif(MarkFrame == 1)
        
        while MarkFrame == 1;
            if toc <= markinterval;
                if resp == kb_RightConst || resp == kb_LeftConst
                    command = ['WHBAR#'];
                    if board == 'm'
                        %MATLABAomControl32(command);
                    else
                    end
                    message = 'On - Running Experiment - Frame Marked.';
                        set(handles.aom1_state, 'String',message);
                    MarkFrame = 0;
                    GetResponse = 1;
                else
                end
            elseif toc >= markinterval;
                MarkFrame = 0;
                GetResponse = 1;
            end
        end

    elseif(GetResponse == 1)
        if(resp == kb_UpConst)
            response = kb_UpArrow;
        elseif(resp == kb_DownConst)
            response = kb_DownArrow;
        else
            response = 'N';
        end;

        if(response ~= 'N')
            if response == 'A'
                message = ['Trial ' num2str(trial) ' of ' num2str(ntrials) ' Accepted'];
                    set(handles.aom1_state, 'String',message);
            elseif response == 'R'
                message = ['Trial ' num2str(trial) ' of ' num2str(ntrials) ' Rejected.'];
                    set(handles.aom1_state, 'String',message);
                ntrials = ntrials+1;
            else
            end
            %write response to psyfile
            vidsuffix = num2str(vidserial);
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
            fprintf(psyfid,'%2.0f\t%s\t%s\n',trial,response, vidname);
            fclose(psyfid);
            %update trial counter
            trial = trial + 1;
            vidserial = vidserial+1;

            if(trial > ntrials)
                runExperiment = 0;
                set(handles.aom_main_figure, 'keypressfcn','');
                TerminateExp;
                message = 'Off - Experiment Complete.';
                    set(handles.aom0_state, 'String',message);
            else %continue experiment
            end
            GetResponse = 0;
            PresentStimulus = 1;
        end
    end
end