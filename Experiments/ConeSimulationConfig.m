function varargout = ConeSimulationConfig(varargin)
% CONESIMULATIONCONFIG M-file for ConeSimulationConfig.fig
%      CONESIMULATIONCONFIG, by itself, creates a new CONESIMULATIONCONFIG or raises the existing
%      singleton*.
%
%      H = CONESIMULATIONCONFIG returns the handle to a new CONESIMULATIONCONFIG or the handle to
%      the existing singleton*.
%
%      CONESIMULATIONCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONESIMULATIONCONFIG.M with the given input arguments.
%
%      CONESIMULATIONCONFIG('Property','Value',...) creates a new CONESIMULATIONCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConeSimulationConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConeSimulationConfig_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConeSimulationConfig

% Last Modified by GUIDE v2.5 22-Jan-2015 08:54:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ConeSimulationConfig_OpeningFcn, ...
    'gui_OutputFcn',  @ConeSimulationConfig_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ConeSimulationConfig is made visible.
function ConeSimulationConfig_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConeSimulationConfig (see VARARGIN)

% Choose default command line output for ConeSimulationConfig
global SYSPARAMS StimParams VideoParams ExpCfgParams; %#ok<*NUSED>
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConeSimulationConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% hAomControl = getappdata(0,'hAomControl');
% exp = getappdata(hAomControl, 'exp'); %#ok<*NASGU>


if exist('lastConeSimulationCFG.mat','file')==2;
    loadLastValues(handles,1);
    set(handles.push_default,'Enable','On');
    set(handles.push_last,'Enable','Off');
else
    loadLastValues(handles,0);
    set(handles.push_default,'Enable','Off');
    set(handles.push_last,'Enable','Off');
end



% NOT Sure if the following is needed
% -------------------------------------% -------------------------------------
% imSize = 100;                           % image size: n X n
% downscale=10;
% ind=(rand(downscale,downscale));
% dotsize=round(imSize/downscale);
% patt=zeros(downscale*dotsize,downscale*dotsize);
% for i=1:downscale
%     for j=1:downscale
%         patt(i*dotsize-(dotsize-1):i*dotsize,j*dotsize-(dotsize-1):j*dotsize)=ind(i,j);
%     end
% end
% handles.patt=imresize(patt,[imSize imSize]);
% handles.width=imSize;
% -------------------------------------% -------------------------------------



guidata(hObject, handles);

drawPreview (handles);


% --- Outputs from this function are returned to the command line.
function varargout = ConeSimulationConfig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Loads last parameters stored in mat file or defaults defined here
function loadLastValues (handles,last)

global SYSPARAMS StimParams VideoParams ExpCfgParams;

if last==1
    load('lastConeSimulationCFG.mat');
else
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.fieldsize = 1.2; % Rastersize in degrees
    ExpCfgParams.record = 1; %Toggle record video, 0 = off
    ExpCfgParams.videodur = 1; % Video recording time in seconds
    
    ExpCfgParams.gainclamp = 0; % gain = 1 only before and after stimulus presentation
    ExpCfgParams.gain = 0; % Gain for stabilization
    ExpCfgParams.angle = 0; % Angle for stabilization
    ExpCfgParams.off = 0; % 0 = no offset
    ExpCfgParams.Xoff = 0; % Xoffset
    ExpCfgParams.Yoff = 0; % Yoffset
    
    ExpCfgParams.method = 2; %2=const. stim size, 1=2d1u, 0=adjust
    ExpCfgParams.first = 5; % [Pixels] first offset
    ExpCfgParams.stepfactor = 1.25; % factor for next intensity (either * or /)
    ExpCfgParams.minstep = 0.1; % smallest stepsize
    ExpCfgParams.npresent = 30; % trials
    ExpCfgParams.fixedstimsize = 1; % 1 = stimuli are presented at fixed size, no intensity progression
    
    ExpCfgParams.presentdur = 500; % [ms] presentation duration
    ExpCfgParams.viewingdistance = 5000; % [mm]
    ExpCfgParams.pixelpitch = 0.27; % [mm]
    
    ExpCfgParams.simulation = 1; %Toggles conefield simulation
    ExpCfgParams.simecc = 1; % [deg] Cone field eccentricity
    ExpCfgParams.simregularity = 3; % [a.u.] Cone field regularity, 1: perfect hex
    ExpCfgParams.simaperture = 1.4; % [a.u.] Cone field regularity, 1: perfect hex
    ExpCfgParams.voronoi = 1; % Toggle Voronoi cone field simulation
    ExpCfgParams.repeatset = 0; % Re-use last stimulus set if checked
    ExpCfgParams.moveoptotype = 1; %movement of optotype or retina
    
    ExpCfgParams.dynamic = 0; %Toggles moving conefield
    ExpCfgParams.random = 1; %Toggles moving conefield
    ExpCfgParams.motiongain = 3; %random walk of cone motion increment per frame
    ExpCfgParams.motionmax = 5; % +- limits within motion allowed, otherwise return to 0,0
    ExpCfgParams.motionaveraging = 0; % controls spatial integration of light capture
    ExpCfgParams.realmotion = 1; % 1 = use AOSLO motion paths
    
%     ExpCfgParams.optoR = 1; % color channels for optotype, cones and background
%     ExpCfgParams.optoG = 1;  
%     ExpCfgParams.optoB = 1;  
%     ExpCfgParams.backR = 0;  
%     ExpCfgParams.backG = 0;  
%     ExpCfgParams.backB = 0;  
    ExpCfgParams.stiminvert = 1; % 0: show Black on white stimulus
    
    ExpCfgParams.kb_StimConst = 'space'; % Key for next stimulus (Space Bar)
    ExpCfgParams.kb_AbortConst = 'escape'; % Key to abort experiment
    ExpCfgParams.kb_Modifier = 'control'; % Key for modifier operations
    ExpCfgParams.kb_BadConst = 'uparrow'; % Key to repeat last trial
    ExpCfgParams.kb_Left = 'leftarrow'; % Key for left response
    ExpCfgParams.kb_Right = 'rightarrow'; % Key for right response
    ExpCfgParams.kb_LeftHi = 'leftarrow'; % Key for Left, Hi confidence
    ExpCfgParams.kb_LeftLo = 'f'; % Key for Left, Lo confidence
    ExpCfgParams.kb_RightLo = 'j'; % Key for Right, Lo confidence
    ExpCfgParams.kb_RightHi = 'rightarrow'; % Key for Right, Hi confidence
    ExpCfgParams.audiofeedback = 0; % Play sounds on correct or false
    
    ExpCfgParams.plotcomplex = 0; % 0 = Fit for psychometric functions
