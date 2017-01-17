function varargout = OrientationDetectionConfig(varargin)
% ORIENTATIONDETECTIONCONFIG MATLAB code for OrientationDetectionConfig.fig
%      ORIENTATIONDETECTIONCONFIG, by itself, creates a new ORIENTATIONDETECTIONCONFIG or raises the existing
%      singleton*.
%
%      H = ORIENTATIONDETECTIONCONFIG returns the handle to a new ORIENTATIONDETECTIONCONFIG or the handle to
%      the existing singleton*.
%
%      ORIENTATIONDETECTIONCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORIENTATIONDETECTIONCONFIG.M with the given input arguments.
%
%      ORIENTATIONDETECTIONCONFIG('Property','Value',...) creates a new ORIENTATIONDETECTIONCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OrientationDetectionConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OrientationDetectionConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OrientationDetectionConfig

% Last Modified by GUIDE v2.5 23-Jun-2016 10:16:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OrientationDetectionConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @OrientationDetectionConfig_OutputFcn, ...
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


% --- Executes just before OrientationDetectionConfig is made visible.
function OrientationDetectionConfig_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OrientationDetectionConfig (see VARARGIN)

% Choose default command line output for OrientationDetectionConfig
global SYSPARAMS StimParams VideoParams ExpCfgParams;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OrientationDetectionConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);
hAomControl = getappdata(0,'hAomControl');

if exist('lastOrientationDetectionCFG.mat','file')==2
    loadLastValues(handles,1);
else
    loadLastValues(handles,0);
end

% make Gabor
DrawPreview (3,32,10,5,handles.ax_StimG,0)

% make Bars
DrawPreview (2,35,5,25,handles.ax_StimB,0)

% make E
DrawPreview (1,35,5,handles.ax_StimE,0)

set(handles.button_ok, 'Enable', 'on');


