function varargout = QuestSensitivityConfig(varargin)
% QUESTSENSITIVITYCONFIG M-file for QuestSensitivityConfig.fig
%      QUESTSENSITIVITYCONFIG, by itself, creates a new QUESTSENSITIVITYCONFIG or raises the existing
%      singleton*.
%
%      H = QUESTSENSITIVITYCONFIG returns the handle to a new QUESTSENSITIVITYCONFIG or the handle to
%      the existing singleton*.
%
%      QUESTSENSITIVITYCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUESTSENSITIVITYCONFIG.M with the given input arguments.
%
%      QUESTSENSITIVITYCONFIG('Property','Value',...) creates a new QUESTSENSITIVITYCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuestSensitivityConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuestSensitivityConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuestSensitivityConfig

% Last Modified by GUIDE v2.5 09-Nov-2011 22:16:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @QuestSensitivityConfig_OpeningFcn, ...
    'gui_OutputFcn',  @QuestSensitivityConfig_OutputFcn, ...
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


% --- Executes just before QuestSensitivityConfig is made visible.
function QuestSensitivityConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuestSensitivityConfig (see VARARGIN)

% Choose default command line output for QuestSensitivityConfig
global StimParams VideoParams;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QuestSensitivityConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');

if exist('lastSensitivityCFG.mat','file')==2
    loadLastValues(handles,1);
    %     set(handles.push_default,'Enable','On');
    %     set(handles.push_last,'Enable','Off');
else
    loadLastValues(handles,0);
    %     set(handles.push_default,'Enable','Off');
    %     set(handles.push_last,'Enable','Off');
end
if get(handles.twodown_radio, 'Value') == 1;
    set(handles.two_step_check, 'Visible', 'on');
else
    set(handles.two_step_check, 'Visible', 'off');