end


% Setting all config window parameters according to former values

set(handles.initials, 'String', ExpCfgParams.initials);
user_entry = get(handles.initials,'String');
if get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'String', user_entry)
elseif get(handles.auto_prefix, 'Value') == 0
    %do nothing
end
set(handles.fieldsize, 'String', ExpCfgParams.fieldsize);
set(handles.check_record,'Value',ExpCfgParams.record);
set(handles.videodur, 'String', ExpCfgParams.videodur);
if ExpCfgParams.record==1
    set(handles.videodur,'Enable','On');
    set(handles.viddurlabel,'Enable','On');
else
    set(handles.videodur,'Enable','Off');
    set(handles.viddurlabel,'Enable','Off');
end

set(handles.vidprefix, 'String', VideoParams.vidprefix);



set(handles.check_gainclamp, 'Value', ExpCfgParams.gainclamp);
set(handles.edit_gain,'String',ExpCfgParams.gain);
set(handles.edit_angle,'String',ExpCfgParams.angle);
set(handles.check_off,'Value',ExpCfgParams.off);
set(handles.edit_Xoff,'String',ExpCfgParams.Xoff);
set(handles.edit_Yoff,'String',ExpCfgParams.Yoff);

if get(handles.check_off,'Value')==1
    set (handles.edit_Xoff,'Enable','On')
    set (handles.edit_Yoff,'Enable','On')
else
    set (handles.edit_Xoff,'String','0')
    set (handles.edit_Yoff,'String','0')
    set (handles.edit_Xoff,'Enable','Off')
    set (handles.edit_Yoff,'Enable','Off')
end


if ExpCfgParams.method==0
    set(handles.radio_adjust, 'Value', 1);
elseif ExpCfgParams.method==1
    set(handles.radio_2d1u, 'Value', 1);
elseif ExpCfgParams.method==2
    set(handles.radio_constpsy, 'Value', 1);
end


if get(handles.radio_2d1u,'Value')==1
    set(handles.radio_adjust,'Value',0)
    set(handles.text_step,'String','Step Factor');
    set(handles.stepfactor,'String',ExpCfgParams.stepfactor);
    set(handles.edit_kb_LeftHi,'Visible','Off');
    set(handles.edit_kb_LeftLo,'Visible','Off');
    set(handles.edit_kb_RightHi,'Visible','Off');
    set(handles.edit_kb_RightLo,'Visible','Off');
    set(handles.text_Leftc,'Visible','Off');
    set(handles.text_Rightc,'Visible','Off');
    set(handles.kb_Left,'Visible','On');
    set(handles.kb_Right,'Visible','On');
    
elseif get(handles.radio_adjust,'Value')==1
    set(handles.radio_adjust,'Value',1)
    set(handles.text_step,'String','Initial step');
    set(handles.stepfactor,'String',2);
    set(handles.edit_kb_LeftHi,'Visible','On');
    set(handles.edit_kb_LeftLo,'Visible','On');
    set(handles.edit_kb_RightHi,'Visible','On');
    set(handles.edit_kb_RightLo,'Visible','On');
    set(handles.text_Leftc,'Visible','On');
    set(handles.text_Rightc,'Visible','On');
    set(handles.kb_Left,'Visible','Off');
    set(handles.kb_Right,'Visible','Off');
end

set(handles.edit_1st,'String',ExpCfgParams.first);
set(handles.stepfactor,'String',ExpCfgParams.stepfactor);
set(handles.edit_minStep,'String',ExpCfgParams.minstep);
set(handles.npresent, 'String', ExpCfgParams.npresent);
set(handles.radio_fixedstimsize,'Value',ExpCfgParams.fixedstimsize);

set(handles.presentdur, 'String', ExpCfgParams.presentdur);
set(handles.edit_viewingdistance, 'String', ExpCfgParams.viewingdistance);
set(handles.edit_pixelpitch, 'String', ExpCfgParams.pixelpitch);

set(handles.toggle_simulation,'Value', ExpCfgParams.simulation);
set(handles.edit_simecc,'String', ExpCfgParams.simecc); 
set(handles.edit_simregularity,'String', ExpCfgParams.simregularity); 
set(handles.edit_simaperture,'String', ExpCfgParams.simaperture); 
set(handles.toggle_dynamic,'Value', ExpCfgParams.dynamic);
set(handles.toggle_random,'Value', ExpCfgParams.random);
set(handles.edit_motiongain,'String', ExpCfgParams.motiongain);
set(handles.edit_motionmax,'String', ExpCfgParams.motionmax);
set(handles.edit_motionaveraging,'String', ExpCfgParams.motionaveraging);
set(handles.toggle_realmotion,'Value', ExpCfgParams.realmotion);
set(handles.check_voronoi,'Value', ExpCfgParams.voronoi);
set(handles.check_repeatset,'Value', 0);  %Hardcoded to always reset to zero

if ExpCfgParams.moveoptotype==1
    set(handles.radio_MoveRet,'Value',0)
    set(handles.radio_MoveOpto,'Value',1)
else
	set(handles.radio_MoveRet,'Value',1)
    set(handles.radio_MoveOpto,'Value',0)
end

if get(handles.toggle_simulation,'Value')
    set(handles.uipanel_simulation,'Visible','on');
else
    set(handles.uipanel_simulation,'Visible','off');
end

if get(handles.toggle_dynamic,'Value')
    set(handles.toggle_static,'Value',0);
    set(handles.toggle_random,'Value',0);
    set(handles.uipanel_dynamic,'Visible','on');
    set(handles.uipanel_line,'Visible','on');
elseif get(handles.toggle_random,'Value')
    set(handles.toggle_static,'Value',0);
    set(handles.toggle_dynamic,'Value',0);
    set(handles.uipanel_dynamic,'Visible','off');
    set(handles.uipanel_line,'Visible','off');
else
    set(handles.toggle_static,'Value',1);
    set(handles.uipanel_dynamic,'Visible','off');
    set(handles.uipanel_line,'Visible','off');
end

if get(handles.toggle_realmotion,'Value')
    set(handles.toggle_realmotion,'Value',1);
    set(handles.edit_motiongain,'Enable','off');
    set(handles.edit_motionmax,'Enable','off');
    set(handles.edit_motionaveraging,'Enable','off');
else
    set(handles.toggle_realmotion,'Value',0);
    set(handles.edit_motiongain,'Enable','on');
    set(handles.edit_motionmax,'Enable','on');
    set(handles.edit_motionaveraging,'Enable','on');
end

