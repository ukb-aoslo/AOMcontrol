function varargout = BasicOneDotConfig(varargin)
%BASICONEDOTCONFIG M-file for BasicOneDotConfig.fig
%      BASICONEDOTCONFIG, by itself, creates a new BASICONEDOTCONFIG or raises the existing
%      singleton*.
%
%      H = BASICONEDOTCONFIG returns the handle to a new BASICONEDOTCONFIG or the handle to
%      the existing singleton*.
%
%      BASICONEDOTCONFIG('Property','Value',...) creates a new BASICONEDOTCONFIG using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to BasicOneDotConfig_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BASICONEDOTCONFIG('CALLBACK') and BASICONEDOTCONFIG('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BASICONEDOTCONFIG.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BasicOneDotConfig

% Last Modified by GUIDE v2.5 12-Jul-2012 10:13:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BasicOneDotConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @BasicOneDotConfig_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before BasicOneDotConfig is made visible.
function BasicOneDotConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for BasicOneDotConfig
handles.output = hObject;
global StimParams VideoParams;
hAomControl = getappdata(0,'hAomControl');
set(handles.videodur, 'String', '20');
set(handles.yloc, 'String','15');
set(handles.xloc, 'String','15');
set(handles.separation,'String','5');
set(handles.stimpath, 'String', [pwd,'\tempStimulus']);
set(handles.initials, 'String', 'test');
%set(handles.vidprefix, 'String', 'test');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BasicOneDotConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BasicOneDotConfig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
%stimpath = getappdata(hAomControl, 'stimpath');
CFG.ok = 1;
stimpath = [pwd,'\tempStimulus\'];
setappdata(hAomControl, 'stimpath', stimpath);
CFG.initials = get(handles.initials, 'String');
% CFG.pupilsize = get(handles.pupilsize, 'String');
% CFG.npresent = str2num(get(handles.npresent, 'String'));
CFG.stimpath = [pwd,'\tempStimulus\'];
CFG.separation = str2num(get(handles.separation,'String'));
CFG.xloc = str2num(get(handles.xloc,'String'));
CFG.yloc = str2num(get(handles.yloc,'String'));
CFG.initials = get(handles.initials, 'String');
CFG.vidprefix = get(handles.initials, 'String');
CFG.videodur = str2num(get(handles.videodur, 'String'));
CFG.presentdur = CFG.videodur;
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


% --- Executes on button press in set_stimpath.
function set_stimpath_Callback(hObject, eventdata, handles)
% hObject    handle to set_stimpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%stimpath = get(hObject,'string');
%set(handles.stimpath, 'String',stimpath );


function separation_Callback(hObject, eventdata, handles)
% hObject    handle to separation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of separation as text
%        str2double(get(hObject,'String')) returns contents of separation as a double
sep = (get(hObject,'string'));
set(handles.separation, 'string',sep );

% --- Executes during object creation, after setting all properties.
function separation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to separation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xloc_Callback(hObject, eventdata, handles)
% hObject    handle to xloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xloc as text
%        str2double(get(hObject,'String')) returns contents of xloc as a double

xloc = (get(hObject,'string'));
set(handles.xloc, 'string',xloc );


% --- Executes during object creation, after setting all properties.
function xloc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yloc_Callback(hObject, eventdata, handles)
% hObject    handle to yloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yloc as text
%        str2double(get(hObject,'String')) returns contents of yloc as a double
yloc = (get(hObject,'string'));
set(handles.yloc, 'string',yloc );


% --- Executes during object creation, after setting all properties.
function yloc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initials_Callback(hObject, eventdata, handles)
% hObject    handle to initials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initials as text
%        str2double(get(hObject,'String')) returns contents of initials as a double
user_entry = get(hObject,'string');
%if get(handles.auto_prefix, 'Value') == 1
    %set(handles.vidprefix, 'String', user_entry)
    set(handles.initials,'String',user_entry)
%elseif get(handles.auto_prefix, 'Value') == 0
    %do nothing
%end

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



function videodur_Callback(hObject, eventdata, handles)
% hObject    handle to videodur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of videodur as text
%        str2double(get(hObject,'String')) returns contents of videodur as a double


videodur = (get(hObject,'string'));
set(handles.videodur, 'string',videodur );

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