% --- Outputs from this function are returned to the command line.
function varargout = OrientationDetectionConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------     CREATION  FUNCTIONS    --------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function txt_VidDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax_Preview (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ax_Preview
% set(gca, 'XTick', [], 'YTick', []); %turn off tick marks
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_SubIni_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Prefix_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Pupil_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Field_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uipanel_StimSelect_CreateFcn(~, ~, ~)

function ax_Preview_CreateFcn(~, ~, ~)

function ax_StimG_CreateFcn(~, ~, ~)

function ax_StimB_CreateFcn(~, ~, ~)

function ax_StimE_CreateFcn(~, ~, ~)

function txt_LineLength_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_PatchSize_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_GapSize_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Sigma_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Period_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_StimDur_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text_RotSteps_CreateFcn(~, ~, ~)

function txt_RotStepSize_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_NumRots_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pop_RotationVector_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Trials_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_ThreshSteps_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------     LAST STIM SETS or DEFAULT STARTUP    -------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function loadLastValues (handles,last)
global SYSPARAMS StimParams VideoParams ExpCfgParams; %#ok<*NUSED>

if last==1
    load('lastOrientationDetectionCFG.mat');
else %Set default values here
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.pupilsize = 6.0;               % pupil size in mm
    ExpCfgParams.fieldsize = 1.28;              % Scan field size in degree
    ExpCfgParams.videodur = 1;                  % Duration of recorded Video in seconds
    ExpCfgParams.record = 1;                    % 1 = Yes, 0 = No
    ExpCfgParams.Stimulus = 3;                  % 1 = "E", 2 = Bars, 3 = Gabor 
    ExpCfgParams.RotSteps = 45;                 % Rotation Step size
    ExpCfgParams.NumRots = 2;                   % Number of rotations for testing
    ExpCfgParams.LineLength = 29;
    ExpCfgParams.GapSize = 5;
    ExpCfgParams.PatchSize = 64;
    ExpCfgParams.Sigma = 10;
    ExpCfgParams.Lambda = 10;
    ExpCfgParams.StimChannel = 1;               % 1 = IR, 2 = RED, 3 = GREEN
    ExpCfgParams.Method = 'Discrimination';
    ExpCfgParams.Thresh = '2d1u';
    ExpCfgParams.THsteps = 1;                   % Step Size of gap size variation in pixel
    ExpCfgParams.StimGain1 = 1;                 % stabilized viewing: 1 = Yes, 0 = No 
    ExpCfgParams.StimGain0 = 1;                 % normal viewing: 1 = Yes, 0 = No 
    ExpCfgParams.Incongruent = 0;               % incongruent (foreign motion) viewing: 1 = Yes, 0 = No 
    ExpCfgParams.StimDur = 500;                 % Stimulus presentation duration in ms
    ExpCfgParams.npresent = 20;                 % presentations per condition
    ExpCfgParams.kb_StimConst = 'space';        % Key for next stimulus (Space Bar)
    ExpCfgParams.kb_AbortConst = 'escape';      % Key to abort experiment
    ExpCfgParams.kb_BadConst = 'r';             % Key to repeat last trial
    ExpCfgParams.kb_Left = 'leftarrow';         % Key for left response
    ExpCfgParams.kb_Right = 'rightarrow';       % Key for right response
    ExpCfgParams.kb_Up = 'uparrow';             % Key for up response
    ExpCfgParams.kb_Down = 'downarrow';         % Key for down response
end

set(handles.txt_Prefix, 'String', VideoParams.vidprefix);
set(handles.txt_RotStepSize,'String',num2str(ExpCfgParams.RotSteps))
set(handles.txt_NumRots,'String',num2str(ExpCfgParams.NumRots));
set(handles.txt_StimDur,'String',num2str(ExpCfgParams.StimDur));
set(handles.txt_LineLength,'String',num2str(ExpCfgParams.LineLength));
set(handles.txt_GapSize,'String',num2str(ExpCfgParams.GapSize));
set(handles.txt_PatchSize,'String',num2str(ExpCfgParams.PatchSize));
set(handles.txt_Sigma,'String',num2str(ExpCfgParams.Sigma));
set(handles.txt_Period,'String',num2str(ExpCfgParams.Lambda));
set(handles.txt_SubIni,'String',num2str(ExpCfgParams.initials));
set(handles.txt_Pupil,'String',num2str(ExpCfgParams.pupilsize));
set(handles.txt_Field,'String',num2str(ExpCfgParams.fieldsize));
set(handles.txt_VidDur,'String',num2str(ExpCfgParams.videodur));
set(handles.txt_Trials,'String',num2str(ExpCfgParams.npresent));

% Generation of Rotation Vector
if ExpCfgParams.Stimulus == 1                   
    preRotVec = 0:ExpCfgParams.RotSteps:359;
else
    preRotVec = 0:ExpCfgParams.RotSteps:179;
end
RotVec = nchoosek(preRotVec,ExpCfgParams.NumRots);
set(handles.pop_RotationVector, 'String', num2str(RotVec));

if ExpCfgParams.Stimulus == 1
    set(handles.rb_StimE,'Value',1);
    set(handles.rb_Bars,'Value',0);
    set(handles.rb_Gabor,'Value',0);
    DrawPreview(1,64,ExpCfgParams.GapSize,handles.ax_Preview,1)
elseif ExpCfgParams.Stimulus == 2
    set(handles.rb_StimE,'Value',0);
    set(handles.rb_Bars,'Value',1);
    set(handles.rb_Gabor,'Value',0);
    DrawPreview(2,64,ExpCfgParams.GapSize,ExpCfgParams.LineLength,handles.ax_Preview,1)
elseif ExpCfgParams.Stimulus == 3
    set(handles.rb_StimE,'Value',0);
    set(handles.rb_Bars,'Value',0);
    set(handles.rb_Gabor,'Value',1);
    DrawPreview(3,ExpCfgParams.PatchSize,ExpCfgParams.Lambda,ExpCfgParams.Sigma,handles.ax_Preview,1)
end

if ExpCfgParams.StimChannel == 1
    set(handles.rb_scIR,'Value',1);
    set(handles.rb_scRED,'Value',0);
    set(handles.rb_scGREEN,'Value',0);
elseif ExpCfgParams.StimChannel == 2
    set(handles.rb_scIR,'Value',0);
    set(handles.rb_scRED,'Value',1);
    set(handles.rb_scGREEN,'Value',0);
elseif ExpCfgParams.StimChannel == 3
    set(handles.rb_scIR,'Value',0);
    set(handles.rb_scRED,'Value',0);
    set(handles.rb_scGREEN,'Value',1);
end

if strcmp(ExpCfgParams.Method,'Discrimination')
    set(handles.rb_Discrimination, 'Value',1)
    set(handles.rb_ThreshEst, 'Value',0)
    set(handles.uipanel_Thresh, 'Visible', 'off')
    set(handles.uipanel_GainTH, 'Visible', 'off')
    set(handles.uipanel_GainDC, 'Visible', 'on')
    set(handles.cbox_DCstab , 'Value', ExpCfgParams.StimGain1);
    set(handles.cbox_DCnorm , 'Value', ExpCfgParams.StimGain0);
    set(handles.cbox_DCincon , 'Value', ExpCfgParams.Incongruent);
elseif strcmp(ExpCfgParams.Method,'Thresholds')
    set(handles.rb_Discrimination, 'Value',0)
    set(handles.rb_ThreshEst, 'Value',1)
    set(handles.rb_THstab , 'Value', ExpCfgParams.StimGain1);
    set(handles.rb_THnorm , 'Value', ExpCfgParams.StimGain0);
%     set(handles.rb_DCincon , 'Value', ExpCfgParams.Incongruent);
    set(handles.uipanel_Thresh, 'Visible', 'on')
    set(handles.uipanel_GainTH, 'Visible', 'on')
    set(handles.uipanel_GainDC, 'Visible', 'off')

    if strcmp(ExpCfgParams.Thresh, '2d1u')
        set(handles.rb_2d1u, 'Value', 1)
        set(handles.rb_Quest, 'Value', 0)
        set(handles.text_ThreshSteps, 'Visible', 'on')
        set(handles.txt_ThreshSteps, 'Visible', 'on')
        set(handles.txt_ThreshSteps, 'String', num2str(ExpCfgParams.THsteps))
    elseif strcmp(ExpCfgParams.Thresh, 'Quest')
        set(handles.rb_2d1u, 'Value', 0)
        set(handles.rb_Quest, 'Value', 1)
        set(handles.text_ThreshSteps, 'Visible', 'off')
        set(handles.txt_ThreshSteps, 'Visible', 'off')
    end
end

if get (handles.rb_StimE, 'Value') == 1;
    set(handles.text_Gap, 'Visible', 'on');
    set(handles.txt_GapSize, 'Visible', 'on');
    set(handles.text_Line, 'Visible', 'off');
    set(handles.txt_LineLength, 'Visible', 'off');
    set(handles.text_Patch, 'Visible', 'off');
    set(handles.txt_PatchSize, 'Visible', 'off');
    set(handles.text_Sigma, 'Visible', 'off');
    set(handles.txt_Sigma, 'Visible', 'off');
    set(handles.text_Period, 'Visible', 'off');
    set(handles.txt_Period, 'Visible', 'off');   

elseif get (handles.rb_Bars, 'Value') == 1;
	set(handles.text_Gap, 'Visible', 'on');
    set(handles.txt_GapSize, 'Visible', 'on');
    set(handles.text_Line, 'Visible', 'on');
    set(handles.txt_LineLength, 'Visible', 'on');
    set(handles.text_Patch, 'Visible', 'off');
    set(handles.txt_PatchSize, 'Visible', 'off');
    set(handles.text_Sigma, 'Visible', 'off');
    set(handles.txt_Sigma, 'Visible', 'off');
    set(handles.text_Period, 'Visible', 'off');
    set(handles.txt_Period, 'Visible', 'off'); 

elseif get (handles.rb_Gabor, 'Value') == 1;
	set(handles.text_Gap, 'Visible', 'off');
    set(handles.txt_GapSize, 'Visible', 'off');
    set(handles.text_Line, 'Visible', 'off');
    set(handles.txt_LineLength, 'Visible', 'off');
    set(handles.text_Patch, 'Visible', 'on');
    set(handles.txt_PatchSize, 'Visible', 'on');
    set(handles.text_Sigma, 'Visible', 'on');
    set(handles.txt_Sigma, 'Visible', 'on');
    set(handles.text_Period, 'Visible', 'on');
    set(handles.txt_Period, 'Visible', 'on'); 
end



set(handles.button_ok, 'Enable', 'on');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------     BUTTON OK -> START EXPERIMENT     --------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function button_ok_Callback(hObject, eventdata, handles)
% hObject    handle to txt_PatchSize (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hAomControl = getappdata(0,'hAomControl');
stimpath = [pwd,'\tempStimulus\'];
setappdata(hAomControl, 'stimpath', stimpath);

CFG.ok = 1;
CFG.stimpath = [pwd,'\tempStimulus\'];
CFG.initials = get(handles.txt_SubIni,'String');
CFG.pupilsize = str2double(get(handles.txt_Pupil,'String'));
CFG.fieldsize = str2double(get(handles.txt_Field,'String'));
CFG.videodur = str2double(get(handles.txt_VidDur,'String'));
CFG.vidprefix = get(handles.txt_Trials,'String');
CFG.record = get(handles.cb_RecVid,'Value');
if get(handles.rb_StimE,'Value')==1
    CFG.Stimulus = 1;
elseif get(handles.rb_Bars,'Value')==1
    CFG.Stimulus = 2;
elseif get(handles.rb_Gabor,'Value')==1
    CFG.Stimulus = 3; 
end
CFG.RotSteps = str2double(get(handles.txt_RotStepSize,'String'));
CFG.NumRots = str2double(get(handles.txt_NumRots,'String'));
RowSelect = str2double(get(handles.pop_RotationVector,'Value'));                    % user selection
SelectVec = get(handles.pop_RotationVector,'String');                               % whole vector
CFG.Rotations = str2double(SelectVec(RowSelect,:));
CFG.TestRots = str2double(get(handles.pop_RotationVector,'String'));
CFG.LineLength = str2double(get(handles.txt_LineLength,'String'));
CFG.GapSize = str2double(get(handles.txt_GapSize,'String'));
CFG.PatchSize = str2double(get(handles.txt_PatchSize,'String'));
CFG.Sigma = str2double(get(handles.txt_Sigma,'String'));
CFG.Lambda = str2double(get(handles.txt_Period,'String'));
CFG.StimDur = str2double(get(handles.txt_StimDur,'String'));
CFG.npresent = str2double(get(handles.txt_Trials,'String'));
if get(handles.rb_scIR, 'Value')==1
    CFG.StimChannel = 1;
elseif get(handles.rb_scRED, 'Value')==1
    CFG.StimChannel = 2;
elseif get(handles.rb_scGREEN, 'Value')==1
    CFG.StimChannel = 3; 
end
if get(handles.rb_Discrimination,'Value')==1
    CFG.Method = 'Discrimination';
    CFG.StimGain1 = get(handles.cbox_DCstab, 'Value');
    CFG.StimGain0 = get(handles.cbox_DCnorm, 'Value'); 
    CFG.Incongruent = get(handles.cbox_DCincon, 'Value'); 
elseif get(handles.rb_ThreshEst,'Value')==1
    CFG.Method = 'Thresholds';
    CFG.StimGain1 = get(handles.rb_THstab, 'Value');
    CFG.StimGain0 = get(handles.rb_THnorm, 'Value');
%     CFG.Incongruent = get(handles.rb_THstab, 'Value');
    if get(handles.rb_2d1u,'Value')==1
        CFG.Thresh = '2d1u';
        CFG.THsteps = str2double(get(handles.txt_ThreshSteps,'String'));
    elseif get(handles.rb_Quest,'Value')==1
        CFG.Thresh = 'Quest';
    end
end
CFG.kb_StimConst = 'space';        % Key for next stimulus (Space Bar)
CFG.kb_AbortConst = 'escape';      % Key to abort experiment
CFG.kb_BadConst = 'r';             % Key to repeat last trial
CFG.kb_Left = 'leftarrow';         % Key for left response
CFG.kb_Right = 'rightarrow';       % Key for right response
CFG.kb_Up = 'uparrow';             % Key for up response
CFG.kb_Down = 'downarrow';         % Key for down response

% Save the same for retrieval while loading last values
ExpCfgParams = CFG;

setappdata(hAomControl, 'CFG', CFG);

save('lastOrientationDetectionCFG.mat', 'ExpCfgParams','CFG')

close;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------     CALLBACK  FUNCTIONS    --------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function txt_VidDur_Callback(hObject, eventdata, handles)
% hObject    handle to txt_PatchSize (see GCBO)
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function cb_AutoVidPre_Callback(~, ~, ~)

function txt_SubIni_Callback(hObject, ~, handles)
user_entry = get(hObject,'string');
if get(handles.cb_AutoVidPre, 'Value') == 1
    set(handles.txt_Prefix, 'String', user_entry)
elseif get(handles.auto_prefix, 'Value') == 0
    %do nothing
end

function txt_Pupil_Callback(~, ~, ~)

function txt_Field_Callback(~, ~, ~)

function txt_Prefix_Callback(~, ~, ~)

function cb_RecVid_Callback(~, ~, ~)

function txt_GapSize_Callback(hObject, ~, handles)
user_entry = str2double(get(hObject,'string'));
if get(handles.rb_StimE,'Value')==1
    DrawPreview(1,64,user_entry,handles.ax_Preview,1)
elseif get(handles.rb_Bars,'Value')==1
    DrawPreview(2,64,user_entry,str2double(get(handles.txt_LineLength,'String')),handles.ax_Preview,1)
end

function txt_LineLength_Callback(hObject, ~, handles)
user_entry = str2double(get(hObject,'string'));
DrawPreview(2,64,str2double(get(handles.txt_GapSize,'String')),user_entry,handles.ax_Preview,1)

function txt_PatchSize_Callback(hObject, ~, handles)
user_entry = str2double(get(hObject,'string'));
DrawPreview(3,user_entry,str2double(get(handles.txt_Period,'String')),...
    str2double(get(handles.txt_Sigma,'String')),handles.ax_Preview,1)

function txt_Sigma_Callback(hObject, ~, handles)
user_entry = str2double(get(hObject,'string'));
DrawPreview(3,str2double(get(handles.txt_PatchSize,'String')),...
        str2double(get(handles.txt_Period,'String')),user_entry,handles.ax_Preview,1)

function txt_Period_Callback(hObject, ~, handles)
user_entry = str2double(get(hObject,'string'));
DrawPreview(3,str2double(get(handles.txt_PatchSize,'String')),...
        user_entry,str2double(get(handles.txt_Sigma,'String')),handles.ax_Preview,1)

function txt_RotStepSize_Callback(~, ~, handles)
NumRots = str2double(get(handles.txt_NumRots,'String'));
StepSize = str2double(get(handles.txt_RotStepSize,'String'));
clear preRotVec RotVec
if get(handles.rb_StimE,'Value') == 1
    preRotVec = 0:StepSize:359;
else
    preRotVec = 0:StepSize:179;
end
RotVec = nchoosek(preRotVec,NumRots);
set(handles.pop_RotationVector, 'String', num2str(RotVec));

function txt_NumRots_Callback(~, ~, handles)
NumRots = str2double(get(handles.txt_NumRots,'String'));
StepSize = str2double(get(handles.txt_RotStepSize,'String'));
clear preRotVec RotVec
if get(handles.rb_StimE,'Value') == 1
    preRotVec = 0:StepSize:359;
else
    preRotVec = 0:StepSize:179;
end
RotVec = nchoosek(preRotVec,NumRots);
set(handles.pop_RotationVector, 'String', num2str(RotVec));

function txt_ThreshSteps_Callback(~, ~, ~)

function pop_RotationVector_Callback(~, ~, ~)

function txt_Trials_Callback(~, ~, ~)

function cbox_DCstab_Callback(~, ~, ~)

function cbox_DCnorm_Callback(~, ~, ~)

function cbox_DCincon_Callback(~, ~, ~)

function txt_StimDur_Callback(~, ~, ~)

function button_cancel_Callback(~, ~, ~)
hAomControl = getappdata(0,'hAomControl');
CFG.ok = 0;
setappdata(hAomControl, 'CFG', CFG);
close;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------     SELECTION CHANGE  FUNCTIONS    ----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function uipanel_StimSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_StimSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get (handles.rb_StimE, 'Value') == 1;
    set(handles.text_Gap, 'Visible', 'on');
    set(handles.txt_GapSize, 'Visible', 'on');
    set(handles.text_Line, 'Visible', 'off');
    set(handles.txt_LineLength, 'Visible', 'off');
    set(handles.text_Patch, 'Visible', 'off');
    set(handles.txt_PatchSize, 'Visible', 'off');
    set(handles.text_Sigma, 'Visible', 'off');
    set(handles.txt_Sigma, 'Visible', 'off');
    set(handles.text_Period, 'Visible', 'off');
    set(handles.txt_Period, 'Visible', 'off');
    DrawPreview(1,64,str2double(get(handles.txt_GapSize,'String')),handles.ax_Preview,1)

elseif get (handles.rb_Bars, 'Value') == 1;
	set(handles.text_Gap, 'Visible', 'on');
    set(handles.txt_GapSize, 'Visible', 'on');
    set(handles.text_Line, 'Visible', 'on');
    set(handles.txt_LineLength, 'Visible', 'on');
    set(handles.text_Patch, 'Visible', 'off');
    set(handles.txt_PatchSize, 'Visible', 'off');
    set(handles.text_Sigma, 'Visible', 'off');
    set(handles.txt_Sigma, 'Visible', 'off');
    set(handles.text_Period, 'Visible', 'off');
    set(handles.txt_Period, 'Visible', 'off');
    DrawPreview(2,64,str2double(get(handles.txt_GapSize,'String')),...
        str2double(get(handles.txt_LineLength,'String')),handles.ax_Preview,1)

elseif get (handles.rb_Gabor, 'Value') == 1;
	set(handles.text_Gap, 'Visible', 'off');
    set(handles.txt_GapSize, 'Visible', 'off');
    set(handles.text_Line, 'Visible', 'off');
    set(handles.txt_LineLength, 'Visible', 'off');
    set(handles.text_Patch, 'Visible', 'on');
    set(handles.txt_PatchSize, 'Visible', 'on');
    set(handles.text_Sigma, 'Visible', 'on');
    set(handles.txt_Sigma, 'Visible', 'on');
    set(handles.text_Period, 'Visible', 'on');
    set(handles.txt_Period, 'Visible', 'on');
    DrawPreview(3,str2double(get(handles.txt_PatchSize,'String')),...
        str2double(get(handles.txt_Period,'String')),str2double(get(handles.txt_Sigma,'String')),handles.ax_Preview,1)
end

function uipanel_StimChannel_SelectionChangeFcn(hObject, eventdata, handles)
if get (handles.rb_scIR, 'Value') == 1;
    disp('IR')
elseif get (handles.rb_scRED, 'Value') == 1;
    disp('RED')
elseif get (handles.rb_scGREEN, 'Value') == 1;
    disp('GREEN')
end 

function uipanel_Methods_SelectionChangeFcn(hObject, eventdata, handles)
if get (handles.rb_Discrimination, 'Value') == 1;
    set(handles.uipanel_Thresh, 'Visible', 'off')
    set(handles.uipanel_GainTH, 'Visible', 'off')
    set(handles.uipanel_GainDC, 'Visible', 'on')    
elseif get (handles.rb_ThreshEst, 'Value') == 1;
    set(handles.uipanel_Thresh, 'Visible', 'on')
	set(handles.uipanel_GainTH, 'Visible', 'on')
    set(handles.uipanel_GainDC, 'Visible', 'off')  
end

function uipanel_Thresh_SelectionChangeFcn(hObject, eventdata, handles)
if get (handles.rb_2d1u, 'Value') == 1;
	set(handles.text_ThreshSteps, 'Visible', 'on')
	set(handles.txt_ThreshSteps, 'Visible', 'on')
elseif get (handles.rb_Quest, 'Value') == 1;
	set(handles.text_ThreshSteps, 'Visible', 'off')
	set(handles.txt_ThreshSteps, 'Visible', 'off')
end

function DrawPreview (varargin)
if varargin{1} == 1
    %% make E
    surround = varargin{2};
    gap = varargin{3};
    e=zeros(gap*5,gap*5);
    e(gap+1:2*gap,gap+1:end)=1;
    e(3*gap+1:4*gap,gap+1:end)=1;
    ylo = floor(surround/2)-floor(gap*5/2);
    yhi = ylo-1+gap*5;
    xlo = floor(surround/2)-floor(gap*5/2);
    xhi = xlo-1+gap*5;
    StimPic2 = ones(surround,surround);
    StimPic2(ylo:yhi,xlo:xhi)=e;
    
    if varargin{5}==1
        Preview = AddSurround(StimPic2);
    else
        Preview = StimPic2;
    end
    
    cla(varargin{4})
    imshow(Preview,'Parent',varargin{4})
    axis(varargin{4}, 'off')
    drawnow
    
elseif varargin{1} == 2
    %% make Bars
    surround = varargin{2};
    gap = varargin{3};
    bars=zeros(varargin{3}*5,varargin{4});
    bars(gap+1:2*gap,1:end)=1;
    bars(3*gap+1:4*gap,1:end)=1;
    ylo = floor(surround/2)-floor(gap*5/2);
    yhi = ylo-1+gap*5;
    xlo = floor(surround/2)-floor(varargin{4}/2);
    xhi = xlo-1+varargin{4};
    StimPic = ones(surround,surround);
    StimPic(ylo:yhi,xlo:xhi)=bars;
    
    if varargin{6}==1
        Preview = AddSurround(StimPic);
    else
        Preview = StimPic;
    end
    
    cla(varargin{5})
    imshow(Preview,'Parent',varargin{5})
    axis(varargin{5}, 'off')
    drawnow
    
elseif varargin{1} == 3
    %% make Gabor
    imSize = varargin{2};                    % image size: n X n
    lambda = varargin{3};                     % wavelength (number of pixels per cycle)
    
    theta = 90;                        % grating orientation
    sigma = varargin{4};                 % gaussian standard deviation in pixels
    phase = .5;                             % phase (0 -> 1)
    trim = .005;        % .005               % trim off gaussian values smaller than this
    
    X = 1:imSize;                           % X is a vector from 1 to imageSize
    X0 = (X / imSize) - .5;                 % rescale X -> -1 to 1
    
    freq = imSize/lambda;                    % compute frequency from wavelength
    phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
    
    [Xm,Ym] = meshgrid(X0, X0);             % 2D matrices
    
    thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
    Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
    Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
    XYt = Xt+Yt;                            % sum X and Y components
    XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
    grating = sin( XYf + phaseRad);         % make 2D sinewave and add Contrast adjustment
    
    s = sigma / imSize;                     % gaussian width as fraction of imageSize
    
    gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
    
    gauss(gauss < trim) = 0;                 % trim around edges (for 8-bit colour displays)
    preGabor = grating.* gauss;           % use .* dot-product
    
    Gabor = preGabor+abs(min(preGabor(:)));    % adjust Gabor to min = 0
    Gabor=Gabor+(.5-mean(Gabor(:)));                    % adjust to a Gabor mean of .5
    Gabor(Gabor<0)=0; Gabor(Gabor>1)=1;

    if varargin{6}==1
        Preview = AddSurround(Gabor);
    else
        Preview = Gabor;
    end
    
    cla(varargin{5})
    imshow(Preview,'Parent',varargin{5})
    axis(varargin{5}, 'off')
    drawnow
end

function [Preview] = AddSurround(varargin)
Stimulus = varargin{1};
imSize = size(Stimulus,1);
Preview = zeros(150,150);
lo = floor(150/2)-floor(imSize/2);
hi = lo-1+imSize;
Preview(lo:hi,lo:hi) = Stimulus;