set(handles.axes_preview,'Visible','off')
set(handles.edit_previewOffset,'String',get(handles.edit_1st,'String'));
set(handles.slider1,'Value',str2num(get(handles.edit_1st,'String')));
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',10);
set(handles.slider1,'SliderStep',[1/9 10/9]);



% set(handles.edit_optoR,'String', ExpCfgParams.optoR);
% set(handles.edit_optoG,'String', ExpCfgParams.optoG);
% set(handles.edit_optoB,'String', ExpCfgParams.optoB);
% set(handles.edit_backR,'String', ExpCfgParams.backR);
% set(handles.edit_backG,'String', ExpCfgParams.backG);
% set(handles.edit_backB,'String', ExpCfgParams.backB);
set(handles.check_stiminvert,'Value', ExpCfgParams.stiminvert);

set(handles.kb_StimConst,'String',ExpCfgParams.kb_StimConst);
set(handles.kb_AbortConst,'String',ExpCfgParams.kb_AbortConst);
set(handles.kb_Modifier,'String',ExpCfgParams.kb_Modifier);
set(handles.kb_BadConst,'String',ExpCfgParams.kb_BadConst);
set(handles.kb_Left,'String',ExpCfgParams.kb_Left);
set(handles.kb_Right,'String',ExpCfgParams.kb_Right);
set(handles.edit_kb_LeftHi,'String',ExpCfgParams.kb_LeftHi);
set(handles.edit_kb_LeftLo,'String',ExpCfgParams.kb_LeftLo);
set(handles.edit_kb_RightHi,'String',ExpCfgParams.kb_RightHi);
set(handles.edit_kb_RightLo,'String',ExpCfgParams.kb_RightLo);
set(handles.check_audiofeedback,'Value',ExpCfgParams.audiofeedback);

set(handles.check_plot,'Value',ExpCfgParams.plotcomplex);
set(handles.ok_button, 'Enable', 'on');


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global SYSPARAMS StimParams VideoParams ExpCfgParams;

