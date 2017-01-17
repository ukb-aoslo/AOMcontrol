function varargout = VA_Config(varargin)
% VA_CONFIG M-file for VA_Config.fig
%      VA_CONFIG, by itself, creates a new VA_CONFIG or raises the existing
%      singleton*.
%
%      H = VA_CONFIG returns the handle to a new VA_CONFIG or the handle to
%      the existing singleton*.
%
%      VA_CONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VA_CONFIG.M with the given input arguments.
%
%      VA_CONFIG('Property','Value',...) creates a new VA_CONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VA_Config_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VA_Config_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VA_Config

% Last Modified by GUIDE v2.5 26-Aug-2011 15:31:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VA_Config_OpeningFcn, ...
                   'gui_OutputFcn',  @VA_Config_OutputFcn, ...
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


% --- Executes just before VA_Config is made visible.
function VA_Config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VA_Config (see VARARGIN)

% Choose default command line output for VA_Config
global StimParams VideoParams;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VA_Config wait for user response (see UIRESUME)
% uiwait(handles.figure1);
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
set(handles.presentdur, 'String', 200);
% set(handles.stimpath, 'String', StimParams.stimpath);
set(handles.stimpath, 'String', [cd '\tempStimulus\']);

if get(handles.yes_no_radio,'Value')==1;
    set(handles.pCorrect, 'String', 50);
elseif get(handles.two_afc_radio,'Value')==1;
    set(handles.pCorrect, 'String', 75);
else
    set(handles.pCorrect,'String', 62.5);
end
set(handles.thresholdGuess, 'String', 3.0);
set(handles.priorSD, 'String', 6.0);
set(handles.ok_button, 'Enable', 'on');
set(handles.initials, 'String', VideoParams.vidprefix);
set(handles.vidprefix, 'String', VideoParams.vidprefix);
set(handles.videodur, 'String', VideoParams.videodur);
set(handles.quest_radio, 'Value', 1);
set(handles.npresent, 'Value', 40);
set(handles.fieldsize, 'Value', 0.60);
set(handles.circle_button, 'Value', 1);
set(handles.gain_lbl, 'Visible', 'On');
set(handles.angle_lbl, 'Visible', 'On');
set(handles.gain, 'Visible', 'On');
set(handles.angle, 'Visible', 'On');
set(handles.mocs_radio, 'Visible', 'Off');
set(handles.fourtworadio, 'Visible', 'Off');
set(handles.yes_no_radio, 'Visible', 'Off');
set(handles.two_afc_radio, 'Value', 1);
set(handles.stim_panel, 'Visible', 'Off');
set(handles.on_check, 'Value', 1);




% --- Outputs from this function are returned to the command line.
function varargout = VA_Config_OutputFcn(hObject, eventdata, handles) 
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
CFG.npresent = str2num(get(handles.npresent, 'String'));
CFG.presentdur = str2num(get(handles.presentdur, 'String'));
CFG.iti = str2num(get(handles.iti,'String'));
CFG.fieldsize = str2num(get(handles.fieldsize, 'String'));
CFG.videodur = str2num(get(handles.videodur, 'String'));
CFG.vidprefix = get(handles.vidprefix, 'String');
CFG.kb_StimConst = uint8(get(handles.kb_StimConst, 'String'));
CFG.kb_UpArrow = get(handles.kb_UpArrow, 'String');
CFG.kb_DownArrow = get(handles.kb_DownArrow, 'String');
CFG.kb_LeftArrow = get(handles.kb_LeftArrow, 'String');
CFG.kb_RightArrow = get(handles.kb_RightArrow, 'String');
CFG.record = 1;
if get(handles.quest_radio, 'Value') == 1;
    CFG.method = 'q';
elseif get(handles.twoup_radio, 'Value') == 1;
    CFG.method = 's';
elseif get(handles.fourtworadio, 'Value') == 1;
    CFG.method = '4';
elseif get(handles.mocs_radio, 'Value') == 1;
    CFG.method = 'm';
end

if get(handles.yes_no_radio, 'Value') == 1;
    CFG.subject_response = 'y';
elseif get(handles.two_afc_radio, 'Value') == 1;
    CFG.subject_response = '2';
else
end

if get(handles.computefit_check, 'Value') == 1;
    CFG.compute_fit = 'y';
else
    CFG.compute_fit = 'n';
end

if get(handles.circle_button, 'Value') == 1;
    CFG.stim_shape = 'Circle';
elseif get(handles.square_button, 'Value') == 1;
    CFG.stim_shape = 'Square';
else
end
CFG.stimsize = str2num(get(handles.stim_size, 'String'));
CFG.gain = str2num(get(handles.gain, 'String'));
CFG.angle = str2num(get(handles.angle, 'String'));
CFG.beta = str2num(get(handles.beta, 'String'));
CFG.delta = str2num(get(handles.delta, 'String'));
CFG.pCorrect = str2num(get(handles.pCorrect, 'String'));
CFG.thresholdGuess = str2num(get(handles.thresholdGuess, 'String'));
CFG.priorSD = str2num(get(handles.priorSD, 'String'));
CFG.stimpath = get(handles.stimpath,'String');
if get(handles.on_check, 'Value') == 1;
    CFG.xscale = str2num(get(handles.xscale, 'String'));
    CFG.yscale = str2num(get(handles.yscale, 'String'));
else
    CFG.xscale = 0;
    CFG.yscale = 0;
end
setappdata(hAomControl, 'CFG', CFG);
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
    set(handles.priorSD, 'String', 6.0, 'Visible', 'on');
    set(handles.text14, 'Visible', 'on');
    set(handles.beta, 'Visible', 'on');
    set(handles.text16, 'Visible', 'on');
    set(handles.delta, 'Visible', 'on');
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Prior SD', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on');
    set(handles.quest_params, 'Title', 'QUEST Parameters');
    set(handles.text14, 'Visible', 'on', 'String', 'Beta');
    set(handles.beta, 'Visible', 'on', 'String', 3.5);
    set(handles.text16, 'Visible', 'on', 'String', 'Delta');
    set(handles.delta, 'Visible', 'on', 'String', 0.01);
    set(handles.fourtworadio, 'Visible', 'off');
    set(handles.mocs_radio, 'Visible', 'off');
elseif get(handles.twoup_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 1.0, 'Visible', 'on');
    set(handles.text14, 'Visible', 'off');
    set(handles.beta, 'Visible', 'off');
    set(handles.text16, 'Visible', 'off');
    set(handles.delta, 'Visible', 'off');
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Step Size', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on');
    set(handles.quest_params, 'Title', 'Staircase Parameters');
    set(handles.mocs_radio, 'Visible', 'off');
    set(handles.fourtworadio, 'Visible', 'off');