end
set(handles.stimpath, 'String', [cd '\tempStimulus\']);
set(handles.ok_button, 'Enable', 'on');
set(handles.gain_lbl, 'Visible', 'On');
set(handles.angle_lbl, 'Visible', 'On');
set(handles.gain, 'Visible', 'On');
set(handles.angle, 'Visible', 'On');



% --- Outputs from this function are returned to the command line.
function varargout = QuestSensitivityConfig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function initials_Callback(hObject, eventdata, handles)
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



function presentdur_Callback(hObject, eventdata, handles)
% hObject    handle to presentdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of presentdur as text
%        str2double(get(hObject,'String')) returns contents of presentdur as a double


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



function iti_Callback(hObject, eventdata, handles)
% hObject    handle to iti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iti as text
%        str2double(get(hObject,'String')) returns contents of iti as a double


% --- Executes during object creation, after setting all properties.
function iti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iti (see GCBO)
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



function kb_UpArrow_Callback(hObject, eventdata, handles)
% hObject    handle to kb_UpArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_UpArrow as text
%        str2double(get(hObject,'String')) returns contents of kb_UpArrow as a double


% --- Executes during object creation, after setting all properties.
function kb_UpArrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_UpArrow (see GCBO)
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



function kb_LeftArrow_Callback(hObject, eventdata, handles)
% hObject    handle to kb_LeftArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_LeftArrow as text
%        str2double(get(hObject,'String')) returns contents of kb_LeftArrow as a double


% --- Executes during object creation, after setting all properties.
function kb_LeftArrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_LeftArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kb_RightArrow_Callback(hObject, eventdata, handles)
% hObject    handle to kb_RightArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kb_RightArrow as text
%        str2double(get(hObject,'String')) returns contents of kb_RightArrow as a double


% --- Executes during object creation, after setting all properties.
function kb_RightArrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kb_RightArrow (see GCBO)
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



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdGuess_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdGuess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdGuess as text
%        str2double(get(hObject,'String')) returns contents of thresholdGuess as a double


% --- Executes during object creation, after setting all properties.
function thresholdGuess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdGuess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function priorSD_Callback(hObject, eventdata, handles)
% hObject    handle to priorSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of priorSD as text
%        str2double(get(hObject,'String')) returns contents of priorSD as a double


% --- Executes during object creation, after setting all properties.
function priorSD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
%        str2double(get(hObject,'String')) returns contents of delta as a double


% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_stimpath.
function set_stimpath_Callback(hObject, eventdata, handles)
% hObject    handle to set_stimpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stimpath = uigetdir('path','Select directory containing the stimuli');
set(handles.stimpath, 'String', [stimpath '\']);
if stimpath == 0;
    %do nothing
else
    set(handles.ok_button, 'Enable', 'on');
    hAomControl = getappdata(0,'hAomControl');
    setappdata(hAomControl, 'stimpath', stimpath);
end


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
stimpath = getappdata(hAomControl, 'stimpath');
CFG.ok = 1;
CFG.initials = get(handles.initials, 'String');
CFG.pupilsize = get(handles.pupilsize, 'String');
CFG.fieldsize = str2num(get(handles.fieldsize, 'String'));
CFG.presentdur = str2num(get(handles.presentdur, 'String'));
CFG.iti = str2num(get(handles.iti,'String'));
CFG.videodur = str2num(get(handles.videodur, 'String'));
CFG.vidprefix = get(handles.vidprefix, 'String');
CFG.kb_StimConst = uint8(get(handles.kb_StimConst, 'String'));
CFG.kb_UpArrow = get(handles.kb_UpArrow, 'String');
CFG.kb_DownArrow = get(handles.kb_DownArrow, 'String');
CFG.kb_LeftArrow = get(handles.kb_LeftArrow, 'String');
CFG.kb_RightArrow = get(handles.kb_RightArrow, 'String');
CFG.record = 1;
CFG.two_step_check = 0;
if get(handles.quest_radio, 'Value') == 1;
    CFG.method = 'q';
    CFG.quest_radio = 1; CFG.mocs_radio = 0; CFG.fourtworadio = 0; CFG.twodown_radio = 0;
elseif get(handles.twodown_radio, 'Value') == 1;
    CFG.method = 's';
    if get(handles.two_step_check, 'Value') == 1;
        CFG.two_step_staircase = 'y';
        CFG.second_step = get(handles.beta, 'String');
        CFG.num_reversals = get(handles.delta, 'String');
        CFG.two_step_check = 1;
    else
        CFG.two_step_staircase = 'n';
        CFG.second_step = get(handles.priorSD, 'String');
        CFG.num_reversals = 0;
        CFG.two_step_check = 0;
    end
    CFG.twodown_radio = 1; CFG.mocs_radio = 0; CFG.fourtworadio = 0; CFG.quest_radio = 0;
elseif get(handles.fourtworadio, 'Value') == 1;
    CFG.method = '4';
    CFG.fourtworadio = 1; CFG.mocs_radio = 0; CFG.twodown_radio = 0; CFG.quest_radio = 0;
elseif get(handles.mocs_radio, 'Value') == 1;
    CFG.method = 'm';
    CFG.mocs_radio = 1; CFG.fourtworadio = 0; CFG.twodown_radio = 0; CFG.quest_radio = 0;
end

if get(handles.yes_no_radio, 'Value') == 1;
    CFG.subject_response = 'y';
    CFG.yes_no_radio = 1;
    CFG.two_afc_radio = 0;
elseif get(handles.two_afc_radio, 'Value') == 1;
    CFG.subject_response = '2';
    CFG.yes_no_radio = 0;
    CFG.two_afc_radio = 1;
else
end

if get(handles.computefit_check, 'Value') == 1;
    CFG.compute_fit = 'y';
    CFG.computefit_check = 1;
else
    CFG.compute_fit = 'n';
    CFG.computefit_check = 0;
end

if get(handles.circle_button, 'Value') == 1;
    CFG.stim_shape = 'Circle';
    CFG.circle_button = 1;
    CFG.square_button = 0;
elseif get(handles.square_button, 'Value') == 1;
    CFG.stim_shape = 'Square';
    CFG.circle_button = 0;
    CFG.square_button = 1;
else
end
CFG.stimsize = str2num(get(handles.stim_size, 'String'));
CFG.npresent = str2num(get(handles.npresent, 'String'));
CFG.gain = str2num(get(handles.gain, 'String'));
CFG.angle = str2num(get(handles.angle, 'String'));
CFG.beta = str2num(get(handles.beta, 'String'));
CFG.delta = str2num(get(handles.delta, 'String'));
CFG.pCorrect = str2num(get(handles.pCorrect, 'String'));
CFG.thresholdGuess = str2num(get(handles.thresholdGuess, 'String'));
CFG.priorSD = str2num(get(handles.priorSD, 'String'));
CFG.stimpath = get(handles.stimpath,'String');
CFG.green_x_offset = str2num(get(handles.green_x_offset,'String'));
CFG.green_y_offset = str2num(get(handles.green_y_offset,'String'));
CFG.red_x_offset = str2num(get(handles.red_x_offset,'String'));
CFG.red_y_offset = str2num(get(handles.red_y_offset,'String'));
CFG.red_stim_color = get(handles.red_stim_radio, 'Value');
CFG.green_stim_color = get(handles.green_stim_radio, 'Value');


ExpCfgParams.initials = CFG.initials;
ExpCfgParams.pupilsize = CFG.pupilsize;
ExpCfgParams.presentdur = CFG.presentdur;
ExpCfgParams.fieldsize = CFG.fieldsize; % Rastersize in degrees
ExpCfgParams.iti = CFG.iti;
ExpCfgParams.videodur = CFG.videodur; % Video recording time in seconds
ExpCfgParams.quest_radio = CFG.quest_radio;
ExpCfgParams.fourtworadio = CFG.fourtworadio;
ExpCfgParams.twodown_radio = CFG.twodown_radio;
ExpCfgParams.mocs_radio = CFG.mocs_radio;
ExpCfgParams.two_step_check = CFG.two_step_check;
ExpCfgParams.priorSD = CFG.priorSD;
ExpCfgParams.text17 = 1;
ExpCfgParams.text19 = 1;
ExpCfgParams.pCorrect = CFG.pCorrect;
ExpCfgParams.text15 = 1;
ExpCfgParams.thresholdGuess = CFG.thresholdGuess;
ExpCfgParams.text14 = 1;
ExpCfgParams.beta = CFG.beta;
ExpCfgParams.text16 = 1;
ExpCfgParams.delta = CFG.delta;
ExpCfgParams.circle_button = CFG.circle_button;
ExpCfgParams.square_button = CFG.square_button;
ExpCfgParams.stim_size = CFG.stimsize;
ExpCfgParams.yes_no_radio = CFG.yes_no_radio;
ExpCfgParams.two_afc_radio = CFG.two_afc_radio;
ExpCfgParams.npresent = CFG.npresent;
ExpCfgParams.gain = CFG.gain;
ExpCfgParams.angle = CFG.angle;
ExpCfgParams.green_x_offset = CFG.green_x_offset;
ExpCfgParams.green_y_offset = CFG.green_y_offset;
ExpCfgParams.red_x_offset = CFG.red_x_offset;
ExpCfgParams.red_y_offset = CFG.red_x_offset;
ExpCfgParams.red_stim_color = CFG.red_stim_color;
ExpCfgParams.green_stim_color = CFG.green_stim_color;

setappdata(hAomControl, 'CFG', CFG);

save('lastSensitivityCFG.mat', 'ExpCfgParams','CFG')

close;

% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
CFG.ok = 0;
setappdata(hAomControl, 'CFG', CFG);
close;


function pCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to pCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pCorrect as text
%        str2double(get(hObject,'String')) returns contents of pCorrect as a double


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


% --- Executes when selected object is changed in method_radio_panel.
function method_radio_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in method_radio_panel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.quest_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 1.0, 'Visible', 'on');
    set(handles.text14, 'Visible', 'on', 'String', 'Beta');
    set(handles.beta, 'Visible', 'on');
    set(handles.text16, 'Visible', 'on');
    set(handles.delta, 'Visible', 'on');
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Prior SD', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on', 'Enable', 'on');
    set(handles.quest_params, 'Title', 'QUEST Parameters');
    set(handles.text14, 'Visible', 'on', 'String', 'Beta');
    set(handles.beta, 'Visible', 'on', 'String', 3.5);
    set(handles.text16, 'Visible', 'on', 'String', 'Delta');
    set(handles.delta, 'Visible', 'on', 'String', 0.01);
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.computefit_check, 'Enable', 'off');
elseif get(handles.twodown_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 0.1, 'Visible', 'on');
    set(handles.two_step_check, 'Visible', 'on');
    if get(handles.two_step_check, 'Value')==1;
        set(handles.text14, 'String', '2nd Step', 'Visible', 'on');
        set(handles.beta, 'Visible', 'on', 'String', 0.1);
        set(handles.text16, 'String', '# Rev', 'Visible', 'on');
        set(handles.delta,'Visible', 'on', 'String', 2);
        set(handles.priorSD, 'String', 0.3);
    else
        set(handles.text14, 'Visible', 'off');
        set(handles.beta, 'Visible', 'off');
        set(handles.text16, 'Visible', 'off');
        set(handles.delta, 'Visible', 'off');
    end
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Step Size', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on','Enable', 'on');
    set(handles.quest_params, 'Title', 'Staircase Parameters');
    set(handles.computefit_check, 'Enable', 'on');
