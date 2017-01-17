function varargout = ExpConfig(varargin)
% ExpConfig M-file for ExpConfig.fig
%      ExpConfig, by itself, creates a new ExpConfig or raises the existing
%      singleton*.
%
%      H = ExpConfig returns the handle to a new ExpConfig or the handle to
%      the existing singleton*.
%
%      ExpConfig('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ExpConfig.M with the given input arguments.
%
%      ExpConfig('Property','Value',...) creates a new ExpConfig or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExpConfig_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExpConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ExpConfig

% Last Modified by GUIDE v2.5 06-Jun-2007 12:58:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExpConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @ExpConfig_OutputFcn, ...
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


% --- Executes just before ExpConfig is made visible.
function ExpConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExpConfig (see VARARGIN)

% Choose default command line output for ExpConfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExpConfig wait for user response (see UIRESUME)
%uiwait(handles.figure1);

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');

if exp(1) == 'V' || exp(1) == 'C';
    %open normally
elseif exp(1) == 'W' || exp(1) == 'S';
    %do something else

    set(handles.method_radio_panel, 'Visible', 'off');
    set(handles.stim_panel, 'Visible', 'off');
    set(handles.npresentationslabel, 'String','Presentations');
    set(handles.npresent, 'String', 10);   
end

% --- Outputs from this function are returned to the command line.
function varargout = ExpConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in computethresh.
function computethresh_Callback(hObject, eventdata, handles)
% hObject    handle to computethresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of computethresh

function initials_Callback(hObject, eventdata, handles)
% hObject    handle to initials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end
% Hints: get(hObject,'String') returns contents of initials as text
%        str2double(get(hObject,'String')) returns contents of initials as
%        a double

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
CFG.port = get(handles.port, 'String');
CFG.baudrate = str2num(get(handles.baudrate, 'String'));
CFG.buffersize = str2num(get(handles.buffersize, 'String'));
CFG.kb_StimConst = uint8(get(handles.kb_StimConst, 'String'));
CFG.kb_UpArrow = get(handles.kb_UpArrow, 'String');
CFG.kb_DownArrow = get(handles.kb_DownArrow, 'String');
CFG.kb_LeftArrow = get(handles.kb_LeftArrow, 'String');
CFG.kb_RightArrow = get(handles.kb_RightArrow, 'String');
CFG.record = 1;
if get(handles.quest_radio, 'Value') == 1;
    CFG.method = 'q';
elseif get(handles.mocs_radio, 'Value') == 1;
    CFG.method = 'm';
end

if get(handles.e_stim_radio, 'Value') == 1;
    CFG.stimtype = 'e';
elseif get(handles.sw_stim_radio, 'Value') == 1;
    CFG.stimtype = 's';
elseif get(handles.twopt_stim_radio, 'Value') == 1;
    CFG.stimtype = 'd';
end


if get(handles.sizerange1, 'Value') == 1;
    CFG.sizerange = get(handles.sizerange1, 'String');
elseif get(handles.sizerange2, 'Value') == 1;
    CFG.sizerange = get(handles.sizerange2, 'String');
else
    %error
end
%quest data for CSF experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CFG.nIntervals = str2num(get(handles.nIntervals, 'String'));
CFG.beta = str2num(get(handles.beta, 'String'));
CFG.delta = str2num(get(handles.delta, 'String'));
CFG.responses = str2num(get(handles.responses, 'String'));
CFG.pCorrect = str2num(get(handles.pCorrect, 'String'));
CFG.thresholdGuess = str2num(get(handles.thresholdGuess, 'String'));
CFG.priorSD = str2num(get(handles.priorSD, 'String'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%spatial filter parameters%%%%%%%%%%%%%%%%%%%%%%%
if get(handles.filter_checkbox, 'Value') == 0;
    CFG.filter = 'none';
    CFG.cutoff = 'na';
    CFG.filtersize = 'na';
elseif get(handles.filter_checkbox, 'Value') == 1;
    if get(handles.window_radio, 'Value') == 1;
        CFG.filter = 'window';
        CFG.cutoff = str2num(get(handles.cutoff,'String'));
        CFG.filtersize = str2num(get(handles.filtersize,'String'));
    elseif get(handles.ideal_radio, 'Value') == 1;
        CFG.filter = 'ideal';        
        CFG.cutoff = str2num(get(handles.cutoff,'String'));
        CFG.filtersize = 'na';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CFG.psypath = get(handles.psypath, 'String');
CFG.compute = get(handles.computethresh, 'Value');
setappdata(hAomControl, 'CFG', CFG);

stimpath = get(handles.stimpath, 'String');
setappdata(hAomControl, 'stimpath', stimpath);
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

% --- Executes on button press in setpsypath.
function setpsypath_Callback(hObject, eventdata, handles)
% hObject    handle to setpsypath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
stimpath = getappdata(hAomControl, 'stimpath');

psypname = uigetdir('path','Select directory for PSY file output');
if exp(end-1) == 'S'
    sr1 = get(handles.sizerange1, 'Value');
    sr2 = get(handles.sizerange2, 'Value');
    cr  = get(handles.customrange, 'Value');
    if psypname == 0;
    %do nothing
    elseif stimpath(1) == '<'
    %do nothing
    elseif sr1 == 0 && sr2 == 0 && cr == 0
        %do nothing
    else
    psypname = [psypname '\'];
    set(handles.psypath, 'String', psypname);
    set(handles.ok_button, 'Enable', 'on');
    end
elseif exp(1) == 'C'
    if psypname == 0;
        %do nothing
    else
    psypname = [psypname '\'];
    set(handles.psypath, 'String', psypname);
    set(handles.ok_button, 'Enable', 'on');
    end
elseif exp(end-1) == 'T'
     if psypname == 0;
        %do nothing
    else
    psypname = [psypname '\'];
    set(handles.psypath, 'String', psypname);
    set(handles.ok_button, 'Enable', 'on');
    end
else
    psypname = [psypname '\'];
    set(handles.psypath, 'String', psypname);
    set(handles.ok_button, 'Enable', 'on');%reserved for new experiment
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

% --- Executes on button press in sizerange1.
function sizerange1_Callback(hObject, eventdata, handles)
% hObject    handle to sizerange1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end
hAomControl = getappdata(0,'hAomControl');
stimpath = getappdata(hAomControl,'stimpath');
    
    rangepath = get(handles.sizerange1, 'UserData');
    sr1path = [stimpath rangepath];
    set(handles.stimpath, 'String', sr1path);
    set(handles.set_stimpath, 'Enable', 'off');
    psypath = get(handles.psypath, 'String');
        
    if stimpath(1) ~= '<' && psypath(1) ~= '<'
        set(handles.ok_button, 'Enable', 'on');
    else
        %do nothing
    end


    % --- Executes on button press in sizerange2.
function sizerange2_Callback(hObject, eventdata, handles)
% hObject    handle to sizerange2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

hAomControl = getappdata(0,'hAomControl');
stimpath = getappdata(hAomControl,'stimpath');
% Hint: get(hObject,'Value') returns toggle state of sizerange2
    rangepath = get(handles.sizerange2, 'UserData');
    sr2path = [stimpath rangepath];
    set(handles.stimpath, 'String', sr2path);
    set(handles.set_stimpath, 'Enable', 'off');
    psypath = get(handles.psypath, 'String');
    
if stimpath(1) ~= '<' && psypath(1) ~= '<'
        set(handles.ok_button, 'Enable', 'on');
    else
        %do nothing
end
    

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function baudrate_Callback(hObject, eventdata, handles)
% hObject    handle to baudrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baudrate as text
%        str2double(get(hObject,'String')) returns contents of baudrate as a double


% --- Executes during object creation, after setting all properties.
function baudrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function buffersize_Callback(hObject, eventdata, handles)
% hObject    handle to buffersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of buffersize as text
%        str2double(get(hObject,'String')) returns contents of buffersize as a double


% --- Executes during object creation, after setting all properties.
function buffersize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buffersize (see GCBO)
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

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');

if exp(1) == 'C'
    set(hObject, 'String',2);
elseif exp(1) == 'W'
    set(hObject, 'String','UL');
    %error, no experiment chosen
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

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');

if exp(1) == 'C'
    set(hObject, 'String', 1);
elseif exp(1) == 'W' 
    set(hObject, 'String','UR');    
else
    %error, no experiment chosen
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

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');

if exp(1) == 'C'
    set(hObject, 'String', 1);
elseif exp(1) == 'W' 
    set(hObject, 'String','LL');
    %error, no experiment chosen
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

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');

if exp(1) == 'C'
    set(hObject, 'String', 2);
elseif exp(1) == 'W' 
    set(hObject, 'String','LR');
elseif exp(1) == 'B'
    %error, no experiment chosen
end




function port_Callback(hObject, eventdata, handles)
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port as text
%        str2double(get(hObject,'String')) returns contents of port as a double


% --- Executes during object creation, after setting all properties.
function port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port (see GCBO)
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
set(handles.stimpath, 'String', stimpath);
psypath = get(handles.psypath, 'String');
sr1 = get(handles.sizerange1, 'Value');
sr2 = get(handles.sizerange2, 'Value');
%cr  = get(handles.customrange, 'Value');

if stimpath == 0;
    %do nothing
elseif psypath(1) == '<'
    %do nothing
%elseif sr1 == 0 && sr2 == 0 && cr == 0
    %do nothing
else
    set(handles.ok_button, 'Enable', 'on');
    hAomControl = getappdata(0,'hAomControl');
    setappdata(hAomControl, 'stimpath', stimpath);
end

% --- Executes during object creation, after setting all properties.
function stimpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl,'exp');
stimpath = getappdata(hAomControl,'stimpath');

if exp(1) == 'V'
    set(hObject, 'Enable', 'off');
    stimpath = [stimpath 'Es_2.5-40'];
    set(hObject, 'String', stimpath);
elseif exp(1) == 'C'
    set(hObject, 'Enable', 'off');
elseif exp(1) == 'W'
    set(hObject,'Enable', 'off');
    stimpath = getappdata(hAomControl, 'stimpath');
    stimpath = [stimpath 'WAIL'];
    set(hObject, 'String', stimpath);
elseif exp(1) == 'S'
    set(hObject,'Enable', 'off');
    stimpath = getappdata(hAomControl, 'stimpath');
    stimpath = 'C:\UHCO_BMP_creators\Sacc_Tumb_E';
    set(hObject, 'String', stimpath);
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





% --- Executes on button press in customrange.
function customrange_Callback(hObject, eventdata, handles)
% hObject    handle to customrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stimpath;
% Hint: get(hObject,'Value') returns toggle state of customrange
    set(handles.stimpath, 'String', '<undefined>');
    set(handles.set_stimpath, 'Enable', 'on');
    set(handles.ok_button, 'Enable', 'off');



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


% --- Executes on key press over kb_UpArrow with no controls selected.
function kb_UpArrow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to kb_UpArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over kb_DownArrow.
function kb_DownArrow_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to kb_DownArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)  



% --- Executes during object creation, after setting all properties.
function sizerange1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizerange1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function sizerange2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizerange2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function size_range_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_range_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function exp_specific_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_specific_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function npresentationslabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npresentationslabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function computethresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to computethresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function nIntervals_Callback(hObject, eventdata, handles)
% hObject    handle to nIntervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nIntervals as text
%        str2double(get(hObject,'String')) returns contents of nIntervals as a double


% --- Executes during object creation, after setting all properties.
function nIntervals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nIntervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'C'
    set(hObject, 'String', '2');
else
    %do nothing
end


% --- Executes during object creation, after setting all properties.
function responses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to responses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'C'
    set(hObject, 'String', '2');
else
    %do nothing
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

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'C'
    set(hObject, 'String', '-1.5');
else
    %do nothing
end


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




% --- Executes during object creation, after setting all properties.
function quest_params_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quest_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'W' || exp(1) == 'S';
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
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
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'C';
    set(hObject, 'String', '4');
else
    %nothing
end

% --- Executes during object creation, after setting all properties.
function uipanel7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





function responses_Callback(hObject, eventdata, handles)
% hObject    handle to responses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of responses as text
%        str2double(get(hObject,'String')) returns contents of responses as a double




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

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'V';
    set(hObject, 'String', 0);
else
    set(hObject, 'String', 1000);
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




% --- Executes during object creation, after setting all properties.
function set_stimpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_stimpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'W' || exp(1) == 'S'
    set(hObject, 'Enable', 'on');
elseif exp(1) == 'C'
    set(hObject, 'Enable', 'off');
end




% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'W'
    set(hObject, 'String', 'Upper Left');
else
    set(hObject, 'String', 'Up Arrow');
end



% --- Executes during object creation, after setting all properties.
function text12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'W'
    set(hObject, 'String', 'Upper Right');
else
    set(hObject, 'String', 'Down Arrow');
end



% --- Executes during object creation, after setting all properties.
function text13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'W'
    set(hObject, 'String', 'Lower Left');
else
     set(hObject, 'String', 'Left Arrow');
end


% --- Executes during object creation, after setting all properties.
function text14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'W' 
    set(hObject, 'String', 'Lower Right');
else
     set(hObject, 'String', 'Right Arrow');
end



function cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cutoff as text
%        str2double(get(hObject,'String')) returns contents of cutoff as a double


% --- Executes during object creation, after setting all properties.
function cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filter_checkbox.
function filter_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to filter_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_checkbox

if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

if get(handles.filter_checkbox,'Value') == 0;
    set(handles.cutoff, 'Enable', 'off');
    set(handles.cutoff_label, 'Enable', 'off');
    set(handles.window_radio, 'Enable', 'off');
    set(handles.ideal_radio, 'Enable', 'off');
    set(handles.filtersize, 'Enable', 'off');    
    set(handles.filtersize_label, 'Enable', 'off');
elseif get(handles.filter_checkbox, 'Value') == 1;
    set(handles.cutoff, 'Enable', 'on');
    set(handles.cutoff_label, 'Enable', 'on');
    set(handles.window_radio, 'Enable', 'on');
    set(handles.ideal_radio, 'Enable', 'on');
    set(handles.filtersize, 'Enable', 'on');
    set(handles.filtersize_label, 'Enable', 'on');
end




function filtersize_Callback(hObject, eventdata, handles)
% hObject    handle to filtersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtersize as text
%        str2double(get(hObject,'String')) returns contents of filtersize as a double


% --- Executes during object creation, after setting all properties.
function filtersize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in ideal_radio.
function ideal_radio_Callback(hObject, eventdata, handles)
% hObject    handle to ideal_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ideal_radio
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

if get(handles.ideal_radio, 'Value') == 1;
    set(handles.filtersize, 'Enable', 'off')
    set(handles.filtersize_label, 'Enable', 'off')
else
end


% --- Executes on button press in window_radio.
function window_radio_Callback(hObject, eventdata, handles)
% hObject    handle to window_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of window_radio
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

if get(handles.window_radio, 'Value') == 1;
    set(handles.filtersize, 'Enable', 'on')
    set(handles.filtersize_label, 'Enable', 'on')
else
end




% --- Executes on button press in quest_radio.
function quest_radio_Callback(hObject, eventdata, handles)
% hObject    handle to quest_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quest_radio
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

set(handles.quest_params, 'Visible', 'on');
set(handles.size_range_panel, 'Visible', 'off');
set(handles.computethresh, 'Visible', 'off');
set(handles.npresentationslabel, 'String', 'Trials');
set(handles.npresent, 'String', 60);
% --- Executes on button press in mocs_radio.
function mocs_radio_Callback(hObject, eventdata, handles)
% hObject    handle to mocs_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mocs_radio
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

set(handles.quest_params, 'Visible', 'off');
set(handles.size_range_panel, 'Visible', 'on');
set(handles.computethresh, 'Visible', 'on');
set(handles.npresentationslabel, 'String','Presentations');
set(handles.npresent, 'String', 10);


% --- Executes on button press in e_stim_radio.
function e_stim_radio_Callback(hObject, eventdata, handles)
% hObject    handle to e_stim_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
stimpath = getappdata(hAomControl, 'stimpath'); 

if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end
set(handles.responses, 'String', 4);
set(handles.sizerange1, 'UserData','Es_5-20');
set(handles.sizerange2, 'UserData','Es_2.5-17.5');
set(handles.kb_UpArrow, 'String', 'U');
set(handles.kb_DownArrow, 'String', 'D');
set(handles.kb_LeftArrow, 'String', 'L');
set(handles.kb_RightArrow, 'String', 'R');

if get(handles.quest_radio, 'Value') == 1
    set(handles.quest_params, 'Visible', 'on');
    stimpath = [stimpath 'Es_2.5-40'];
    set(handles.stimpath, 'String', stimpath);
    set(handles.stimpath, 'Enable', 'off');
elseif get(handles.mocs_radio, 'Value') == 1
    set(handles.quest_radio, 'Enable', 'on');
    set(handles.size_range_panel, 'Visible', 'on');
    set(handles.max_separation_lbl, 'Visible', 'off');
    set(handles.max_sep, 'Visible', 'off');
    set(handles.spotsize_lbl, 'Visible', 'off');
    set(handles.spotsize, 'Visible', 'off');
    set(handles.gen_twopt_stim, 'Visible', 'off');
    set(handles.stimpath, 'String',stimpath);
    %set(handles.prewarp_button, 'Visible', 'off');
end

% --- Executes on button press in sw_stim_radio.
function sw_stim_radio_Callback(hObject, eventdata, handles)
% hObject    handle to sw_stim_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
stimpath = getappdata(hAomControl, 'stimpath'); 

if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end
set(handles.responses, 'String', 2);
set(handles.sizerange1, 'UserData', 'SWs_5-20');
set(handles.sizerange2, 'UserData', 'SWs_2.5-17.5');
set(handles.kb_UpArrow, 'String', 'V');
set(handles.kb_DownArrow, 'String', 'V');
set(handles.kb_LeftArrow, 'String', 'H');
set(handles.kb_RightArrow, 'String', 'H');


if get(handles.quest_radio, 'Value') == 1
   stimpath = [stimpath 'SWs_2.5-40'];
   set(handles.stimpath, 'String', stimpath);
   set(handles.stimpath, 'Enable', 'off');
elseif get(handles.mocs_radio, 'Value') == 1
    set(handles.quest_radio, 'Enable', 'on');
    set(handles.size_range_panel, 'Visible', 'on');
    set(handles.max_separation_lbl, 'Visible', 'off');
    set(handles.max_sep, 'Visible', 'off');
    set(handles.spotsize_lbl, 'Visible', 'off');
    set(handles.spotsize, 'Visible', 'off');
    set(handles.gen_twopt_stim, 'Visible', 'off');
    set(handles.stimpath, 'String',stimpath);
    %set(handles.prewarp_button, 'Visible', 'off');
end

% --- Executes on button press in twopt_stim_radio.
function twopt_stim_radio_Callback(hObject, eventdata, handles)
% hObject    handle to twopt_stim_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAomControl = getappdata(0,'hAomControl');
stimpath = getappdata(hAomControl, 'stimpath'); 

if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

set(handles.quest_radio, 'Value', 0);
set(handles.mocs_radio, 'Value', 1);
set(handles.quest_radio, 'Enable', 'off');
set(handles.quest_params, 'Visible', 'off');
set(handles.computethresh, 'Visible', 'on');
set(handles.size_range_panel, 'Visible', 'off');
set(handles.npresentationslabel, 'String','Presentations');
set(handles.npresent, 'String', 10);
set(handles.max_separation_lbl, 'Visible', 'on');
set(handles.max_sep, 'Visible', 'on');
set(handles.spotsize_lbl, 'Visible', 'on');
set(handles.spotsize, 'Visible', 'on');
set(handles.kb_UpArrow, 'String', '1');
set(handles.kb_DownArrow, 'String', '2');
set(handles.kb_LeftArrow, 'String', '1');
set(handles.kb_RightArrow, 'String', '2');
set(handles.gen_twopt_stim, 'Visible', 'on');
set(handles.set_stimpath, 'Enable', 'off');
set(handles.stimpath, 'String','<undefined>');
%set(handles.prewarp_button, 'Visible', 'on');
function exp_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to exp_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exp_name_edit as text
%        str2double(get(hObject,'String')) returns contents of exp_name_edit as a double


% --- Executes during object creation, after setting all properties.
function exp_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_name_edit (see GCBO)
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

% Hint: get(hObject,'Value') returns toggle state of auto_pre
if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end

if get(handles.auto_prefix, 'Value') == 0
    set(handles.vidprefix, 'Enable', 'on');
elseif get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'Enable', 'off');
    set(handles.vidprefix, 'String', get(handles.initials, 'String'));
end



function max_sep_Callback(hObject, eventdata, handles)
% hObject    handle to max_sep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_sep as text
%        str2double(get(hObject,'String')) returns contents of max_sep as a double


% --- Executes during object creation, after setting all properties.
function max_sep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_sep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function spotsize_Callback(hObject, eventdata, handles)
% hObject    handle to spotsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spotsize as text
%        str2double(get(hObject,'String')) returns contents of spotsize as a double


% --- Executes during object creation, after setting all properties.
function spotsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spotsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in gen_twopt_stim.
function gen_twopt_stim_Callback(hObject, eventdata, handles)
% hObject    handle to gen_twopt_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist('handles') == 0;
    handles = guihandles;
else
    %donothing
end
dacoeff = [9346852.79448745 -41895568.24241997 79504249.96067327 -83044522.43767963 52026750.07637602 -20004605.37173481 4659748.165839 -634660.4543606126 57930.19303583798 -8006.013601828307];
imagesizeH = 528; %these might be variables again but are
imagesizeV = 480; %hardcoded now for simplicity
framerate = 30;
%mingap = 12;
findex = 2;

maxseparation = str2num(get(handles.max_sep, 'String')); %maximum gap in arc seconds
fieldsize = str2num(get(handles.fieldsize, 'String'));
dotsize = str2num(get(handles.spotsize, 'String'));
nruns = str2num(get(handles.npresent, 'String'));
mingap = dotsize.*1.5;

hAomControl = getappdata(0,'hAomControl');
aom = getappdata(hAomControl, 'aom');
if aom == 0
    fprefix = 'analog';
elseif aom == 1
    fprefix = 'digital';
end


seqfname = strcat(fprefix, '.seq');
dotsize = dotsize-1;
fieldsizeinminutes = fieldsize.*60;
arcminsperpixel = imagesizeV/fieldsizeinminutes;
maxgap = round(arcminsperpixel.*(maxseparation/60));


TwoPt=ones(imagesizeV,imagesizeH);
hbTwoPt=ones(imagesizeV,imagesizeH).*8191;

TwoPtCatch=ones(imagesizeV, imagesizeH);
hbTwoPtCatch=ones(imagesizeV, imagesizeH).*8191;

imcenter=size(TwoPt)./2;
gaps = [];
sequence = [];
dotseparation = [];
dot1center = [];
dot2center = [];

if isdir([pwd,'\temp']) == 0;
    mkdir(pwd,'temp');
    cd([pwd,'\temp']);
else
    cd([pwd,'\temp']);
end

h = waitbar(0,'Generating horizontal stimuli...');
%make horizontally separated dots
for gap = mingap:maxgap;
    if gap == 0;
        TwoPt(imcenter(1)-dotsize/2:imcenter(1)+dotsize/2, imcenter(2)-dotsize/2:imcenter(2)+dotsize/2) = 0;
        hbTwoPt(imcenter(1)-dotsize/2:imcenter(1)+dotsize/2, imcenter(2)-dotsize/2:imcenter(2)+dotsize/2) = -8191;       
        dotseparation = 0;
    elseif gap > 0;
        TwoPt=ones(imagesizeV,imagesizeH);
        hbTwoPt=ones(imagesizeV,imagesizeH).*8191;

        dot1center(1) = imcenter(1);
        dot1center(2) = imcenter(2)- gap/2;
        dot2center(1) = imcenter(1);
        dot2center(2) = imcenter(2)+ gap/2;
        
        dotseparation = dot2center(2) - dot1center(2) - dotsize - 1;
        if dotseparation < 0 
            dotseparation = 0;
        elseif dotseparation > 0 || dotseparation == 0;
                dotseparation = dotseparation;
        end
        TwoPt(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2 , dot1center(2)-dotsize/2:dot1center(2)+dotsize/2)=0;
        TwoPt(dot2center(1)-dotsize/2:dot2center(1)+dotsize/2 , dot2center(2)-dotsize/2:dot2center(2)+dotsize/2)=0;
        hbTwoPt(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2 , dot1center(2)-dotsize/2:dot1center(2)+dotsize/2)=-8191;
        hbTwoPt(dot2center(1)-dotsize/2:dot2center(1)+dotsize/2 , dot2center(2)-dotsize/2:dot2center(2)+dotsize/2)=-8191;
        
    end
    M(findex).pixelsep = dotseparation;
    M(findex).arcminsep = dotseparation/arcminsperpixel;
    M(findex).orientation = 'H';
    if dotseparation == 0
        ndots = '1';
    elseif dotseparation > 0
        ndots = '2';
    end
    M(findex).ndots = ndots;
       
    %write to file
    bufname=[fprefix num2str(findex) '.buf'];
    bmpname=[fprefix num2str(findex) '.bmp'];
    findex = findex+1;
    imwrite(TwoPt,bmpname,'bmp');
    fid = fopen(bufname,'w');
    fwrite(fid, imagesizeH, 'int16');
    fwrite(fid, imagesizeV, 'int16');
    hbTwoPt = hbTwoPt';
    fwrite(fid,hbTwoPt,'int16');
    fclose(fid);
    
 %if there are two dots, make a stimulus of equivalent length with no
    %space
    if ndots == '2'
        
        TwoPtCatch=ones(imagesizeV, imagesizeH);
        hbTwoPtCatch=ones(imagesizeV, imagesizeH).*8191;
        
        meanlum = mean2(TwoPt(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2, dot1center(2)-dotsize/2:dot2center(2)+dotsize/2));
        TwoPtCatch(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2, dot1center(2)-dotsize/2:dot2center(2)+dotsize/2)=meanlum;
        
        hibitval = polyval(dacoeff,meanlum);
        hbTwoPtCatch(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2, dot1center(2)-dotsize/2:dot2center(2)+dotsize/2)=hibitval;
                
        dotseparation = 0;
        ndots = '1';
        M(findex).pixelsep = dotseparation;
        M(findex).arcminsep = dotseparation/arcminsperpixel;
        M(findex).orientation = 'H';  
        M(findex).ndots = ndots;
        
        %write to file
        bufname=[fprefix num2str(findex) '.buf'];
        bmpname=[fprefix num2str(findex) '.bmp'];
        findex = findex+1;
        imwrite(TwoPtCatch,bmpname,'bmp');
        fid = fopen(bufname,'w');
        fwrite(fid, imagesizeH, 'int16');
        fwrite(fid, imagesizeV, 'int16');
        hbTwoPtCatch = hbTwoPtCatch';
        fwrite(fid,hbTwoPtCatch,'int16');
        fclose(fid);
        %create the no space stim and write to disc
    elseif ndots == '1'
        %continue
    end
    
    waitbar(gap/maxgap);
end
close(h);

% h = waitbar(0,'Generating vertical stimuli...');
%make vertically separated dots
% TwoPt=ones(imagesizeV,imagesizeH);
% hbTwoPt=ones(imagesizeV,imagesizeH).*8191;
% 
% for gap = mingap:maxgap;
%     if gap == 0;
%         TwoPt(imcenter(1)-dotsize/2:imcenter(1)+dotsize/2, imcenter(2)-dotsize/2:imcenter(2)+dotsize/2) =0;
%         TwoPt(imcenter(1)-dotsize/2:imcenter(1)+dotsize/2, imcenter(2)-dotsize/2:imcenter(2)+dotsize/2) =0;
%         hbTwoPt(imcenter(1)-dotsize/2:imcenter(1)+dotsize/2, imcenter(2)-dotsize/2:imcenter(2)+dotsize/2) =-8191;
%         hbTwoPt(imcenter(1)-dotsize/2:imcenter(1)+dotsize/2, imcenter(2)-dotsize/2:imcenter(2)+dotsize/2) =-8191;
%         dotseparation = 0;
%     elseif gap > 0;
%         TwoPt=ones(imagesizeV,imagesizeH);
%         hbTwoPt=ones(imagesizeV,imagesizeH).*8191;
%         
%         dot1center(1) = imcenter(1) - gap/2;
%         dot1center(2) = imcenter(2);
%         dot2center(1) = imcenter(1) + gap/2;
%         dot2center(2) = imcenter(2);
%         
%         dotseparation = dot2center(1) - dot1center(1) - dotsize - 1;
%         if dotseparation < 0
%             dotseparation = 0;
%         elseif dotseparation > 0 || dotseparation == 0;
%             dotseparation = dotseparation;
%         end
%         TwoPt(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2 , dot1center(2)-dotsize/2:dot1center(2)+dotsize/2)=0;
%         TwoPt(dot2center(1)-dotsize/2:dot2center(1)+dotsize/2 , dot2center(2)-dotsize/2:dot2center(2)+dotsize/2)=0;
%         hbTwoPt(dot1center(1)-dotsize/2:dot1center(1)+dotsize/2 , dot1center(2)-dotsize/2:dot1center(2)+dotsize/2)=-8191;
%         hbTwoPt(dot2center(1)-dotsize/2:dot2center(1)+dotsize/2 , dot2center(2)-dotsize/2:dot2center(2)+dotsize/2)=-8191;
%     end
%     
%     M(findex).pixelsep = dotseparation;
%     M(findex).arcminsep = dotseparation/arcminsperpixel;
%     M(findex).orientation = 'V';
%     if dotseparation == 0
%         ndots = '1';
%     elseif dotseparation > 0
%         ndots = '2';
%     end
%     M(findex).ndots = ndots;
%       
%     %write to file
%     bufname=[fprefix num2str(findex) '.buf'];
%     bmpname=[fprefix num2str(findex) '.bmp'];
%     findex = findex+1;
%     imwrite(TwoPt,bmpname,'bmp');
%     fid = fopen(bufname,'w');
%     fwrite(fid, imagesizeH, 'int16');
%     fwrite(fid, imagesizeV, 'int16');
%     hbTwoPt = hbTwoPt';
%     fwrite(fid,hbTwoPt,'int16');
%     fclose(fid);
%     
%     %if there are two dots, make a stimulus of equivalent length with no
%     %space
%     if ndots == '2'
%         TwoPtCatch=ones(imagesizeV, imagesizeH);
%         hbTwoPtCatch=ones(imagesizeV, imagesizeH).*8191;        
%         
%         meanlum = mean2(TwoPt(dot1center(1)-dotsize/2:dot2center(1)+dotsize/2, dot1center(2)-dotsize/2:dot1center(2)+dotsize/2));
%         TwoPtCatch(dot1center(1)-dotsize/2:dot2center(1)+dotsize/2, dot1center(2)-dotsize/2:dot1center(2)+dotsize/2)=meanlum;
%         
%         hibitval = polyval(dacoeff,meanlum);
%         hbTwoPtCatch(dot1center(1)-dotsize/2:dot2center(1)+dotsize/2, dot1center(2)-dotsize/2:dot1center(2)+dotsize/2)=hibitval;
%                
%         dotseparation = 0;
%         ndots = '1';
%         M(findex).pixelsep = dotseparation;
%         M(findex).arcminsep = dotseparation/arcminsperpixel;
%         M(findex).orientation = 'H';  
%         M(findex).ndots = ndots;
%           
%         %write to file
%         bufname=[fprefix num2str(findex) '.buf'];
%         bmpname=[fprefix num2str(findex) '.bmp'];
%         findex = findex+1;
%         imwrite(TwoPtCatch,bmpname,'bmp');
%         fid = fopen(bufname,'w');
%         fwrite(fid, imagesizeH, 'int16');
%         fwrite(fid, imagesizeV, 'int16');
%         hbTwoPtCatch = hbTwoPtCatch';
%         fwrite(fid,hbTwoPtCatch,'int16');
%         fclose(fid);
%         %create the no space stim and write to disc
%     elseif ndots == '1'
%         %continue
%     end  
%      
%     waitbar(gap/maxgap);
% end
% close(h);


%generate the mapping file
orient = [M.orientation]';
arcsep =[M.arcminsep]';
pixsep =[M.pixelsep]';
dotnum =[M.ndots]';

mapfname = strcat(fprefix, '_mapping', '.map');
fid = fopen(mapfname,'w');
for i = 1:findex-2;
    fprintf(fid, '%i\t%c\t%4.4f\t%i\t%c\n',i+1,dotnum(i), arcsep(i), pixsep(i), orient(i));
end
fclose(fid);
% 
% %generate the sequence file
% for k = 1:nruns
%     seq = [1:findex-2]';
%     seq(:,1) = rand(findex-2,1);
%     [IX, randseq] = sort(seq,1);
%     randseq = randseq+1;
%     sequence = [randseq;sequence];
% end
% 
% for j = 1:framerate
%     sequence(:,j) = sequence(:,1);
% end;
% 
% ntrials = ((findex-2)*nruns);
% blankend = (zeros(1,ntrials))';
% sequence = [sequence,blankend];
% dlmwrite(seqfname, sequence, '\t');


%set stimpath & go up a directory
set(handles.stimpath, 'String',pwd);
cd ..;
%set(handles.prewarp_button, 'Enable', 'on');


% --- Executes on button press in prewarp_button.
function prewarp_button_Callback(hObject, eventdata, handles)
% hObject    handle to prewarp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function mocs_radio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mocs_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'C'
    set(hObject, 'Enable', 'off');
else
    %do nothing
end




% --- Executes during object creation, after setting all properties.
function stim_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp');
if exp(1) == 'C'
    set(hObject, 'Visible', 'off');
else
    %do nothing
end



