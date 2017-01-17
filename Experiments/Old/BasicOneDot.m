function BasicOneDot
global SYSPARAMS StimParams VideoParams; %#ok<NUSED>
if exist('handles','var') == 0,  handles = guihandles; end
%%%%% User setup parameters %%%%%%%%%%
BasicOneDotParams; % load all the experiment parameters in structure p
p.version = '1.0 created by TC 7/12/2012';
startup(p);
%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(BasicOneDotConfig);
CFG = getappdata(hAomControl, 'CFG');
p.subject=CFG.initials; % subject ID
VideoParams.vidprefix = p.subject;
p.psyfname = set_VideoParams_PsyfileName();
%hAomControl = getappdata(0,'hAomControl');
Parse_Load_Buffers(1);

StimParams.stimpath = [cd '\tempStimulus\'];
StimParams.fprefix = 'frame';
set(handles.aom1_state, 'String', 'Configuring Experiment...');
if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
    set(handles.aom1_state, 'String', 'Off - Press Start Button To Begin Experiment');
else
    set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
end

% setup up movie temporal sequence
Mov=createTemporal(p);
% collect the data
[p resp]=runExperiment(p,Mov,handles,kb);
saveResults(resp,p,kb);
end

function [p resp]=runExperiment(p,Mov,handles,kb)
global SYSPARAMS StimParams VideoParams; %#ok<NUSED>
hAomControl = getappdata(0,'hAomControl');
if exist('handles','var') == 0,  handles = guihandles; end
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
PresentStimulus = 1;
GetResponse = 0;
while(1) % start of main experiment loop
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentKey');
    if strcmp(resp,kb.AbortConst);
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(p.trial) ' of ' num2str(p.ntrials)];
        set(handles.aom1_state, 'String',message);
        break;
    elseif strcmp(resp,kb.StimConst)    % check if present stimulus button was pressed
        if PresentStimulus == 1;
            if SYSPARAMS.realsystem == 1
                StimParams.sframe = 2;
                StimParams.eframe = 2;
                %StimParams.fext = 'bmp';
                StimParams.fext = 'buf';
                Parse_Load_Buffers(0);
            end
            Mov.frm = 1;
            %Mov.duration = VideoParams.videodur*fps;
            
            Mov.msg = ['Running Experiment - Trial ' num2str(p.trial) ' of ' num2str(p.ntrials)];
            %Mov.seq = '';
            setappdata(hAomControl, 'Mov',Mov);
            VideoParams.vidname = [VideoParams.vidprefix '_' sprintf('%03d',p.trial)];
            PlayMovie;
            PresentStimulus = 0;
            GetResponse = 1;
        end
    elseif(GetResponse == 1)
        [p message GetResponse]=processResponse(resp,p);
        set(handles.aom1_state, 'String',message);
        if GetResponse == 0
            if(p.trial > p.ntrials)
                set(handles.aom_main_figure, 'keypressfcn','');
                TerminateExp;
                break;
            end
            PresentStimulus = 1;
        end
    end
end
end
function saveResults(resp,p,kb)
% test for proper exit and them call excel code to save results
if ~strcmp(resp,kb.AbortConst)
    % path to matlab2excel
    addpath 'C:\Programs\AOMcontrol_V3_2\Experiments\ThomData'
    comment = input('enter a comment about the run: ','s');
    day=datestr(now);
    header = {
        'subject' 'day'  'version' 'repeat' 'duration' 'ntrials' 'fieldsize' ...
        'dotsize' 'contrast' ...
        'response' 'condition' 'respByCond' 'comment' ...
        };
    data = {
        p.subject day p.version p.badTrial p.presentdur p.ntrials p.fieldsize ...
        p.dotsize p.dotcontrast ...
        p.response p.condition p.respByCond comment...
        };
    exfilename = [p.psyfname(1:end-4) '_BasicOneDot_' p.subject '.xls'];
    matlab2excel('open',exfilename);
    matlab2excel('header', header, 'data', data); % writes the data
    p.respByCond, % show the button presses
end
end
function createImages(p)
%use stim_im variable to create your new stimulus image data
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
else
    cd([pwd,'\tempStimulus']);
    delete ('*.*'); %inserted to simplify startup function
end
% use the below section to save buffer files 14bit
%create target 
stim_im1 = ones(p.dotsize, p.dotsize)*p.dotcontrast(p.nextLevel);
fid = fopen(['frame' num2str(p.targetBMPnumber) '.buf'],'w');
fwrite(fid,size(stim_im1,2),'uint16');
fwrite(fid,size(stim_im1,1),'uint16');
fwrite(fid, stim_im1, 'double');
fclose(fid);
%imwrite(stim_im1,['frame' num2str(p.targetBMPnumber) '.bmp']);
%create cue
stim_im2=zeros((p.cueRadius+p.cueThickness)*2);
stim_im2(p.cueThickness:end-p.cueThickness,p.cueThickness:end-p.cueThickness)=1; %ring
fid = fopen(['frame' num2str(p.cueBMPnumber) '.buf'],'w');
fwrite(fid,size(stim_im2,2),'uint16');
fwrite(fid,size(stim_im2,1),'uint16');
fwrite(fid, stim_im2, 'double');
fclose(fid);
%imwrite(stim_im2,['frame' num2str(p.cueBMPnumber) '.bmp']);