elseif get(handles.fourtworadio, 'Value') == 1;
    set(handles.priorSD, 'Visible', 'off');
    set(handles.text14, 'Visible', 'off');
    set(handles.beta, 'Visible', 'off');
    set(handles.text16, 'Visible', 'off');
    set(handles.delta, 'Visible', 'off');
    set(handles.text19, 'Visible', 'off');
    set(handles.pCorrect, 'Visible', 'off');
    set(handles.text17, 'Visible', 'off');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Value', 40,'Enable', 'off');
    set(handles.quest_params, 'Title', 'Staircase Parameters');
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.npresent, 'Value', 40);
    set(handles.computefit_check, 'Enable', 'off');
elseif get(handles.mocs_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 100, 'Visible', 'on');   %range aka PriorSD
    set(handles.text14, 'Visible', 'on', 'String', 'Num Levels');
    set(handles.beta, 'Visible', 'on', 'String', 8);
    set(handles.text16, 'Visible', 'on', 'String', 'Trials/Level');
    set(handles.delta, 'Visible', 'on', 'String', 5);
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Range', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on', 'Enable', 'on');
    set(handles.quest_params, 'Title', 'MOCS Parameters');
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.computefit_check, 'Enable', 'on');
end


% --- Executes on button press in computefit_check.
function computefit_check_Callback(hObject, eventdata, handles)
% hObject    handle to computefit_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of computefit_check