hAomControl = getappdata(0,'hAomControl');
% stimpath = getappdata(hAomControl, 'stimpath');
stimpath = [pwd,'\tempStimulus\'];
setappdata(hAomControl, 'stimpath', stimpath);

CFG.ok = 1;
CFG.initials = get(handles.initials, 'String');
CFG.fieldsize = str2num(get(handles.fieldsize, 'String')); %#ok<*ST2NM>
CFG.record = get(handles.check_record,'Value');
CFG.videodur = str2num(get(handles.videodur, 'String'));
CFG.vidprefix = get(handles.vidprefix, 'String');

CFG.gainclamp = get(handles.check_gainclamp, 'Value');
if get(handles.check_gainclamp,'Value')==1
    CFG.gain = 1;
else
    CFG.gain = str2num(get(handles.edit_gain, 'String'));
end
CFG.angle = str2num(get(handles.edit_angle, 'String'));
CFG.off=get(handles.check_off,'Value');
CFG.Xoff=str2num(get(handles.edit_Xoff,'String'));
CFG.Yoff=str2num(get(handles.edit_Yoff,'String'));


if get(handles.radio_2d1u, 'Value') == 1;
    CFG.method = '2d1u';
elseif get(handles.radio_adjust, 'Value') == 1;
    CFG.method = 'adjust';
elseif get(handles.radio_constpsy, 'Value') == 1;
    CFG.method = 'ConstPsy';
else
    CFG.method = [];
end
CFG.first = str2num(get(handles.edit_1st, 'String'));
CFG.stepfactor = str2num(get(handles.stepfactor, 'String'));
CFG.minstep = str2num(get(handles.edit_minStep,'String'));
CFG.npresent = str2num(get(handles.npresent, 'String'));
CFG.fixedstimsize = get(handles.radio_fixedstimsize,'Value');

CFG.presentdur = str2num(get(handles.presentdur, 'String'));
CFG.viewingdistance = str2num(get(handles.edit_viewingdistance,'String'));
CFG.pixelpitch = str2num(get(handles.edit_pixelpitch,'String'));

CFG.simulation = get(handles.toggle_simulation,'Value');
CFG.simecc = str2num(get(handles.edit_simecc,'String'));
CFG.simregularity = str2num(get(handles.edit_simregularity,'String'));
CFG.simaperture = str2num(get(handles.edit_simaperture,'String'));
CFG.dynamic = get(handles.toggle_dynamic,'Value');
CFG.random = get(handles.toggle_random,'Value');
CFG.motiongain = str2num(get(handles.edit_motiongain,'String'));
CFG.motionmax = str2num(get(handles.edit_motionmax,'String'));
CFG.motionaveraging = str2num(get(handles.edit_motionaveraging,'String'));
CFG.realmotion = get(handles.toggle_realmotion,'Value');
CFG.voronoi = get(handles.check_voronoi,'Value');
CFG.repeatset = get(handles.check_repeatset,'Value');
CFG.moveoptotype = get(handles.radio_MoveOpto,'Value');

% CFG.optoR = str2num(get(handles.edit_optoR,'String'));
% CFG.optoG = str2num(get(handles.edit_optoG,'String'));
% CFG.optoB = str2num(get(handles.edit_optoB,'String'));
% CFG.backR = str2num(get(handles.edit_backR,'String'));
% CFG.backG = str2num(get(handles.edit_backG,'String'));
% CFG.backB = str2num(get(handles.edit_backB,'String'));
CFG.stiminvert = get(handles.check_stiminvert,'Value');

CFG.kb_StimConst = get(handles.kb_StimConst, 'String');
CFG.kb_AbortConst = get(handles.kb_AbortConst, 'String');
CFG.kb_Modifier = get(handles.kb_Modifier,'String');
CFG.kb_BadConst = get(handles.kb_BadConst, 'String');
CFG.kb_Left = get(handles.kb_Left, 'String');
CFG.kb_Right = get(handles.kb_Right, 'String');
CFG.kb_LeftHi = get(handles.edit_kb_LeftHi, 'String');
CFG.kb_LeftLo = get(handles.edit_kb_LeftLo, 'String');
CFG.kb_RightHi = get(handles.edit_kb_RightHi, 'String');
CFG.kb_RightLo = get(handles.edit_kb_RightLo, 'String');
CFG.audiofeedback = get(handles.check_audiofeedback, 'Value');

CFG.plotcomplex = get(handles.check_plot, 'Value');
CFG.stimpath = [pwd,'\tempStimulus\'];

setappdata(hAomControl, 'CFG', CFG);

% store last values in Config dialog for next time
StimParams.stimpath = CFG.stimpath;
VideoParams.vidprefix = CFG.vidprefix;

ExpCfgParams.initials = CFG.initials;
ExpCfgParams.record = CFG.record;
ExpCfgParams.videodur = CFG.videodur;
ExpCfgParams.fieldsize = CFG.fieldsize;
ExpCfgParams.off = CFG.off;
ExpCfgParams.Xoff = CFG.Xoff;
ExpCfgParams.Yoff = CFG.Yoff;
ExpCfgParams.presentdur = CFG.presentdur;
ExpCfgParams.viewingdistance = CFG.viewingdistance;
ExpCfgParams.pixelpitch = CFG.pixelpitch;
ExpCfgParams.simulation = CFG.simulation;
ExpCfgParams.simecc = CFG.simecc;
ExpCfgParams.simregularity = CFG.simregularity;
ExpCfgParams.simaperture = CFG.simaperture;
ExpCfgParams.dynamic = CFG.dynamic;
ExpCfgParams.random = CFG.random;
ExpCfgParams.motiongain = CFG.motiongain;
ExpCfgParams.motionmax = CFG.motionmax;
ExpCfgParams.motionaveraging = CFG.motionaveraging;
ExpCfgParams.realmotion = CFG.realmotion;
ExpCfgParams.voronoi = CFG.voronoi;
ExpCfgParams.repeatset = CFG.repeatset;
ExpCfgParams.moveoptotype = CFG.moveoptotype;
ExpCfgParams.npresent = CFG.npresent;
ExpCfgParams.stepfactor = CFG.stepfactor;
ExpCfgParams.first = CFG.first;
ExpCfgParams.minstep = CFG.minstep;
ExpCfgParams.plotcomplex = CFG.plotcomplex;
ExpCfgParams.gain = CFG.gain;
ExpCfgParams.angle = CFG.angle;
ExpCfgParams.kb_StimConst = CFG.kb_StimConst;
ExpCfgParams.kb_AbortConst = CFG.kb_AbortConst;
ExpCfgParams.kb_Modifier = CFG.kb_Modifier;
ExpCfgParams.kb_BadConst = CFG.kb_BadConst;
ExpCfgParams.kb_Left = CFG.kb_Left;
ExpCfgParams.kb_Right = CFG.kb_Right;
ExpCfgParams.kb_LeftHi = CFG.kb_LeftHi;
ExpCfgParams.kb_LeftLo = CFG.kb_LeftLo;
ExpCfgParams.kb_RightLo = CFG.kb_RightLo;
ExpCfgParams.kb_RightHi = CFG.kb_RightHi;
ExpCfgParams.audiofeedback  = CFG.audiofeedback;
ExpCfgParams.gainclamp = CFG.gainclamp;
ExpCfgParams.fixedstimsize = CFG.fixedstimsize;
% ExpCfgParams.optoR = CFG.optoR;
% ExpCfgParams.optoG = CFG.optoG;
% ExpCfgParams.optoB = CFG.optoB;
% ExpCfgParams.backR = CFG.backR;
% ExpCfgParams.backG = CFG.backG;
% ExpCfgParams.backB = CFG.backB;
ExpCfgParams.stiminvert = CFG.stiminvert;


if strcmp(CFG.method,'ConstPsy')
    ExpCfgParams.method = 2;
elseif strcmp(CFG.method,'2d1u'); 
    ExpCfgParams.method = 1;
else
    ExpCfgParams.method = 0;
end

%save('lastConeSimulationCFG.mat', 'SYSPARAMS', 'StimParams', 'VideoParams', 'ExpCfgParams','CFG')
save('lastConeSimulationCFG.mat', 'ExpCfgParams','CFG')

close;


function drawPreview (handles)

% Axes geometry determining figure size
previewPosition = get(gca,'Position');
previewHeight = previewPosition(4);
previewWidth = previewPosition(3);

gap = floor(str2num(get(handles.edit_previewOffset,'String')));

% % make E
e=zeros(gap*5,gap*5);
e(gap+1:2*gap,gap+1:end)=1;
e(3*gap+1:4*gap,gap+1:end)=1;
E=imrotate(e,90*floor(rand*4));
PreviewBuffer=ones(previewHeight,previewWidth);
ylo = floor(previewHeight/2)-floor(gap*5/2);
yhi = ylo-1+gap*5;
xlo = floor(previewWidth/2)-floor(gap*5/2);
xhi = xlo-1+gap*5;
PreviewBuffer(ylo:yhi,xlo:xhi)=E;


if get(handles.check_stiminvert,'Value')
    PreviewBuffer=PreviewBuffer.*(-1)+1;
end


% CONE SIMULATION  -----------------
if get(handles.toggle_simulation,'Value')
    
    width = previewWidth;
    height = previewHeight;
    eccentricity = str2num(get(handles.edit_simecc,'String')); % get ecc from input  
    jitter = str2num(get(handles.edit_simregularity,'String')); % get regularity parameter from input (0 = perfect hex)
    apert_fit = str2num(get(handles.edit_simaperture,'String'));
    
    a1 = 1.6570; s1 = -0.0222; a2 = -1.0490; s2 = 0.4358; % Best Fit Roorda lab data basis, May 2013
    spacing = a1*exp(-s1.*eccentricity)+a2*exp(-s2.*eccentricity);% in arcmin
    spacing = floor((400/60)*spacing);     % in pixel
    
    border = 10;
    nconesi = length(1+border:spacing:height-border);
    nconesj = length(1+border:spacing:width-border);
    ncones = nconesi*nconesj;
    
    randjitter = rand(ncones,2);
    randjitter = floor(jitter/2-randjitter*jitter);
    
    n = 0;
    indexcount = 1;
    
    for i=1+border:spacing:height-border
        for j=1+border:spacing:width-border
            if mod(n,2)==0
                xc(indexcount,:)=(j+randjitter(indexcount,2)+floor(spacing/2));
                yc(indexcount,:)=(i+randjitter(indexcount,1));
            else
                xc(indexcount,:)=(j+randjitter(indexcount,2));
                yc(indexcount,:)=(i+randjitter(indexcount,1));
            end;
            indexcount = indexcount + 1;
        end;
        n=n+1;
    end;
    xc = xc-floor(previewWidth/2); % Position around origin before rotation
    yc = yc-floor(previewHeight/2);
    
    % Rotation about random angle [-30:1:30]
    rotationangle = floor(-30+rand(1)*60);
    nSize = size(xc);
    theta = rotationangle * pi/180;
    mRot = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    vRot = [xc(:) yc(:)]*mRot;
    xcr = reshape(vRot(:,1), nSize);
    ycr = reshape(vRot(:,2), nSize);
    
    xcr = floor(xcr+(previewWidth/2)); % Reposition and cropping
    ycr = floor(ycr+(previewHeight/2));
    cones = [ycr xcr];
    cones(logical((ycr<=0+border)+(xcr<=0+border)+(ycr>=previewHeight-border)+(xcr>=previewWidth-border)),:)=[];
    
    yi = cones(:,1);
    xi = cones(:,2);
    
	spotSize=2*spacing;
    Aperture = 3.1243/2.35482;       % in pixel --- computed by "get_fwhm_curcio.m": ecc = 1°, scaling = 400
    Aperture = apert_fit*Aperture;
    spot = single(fspecial('gaussian', spotSize, Aperture)); %generate Gaussian (SpotSize=ConeSize pixels wide)
    spot = spot./max(spot(:)); %normalize Gaussian
    

% % set some more Vars
	Factor=floor(size(spot,1)/2);
 	InnerSegment=round(Aperture/0.48);
	[Cols,Rows] = meshgrid(1:previewWidth, 1:previewHeight);
	[ColsS,RowsS] = meshgrid(1:spotSize, 1:spotSize);
	AllMat=(ColsS-(spotSize/2)).^2+(RowsS-(spotSize/2)).^2 <= InnerSegment.^2;
	AllC = sum(sum(AllMat.*spot));

    PreviewBuffer1=zeros(previewHeight,previewWidth);
    
% % Shifting around
    deltac = 2-4*rand;  % Shift in X (negative because of shift algorithm)
    deltar = 2-4*rand;  % Shift in Y
    f=im2double(PreviewBuffer);
    phase = 2; [nr,nc]=size(f);
    Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
    Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
    [Nc,Nr] = meshgrid(Nc,Nr);
    g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
    Hallo_E=abs(g);

    patchintensity = zeros(length(xi),1);
    
    for cone = 1:size(xi,1)
        if rem(length(spot),2)~=0; %odd spotsize
            ConeMat=(Cols-cones(cone,2)).^2+(Rows-cones(cone,1)).^2 <= InnerSegment.^2;

            if sum(sum(ConeMat.*Hallo_E))>=1;

                PreviewBuffer1(yi(cone)-Factor:yi(cone)+Factor,...
                (xi(cone))-(Factor):(xi(cone))+Factor-1,2) = spot;    %UseSpot

                ActCone = PreviewBuffer1(:,:,2).*ConeMat;
                EtoCone = ActCone.*Hallo_E;    % ones(150,150);       
                EVal = sum(EtoCone(:));

                CorrVal = EVal/AllC;

                PreviewBuffer1(:,:,2)=PreviewBuffer1(:,:,2).*CorrVal;
                PreviewBuffer1=sum(PreviewBuffer1,3);
                
                % EDIT to have intensity vector for voronoi
                if CorrVal > 1
                    CorrVal = 1;
                end
                patchintensity(cone,1) = CorrVal;
                
            end

        else
            ConeMat=(Cols-cones(cone,2)).^2+(Rows-cones(cone,1)).^2 <= InnerSegment.^2;

            if sum(sum(ConeMat.*Hallo_E))>=1;

                PreviewBuffer1(yi(cone)-Factor:yi(cone)+Factor-1,...
                (xi(cone))-(Factor):(xi(cone))+Factor-1,2) = spot;   %UseSpot

                ActCone = PreviewBuffer1(:,:,2).*ConeMat;
                EtoCone = ActCone.*Hallo_E;    % ones(150,150); 
                EVal = sum(EtoCone(:));

                CorrVal = EVal/AllC;

                PreviewBuffer1(:,:,2)=PreviewBuffer1(:,:,2).*CorrVal;
                PreviewBuffer1=sum(PreviewBuffer1,3);
                
                % EDIT to have intensity vector for voronoi
                if CorrVal > 1
                    CorrVal = 1;
                end
                patchintensity(cone,1) = CorrVal;
                
            end
        end
    end
    
    % Mulitplication and normalization of Stimulus with Conefield
    % PreviewBuffer(:,:,1) = PreviewBuffer(:,:,1).*conefield;
    % PreviewBuffer(:,:,2) = PreviewBuffer(:,:,2).*conefield;
    % PreviewBuffer(:,:,3) = PreviewBuffer(:,:,3).*conefield;
    % PreviewBuffer(:,:,1) = PreviewBuffer(:,:,1)./max(max((PreviewBuffer(:,:,1))));
    % PreviewBuffer(:,:,2) = PreviewBuffer(:,:,2)./max(max((PreviewBuffer(:,:,2))));
    % PreviewBuffer(:,:,3) = PreviewBuffer(:,:,3)./max(max((PreviewBuffer(:,:,3))));
    
    % PreviewBuffer(:,:,1) = PreviewBuffer1(:,:,1)./max(PreviewBuffer1(:));
    PreviewBuffer(:,:,1) = PreviewBuffer1(:,:,1);
    PreviewBuffer(PreviewBuffer>=1) = 1;

    
    %-------------------- EDIT: add Voronoi display option
    if get(handles.check_voronoi,'Value')
        width = previewWidth; height = previewHeight;
        if get(handles.check_stiminvert,'Value')
            VI = zeros(height,width); % Target image, empty for now
        else
            VI = ones(height,width); % Target image, empty for now
        end
        [VIx,VIy] = meshgrid(1:width,1:height);  % Prepare image coordinates
        
        X = [xi yi];
        dt = DelaunayTri(xi,yi);
        [V,C] = voronoiDiagram(dt);
        [dump,G] = voronoin(X);
        
        for j = 1:length(C)
            if ~sum((V(C{j},1))>=min([width height]))>0 && ~sum((V(C{j},1))<0)>0 % Exclude border cones with too far spread vertices
                in = inpolygon(VIx,VIy,V(C{j},1),V(C{j},2)); % Find matrix index inside single polygons
                VI(in) = patchintensity(j); % Fill image matrix with activation intensity
            end
        end
        PreviewBuffer = VI;
    end
    %-------------------- END: add Voronoi display option
    
    
    
end
% -----------------





imshow(PreviewBuffer,'InitialMagnification',100)


disp('drawn');





function initials_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to initials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initials as text
%        str2double(get(hObject,'String')) returns contents of initials as a double
user_entry = get(hObject,'string');
if get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'String', user_entry)
elseif get(handles.auto_prefix, 'Value') == 0
    %do nothing
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function initials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pupilsize_Callback(hObject, eventdata, handles)
% hObject    handle to pupilsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pupilsize as text
%        str2double(get(hObject,'String')) returns contents of pupilsize as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


% --- Executes during object creation, after setting all properties.
function pupilsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pupilsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fieldsize_Callback(hObject, eventdata, handles)
% hObject    handle to fieldsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldsize as text
%        str2double(get(hObject,'String')) returns contents of fieldsize as a double

drawPreview (handles);
fieldsize=str2num(get(handles.fieldsize,'String'));
set(handles.text_actualbarheight,'String',num2str((60*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'));
set(handles.text_actualdotsize,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'));
set(handles.text_actualdotseparation,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'));
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


% --- Executes during object creation, after setting all properties.
function fieldsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function videodur_Callback(hObject, eventdata, handles)
% hObject    handle to videodur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of videodur as text
%        str2double(get(hObject,'String')) returns contents of videodur as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function videodur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to videodur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vidprefix_Callback(hObject, eventdata, handles)
% hObject    handle to vidprefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vidprefix as text
%        str2double(get(hObject,'String')) returns contents of vidprefix as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function vidprefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vidprefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in auto_prefix.
function auto_prefix_Callback(hObject, eventdata, handles)
% hObject    handle to auto_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of auto_prefix
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


function presentdur_Callback(hObject, eventdata, handles)
% hObject    handle to presentdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of presentdur as text
%        str2double(get(hObject,'String')) returns contents of presentdur as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function presentdur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_StimConst_Callback(hObject, eventdata, handles)
% hObject    handle to kb_StimConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_StimConst as text
%        str2double(get(hObject,'String')) returns contents of kb_StimConst as a double


set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_StimConst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_StimConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_BadConst_Callback(hObject, eventdata, handles)
% hObject    handle to kb_BadConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_BadConst as text
%        str2double(get(hObject,'String')) returns contents of kb_BadConst as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_BadConst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_BadConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_DownArrow_Callback(hObject, eventdata, handles)
% hObject    handle to kb_DownArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_DownArrow as text
%        str2double(get(hObject,'String')) returns contents of kb_DownArrow as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_DownArrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_DownArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_Left_Callback(hObject, eventdata, handles)
% hObject    handle to kb_Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_Left as text
%        str2double(get(hObject,'String')) returns contents of kb_Left as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_Left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_Right_Callback(hObject, eventdata, handles)
% hObject    handle to kb_Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_Right as text
%        str2double(get(hObject,'String')) returns contents of kb_Right as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_Right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function npresent_Callback(hObject, eventdata, handles)
% hObject    handle to npresent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of npresent as text
%        str2double(get(hObject,'String')) returns contents of npresent as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function npresent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npresent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function pCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to pCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pCorrect as text
%        str2double(get(hObject,'String')) returns contents of pCorrect as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function pCorrect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gain_Callback(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain as text
%        str2double(get(hObject,'String')) returns contents of gain as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_Callback(hObject, eventdata, handles)
% hObject    handle to angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle as text
%        str2double(get(hObject,'String')) returns contents of angle as a double

set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in radio_2d1u.
function radio_2d1u_Callback(hObject, eventdata, handles)
% hObject    handle to check_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_plot

if get(hObject,'Value')==1
    set(handles.radio_adjust,'Value',0)
    set(handles.radio_fixedstimsize,'Value',0)
    set(handles.radio_constpsy,'Value',0)
    
    set(handles.text_step,'String','Step size');
    set(handles.stepfactor,'String',1);
    
    
    
    set(handles.kb_Left,'Visible','On');
    set(handles.kb_Right,'Visible','On');
    
    
    set(handles.edit_kb_LeftHi,'Visible','Off');
    set(handles.edit_kb_LeftLo,'Visible','Off');
    set(handles.edit_kb_RightHi,'Visible','Off');
    set(handles.edit_kb_RightLo,'Visible','Off');
    set(handles.text_Leftc,'Visible','Off');
    set(handles.text_Rightc,'Visible','Off');
    
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes on button press in radio_adjust.
function radio_adjust_Callback(hObject, eventdata, handles)
% hObject    handle to check_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_plot
if get(hObject,'Value')==1
    set(handles.radio_2d1u,'Value',0)
    set(handles.radio_fixedstimsize,'Value',0)
    set(handles.radio_constpsy,'Value',0)
    
    set(handles.text_step,'String','Initial step');
    set(handles.stepfactor,'String',2);
    
    
    set(handles.kb_Left,'Visible','Off');
    set(handles.kb_Right,'Visible','Off');
    
    
    
    set(handles.edit_kb_LeftHi,'Visible','On');
    set(handles.edit_kb_LeftLo,'Visible','On');
    set(handles.edit_kb_RightHi,'Visible','On');
    set(handles.edit_kb_RightLo,'Visible','On');
    set(handles.text_Leftc,'Visible','On');
    set(handles.text_Rightc,'Visible','On');
    
    
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes on button press in radio_fixedstimsize.
function radio_fixedstimsize_Callback(hObject, eventdata, handles)
% hObject    handle to radio_fixedstimsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_fixedstimsize
if get(hObject,'Value')==1
    set(handles.radio_2d1u,'Value',0)
    set(handles.radio_adjust,'Value',0)
    set(handles.radio_constpsy,'Value',0)
end

set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes on button press in radio_constpsy.
function radio_constpsy_Callback(hObject, eventdata, handles)
% hObject    handle to radio_constpsy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_constpsy
if get(hObject,'Value')==1
    set(handles.radio_2d1u,'Value',0)
    set(handles.radio_adjust,'Value',0)
    set(handles.radio_fixedstimsize,'Value',0)
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


function stepfactor_Callback(hObject, eventdata, handles)
% hObject    handle to stepfactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepfactor as text
%        str2double(get(hObject,'String')) returns contents of stepfactor as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function stepfactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepfactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_1st_Callback(hObject, eventdata, handles)
% hObject    handle to edit_1st (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_1st as text
%        str2double(get(hObject,'String')) returns contents of edit_1st as a double

set(handles.edit_previewOffset,'String',str2num(get(hObject,'String')))
set(handles.slider1,'Value',str2num(get(hObject,'String')))
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles);

% --- Executes during object creation, after setting all properties.
function edit_1st_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_1st (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minStep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minStep as text
%        str2double(get(hObject,'String')) returns contents of edit_minStep as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_minStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


set(handles.edit_previewOffset,'String',round(get(hObject,'Value')));


drawPreview(handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_previewOffset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_previewOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_previewOffset as text
%        str2double(get(hObject,'String')) returns contents of edit_previewOffset as a double

set(handles.edit_previewOffset,'String',floor(str2num(get(handles.edit_previewOffset,'String'))));
set(handles.slider1,'Value',str2num(get(hObject,'String')))

drawPreview(handles);



% --- Executes during object creation, after setting all properties.
function edit_previewOffset_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to edit_previewOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes_preview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_preview




function edit_gain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gain as text
%        str2double(get(hObject,'String')) returns contents of edit_gain as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_angle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_angle as text
%        str2double(get(hObject,'String')) returns contents of edit_angle as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_kb_LeftHi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_LeftHi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_LeftHi as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_LeftHi as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_kb_LeftHi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_LeftHi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_LeftLo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_LeftLo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_LeftLo as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_LeftLo as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_kb_LeftLo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_LeftLo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_RightLo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_RightLo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_RightLo as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_RightLo as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_kb_RightLo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_RightLo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_RightHi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_RightHi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_RightHi as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_RightHi as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_kb_RightHi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_RightHi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Yoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Yoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Yoff as text
%        str2double(get(hObject,'String')) returns contents of edit_Yoff as a double
handles.lastX= get(handles.edit_Xoff,'String');
handles.lastY= get(handles.edit_Yoff,'String');
guidata(hObject, handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_Yoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Yoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Xoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Xoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Xoff as text
%        str2double(get(hObject,'String')) returns contents of edit_Xoff as a double
handles.lastX= get(handles.edit_Xoff,'String');
handles.lastY= get(handles.edit_Yoff,'String');
guidata(hObject, handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_Xoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Xoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in check_off.
function check_off_Callback(hObject, eventdata, handles)
% hObject    handle to check_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_off

if get(hObject,'Value')==0
    
    set (handles.edit_Xoff,'String','0')
    set (handles.edit_Yoff,'String','0')
    set (handles.edit_Xoff,'Enable','Off')
    set (handles.edit_Yoff,'Enable','Off')
else
    
    set (handles.edit_Xoff,'Enable','On')
    set (handles.edit_Yoff,'Enable','On')
    set (handles.edit_Xoff,'String',handles.lastX)
    set (handles.edit_Yoff,'String',handles.lastY)
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')



% --- Executes on button press in check_plot.
function check_plot_Callback(hObject, eventdata, handles)
% hObject    handle to check_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_plot
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


% --- Executes on button press in check_gainclamp.
function check_gainclamp_Callback(hObject, eventdata, handles)
% hObject    handle to check_gainclamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_gainclamp
gray= get(0,'defaultUicontrolBackgroundColor');

if get(hObject,'Value')==1
    set(handles.edit_gain,'String','1..0..1')
    set(handles.edit_gain,'FontSize',7)
    set(handles.edit_gain,'FontWeight','bold')
    set(handles.edit_gain,'BackgroundColor', gray);
else
    set(handles.edit_gain,'String',0)
    set(handles.edit_gain,'FontSize',8)
    set(handles.edit_gain,'FontWeight','normal')
    set(handles.edit_gain,'BackgroundColor','white');
    
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


function kb_AbortConst_Callback(hObject, eventdata, handles)
% hObject    handle to kb_AbortConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_AbortConst as text
%        str2double(get(hObject,'String')) returns contents of kb_AbortConst as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_AbortConst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_AbortConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_Modifier_Callback(hObject, eventdata, handles)
% hObject    handle to kb_Modifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_Modifier as text
%        str2double(get(hObject,'String')) returns contents of kb_Modifier as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function kb_Modifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_Modifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in check_record.
function check_record_Callback(hObject, eventdata, handles)
% hObject    handle to check_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_record
if get(hObject,'Value')==1
    set(handles.videodur,'Enable','On');
    set(handles.viddurlabel,'Enable','On');
else
    set(handles.videodur,'Enable','Off');
    set(handles.viddurlabel,'Enable','Off');
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');





% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% k=eventdata.Key;
% disp(k);

if strcmp(eventdata.Modifier,'control')
    if strcmp(eventdata.Key,'s')
        display('You just pressed Control+s')
    end
end




function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit_orientAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_orientAngle as text
%        str2double(get(hObject,'String')) returns contents of edit_orientAngle as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_orientAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_simecc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_simecc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simecc as text
%        str2double(get(hObject,'String')) returns contents of edit_simecc as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_simecc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simecc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



% --- Executes on button press in push_last.
function push_last_Callback(hObject, eventdata, handles)
% hObject    handle to push_last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global SYSPARAMS StimParams VideoParams ExpCfgParams
%
if exist('lastConeSimulationCFG.mat','file')==2
    loadLastValues(handles,1)
else
    display('No default found')
end

set(hObject,'Enable','Off')
set(handles.push_default,'Enable','On');
drawPreview(handles);



% --- Executes on button press in push_default.
function push_default_Callback(hObject, eventdata, handles)
% hObject    handle to push_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadLastValues(handles,0)

set(hObject,'Enable','Off')
set(handles.push_last,'Enable','On');
drawPreview(handles);



% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
CFG.ok = 0;
setappdata(hAomControl, 'CFG', CFG);
close;




function edit_viewingdistance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_viewingdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_viewingdistance as text
%        str2double(get(hObject,'String')) returns contents of edit_viewingdistance as a double
pixelpitch = str2num(get(handles.edit_pixelpitch,'String'));
viewingdistance = str2num(get(handles.edit_viewingdistance,'String'));

set(handles.text_pixelangle,'String',num2str(3600*atand(pixelpitch/viewingdistance),'%2.2f'));


% --- Executes during object creation, after setting all properties.
function edit_viewingdistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_viewingdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixelpitch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixelpitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixelpitch as text
%        str2double(get(hObject,'String')) returns contents of edit_pixelpitch as a double

pixelpitch = str2num(get(handles.edit_pixelpitch,'String'));
viewingdistance = str2num(get(handles.edit_viewingdistance,'String'));

set(handles.text_pixelangle,'String',num2str(3600*atand(pixelpitch/viewingdistance),'%2.2f'));


% --- Executes during object creation, after setting all properties.
function edit_pixelpitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixelpitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in toggle_simulation.
function toggle_simulation_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_simulation

if get(hObject,'Value')
    set(handles.uipanel_simulation,'Visible','on');
else
    set(handles.uipanel_simulation,'Visible','off');
end

    drawPreview(handles)



% --- Executes on button press in toggle_static.
function toggle_static_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_static (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_static
if get(hObject,'Value')
    set(handles.toggle_dynamic,'Value',0);
    set(handles.toggle_random,'Value',0);
    set(handles.uipanel_dynamic,'Visible','off');
    set(handles.uipanel_line,'Visible','off');
else
    set(handles.toggle_dynamic,'Value',1);
    set(handles.uipanel_dynamic,'Visible','on');
    set(handles.uipanel_line,'Visible','on');
end

% --- Executes on button press in toggle_dynamic.
function toggle_dynamic_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_dynamic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_dynamic
if get(hObject,'Value')
    set(handles.toggle_static,'Value',0);
    set(handles.toggle_random,'Value',0);
    set(handles.uipanel_dynamic,'Visible','on');
    set(handles.uipanel_line,'Visible','on');
else
    set(handles.toggle_static,'Value',1);
    set(handles.uipanel_dynamic,'Visible','off');
    set(handles.uipanel_line,'Visible','off');
end

% --- Executes on button press in toggle_random.
function toggle_random_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_random
if get(hObject,'Value')
    set(handles.toggle_dynamic,'Value',0);
    set(handles.toggle_static,'Value',0);
    set(handles.uipanel_dynamic,'Visible','off');
    set(handles.uipanel_line,'Visible','off');
else
    set(handles.toggle_static,'Value',1);
    set(handles.uipanel_dynamic,'Visible','off');
    set(handles.uipanel_line,'Visible','off');
end


% --- Executes on button press in toggle_model.
function toggle_model_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_model
if get(hObject,'Value')
    set(handles.toggle_actual,'Value',0);
    set(handles.push_loadretina,'Visible','off');
    set(handles.edit_simecc,'Enable','on');
    set(handles.edit_simregularity,'Enable','on');
else
    set(handles.toggle_actual,'Value',1);
    set(handles.push_loadretina,'Visible','on');
    set(handles.edit_simecc,'Enable','off');
    set(handles.edit_simregularity,'Enable','off');
end
drawPreview(handles)

% --- Executes on button press in toggle_actual.
function toggle_actual_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_actual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_actual
if get(hObject,'Value')
    set(handles.toggle_model,'Value',0);
    set(handles.push_loadretina,'Visible','on');
    set(handles.edit_simecc,'Enable','off');
    set(handles.edit_simregularity,'Enable','off');
else
    set(handles.toggle_model,'Value',1);
    set(handles.push_loadretina,'Visible','off');
    set(handles.edit_simecc,'Enable','on');
    set(handles.edit_simregularity,'Enable','on');
end



function edit_simregularity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_simregularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simregularity as text
%        str2double(get(hObject,'String')) returns contents of edit_simregularity as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_simregularity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simregularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_loadretina.
function push_loadretina_Callback(hObject, eventdata, handles)
% hObject    handle to push_loadretina (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_optoR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_optoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_optoR as text
%        str2double(get(hObject,'String')) returns contents of edit_optoR as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_optoR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_optoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_optoG_Callback(hObject, eventdata, handles)
% hObject    handle to edit_optoG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_optoG as text
%        str2double(get(hObject,'String')) returns contents of edit_optoG as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_optoG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_optoG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_optoB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_optoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_optoB as text
%        str2double(get(hObject,'String')) returns contents of edit_optoB as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_optoB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_optoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_backR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_backR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_backR as text
%        str2double(get(hObject,'String')) returns contents of edit_backR as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_backR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_backR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_backG_Callback(hObject, eventdata, handles)
% hObject    handle to edit_backG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_backG as text
%        str2double(get(hObject,'String')) returns contents of edit_backG as a double
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_backG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_backG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_backB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_backB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_backB as text
%        str2double(get(hObject,'String')) returns contents of edit_backB as a double
drawPreview(handles)

% --- Executes during object creation, after setting all properties.
function edit_backB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_backB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_motiongain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_motiongain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_motiongain as text
%        str2double(get(hObject,'String')) returns contents of edit_motiongain as a double


% --- Executes during object creation, after setting all properties.
function edit_motiongain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_motiongain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_motionmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_motionmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_motionmax as text
%        str2double(get(hObject,'String')) returns contents of edit_motionmax as a double


% --- Executes during object creation, after setting all properties.
function edit_motionmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_motionmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_motionaveraging_Callback(hObject, eventdata, handles)
% hObject    handle to edit_motionaveraging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_motionaveraging as text
%        str2double(get(hObject,'String')) returns contents of edit_motionaveraging as a double


% --- Executes during object creation, after setting all properties.
function edit_motionaveraging_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_motionaveraging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_simaperture_Callback(hObject, eventdata, handles)
% hObject    handle to edit_simaperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simaperture as text
%        str2double(get(hObject,'String')) returns contents of edit_simaperture as a double
drawPreview(handles)

% --- Executes during object creation, after setting all properties.
function edit_simaperture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simaperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in toggle_realmotion.
function toggle_realmotion_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_realmotion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_realmotion
if get(hObject,'Value')
    set(handles.edit_motiongain,'Enable','off');
    set(handles.edit_motionmax,'Enable','off');
    set(handles.edit_motionaveraging,'Enable','off');
else
    set(handles.edit_motiongain,'Enable','on');
    set(handles.edit_motionmax,'Enable','on');
    set(handles.edit_motionaveraging,'Enable','on');
end


% --- Executes on button press in check_audiofeedback.
function check_audiofeedback_Callback(hObject, eventdata, handles)
% hObject    handle to check_audiofeedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_audiofeedback
try
    if  exist('AnswerCorrect.wav','file')
        [AnsCor,AnsCor_SR]=wavread('AnswerCorrect.wav');
        sound(AnsCor,AnsCor_SR)
    end
end


% --- Executes on button press in check_stiminvert.
function check_stiminvert_Callback(hObject, eventdata, handles)
% hObject    handle to check_stiminvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_stiminvert
drawPreview(handles)


% --- Executes on button press in check_voronoi.
function check_voronoi_Callback(hObject, eventdata, handles)
% hObject    handle to check_voronoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_voronoi
drawPreview(handles)


function cdata = zbuffer_cdata(hfig)

% % Get CDATA from hardcopy using zbuffer
% % Need to have PaperPositionMode be auto 

% orig_mode = get(hfig, 'PaperPositionMode');
% set(hfig, 'PaperPositionMode', 'auto');

cdata = hardcopy(hfig, '-Dzbuffer', '-r0');

% % Restore figure to original state
% set(hfig, 'PaperPositionMode', orig_mode); % end



% --- Executes on button press in check_repeatset.
function check_repeatset_Callback(hObject, eventdata, handles)
% hObject    handle to check_repeatset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_repeatset

SimEcc = round(str2num(get(handles.edit_simecc,'String'))*100);

if get(hObject,'Value')
    if exist(['lastSimSetEcc' num2str(SimEcc) '.mat'],'file')==2
%     if exist('lastSimSet.mat','file')==2
        set(hObject,'String','Repeat Set');
        set(hObject,'ForegroundColor',[0 0.8 0]);
    
    else
        set(hObject,'String','not found');
        set(hObject,'ForegroundColor',[0.8 0 0]);
        set(hObject,'Value',0);
    end
        
else
    set(hObject,'ForegroundColor',[0 0 0]);
end