elseif get(handles.fourtworadio, 'Value') == 1;
    set(handles.priorSD, 'Visible', 'off');
    set(handles.text14, 'Visible', 'off');
    set(handles.beta, 'Visible', 'off');
    set(handles.text16, 'Visible', 'off');
    set(handles.delta, 'Visible', 'off');
    set(handles.text19, 'Visible', 'off');
    set(handles.pCorrect, 'Visible', 'off');
    set(handles.text17, 'Visible', 'off');
    set(handles.text13, 'Visible', 'off');
    set(handles.npresent, 'Visible', 'off');
    set(handles.quest_params, 'Title', 'Staircase Parameters');
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
    set(handles.npresent, 'Visible', 'on');
    set(handles.quest_params, 'Title', 'MOCS Parameters');    
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
    



function xscale_Callback(hObject, eventdata, handles)
% hObject    handle to xscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xscale as text
%        str2double(get(hObject,'String')) returns contents of xscale as a double


% --- Executes during object creation, after setting all properties.
function xscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yscale_Callback(hObject, eventdata, handles)
% hObject    handle to yscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yscale as text
%        str2double(get(hObject,'String')) returns contents of yscale as a double


% --- Executes during object creation, after setting all properties.
function yscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in on_check.
function on_check_Callback(hObject, eventdata, handles)
% hObject    handle to on_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of on_check
