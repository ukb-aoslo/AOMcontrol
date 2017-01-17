function varargout = ConeMappingConfig(varargin)
% CONEMAPPINGCONFIG M-file for ConeMappingConfig.fig
%      CONEMAPPINGCONFIG, by itself, creates a new CONEMAPPINGCONFIG or raises the existing
%      singleton*.
%
%      H = CONEMAPPINGCONFIG returns the handle to a new CONEMAPPINGCONFIG or the handle to
%      the existing singleton*.
%
%      CONEMAPPINGCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONEMAPPINGCONFIG.M with the given input arguments.
%
%      CONEMAPPINGCONFIG('Property','Value',...) creates a new CONEMAPPINGCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConeMappingConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConeMappingConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConeMappingConfig

% Last Modified by GUIDE v2.5 02-Apr-2014 14:33:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ConeMappingConfig_OpeningFcn, ...
    'gui_OutputFcn',  @ConeMappingConfig_OutputFcn, ...
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


% --- Executes just before ConeMappingConfig is made visible.
function ConeMappingConfig_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConeMappingConfig (see VARARGIN)

% Choose default command line output for ConeMappingConfig
global SYSPARAMS StimParams VideoParams ExpCfgParams;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConeMappingConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);
hAomControl = getappdata(0,'hAomControl');
% exp = getappdata(hAomControl, 'exp');

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

set(handles.ok_button, 'Enable', 'on');
set(handles.gain_lbl, 'Visible', 'On');
set(handles.gain, 'Visible', 'On');

drawPreview (handles);


% --- Outputs from this function are returned to the command line.
function varargout = ConeMappingConfig_OutputFcn(hObject, eventdata, handles)
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
if get(handles.mocs_radio,'Value')
set(handles.npresent,'Enable','off');
set(handles.npresent,'String',num2str(str2num(get(handles.delta,'String'))*str2num(get(handles.beta,'String'))));
end

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
if get(handles.mocs_radio,'Value')
set(handles.npresent,'Enable','off');
set(handles.npresent,'String',num2str(str2num(get(handles.delta,'String'))*str2num(get(handles.beta,'String'))));
end


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



% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
stimpath = [pwd,'\tempStimulus\'];
setappdata(hAomControl, 'stimpath', stimpath);

CFG.ok = 1;
CFG.stimpath = [pwd,'\tempStimulus\'];
CFG.initials = get(handles.initials, 'String');
CFG.pupilsize = str2num(get(handles.pupilsize, 'String'));
CFG.fieldsize = str2num(get(handles.fieldsize, 'String'));
CFG.videodur = str2num(get(handles.videodur, 'String'));
CFG.vidprefix = get(handles.vidprefix, 'String');
CFG.record = 1;
CFG.presentdur = str2num(get(handles.presentdur, 'String'));
CFG.iti = str2num(get(handles.iti,'String'));
CFG.stimsize = str2num(get(handles.stim_size, 'String'));
CFG.ir_stim_color = get(handles.ir_stim_radio, 'Value');
CFG.red_stim_color = get(handles.red_stim_radio, 'Value');
CFG.green_stim_color = get(handles.green_stim_radio, 'Value');
if get(handles.circle_button, 'Value') == 1;
    CFG.stim_shape = 'Circle';
elseif get(handles.square_button, 'Value') == 1;
    CFG.stim_shape = 'Square';
end
CFG.antialiased = get(handles.checkbox_antialiased,'Value');
if get(handles.quest_radio, 'Value') == 1;
    CFG.method = 'Quest';
elseif get(handles.twodown_radio, 'Value') == 1;
    CFG.method = 'Twodown';
     if get(handles.two_step_check, 'Value') == 1;
        CFG.second_step = get(handles.beta, 'String');
        CFG.num_reversals = get(handles.delta, 'String');
    else
        CFG.second_step = get(handles.priorSD, 'String');
        CFG.num_reversals = 0;
    end
elseif get(handles.fourtworadio, 'Value') == 1;
    CFG.method = '4-2';
elseif get(handles.mocs_radio, 'Value') == 1;
    CFG.method = 'Mocs';
end
   
if get(handles.yes_no_radio, 'Value') == 1;
    CFG.subject_response = 'y';
elseif get(handles.two_afc_radio, 'Value') == 1;
    CFG.subject_response = '2';
end    
CFG.two_step_check = get(handles.two_step_check, 'Value');
CFG.priorSD = str2num(get(handles.priorSD, 'String'));
CFG.pCorrect = str2num(get(handles.pCorrect, 'String'));
CFG.thresholdGuess = str2num(get(handles.thresholdGuess, 'String'));
CFG.beta = str2num(get(handles.beta, 'String'));
CFG.delta = str2num(get(handles.delta, 'String'));
CFG.offset_script = get(handles.offset_script, 'Value');
CFG.ncatch = str2num(get(handles.ncatch, 'String'));
CFG.nlapse = str2num(get(handles.nlapse, 'String'));
CFG.multidot = get(handles.checkbox_multidot,'Value');
CFG.selectionwidth = str2num(get(handles.edit_selectionWidth,'String'));
CFG.summation = get(handles.checkbox_summation,'Value');
CFG.pairs = get(handles.checkbox_pairs,'Value');
CFG.singlemax = get(handles.checkbox_max,'Value');
CFG.npresent = str2num(get(handles.npresent, 'String'));
CFG.twopoint = get(handles.checkbox_twopoint,'Value');
CFG.selectionWidthtwopoint = str2num(get(handles.edit_selectionWidthtwopoint,'String'));
CFG.gain = str2num(get(handles.gain, 'String'));    
CFG.compute_fit = get(handles.computefit_check, 'Value');
CFG.kb_repeat = get(handles.edit_kb_repeat, 'String');
CFG.kb_next = get(handles.edit_kb_next, 'String');
CFG.kb_no = get(handles.edit_kb_no, 'String');
CFG.kb_yes = get(handles.edit_kb_yes, 'String');
CFG.green_x_offset = str2num(get(handles.green_x_offset,'String'));
CFG.green_y_offset = str2num(get(handles.green_y_offset,'String'));
CFG.red_x_offset = str2num(get(handles.red_x_offset,'String'));
CFG.red_y_offset = str2num(get(handles.red_y_offset,'String'));

% Save the same for retrieval while loading last values
ExpCfgParams = CFG;

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






% --- Executes when selected object is changed in method_radio_panel.
function method_radio_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in method_radio_panel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global SYSPARAMS StimParams VideoParams ExpCfgParams;

if get(handles.quest_radio, 'Value') == 1;
    set(handles.priorSD, 'Visible', 'on');
    set(handles.priorSD, 'String', 1);
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
    set(handles.priorSD, 'Visible', 'on');
    set(handles.priorSD, 'String', ExpCfgParams.priorSD);
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
elseif get(handles.mocs_radio, 'Value') == 1;
    set(handles.priorSD, 'String', 100, 'Visible', 'on');   %range aka PriorSD
    set(handles.text14, 'Visible', 'on', 'String', 'Levels');
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
    set(handles.npresent,'Enable','off');
    set(handles.npresent,'String',num2str(str2num(get(handles.delta,'String'))*str2num(get(handles.beta,'String'))));
    
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
drawPreview (handles);

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
    set(handles.checkbox_antialiased,'Visible','on');
elseif get(handles.square_button, 'Value') ==1;
    set(handles.circle_button, 'Value', 0);
    set(handles.checkbox_antialiased,'Visible','off');
end
drawPreview (handles);
disp('Selection done')



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

global SYSPARAMS StimParams VideoParams ExpCfgParams; %#ok<*NUSED>

if last==1
    load('lastSensitivityCFG.mat');
else %Set default values here
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.pupilsize = 6.0;
    ExpCfgParams.fieldsize = 2.2; 
    ExpCfgParams.videodur = 1; 
    ExpCfgParams.presentdur = 1;
    ExpCfgParams.iti = 1000;
    ExpCfgParams.stimsize = 5;
    ExpCfgParams.ir_stim_color = 0;
    ExpCfgParams.red_stim_color = 1;
    ExpCfgParams.green_stim_color = 0;
    ExpCfgParams.stim_shape = 'Square';
    ExpCfgParams.antialiased = 0;
    ExpCfgParams.method = 'Quest';
    ExpCfgParams.subject_response = 'y';
    ExpCfgParams.two_step_check = 0;
    ExpCfgParams.priorSD = 1;
    ExpCfgParams.pCorrect = 50;
    ExpCfgParams.thresholdGuess = 0.5;
    ExpCfgParams.beta = 3.5;
    ExpCfgParams.delta = 0.01;
    ExpCfgParams.offset_script = 0;
    ExpCfgParams.ncatch = 0;
    ExpCfgParams.nlapse = 0;
    ExpCfgParams.multidot = 0;
    ExpCfgParams.selectionwidth = 59;
    ExpCfgParams.summation = 0;
    ExpCfgParams.pairs = 0;
    ExpCfgParams.singlemax = 0;
    ExpCfgParams.npresent = 22;
    ExpCfgParams.twopoint = 0;
    ExpCfgParams.selectionWidthtwopoint = 69;
    ExpCfgParams.gain = 1;
    ExpCfgParams.compute_fit = 0;
    ExpCfgParams.kb_repeat = 'uparrow';
    ExpCfgParams.kb_next = 'space';
    ExpCfgParams.kb_no = 'leftarrow';
    ExpCfgParams.kb_yes = 'rightarrow';
    ExpCfgParams.green_x_offset = 0;
    ExpCfgParams.green_y_offset = 0;
    ExpCfgParams.red_x_offset = 0;
    ExpCfgParams.red_y_offset = 0;
    
%     ExpCfgParams.text17 = 1;
%     ExpCfgParams.text19 = 1;
%     ExpCfgParams.text15 = 1;
%     ExpCfgParams.text14 = 1;
%     ExpCfgParams.text16 = 1;
end

set(handles.initials, 'String', ExpCfgParams.initials);
set(handles.pupilsize, 'String', ExpCfgParams.pupilsize);
set(handles.fieldsize, 'String', ExpCfgParams.fieldsize);
set(handles.videodur, 'String', ExpCfgParams.videodur);
set(handles.vidprefix, 'String', VideoParams.vidprefix);
set(handles.presentdur, 'String', ExpCfgParams.presentdur);
set(handles.iti, 'String', ExpCfgParams.iti);
set(handles.stim_size, 'String', ExpCfgParams.stimsize);
set(handles.ir_stim_radio, 'Value', ExpCfgParams.ir_stim_color);
set(handles.red_stim_radio, 'Value', ExpCfgParams.red_stim_color);
set(handles.green_stim_radio, 'Value', ExpCfgParams.green_stim_color);
if strcmp(ExpCfgParams.stim_shape,'Circle')
    set(handles.circle_button, 'Value', 1);
    set(handles.square_button, 'Value', 0);
else
    set(handles.circle_button, 'Value', 0);
    set(handles.square_button, 'Value', 1);
end
set(handles.checkbox_antialiased,'Value', ExpCfgParams.antialiased);
if strcmp(ExpCfgParams.method,'Quest')
    set(handles.quest_radio, 'Value',1);
    set(handles.fourtworadio, 'Value',0);
    set(handles.twodown_radio, 'Value',0);
    set(handles.mocs_radio, 'Value',0);
elseif strcmp(ExpCfgParams.method,'Twodown')
    set(handles.quest_radio, 'Value',0);
    set(handles.fourtworadio, 'Value',0);
    set(handles.twodown_radio, 'Value',1);
    set(handles.mocs_radio, 'Value',0);
elseif strcmp(ExpCfgParams.method,'4-2')
    set(handles.quest_radio, 'Value',0);
    set(handles.fourtworadio, 'Value',1);
    set(handles.twodown_radio, 'Value',0);
    set(handles.mocs_radio, 'Value',0);
elseif strcmp(ExpCfgParams.method,'Mocs')
    set(handles.quest_radio, 'Value',0);
    set(handles.fourtworadio, 'Value',0);
    set(handles.twodown_radio, 'Value',0);
    set(handles.mocs_radio, 'Value',1);
    
end
if strcmp(ExpCfgParams.subject_response,'y')
    set(handles.yes_no_radio, 'Value', 1);
    set(handles.two_afc_radio, 'Value', 0);
else
    set(handles.yes_no_radio, 'Value', 0);
    set(handles.two_afc_radio, 'Value', 1);
end
set(handles.two_step_check, 'Value', ExpCfgParams.two_step_check);
set(handles.priorSD, 'String', ExpCfgParams.priorSD);
set(handles.pCorrect, 'String', ExpCfgParams.pCorrect);
set(handles.thresholdGuess, 'String', ExpCfgParams.thresholdGuess);
set(handles.beta, 'String', ExpCfgParams.beta);
set(handles.delta, 'String', ExpCfgParams.delta);
set(handles.offset_script, 'Value', ExpCfgParams.offset_script);
set(handles.ncatch, 'String', ExpCfgParams.ncatch);
set(handles.nlapse, 'String', ExpCfgParams.nlapse);
set(handles.checkbox_multidot,'Value', ExpCfgParams.multidot);
set(handles.edit_selectionWidth,'String', ExpCfgParams.selectionwidth);
set(handles.checkbox_summation,'Value', ExpCfgParams.summation);
set(handles.checkbox_pairs,'Value', ExpCfgParams.pairs);
set(handles.checkbox_max,'Value', ExpCfgParams.singlemax);
set(handles.checkbox_twopoint,'Value', ExpCfgParams.twopoint);
set(handles.edit_selectionWidthtwopoint,'String', ExpCfgParams.selectionWidthtwopoint);
set(handles.npresent, 'String', ExpCfgParams.npresent);
set(handles.gain, 'String', ExpCfgParams.gain);
set(handles.computefit_check, 'Value',ExpCfgParams.compute_fit);
set(handles.edit_kb_repeat, 'String',ExpCfgParams.kb_repeat);
set(handles.edit_kb_next, 'String',ExpCfgParams.kb_next);
set(handles.edit_kb_no, 'String',ExpCfgParams.kb_no);
set(handles.edit_kb_yes, 'String',ExpCfgParams.kb_yes);
set(handles.green_x_offset, 'String', ExpCfgParams.green_x_offset);
set(handles.green_y_offset, 'String', ExpCfgParams.green_y_offset);
set(handles.red_x_offset, 'String', ExpCfgParams.red_x_offset);
set(handles.red_y_offset, 'String', ExpCfgParams.red_y_offset);

set(handles.ok_button, 'Enable', 'on');
if get(handles.quest_radio, 'Value') == 1;
    set(handles.priorSD, 'Visible', 'on');
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
    set(handles.priorSD, 'Visible', 'on');
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
    set(handles.priorSD, 'String', ExpCfgParams.priorSD, 'Visible', 'on');   %range aka PriorSD
    set(handles.text14, 'Visible', 'on', 'String', 'Levels');
    set(handles.beta, 'Visible', 'on', 'String', ExpCfgParams.beta);
    set(handles.text16, 'Visible', 'on', 'String', 'Trials/Level');
    set(handles.delta, 'Visible', 'on', 'String', ExpCfgParams.delta);
    set(handles.text19, 'Visible', 'on');
    set(handles.pCorrect, 'Visible', 'on');
    set(handles.text17, 'String', 'Range', 'Visible', 'on');
    set(handles.text13, 'Visible', 'on');
    set(handles.npresent, 'Visible', 'on', 'Enable', 'on');
    set(handles.quest_params, 'Title', 'MOCS Parameters');
    set(handles.two_step_check, 'Visible', 'off');
    set(handles.computefit_check, 'Enable', 'on');
    set(handles.npresent,'Enable','off');
    set(handles.npresent,'String',num2str(str2num(get(handles.delta,'String'))*str2num(get(handles.beta,'String'))));
end



user_entry = get(handles.initials,'String');
if get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'String', user_entry)
end

if get(handles.offset_script,'Value')==1
    set(handles.uipanel_offsetscript,'Visible','On');
else
    set(handles.uipanel_offsetscript,'Visible','Off');
end

if get(handles.checkbox_multidot,'Value')==1
    set(handles.uipanel_multidot,'Visible','On');
else
    set(handles.uipanel_multidot,'Visible','Off');
end

if get(handles.checkbox_summation,'Value')==1
    set(handles.uipanel_summation,'Visible','On');
else
    set(handles.uipanel_summation,'Visible','Off');
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
    set(handles.ir_stim_radio, 'Value', 0);
elseif get(handles.green_stim_radio, 'Value') ==1;
    set(handles.red_stim_radio, 'Value', 0);
    set(handles.ir_stim_radio, 'Value', 0);
elseif get(handles.ir_stim_radio, 'Value') == 1;
    set(handles.red_stim_radio, 'Value', 0);
    set(handles.green_stim_radio, 'Value', 0);
end
drawPreview (handles);


% if get(handles.offset_script, 'Value')==1
%     set(handles.catch_text, 'Visible', 'on')
%     set(handles.lapse_text, 'Visible', 'on')
%     set(handles.ncatch, 'Visible', 'on')
%     set(handles.nlapse, 'Visible', 'on')
% elseif get(handles.offset_script, 'Value')==0
%     set(handles.catch_text, 'Visible', 'off')
%     set(handles.lapse_text, 'Visible', 'off')
%     set(handles.ncatch, 'Visible', 'off')
%     set(handles.nlapse, 'Visible', 'off')
% else
%     %do nothing
%     

    



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over offset_script.
function offset_script_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to offset_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function ncatch_Callback(hObject, eventdata, handles)
% hObject    handle to ncatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncatch as text
%        str2double(get(hObject,'String')) returns contents of ncatch as a double


% --- Executes during object creation, after setting all properties.
function ncatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nlapse_Callback(hObject, eventdata, handles)
% hObject    handle to nlapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nlapse as text
%        str2double(get(hObject,'String')) returns contents of nlapse as a double


% --- Executes during object creation, after setting all properties.
function nlapse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nlapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function edit_selectionWidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_selectionWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_selectionWidth as text
%        str2double(get(hObject,'String')) returns contents of edit_selectionWidth as a double


% --- Executes during object creation, after setting all properties.
function edit_selectionWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_selectionWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_antialiased.
function checkbox_antialiased_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_antialiased (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_antialiased
drawPreview (handles);


function edit_kb_repeat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_repeat as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_repeat as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_repeat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_no_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_no as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_no as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_yes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_yes as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_yes as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_yes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_next_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_next as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_next as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_next_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in offset_script.
function offset_script_Callback(hObject, eventdata, handles)
% hObject    handle to offset_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of offset_script

if get(hObject,'Value')==1
    set(handles.uipanel_offsetscript,'Visible','On');
    set(handles.checkbox_summation,'Value',0);
    set(handles.checkbox_multidot,'Value',0);
    set(handles.checkbox_twopoint,'Value',0);
    set(handles.uipanel_summation,'Visible','Off');
    set(handles.uipanel_multidot,'Visible','Off');
    set(handles.uipanel_twopoint,'Visible','Off');
    
    set(handles.thresholdGuess,'BackgroundColor',[1 1 1]);
    set(handles.delta,'BackgroundColor',[1 1 1]);
else
    set(handles.uipanel_offsetscript,'Visible','Off');
end

% --- Executes on button press in checkbox_multidot.
function checkbox_multidot_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_multidot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_multidot
if get(hObject,'Value')==1
    set(handles.uipanel_multidot,'Visible','On');
    set(handles.checkbox_summation,'Value',0);
    set(handles.offset_script,'Value',0);
    set(handles.checkbox_twopoint,'Value',0);
    set(handles.uipanel_summation,'Visible','Off');
    set(handles.uipanel_offsetscript,'Visible','Off');
    set(handles.uipanel_twopoint,'Visible','Off');
    
    set(handles.thresholdGuess,'BackgroundColor',[1 1 1]);
    set(handles.delta,'BackgroundColor',[1 1 1]);
     
   
else
    set(handles.uipanel_multidot,'Visible','Off');
end


% --- Executes on button press in checkbox_summation.
function checkbox_summation_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_summation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_summation
if get(hObject,'Value')==1
    set(handles.uipanel_summation,'Visible','On');
    set(handles.checkbox_multidot,'Value',0);
    set(handles.checkbox_twopoint,'Value',0);
    set(handles.offset_script,'Value',0);
    set(handles.uipanel_multidot,'Visible','Off');
    set(handles.uipanel_offsetscript,'Visible','Off');
    set(handles.uipanel_twopoint,'Visible','Off');
    
    set(handles.thresholdGuess,'BackgroundColor',[1 1 1]);
    set(handles.delta,'BackgroundColor',[1 1 1]);
    
    
else
    set(handles.uipanel_summation,'Visible','Off');
end



% --- Executes on button press in checkbox_twopoint.
function checkbox_twopoint_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_twopoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_twopoint
if get(hObject,'Value')==1
    set(handles.uipanel_twopoint,'Visible','On');
    
    set(handles.checkbox_summation,'Value',0);
    set(handles.checkbox_multidot,'Value',0);
    set(handles.offset_script,'Value',0);
    set(handles.uipanel_summation,'Visible','Off');
    set(handles.uipanel_multidot,'Visible','Off');
    set(handles.uipanel_offsetscript,'Visible','Off');
    
    set(handles.thresholdGuess,'BackgroundColor',[1 0 0]);
    set(handles.delta,'BackgroundColor',[1 0 0]);
        
    
else
    set(handles.uipanel_twopoint,'Visible','Off');
    set(handles.thresholdGuess,'BackgroundColor',[1 1 1]);
    set(handles.delta,'BackgroundColor',[1 1 1]);
    
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_pairs.
function checkbox_pairs_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to checkbox_pairs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pairs
if get(hObject,'Value')
    set(handles.checkbox_max,'Value',0);
end



% --- Executes on button press in checkbox_max.
function checkbox_max_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_max
if get(hObject,'Value')
    set(handles.checkbox_pairs,'Value',0);
end


% --- Executes during object creation, after setting all properties.
function axes_preview_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to axes_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_preview



function drawPreview (handles)

dia  = str2num(get(handles.stim_size,'String')); %#ok<*ST2NM>

if get(handles.square_button,'Value')==1  % SQUARE STIMULUS
    
    stim = ones(dia,dia);
    padh = zeros(1,size(stim,1)); padv = zeros(size(stim,1)+2,1);
    stim=[padh; stim; padh]; stim=[padv stim padv];
    padh = zeros(1,size(stim,1)); padv = zeros(size(stim,1)+1,1);
    stim=[stim; padh]; stim=[stim padv];
    
elseif get(handles.circle_button,'Value')==1  % CIRCLE STIMULUS
    
    [rr cc] = meshgrid(1:dia+1);
    if mod(dia,2)==0
        stim = sqrt((rr-((dia+1)/2)).^2+(cc-((dia+1)/2)).^2)<=((dia)/2);
    else
        if dia <= 3
            stim = sqrt((rr-ceil((dia)/2)).^2+(cc-ceil((dia)/2)).^2)<=ceil((dia-1)/2);
        elseif dia <=5
            stim = sqrt((rr-floor((dia+1)/2)).^2+(cc-floor((dia+1)/2)).^2)<=((dia)/2);
        else
            stim = sqrt((rr-floor((dia+1)/2)).^2+(cc-floor((dia+1)/2)).^2)<=((dia)/2);
        end
        
    end
    padh = zeros(1,size(stim,1)); padv = zeros(size(stim,1)+2,1);
    stim=[padh; stim; padh]; stim=[padv stim padv];
end

if get(handles.checkbox_antialiased,'Value')
         f = fspecial('gaussian',[3 3],1);
         stim = imfilter(stim,f,'replicate');
end

pixels_stim = sum(stim(:));

[ir_map r_map g_map] = deal(zeros(64,3));
ir_map(1:64,1) = fliplr(0:0.3/63:0.3);
r_map(1:64,1) = 0.3:0.7/63:1;
g_map(33:64,1) = 0:0.3/31:0.3; g_map(1:64,2) = fliplr(0:1/63:1);
g_map = flipud(g_map);

h1 = surf(stim); set(h1,'LineWidth',1);
if dia>=16
set(h1,'EdgeColor','none');
else
set(h1,'EdgeColor',[.5 .5 .5]);
end
view(90,90); axis tight; axis off;

if get(handles.ir_stim_radio,'Value')==1
    colormap(ir_map)
elseif get(handles.red_stim_radio,'Value')==1
    colormap(r_map)
elseif get(handles.green_stim_radio,'Value')==1
    colormap(g_map)
end

set(handles.text_pixelcount,'String',['PixelSum: ',num2str(pixels_stim)]);



% --- Executes when selected object is changed in uipanel_shape.
function uipanel_shape_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_shape 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.circle_button, 'Value')==1;
    set(handles.square_button, 'Value', 0);
elseif get(handles.square_button, 'Value') ==1;
    set(handles.circle_button, 'Value', 0);
end
drawPreview (handles);



function edit_selectionWidthtwopoint_Callback(hObject, eventdata, handles)
% hObject    handle to edit_selectionWidthtwopoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_selectionWidthtwopoint as text
%        str2double(get(hObject,'String')) returns contents of edit_selectionWidthtwopoint as a double


% --- Executes during object creation, after setting all properties.
function edit_selectionWidthtwopoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_selectionWidthtwopoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

