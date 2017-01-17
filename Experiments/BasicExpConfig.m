function varargout = BasicExpConfig(varargin)
% BASICEXPCONFIG MATLAB code for BasicExpConfig.fig
%      BASICEXPCONFIG, by itself, creates a new BASICEXPCONFIG or raises the existing
%      singleton*.
%
%      H = BASICEXPCONFIG returns the handle to a new BASICEXPCONFIG or the handle to
%      the existing singleton*.
%
%      BASICEXPCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASICEXPCONFIG.M with the given input arguments.
%
%      BASICEXPCONFIG('Property','Value',...) creates a new BASICEXPCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BasicExpConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BasicExpConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BasicExpConfig

% Last Modified by GUIDE v2.5 11-Apr-2012 10:03:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BasicExpConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @BasicExpConfig_OutputFcn, ...
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


% --- Executes just before BasicExpConfig is made visible.
function BasicExpConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BasicExpConfig (see VARARGIN)

% Choose default command line output for BasicExpConfig
handles.output = hObject;
hAomControl = getappdata(0,'hAomControl');
%stimpath = getappdata(hAomControl, 'stimpath');
init_load = 0;
if exist('Experiments\lastBasicCFG.mat','file')==2
    CFG = load('Experiments\lastBasicCFG.mat');
    init_load = 1;
    setappdata(hAomControl, 'CFG', CFG);
end
if (init_load == 0) %load defaults    
    CFG.initials = 'Sample';
    CFG.psize = 5.81;
    CFG.fsize = 1.2;
    CFG.pdur = 500;
    CFG.tdur = 1000;
    CFG.loadseq = 0;
    CFG.seqpath = '';
    CFG.vdur = 1;
    CFG.autopfx = 1;
    CFG.vpfx = 'Sample';
    CFG.stimconst = ' ';
    CFG.upconst = 'U';
    CFG.leftconst = 'L';
    CFG.downconst = 'D';
    CFG.rightconst = 'R';
    CFG.ntrials = 40;
    CFG.gain = 1.0;
    CFG.angle = 0;
    CFG.beep = 1;
    stimpath = getappdata(hAomControl, 'stimpath');
    CFG.stimpath = [stimpath  'Es_5-20\']; 
    setappdata(hAomControl, 'CFG', CFG);
end

set(handles.initials, 'String', CFG.initials);
set(handles.pupilsize, 'String', num2str(CFG.psize, '%1.2f'));
set(handles.fieldsize, 'String', num2str(CFG.fsize, '%1.2f'));
set(handles.presentdur, 'String', num2str(CFG.pdur));
set(handles.trial_dur, 'String', num2str(CFG.tdur));
set(handles.load_seq, 'Value', CFG.loadseq);
set(handles.videodur, 'String', num2str(CFG.vdur));
set(handles.auto_prefix, 'Value', CFG.autopfx);
set(handles.vidprefix, 'String', CFG.vpfx);
set(handles.kb_StimConst, 'String', CFG.stimconst);
set(handles.kb_UpArrow, 'String', CFG.upconst);
set(handles.kb_LeftArrow, 'String', CFG.leftconst);
set(handles.kb_DownArrow, 'String', CFG.downconst);
set(handles.kb_RightArrow, 'String', CFG.rightconst);
set(handles.npresent, 'String', num2str(CFG.ntrials));
set(handles.gain, 'String', num2str(CFG.gain, '%1.2f'));
set(handles.angle, 'String', num2str(CFG.angle));
set(handles.stim_pres_beep, 'Value', CFG.beep);
set(handles.stimpath, 'String', CFG.stimpath);
% Update handles structure
guidata(hObject, handles);
load_seq_Callback(hObject, 0, handles);

% UIWAIT makes BasicExpConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BasicExpConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function trial_dur_Callback(hObject, eventdata, handles)
% hObject    handle to trial_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_dur as text
%        str2double(get(hObject,'String')) returns contents of trial_dur as a double


% --- Executes during object creation, after setting all properties.
function trial_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_seq.
function load_seq_Callback(hObject, eventdata, handles)
% hObject    handle to load_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of load_seq
if get(handles.load_seq, 'Value') == 1
    %enable load sequence browse button
    set(handles.browse_seq, 'Enable', 'on');
    %disable trial number duration, gain, angle, stimbeep fields
    set(handles.presentdur, 'Enable', 'off');
    set(handles.trial_dur, 'Enable', 'off');
    set(handles.npresent, 'Enable', 'off');
    set(handles.gain, 'Enable', 'off');
    set(handles.angle, 'Enable', 'off');
    set(handles.stim_pres_beep, 'Enable', 'off');
else
    %disable load sequence browse button
    set(handles.browse_seq, 'Enable', 'off');
    %enable trial number duration, gain, angle, stimbeep fields
    set(handles.presentdur, 'Enable', 'on');
    set(handles.trial_dur, 'Enable', 'on');
    set(handles.npresent, 'Enable', 'on');
    set(handles.gain, 'Enable', 'on');
    set(handles.angle, 'Enable', 'on');
    set(handles.stim_pres_beep, 'Enable', 'on');
end


% --- Executes on button press in browse_seq.
function browse_seq_Callback(hObject, eventdata, handles)
% hObject    handle to browse_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');
CFG.seqpath = uigetdir('path','Select directory containing the stimuli');
setappdata(hAomControl, 'CFG', CFG);


function initials_Callback(hObject, eventdata, handles)
% hObject    handle to initials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initials as text
%        str2double(get(hObject,'String')) returns contents of initials as a double


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


% --- Executes on button press in set_stimpath.
function set_stimpath_Callback(hObject, eventdata, handles)
% hObject    handle to set_stimpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stimpath = uigetdir('path','Select directory containing the stimuli');
set(handles.stimpath, 'String', [stimpath '\']);


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');
CFG.ok = 1;
CFG.initials = get(handles.initials, 'String');
CFG.psize = get(handles.pupilsize, 'String');
CFG.fsize = get(handles.fieldsize, 'String');
CFG.pdur = str2num(get(handles.presentdur, 'String'));
CFG.tdur = str2num(get(handles.trial_dur, 'String'));
CFG.loadseq = get(handles.load_seq, 'Value');
CFG.ntrials = str2num(get(handles.npresent,'String'));
CFG.gain = str2num(get(handles.gain, 'String'));
CFG.angle = str2num(get(handles.angle, 'String'));
CFG.vdur = str2num(get(handles.videodur, 'String'));
CFG.vpfx = get(handles.vidprefix, 'String');
CFG.stimconst = get(handles.kb_StimConst, 'String');
CFG.upconst = get(handles.kb_UpArrow, 'String');
CFG.leftconst = get(handles.kb_LeftArrow, 'String');
CFG.downconst = get(handles.kb_DownArrow, 'String');
CFG.rightconst = get(handles.kb_RightArrow, 'String');
CFG.record = 1;
CFG.stimpath = get(handles.stimpath,'String');
setappdata(hAomControl, 'CFG', CFG);
save('Experiments\lastBasicCFG.mat', '-struct', 'CFG');
close;


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');
CFG.ok = 0;
setappdata(hAomControl, 'CFG', CFG);
close;


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


% --- Executes on button press in stim_pres_beep.
function stim_pres_beep_Callback(hObject, eventdata, handles)
% hObject    handle to stim_pres_beep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stim_pres_beep