%create cue+target
stim_im2(round((p.cueRadius+p.cueThickness)-p.dotsize/2:(p.cueRadius+p.cueThickness)+p.dotsize/2-1), ...
        round((p.cueRadius+p.cueThickness)-p.dotsize/2:(p.cueRadius+p.cueThickness)+p.dotsize/2-1)) = stim_im1;
fid = fopen(['frame' num2str(p.cueBMPnumber+p.targetBMPnumber-1) '.buf'],'w');
fwrite(fid,size(stim_im2,2),'uint16');
fwrite(fid,size(stim_im2,1),'uint16');
fwrite(fid, stim_im2, 'double');
fclose(fid);
%imwrite(stim_im2,['frame' num2str(p.cueBMPnumber+p.targetBMPnumber-1) '.bmp']);
cd ..;
end
function startup(p)
global SYSPARAMS StimParams VideoParams; %#ok<NUSED>
createImages(p);
if exist('handles','var') == 0,  handles = guihandles; end
set(handles.image_radio1, 'Enable', 'off');
set(handles.seq_radio1, 'Enable', 'off');
set(handles.im_popup1, 'Enable', 'off');
set(handles.display_button, 'String', 'Running Exp...');
set(handles.display_button, 'Enable', 'off');
set(handles.aom1_state, 'String', 'On - Experiment Mode - Running Experiment');
SYSPARAMS.aoms_state(2)=0; % SWITCH RED OFF
SYSPARAMS.aoms_state(3)=0; % SWITCH GREEN OFF
end
function [p message GetResponse ]=processResponse(resp,p)
if strcmp(resp,'1') || strcmp(resp,'2') || strcmp(resp,'3')  || strcmp(resp,'4')
    p.response(p.trial) = str2double(resp);
    p.condition(p.trial)= p.nextLevel;
    p.respByCond(p.response(p.trial),p.condition(p.trial))= p.respByCond(p.response(p.trial),p.condition(p.trial))+1;
    message = [ ' - Stimulus presented: ' num2str(p.nextLevel) ' - Stimulus seen: ' resp]; % customize this message as per your requirements
    GetResponse = 0;
    p.nextLevel = ceil(rand *4);
    p.trial=p.trial+1;
    createImages(p);
elseif strcmp(resp,'9') % bad trial
    message =  ' bad trial '; % customize this message as per your requirements
    GetResponse = 0;
    p.badTrial=p.badTrial+1;
else
    message = 'bad response code string';
    GetResponse = 1; % not sure about this value
end
end
function Mov=createTemporal(p)
global SYSPARAMS StimParams VideoParams; %#ok<NUSED>
%generate a sequence that can be used thru out the experiment
%framenum = 2; %the index of your bitmap
%startframe = 5; %the frame at which it starts presenting stimulus
%stimdur = round(p.fps*p.presentdur/1000); %how long is the presentation
numframes = p.fps*VideoParams.videodur;
%seq=[ones(1,startframe-1) ones(1,stimdur).*framenum ones(1,numframes-startframe+1-stimdur)];
seq=ones(1,numframes); seq(p.cueFrames(1):p.cueFrames(2))= p.cueBMPnumber;
for i=p.dotFrames(1):p.dotFrames(2), 
    if seq(i)== p.cueBMPnumber, seq(i)= p.cueBMPnumber+p.targetBMPnumber-1; 
    else seq(i) = p.targetBMPnumber;
    end
end
aom0seq = seq;
aom0locx = zeros(size(aom0seq)); %we dont need to move the stimulus location relative to the selected location
aom0locy = zeros(size(aom0seq)); %we dont need to move the stimulus location relative to the selected location
aom0pow = ones(size(aom0seq)); %the power of the stimlus stays the same through out the trial

%set paramters for Red laser to zeros as we are not using
aom1seq = zeros(size(aom0seq));
aom1pow = zeros(size(aom1seq));
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
%set paramters for Green laser to zeros as we are not using
aom2seq = zeros(size(aom0seq));
aom2pow = zeros(size(aom2seq));
aom2offx = zeros(size(aom2seq));
aom2offy = zeros(size(aom2seq));
aom2locx = zeros(size(aom2seq));
aom2locy = zeros(size(aom2seq));

gainseq = ones(size(aom1seq)); % specify if you want to use different gain, here it is set to 1
angleseq = zeros(size(aom1seq)); %no angle is being used for stimulus presentation
stimbeep = zeros(size(aom1seq));
%stimbeep(startframe+stimdur-1) = 1; % set the frame number at which you would like to present a beep for stimulus presentation
stimbeep(p.cueFrames(1)) = 1; % set the frame number at which you would like to present a beep for stimulus presentation

%Set up movie parameters
Mov.dir = StimParams.stimpath;
Mov.suppress = 0;
Mov.pfx = StimParams.fprefix;
Mov.duration = size(aom1seq,2);
Mov.aom0seq = aom0seq;
Mov.aom1seq = aom1seq;
Mov.aom0pow = aom0pow;
Mov.aom1pow = aom1pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;
Mov.aom2seq = aom2seq;
Mov.aom2pow = aom2pow;
Mov.aom2locx = aom2locx;
Mov.aom2locy = aom2locy;
Mov.aom2offx = aom2offx;
Mov.aom2offy = aom2offy;
Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.stimbeep = stimbeep;
Mov.frm = 1;
Mov.seq = '';
end