% --- Executes when selected object is changed in method_uipanel.
function method_uipanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in method_uipanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.yes_no_radio,'Value')==1;
    set(handles.pCorrect, 'String', 50);
elseif get(handles.two_afc_radio,'Value')==1;
    set(handles.pCorrect, 'String', 75);
else
    set(handles.pCorrect,'String', 62.5);
end



function stim_size_Callback(hObject, eventdata, handles)
% hObject    handle to stim_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_size as text
%        str2double(get(hObject,'String')) returns contents of stim_size as a double


% --- Executes during object creation, after setting all properties.
function stim_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function stim_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in stim_panel.
function stim_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in stim_panel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.circle_button, 'Value')==1;
    set(handles.square_button, 'Value', 0);
elseif get(handles.square_button, 'Value') ==1;
    set(handles.circle_button, 'Value', 0);
else
end



% --- Executes on button press in two_step_check.
function two_step_check_Callback(hObject, eventdata, handles)
% hObject    handle to two_step_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of two_step_check

if get(handles.twodown_radio, 'Value')==1;
    if get(handles.two_step_check, 'Value')==1;
        set(handles.text14, 'String', '2nd Step', 'Visible', 'on');
        set(handles.beta, 'Visible', 'on', 'String', 0.1);
        set(handles.text16, 'String', '# Rev', 'Visible', 'on');
        set(handles.delta,'Visible', 'on', 'String', 2);
        set(handles.priorSD, 'String', 0.3);
    else
        set(handles.text14, 'Visible', 'off');
        set(handles.beta, 'Visible', 'off');
        set(handles.text16, 'Visible', 'off');
        set(handles.delta,'Visible', 'off');
        set(handles.priorSD, 'String', 0.1);
    end
else
    set(handles.text14, 'Visible', 'off');
    set(handles.beta, 'Visible', 'off');
    set(handles.text16, 'Visible', 'off');
    set(handles.delta,'Visible', 'off');
    set(handles.priorSD, 'String', 0.1);
end





function green_y_offset_Callback(hObject, eventdata, handles)
% hObject    handle to green_y_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of green_y_offset as text
%        str2double(get(hObject,'String')) returns contents of green_y_offset as a double


% --- Executes during object creation, after setting all properties.
function green_y_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to green_y_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function green_x_offset_Callback(hObject, eventdata, handles)
% hObject    handle to green_x_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of green_x_offset as text
%        str2double(get(hObject,'String')) returns contents of green_x_offset as a double


% --- Executes during object creation, after setting all properties.
function green_x_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to green_x_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function red_y_offset_Callback(hObject, eventdata, handles)
% hObject    handle to red_y_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of red_y_offset as text
%        str2double(get(hObject,'String')) returns contents of red_y_offset as a double


% --- Executes during object creation, after setting all properties.
function red_y_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to red_y_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function red_x_offset_Callback(hObject, eventdata, handles)
% hObject    handle to red_x_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of red_x_offset as text
%        str2double(get(hObject,'String')) returns contents of red_x_offset as a double


% --- Executes during object creation, after setting all properties.
function red_x_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to red_x_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function loadLastValues (handles,last)

global SYSPARAMS StimParams VideoParams ExpCfgParams;

if last==1
    load('lastSensitivityCFG.mat');
else %use defaults
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.pupilsize = 6.0;
    ExpCfgParams.presentdur = 200;
    ExpCfgParams.fieldsize = 2.2; % Rastersize in degrees
    ExpCfgParams.iti = 1000;
    ExpCfgParams.videodur = 1; % Video recording time in seconds
    ExpCfgParams.quest_radio = 1;
    ExpCfgParams.fourtworadio = 0;
    ExpCfgParams.twodown_radio = 0;
    ExpCfgParams.mocs_radio = 0;
    ExpCfgParams.two_step_check = 0;
    ExpCfgParams.priorSD = 1;
    ExpCfgParams.text17 = 1;
    ExpCfgParams.text19 = 1;
    ExpCfgParams.pCorrect = 50;
    ExpCfgParams.text15 = 1;
    ExpCfgParams.thresholdGuess = 0.5;
    ExpCfgParams.text14 = 1;
    ExpCfgParams.beta = 3.5;
    ExpCfgParams.text16 = 1;
    ExpCfgParams.delta = 0.01;
    ExpCfgParams.circle_button = 1;
    ExpCfgParams.square_button = 0;
    ExpCfgParams.stim_size = 26;
    ExpCfgParams.yes_no_radio = 1;
    ExpCfgParams.two_afc_radio = 0;
    ExpCfgParams.npresent = 40;
    ExpCfgParams.gain = 1;
    ExpCfgParams.angle = 0;
    ExpCfgParams.green_x_offset = 0;
    ExpCfgParams.green_y_offset = 0;
    ExpCfgParams.red_x_offset = 0;
    ExpCfgParams.red_y_offset = 0;
    ExpCfgParams.red_stim_color = 1;
    ExpCfgParams.green_stim_color = 0;
end

set(handles.initials, 'String', ExpCfgParams.initials);
set(handles.pupilsize, 'String', ExpCfgParams.pupilsize);
set(handles.fieldsize, 'String', ExpCfgParams.fieldsize);
set(handles.presentdur, 'String', ExpCfgParams.presentdur);
set(handles.iti, 'String', ExpCfgParams.iti);
set(handles.videodur, 'String', ExpCfgParams.videodur);
set(handles.quest_radio, 'Value', ExpCfgParams.quest_radio);
set(handles.fourtworadio, 'Value', ExpCfgParams.fourtworadio);
set(handles.twodown_radio, 'Value', ExpCfgParams.twodown_radio);
set(handles.mocs_radio, 'Value', ExpCfgParams.mocs_radio);
set(handles.two_step_check, 'Value', ExpCfgParams.two_step_check);
set(handles.priorSD, 'String', ExpCfgParams.priorSD);
set(handles.pCorrect, 'String', ExpCfgParams.pCorrect);
set(handles.thresholdGuess, 'String', ExpCfgParams.thresholdGuess);
set(handles.beta, 'String', ExpCfgParams.beta);
set(handles.delta, 'String', ExpCfgParams.delta);
set(handles.circle_button, 'Value', ExpCfgParams.circle_button);
set(handles.square_button, 'Value', ExpCfgParams.square_button);
set(handles.stim_size, 'String', ExpCfgParams.stim_size);
set(handles.yes_no_radio, 'Value', ExpCfgParams.yes_no_radio);
set(handles.two_afc_radio, 'Value', ExpCfgParams.two_afc_radio);
set(handles.npresent, 'String', ExpCfgParams.npresent);
set(handles.gain, 'String', ExpCfgParams.gain);
set(handles.angle, 'String', ExpCfgParams.angle);
set(handles.green_x_offset, 'String', ExpCfgParams.green_x_offset);
set(handles.green_y_offset, 'String', ExpCfgParams.green_y_offset);
set(handles.red_x_offset, 'String', ExpCfgParams.red_x_offset);
set(handles.red_y_offset, 'String', ExpCfgParams.red_y_offset);
set(handles.red_stim_radio, 'Value', ExpCfgParams.red_stim_color);
set(handles.green_stim_radio, 'Value', ExpCfgParams.green_stim_color);
set(handles.stimpath, 'String',[pwd,'\tempStimulus\']);
set(handles.ok_button, 'Enable', 'on');

if get(handles.quest_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 1.0, 'Visible', 'on');
    set(handles.text14, 'Visible', 'on', 'String', 'Beta');
    set(handles.beta, 'Visible', 'on');
    set(handles.text16, 'Visible', 'on');
    set(handles.delta, 'Visible', 'on');
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Prior SD', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on', 'Enable', 'on');
    set(handles.quest_params, 'Title', 'QUEST Parameters');
    set(handles.text14, 'Visible', 'on', 'String', 'Beta');
    set(handles.beta, 'Visible', 'on', 'String', 3.5);
    set(handles.text16, 'Visible', 'on', 'String', 'Delta');
    set(handles.delta, 'Visible', 'on', 'String', 0.01);
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.computefit_check, 'Enable', 'off');
elseif get(handles.twodown_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 0.1, 'Visible', 'on');
    set(handles.two_step_check, 'Visible', 'on');
    if get(handles.two_step_check, 'Value')==1;
        set(handles.text14, 'String', '2nd Step', 'Visible', 'on');
        set(handles.beta, 'Visible', 'on', 'String', 0.1);
        set(handles.text16, 'String', '# Rev', 'Visible', 'on');
        set(handles.delta,'Visible', 'on', 'String', 2);
        set(handles.priorSD, 'String', 0.3);
    else
        set(handles.text14, 'Visible', 'off');
        set(handles.beta, 'Visible', 'off');
        set(handles.text16, 'Visible', 'off');
        set(handles.delta, 'Visible', 'off');
    end
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Step Size', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on','Enable', 'on');
    set(handles.quest_params, 'Title', 'Staircase Parameters');
    set(handles.computefit_check, 'Enable', 'on');
elseif get(handles.fourtworadio, 'Value') == 1;
    set(handles.priorSD, 'Visible', 'off');
    set(handles.text14, 'Visible', 'off');
    set(handles.beta, 'Visible', 'off');
    set(handles.text16, 'Visible', 'off');
    set(handles.delta, 'Visible', 'off');
    set(handles.text19, 'Visible', 'off');
    set(handles.pCorrect, 'Visible', 'off');
    set(handles.text17, 'Visible', 'off');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Value', 40, 'Enable', 'off');
    set(handles.quest_params, 'Title', 'Staircase Parameters');
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.computefit_check, 'Enable', 'off');
elseif get(handles.mocs_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 100, 'Visible', 'on');   %range aka PriorSD
    set(handles.text14, 'Visible', 'on', 'String', 'Num Levels');
    set(handles.beta, 'Visible', 'on', 'String', 8);
    set(handles.text16, 'Visible', 'on', 'String', 'Trials/Level');
    set(handles.delta, 'Visible', 'on', 'String', 5);
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Range', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on', 'Enable', 'on');
    set(handles.quest_params, 'Title', 'MOCS Parameters');
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.computefit_check, 'Enable', 'on');
end
set(handles.vidprefix, 'String', VideoParams.vidprefix);

user_entry = get(handles.initials,'String');
if get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'String', user_entry)
elseif get(handles.auto_prefix, 'Value') == 0
    %do nothing
end


% --- Executes when selected object is changed in stim_color_panel.
function stim_color_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in stim_color_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.red_stim_radio, 'Value')==1;
    set(handles.green_stim_radio, 'Value', 0);
elseif get(handles.green_stim_radio, 'Value') ==1;
    set(handles.red_stim_radio, 'Value', 0);
else
end