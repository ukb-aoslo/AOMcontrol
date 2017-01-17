function varargout = VernierConfig(varargin)
% VERNIERCONFIG M-file for VernierConfig.fig
%      VERNIERCONFIG, by itself, creates a new VERNIERCONFIG or raises the existing
%      singleton*.
%
%      H = VERNIERCONFIG returns the handle to a new VERNIERCONFIG or the handle to
%      the existing singleton*.
%
%      VERNIERCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VERNIERCONFIG.M with the given input arguments.
%
%      VERNIERCONFIG('Property','Value',...) creates a new VERNIERCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VernierConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VernierConfig_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VernierConfig

% Last Modified by GUIDE v2.5 29-Feb-2012 12:32:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VernierConfig_OpeningFcn, ...
    'gui_OutputFcn',  @VernierConfig_OutputFcn, ...
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

% --- Executes just before VernierConfig is made visible.
function VernierConfig_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VernierConfig (see VARARGIN)

% Choose default command line output for VernierConfig
global SYSPARAMS StimParams VideoParams ExpCfgParams; %#ok<*NUSED>
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VernierConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);
hAomControl = getappdata(0,'hAomControl');
exp = getappdata(hAomControl, 'exp'); %#ok<*NASGU>

if exist('lastVernierCFG.mat','file')==2;
    loadLastValues(handles,1);
    set(handles.push_default,'Enable','On');
    set(handles.push_last,'Enable','Off');
else
    loadLastValues(handles,0);
    set(handles.push_default,'Enable','Off');
    set(handles.push_last,'Enable','Off');
end

if get(handles.check_off,'Value')==1
    handles.lastX= get(handles.edit_Xoff,'String');
    handles.lastY= get(handles.edit_Yoff,'String');
    set (handles.edit_Xoff,'Enable','On')
    set (handles.edit_Yoff,'Enable','On')
else
    set (handles.edit_Xoff,'String','0')
    set (handles.edit_Yoff,'String','0')
    set (handles.edit_Xoff,'Enable','Off')
    set (handles.edit_Yoff,'Enable','Off')
    handles.lastX=0;
    handles.lastY=0;
end

if get(handles.check_TCAcorrection,'Value')==1
    handles.lasttcaX= get(handles.edit_tcaX,'String');
    handles.lasttcaY= get(handles.edit_tcaY,'String');
    set (handles.edit_tcaX,'Enable','On')
    set (handles.edit_tcaY,'Enable','On')
else
    set (handles.edit_tcaX,'String','0')
    set (handles.edit_tcaY,'String','0')
    set (handles.edit_tcaX,'Enable','Off')
    set (handles.edit_tcaY,'Enable','Off')
    handles.lasttcaX=0;
    handles.lasttcaY=0;
end


%%%%%%%%%%%%%%%%%%%%% FOR DRIFT PATTERN PREVIEW

% handles.width=100;
% handles.patt=rand(handles.width,handles.width);


imSize = 100;                           % image size: n X n
downscale=10;
ind=(rand(downscale,downscale));
dotsize=round(imSize/downscale);
patt=zeros(downscale*dotsize,downscale*dotsize);
for i=1:downscale
    for j=1:downscale
        patt(i*dotsize-(dotsize-1):i*dotsize,j*dotsize-(dotsize-1):j*dotsize)=ind(i,j);
    end
end
handles.patt=imresize(patt,[imSize imSize]);
handles.width=imSize;




guidata(hObject, handles);

drawPreview (handles);



% --- Outputs from this function are returned to the command line.
function varargout = VernierConfig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
set(handles.text_actualduration,'String',num2str(round(33.3333*str2num(get(handles.presentdur,'String'))),'%2.1d'));
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



function iti_Callback(hObject, eventdata, handles)
% hObject    handle to iti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iti as text
%        str2double(get(hObject,'String')) returns contents of iti as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

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
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')



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
    if get(handles.check_subpixel,'Value')==1
        set(handles.text_step,'String','Step factor');
        set(handles.stepfactor,'String',1.75);
    else
        set(handles.text_step,'String','Step size');
        set(handles.stepfactor,'String',1);
    end
    
    
    
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

function edit_barheight_Callback(hObject, eventdata, handles)
% hObject    handle to edit_barheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_barheight as text
%        str2double(get(hObject,'String')) returns contents of edit_barheight as a double

drawPreview(handles);
fieldsize=str2num(get(handles.fieldsize,'String'));
set(handles.text_actualbarheight,'String',num2str((60*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'));
set(handles.text_actualdotsize,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'));
set(handles.text_actualdotseparation,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'));
set(handles.text_actualduration,'String',num2str(3*str2num(get(handles.presentdur,'String'))/100,'%2.1f'));
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function edit_barheight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_barheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dotsize_Callback(hObject, eventdata, handles)
% hObject    handle to dotsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dotsize as text
%        str2double(get(hObject,'String')) returns contents of dotsize as a double
drawPreview(handles);
fieldsize=str2num(get(handles.fieldsize,'String'));
set(handles.text_actualbarheight,'String',num2str((60*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'));
set(handles.text_actualdotsize,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'));
set(handles.text_actualdotseparation,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'));
set(handles.text_actualduration,'String',num2str(3*str2num(get(handles.presentdur,'String'))/100,'%2.1f'));
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function dotsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dotsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dotseparation_Callback(hObject, eventdata, handles)
% hObject    handle to dotseparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dotseparation as text
%        str2double(get(hObject,'String')) returns contents of dotseparation as a double
drawPreview(handles);
fieldsize=str2num(get(handles.fieldsize,'String'));
set(handles.text_actualbarheight,'String',num2str((60*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'));
set(handles.text_actualdotsize,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'));
set(handles.text_actualdotseparation,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'));
set(handles.text_actualduration,'String',num2str(3*str2num(get(handles.presentdur,'String'))/100,'%2.1f'));
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

% --- Executes during object creation, after setting all properties.
function dotseparation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dotseparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_orientationAngle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_orientationAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_orientationAngle as text
%        str2double(get(hObject,'String')) returns contents of edit_orientationAngle as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles)


% --- Executes during object creation, after setting all properties.
function edit_orientationAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_orientationAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_subpixel.
function check_subpixel_Callback(hObject, eventdata, handles)
% hObject    handle to check_subpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_subpixel

if get(handles.radio_2d1u,'Value')==1
    if get(hObject,'Value')==1
        set(handles.text_step,'String','Step factor');
        set(handles.stepfactor,'String',1.75);
    else
        set(handles.text_step,'String','Step size');
        set(handles.stepfactor,'String',1);
    end
end

if get(hObject,'Value')==1
    set(handles.edit_gaussw,'Visible','On');
    set(handles.text_gaussw,'Visible','On');
    set(handles.edit_minStep,'String','0.01')
    
else
    set(handles.edit_gaussw,'Visible','Off');
    set(handles.text_gaussw,'Visible','Off');
    set(handles.edit_minStep,'String','1')
end

if get(handles.check_subpixel,'Value')==0
    %set(handles.slider1,'Value',floor(str2num(get(handles.edit_previewOffset,'String'))));
    set(handles.slider1,'SliderStep',[0.1 1]);
    set(handles.edit_previewOffset,'String',floor(str2num(get(handles.edit_previewOffset,'String'))));
    set(handles.slider1,'Value',str2num(get(handles.edit_previewOffset,'String')));
else
    set(handles.slider1,'SliderStep',[0.05 1]);
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles);

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


% --- Executes on button press in radio_3dot.
function radio_3dot_Callback(hObject, eventdata, handles)
% hObject    handle to radio_3dot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_3dot
if get(hObject,'Value')==1
    set(handles.radio_2lines,'Value',0)
    set(handles.radio_grid,'Value',0)
    set(handles.radio_E,'Value',0)
    
    set(handles.text_stimsize,'String','Dot size')
    %set(handles.dotsize,'String',5)
    set(handles.text_separation,'String','Gaps')
    set(handles.text_barheight,'Visible','Off')
    set(handles.edit_barheight,'Visible','Off')
    set(handles.text_actualbarheight,'Visible','Off')
    set(handles.text_lengthdim,'Visible','Off')
    set(handles.check_i,'Visible','Off')
else
    set(handles.radio_2lines,'Value',1)
    set(handles.check_i,'Visible','On')
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles);

% --- Executes on button press in radio_2lines.
function radio_2lines_Callback(hObject, eventdata, handles)
% hObject    handle to radio_2lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ExpCfgParams

% Hint: get(hObject,'Value') returns toggle state of radio_2lines
if get(hObject,'Value')==1
    set(handles.radio_3dot,'Value',0)
    set(handles.radio_grid,'Value',0)
    set(handles.radio_E,'Value',0)
    
    set(handles.text_stimsize,'String','Width')
    %set(handles.dotsize,'String',3)
    set(handles.text_separation,'String','Gap')
    set(handles.text_barheight,'String','Length')
    set(handles.text_barheight,'Visible','On')
    set(handles.edit_barheight,'String',20)
    set(handles.edit_barheight,'Visible','On')
    set(handles.text_actualbarheight,'Visible','On')
    set(handles.text_lengthdim,'Visible','On')
    set(handles.check_i,'Visible','On')
    
else
    set(handles.check_i,'Visible','Off')
    set(handles.radio_3dot,'Value',1)
    
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles);


% --- Executes on button press in radio_grid.
function radio_grid_Callback(hObject, eventdata, handles)
% hObject    handle to radio_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_grid
if get(hObject,'Value')==1
    set(handles.radio_3dot,'Value',0)
    set(handles.radio_2lines,'Value',0)
    set(handles.radio_E,'Value',0)
    
    
    set(handles.text_separation,'String','Gaps')
    set(handles.text_barheight,'String','n rows')
    set(handles.edit_barheight,'String',4)
    
    set(handles.dotseparation,'Visible','On')
    set(handles.dotsize,'Visible','On')
    set(handles.edit_barheight,'Visible','On')
    set(handles.text_separation,'Visible','On')
    set(handles.text_stimsize,'Visible','On')
    set(handles.text_barheight,'Visible','On')
    set(handles.text_actualdotseparation,'Visible','On')
    set(handles.text_actualdotsize,'Visible','On')
    set(handles.text47,'Visible','On')
    set(handles.text48,'Visible','On')
    set(handles.check_i,'Visible','Off')
    
    set(handles.text_actualbarheight,'Visible','Off')
    set(handles.text_lengthdim,'Visible','Off')
else
    set(handles.check_i,'Visible','On')
end

set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles);


% --- Executes on button press in radio_E.
function radio_E_Callback(hObject, eventdata, handles)
% hObject    handle to radio_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_E
if get(hObject,'Value')==1
    
    set(handles.check_subpixel,'Value',0)
    set(handles.radio_2d1u,'Value',1)
    set(handles.radio_adjust,'Value',0)
    set(handles.edit_minStep,'String',1)
    set(handles.stepfactor,'String',1.4)
    set(handles.edit_1st,'String',10)
    
    set(handles.radio_3dot,'Value',0)
    set(handles.radio_2lines,'Value',0)
    set(handles.radio_grid,'Value',0)
    set(handles.check_i,'Visible','Off')
    
%     set(handles.dotseparation,'Visible','Off')
%     set(handles.dotsize,'Visible','Off')
%     set(handles.edit_barheight,'Visible','Off')
%     set(handles.text_separation,'Visible','Off')
%     set(handles.text_stimsize,'Visible','Off')
%     set(handles.text_barheight,'Visible','Off')
%     set(handles.text_actualdotseparation,'Visible','Off')
%     set(handles.text_actualdotsize,'Visible','Off')
%     set(handles.text_actualbarheight,'Visible','Off')
%     set(handles.text47,'Visible','Off')
%     set(handles.text48,'Visible','Off')
%     set(handles.text_lengthdim,'Visible','Off')
%     
else
    set(handles.dotseparation,'Visible','On')
    set(handles.dotsize,'Visible','On')
    set(handles.edit_barheight,'Visible','On')
    set(handles.edit_orientationAngle, 'Visisble', 'On');  %##### JBF ADDED 3/1/12 #####
    set(handles.text_separation,'Visible','On')
    set(handles.text_stimsize,'Visible','On')
    set(handles.text_barheight,'Visible','On')
    set(handles.text_actualdotseparation,'Visible','On')
    set(handles.text_actualdotsize,'Visible','On')
    set(handles.text_actualbarheight,'Visible','On')
    set(handles.text47,'Visible','On')
    set(handles.text48,'Visible','On')
    set(handles.text_lengthdim,'Visible','On')
    set(handles.check_i,'Visible','On')
    
end



set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview(handles);


function edit_1st_Callback(hObject, eventdata, handles)
% hObject    handle to edit_1st (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_1st as text
%        str2double(get(hObject,'String')) returns contents of edit_1st as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')

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


set(handles.edit_previewOffset,'String',get(hObject,'Value'))

if get(handles.check_subpixel,'Value')==0
    set(handles.slider1,'SliderStep',[0.1 1.0]);
    set(handles.slider1,'Value',floor(str2num(get(handles.edit_previewOffset,'String'))));
    set(handles.edit_previewOffset,'String',floor(str2num(get(handles.edit_previewOffset,'String'))));
else
    set(handles.slider1,'SliderStep',[0.025 1.0]);
end



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
if get(handles.check_subpixel,'Value')==0
    set(handles.edit_previewOffset,'String',floor(str2num(get(handles.edit_previewOffset,'String'))));
end

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




function edit_gaussw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gaussw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gaussw as text
%        str2double(get(hObject,'String')) returns contents of edit_gaussw as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview (handles)


% --- Executes during object creation, after setting all properties.
function edit_gaussw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gaussw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




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



function drawPreview (handles)

dotSize =  str2num(get(handles.dotsize,'String'));
dotSeparation = str2num(get(handles.dotseparation, 'String'));
offset = str2num(get(handles.edit_previewOffset,'String'));
gaussw=str2num(get(handles.edit_gaussw,'String'));

if get(handles.check_2D,'Value')==1
    offsety=5;
else
    offsety=0;
    
end



%
% test=zeros(20,20);
% test(10:15,10:15)=1;
% axes(handles.axes_preview);
% imshow(test);


if get(handles.radio_3dot,'Value')==1
    
    
    canvh=6+dotSize*3+dotSeparation*2;  %3 pixel margin at each side
    canvw=canvh;   % the whole thing is square (TODO: re-think because of stabilization constraints)
    canv=ones(canvh,canvw);  % create empty canvas
    
    flank=ones(6+dotSize,canvw);  % top and bottom part of stimulus
    flankw=(floor((canvw-dotSize)/2):floor((canvw-dotSize)/2)+dotSize-1);
    flankh=(4:4+dotSize-1);
    flank(flankh,flankw)=0;
    
    if get(handles.check_subpixel,'Value')==1
        gf=fspecial('gaussian',11,gaussw);
        flank=imfilter(flank,gf,'replicate');
    end
    
    probe=ones(2*dotSeparation+dotSize-6,canvw);
    
    if get(handles.check_subpixel,'Value')==1
        probew=(floor((canvw-dotSize)/2):floor((canvw-dotSize)/2)+dotSize-1);
    else
        probew=(floor((canvw-dotSize)/2)+floor(offset):floor((canvw-dotSize)/2)+dotSize-1+floor(offset));
    end
    
    probeh=(dotSeparation-2:dotSeparation-2+dotSize-1);
    probe(probeh,probew)=0;
    
    if get(handles.check_subpixel,'Value')==1
        gf=fspecial('gaussian',11,gaussw);
        probe=imfilter(probe,gf,'replicate');
        deltac = -offset;  % Shift in X (negative because of shift algorithm)
        deltar = offsety;  % Shift in Y
        f=im2double(probe);
        phase = 2;
        [nr,nc]=size(f);
        Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
        Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
        [Nc,Nr] = meshgrid(Nc,Nr);
        g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
        probe=abs(g);
    end
    
    canv=[flank;probe;flank];
    
    
elseif get(handles.radio_2lines,'Value')==1
    
    barheight= str2num(get(handles.edit_barheight, 'String'));
            
    canvh=6+barheight*2+dotSeparation;  %3 pixel margin at each side
    canvw=canvh;   % the whole thing is square (TODO: re-think because of stabilization constraints)
    canv=ones(canvh,canvw);  % create empty canvas
    
    flank=ones(6+barheight,canvw);  % top and bottom part of stimulus
    flankw=(floor((canvw-dotSize)/2):floor((canvw-dotSize)/2)+dotSize-1);
    flankh=(4:4+barheight-1);
    flank(flankh,flankw)=0;
    if get(handles.check_subpixel,'Value')==1
        gf=fspecial('gaussian',11,gaussw);
        flank=imfilter(flank,gf,'replicate');
    end
    
    
   
    if get(handles.check_i,'Value')==1
        probe=ones(6+dotSize+dotSeparation-3,canvw);
        probeh=(4:4+dotSize-1);
        
    else
        probe=ones(6+barheight+dotSeparation-3,canvw);
        probeh=(4:4+barheight-1);
    end    
    
    if get(handles.check_subpixel,'Value')==1
        probew=(floor((canvw-dotSize)/2):floor((canvw-dotSize)/2)+dotSize-1);
    else
        probew=(floor((canvw-dotSize)/2)+floor(offset):floor((canvw-dotSize)/2)+dotSize-1+floor(offset));
    end
    
    probe(probeh,probew)=0;
    
    if get(handles.check_subpixel,'Value')==1
        gf=fspecial('gaussian',11,gaussw);
        probe=imfilter(probe,gf,'replicate');
        deltac = -offset;  % Shift in X (negative because of shift algorithm)
        deltar = 0;       % Shift in Y
        f=im2double(probe);
        phase = 2;
        [nr,nc]=size(f);
        Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
        Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
        [Nc,Nr] = meshgrid(Nc,Nr);
        g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
        probe=abs(g);
    end
    
    canv=[probe;flank];
    
        %ROTATE STIMULUS BY orientationAngle  ##### JBF Added 3/7/12 #####
        %--------------------------------------------- 
        %reverse image values (to make white on black, b/c imrotate 'loose' fills in new area with zeros)
        canv = 1 - canv;        
        %rotate image
        orientationAngle=str2num(get(handles.edit_orientationAngle,'String'));
        canv = imrotate(canv, orientationAngle,'bicubic','loose'); %beware of pixel values outside the original range      
        %crop values greater than zero (aka crop the stimulus, getting rid of all near-zero values)
        [nzRow, nzCol, val] = find(canv > .001); 
        canv = canv(min(nzRow):max(nzRow), min(nzCol):max(nzCol));       
        %reverse image values (back to black on white)
        canv = 1 - canv;
    
    
elseif get(handles.radio_grid,'Value')==1
    
    n = str2num(get(handles.edit_barheight, 'String'));
    zell=ones(dotSeparation+ceil(dotSize/2),dotSeparation+ceil(dotSize/2));
    
    if dotSize>=dotSeparation
        dotSize=dotSeparation-1;
    end
    
    zell(ceil(dotSeparation/2)-floor(dotSize/2):ceil(dotSeparation/2)-floor(dotSize/2)+dotSize-1,ceil(dotSeparation/2)-floor(dotSize/2):ceil(dotSeparation/2)-floor(dotSize/2)+dotSize-1)=0;
    
    if get(handles.check_subpixel,'Value')==1
        gf=fspecial('gaussian',11,gaussw);
        probe=imfilter(zell,gf,'replicate');
        zell=probe;
    end
    
    row=zell;
    for k = 1:n-1
        row=[row zell];
    end
    canv=row;
    for k = 1:n-1
        canv=[canv;row];
    end
    
elseif get(handles.radio_E,'Value')==1
    
    
    gap=round(offset);
    padw=gap;
    e=zeros(gap*5,gap*5);
    e(gap+1:2*gap,gap+1:end)=1;
    e(3*gap+1:4*gap,gap+1:end)=1;
    
    padh=ones(padw,size(e,2));
    padv=ones(size(e,1)+2*padw,padw);
    
    E=[padh;e;padh];
    E=[padv E padv];
    
    E=imrotate(E,90*floor(rand*4));
    
    if get(handles.check_subpixel,'Value')==1
        f = fspecial('gaussian',11,1);
        E = imfilter(E,f,'replicate');
    end
    canv=E;
end

if get(handles.check_drift,'Value')==1
    
    width=handles.width;
    patt=handles.patt;

    gf=fspecial('gaussian',9,1);
    gf=gf/max(gf(:));
    gf2=fspecial('gaussian',width,15);
    gf2=gf2/max(max(gf2));
    
    speed=str2num(get(handles.edit_drift_speed,'String'));
    anglex=cosd(str2num(get(handles.edit_drift_angle,'String')));
    angley=sind(str2num(get(handles.edit_drift_angle,'String')));
    
    i=get(handles.slider1,'Value');
    
    deltac = i*anglex*speed;  % Shift in X (negative because of shift algorithm)
    deltar = i*angley*speed;       % Shift in Y
    f=im2double(patt);
    phase = 2;
    [nr,nc]=size(f);
    Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
    Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
    [Nc,Nr] = meshgrid(Nc,Nr);
    g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
    g=abs(g);
   
    g=imfilter(g,gf,'replicate');
    g=g.*gf2;
    g=g/max(g(:));
    g(width/2-5:width/2+5,width/2-5:width/2+5)=0;
    g=imcomplement(g);
    canv=g;
    
end

previewPosition = get(gca,'Position');
previewHeight = previewPosition(4);
previewWidth = previewPosition(3);

padheight=previewHeight-size(canv,1);
padhl=floor(padheight/2);
padhu=ceil(padheight/2);
padwidth=previewWidth-size(canv,2);
padwl=floor(padwidth/2);
padwr=ceil(padwidth/2);

padt=ones(padhl,size(canv,2));
padb=ones(padhu,size(canv,2));
padl=ones(previewHeight,padwl);
padr=ones(previewHeight,padwr);
prev=[padt;canv;padb];
prev=[padl prev padr];

if get(handles.check_flipv,'Value')==1
    prev=flipud(prev);
end

if get(handles.check_positive,'Value')==1
    prev=imcomplement(prev);
end

%if size(prev,1)>=previewHeight || size(prev,2)>=previewWidth
    
%end

if get(handles.radio_red,'Value')==1
    IR=(ones(previewHeight,previewWidth));
    R=prev;
else
    IR=prev;
    R=(zeros(previewHeight,previewWidth));
end

IR=imresize(IR,[previewHeight previewWidth]);
R=imresize(R,[previewHeight previewWidth]);

PreviewBuffer(:,:,1) = uint8(100*IR);
PreviewBuffer(:,:,1) = PreviewBuffer(:,:,1)+uint8(205*R);
PreviewBuffer(:,:,2) = uint8(zeros(previewHeight,previewWidth));
PreviewBuffer(:,:,3) = uint8(zeros(previewHeight,previewWidth));


% draw the stimulus

% imshow(prev,'InitialMagnification',100)
imshow(PreviewBuffer,'InitialMagnification',100)
disp('drawn');


% % annotations
% 
% fieldsize=str2num(get(handles.fieldsize,'String'));
% fontsz=7;
% colw=[1 1 1];
% col1=[0.2 0.2 0.2];
% col2=[0.0    0.6000    0.0];

% text (3,7,'arcmin','FontSize',fontsz,'Color',col1);
% text (3,13,'arcsec','FontSize',fontsz,'Color',col2);

% if get(handles.radio_3dot,'Value')==0
%     text (3,29,num2str((60*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'),'FontSize',fontsz,'Color',col1);
%     text (3,37,num2str((3600*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'),'FontSize',fontsz,'Color',col2);
%
% end
% text (3,51,num2str((60*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'),'FontSize',fontsz,'Color',col1);
% text (3,59,num2str((3600*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'),'FontSize',fontsz,'Color',col2);
%
% text (3,71,num2str((60*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'),'FontSize',fontsz,'Color',col1);
% text (3,79,num2str((3600*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'),'FontSize',fontsz,'Color',col2);

% text(90,previewHeight-5,num2str((3600*fieldsize/512)*str2num(get(handles.edit_previewOffset,'String')),'%2.1f'),'FontSize',fontsz,'Color',colw);


% --- Executes on button press in radio_red.
function radio_red_Callback(hObject, eventdata, handles)
% hObject    handle to radio_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_red
global SYSPARAMS

if get(hObject,'Value')==1
    set(handles.check_positive,'Value',1);
    set(handles.check_TCA,'Enable','On')
    SYSPARAMS.aoms_state(2)=1;
    set(handles.radio_ir,'Value',0);
    set(handles.check_TCAcorrection,'Enable','On')
    set(handles.edit_tcaX,'Enable','On')
    set(handles.edit_tcaY,'Enable','On')
else
    set(handles.check_positive,'Value',0);
    set(handles.check_TCA,'Enable','Off')
    SYSPARAMS.aoms_state(2)=0;
    set(handles.radio_ir,'Value',1);
    set(handles.check_TCAcorrection,'Enable','Off')
    set(handles.edit_tcaX,'Enable','Off')
    set(handles.edit_tcaY,'Enable','Off')
end

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')


% --- Executes on button press in radio_ir.
function radio_ir_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ir

if get(hObject,'Value')==1
    set(handles.check_positive,'Value',0);
    set(handles.radio_red,'Value',0);
    set(handles.check_TCA,'Enable','Off')
    set(handles.check_TCAcorrection,'Enable','Off')
    set(handles.edit_tcaX,'Enable','Off')
    set(handles.edit_tcaY,'Enable','Off')
else
    set(handles.check_positive,'Value',1);
    set(handles.radio_red,'Value',1);
    set(handles.check_TCA,'Enable','On')
    set(handles.check_TCAcorrection,'Enable','On')
    set(handles.edit_tcaX,'Enable','On')
    set(handles.edit_tcaY,'Enable','On')
end

drawPreview (handles);
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


% --- Executes on button press in check_TCA.
function check_TCA_Callback(hObject, eventdata, handles)
% hObject    handle to check_TCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_TCA
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');
drawPreview (handles);



% --- Executes on button press in check_2D.
function check_2D_Callback(hObject, eventdata, handles)
% hObject    handle to check_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_2D
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview (handles);




% --- Executes on button press in check_positive.
function check_positive_Callback(hObject, eventdata, handles)
% hObject    handle to check_positive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_positive
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On')
drawPreview (handles);





% --- Executes on button press in check_TCAcorrection.
function check_TCAcorrection_Callback(hObject, eventdata, handles)
% hObject    handle to check_TCAcorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_TCAcorrection
if get(hObject,'Value')==0
    set (handles.edit_tcaX,'String','0')
    set (handles.edit_tcaY,'String','0')
    set (handles.edit_tcaX,'Enable','Off')
    set (handles.edit_tcaY,'Enable','Off')
else
    
    set (handles.edit_tcaX,'Enable','On')
    set (handles.edit_tcaY,'Enable','On')
    set (handles.edit_tcaX,'String',handles.lasttcaX)
    set (handles.edit_tcaY,'String',handles.lasttcaY)
end
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');



function edit_tcaX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tcaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tcaX as text
%        str2double(get(hObject,'String')) returns contents of edit_tcaX as a double

handles.lasttcaX= get(handles.edit_tcaX,'String');
handles.lasttcaY= get(handles.edit_tcaY,'String');
guidata(hObject, handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes during object creation, after setting all properties.
function edit_tcaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tcaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tcaY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tcaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tcaY as text
%        str2double(get(hObject,'String')) returns contents of edit_tcaY as a double
handles.lasttcaX= get(handles.edit_tcaX,'String');
handles.lasttcaY= get(handles.edit_tcaY,'String');
guidata(hObject, handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes during object creation, after setting all properties.
function edit_tcaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tcaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radio_green.
function radio_green_Callback(hObject, eventdata, handles)
% hObject    handle to radio_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_green

set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');



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




% --- Executes on button press in check_bisection.
function check_bisection_Callback(hObject, eventdata, handles)
% hObject    handle to check_bisection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_bisection
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');



function edit_TCA_G_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TCA_G_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TCA_G_X as text
%        str2double(get(hObject,'String')) returns contents of edit_TCA_G_X as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes during object creation, after setting all properties.
function edit_TCA_G_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TCA_G_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TCA_G_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TCA_G_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TCA_G_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_TCA_G_Y as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes during object creation, after setting all properties.
function edit_TCA_G_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TCA_G_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_drift.
function check_drift_Callback(hObject, eventdata, handles)
% hObject    handle to check_drift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_drift

if get(hObject,'Value')==1
    set(handles.panel_drift,'Visible','On');
%     set(handles.edit_drift_angle,'Enable', 'On');
%     set(handles.edit_drift_speed,'Enable', 'On');
    set(handles.slider1,'SliderStep',[1 30]);
    set(handles.slider1,'Max',20);
else
    set(handles.panel_drift,'Visible','Off');
%     set(handles.edit_drift_angle,'Enable', 'Off');
%     set(handles.edit_drift_speed,'Enable', 'Off');
    set(handles.slider1,'Max',10);
end

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


function edit_drift_angle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_drift_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_drift_angle as text
%        str2double(get(hObject,'String')) returns contents of edit_drift_angle as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes during object creation, after setting all properties.
function edit_drift_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_drift_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_drift_speed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_drift_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_drift_speed as text
%        str2double(get(hObject,'String')) returns contents of edit_drift_speed as a double
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');

% --- Executes during object creation, after setting all properties.
function edit_drift_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_drift_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_drift_cpd_Callback(hObject, eventdata, handles)
% hObject    handle to edit_drift_cpd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_drift_cpd as text
%        str2double(get(hObject,'String')) returns contents of edit_drift_cpd as a double

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');

% --- Executes during object creation, after setting all properties.
function edit_drift_cpd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_drift_cpd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in check_i.
function check_i_Callback(hObject, eventdata, handles)
% hObject    handle to check_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_i

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');




function edit_drift_width_Callback(hObject, eventdata, handles)
% hObject    handle to edit_drift_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_drift_width as text
%        str2double(get(hObject,'String')) returns contents of edit_drift_width as a double

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');

% --- Executes during object creation, after setting all properties.
function edit_drift_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_drift_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in radio_drift_red.
function radio_drift_red_Callback(hObject, eventdata, handles)
% hObject    handle to radio_drift_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_drift_red
if get(hObject,'Value')==1
    set(handles.radio_drift_ir,'Value',0)
else
    set(handles.radio_drift_ir,'Value',1)
end

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes on button press in radio_drift_ir.
function radio_drift_ir_Callback(hObject, eventdata, handles)
% hObject    handle to radio_drift_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_drift_ir
if get(hObject,'Value')==1
    set(handles.radio_drift_red,'Value',0)
else
    set(handles.radio_drift_red,'Value',1)
end

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');




function edit_drift_nframes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_drift_nframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_drift_nframes as text
%        str2double(get(hObject,'String')) returns contents of edit_drift_nframes as a double

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');


% --- Executes during object creation, after setting all properties.
function edit_drift_nframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_drift_nframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in check_flipv.
function check_flipv_Callback(hObject, eventdata, handles)
% hObject    handle to check_flipv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_flipv

drawPreview (handles);
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




% --- Executes on button press in push_last.
function push_last_Callback(hObject, eventdata, handles)
% hObject    handle to push_last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global SYSPARAMS StimParams VideoParams ExpCfgParams
%
if exist('lastVernierCFG.mat','file')==2
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

CFG.off=get(handles.check_off,'Value');
CFG.Xoff=str2num(get(handles.edit_Xoff,'String'));
CFG.Yoff=str2num(get(handles.edit_Yoff,'String'));

CFG.TCA=get(handles.check_TCA,'Value');
CFG.TCAcorrection=get(handles.check_TCAcorrection,'Value');
CFG.tcaX=str2num(get(handles.edit_tcaX,'String'));
CFG.tcaY=str2num(get(handles.edit_tcaY,'String'));

CFG.flipv=get(handles.check_flipv,'Value');
CFG.twoD=get(handles.check_2D,'Value');
CFG.positive=get(handles.check_positive,'Value');
CFG.bisection=get(handles.check_bisection,'Value');
CFG.i=get(handles.check_i,'Value');

CFG.presentdur = str2num(get(handles.presentdur, 'String'));

CFG.first = str2num(get(handles.edit_1st, 'String'));
CFG.stepfactor = str2num(get(handles.stepfactor, 'String'));
CFG.minstep = str2num(get(handles.edit_minStep,'String'));
CFG.npresent = str2num(get(handles.npresent, 'String'));

CFG.dotsize = str2num(get(handles.dotsize,'String'));
CFG.dotseparation = str2num(get(handles.dotseparation,'String'));
CFG.barheight = str2num(get(handles.edit_barheight,'String'));
CFG.gaussw = str2num(get(handles.edit_gaussw,'String'));
CFG.orientationAngle = str2num(get(handles.edit_orientationAngle,'String'));  %##### JBF ADDED 2/29/12 #####

CFG.fieldsize = str2num(get(handles.fieldsize, 'String')); %#ok<*ST2NM>
CFG.videodur = str2num(get(handles.videodur, 'String'));
CFG.vidprefix = get(handles.vidprefix, 'String');

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

CFG.record = get(handles.check_record,'Value');

if get(handles.radio_2d1u, 'Value') == 1;
    CFG.method = '2d1u';
elseif get(handles.radio_adjust, 'Value') == 1;
    CFG.method = 'adjust';
end

if get(handles.check_subpixel,'Value') == 1
    CFG.stim = 'subp';
else
    CFG.stim = 'discrete';
end

if get(handles.radio_3dot,'Value') ==1
    CFG.optotype = '3dots';
elseif get(handles.radio_2lines,'Value') ==1
    CFG.optotype = '2bars';
elseif get(handles.radio_grid,'Value') ==1
    CFG.optotype = 'grid';
elseif get(handles.radio_E,'Value') ==1
    CFG.optotype = 'E';
    
end

CFG.red = get(handles.radio_red, 'Value');
CFG.ir = get(handles.radio_ir, 'Value');

CFG.gainclamp = get(handles.check_gainclamp, 'Value');

if get(handles.check_gainclamp,'Value')==1
    CFG.gain = 1;
else
    CFG.gain = str2num(get(handles.edit_gain, 'String'));
end

CFG.angle = str2num(get(handles.edit_angle, 'String'));
CFG.orientationAngle = str2num(get(handles.edit_orientationAngle, 'String'));
CFG.plotcomplex = get(handles.check_plot, 'Value');
% CFG.stimpath = get(handles.stimpath,'String');
CFG.stimpath = [pwd,'\tempStimulus\'];
CFG.drift = get(handles.check_drift,'Value');
CFG.drift_angle = str2num(get(handles.edit_drift_angle,'String'));
CFG.drift_speed = str2num(get(handles.edit_drift_speed,'String'));
CFG.drift_cpd = str2num(get(handles.edit_drift_cpd,'String'));
CFG.drift_width = str2num(get(handles.edit_drift_width,'String'));
CFG.drift_ir = get(handles.radio_drift_ir,'Value');
CFG.drift_red = get(handles.radio_drift_red,'Value');
CFG.drift_nframes = str2num(get(handles.edit_drift_nframes,'String'));
CFG.scan = get(handles.check_scan,'Value');

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
ExpCfgParams.TCA = CFG.TCA;
ExpCfgParams.TCAcorrection = CFG.TCAcorrection;
ExpCfgParams.tcaX = CFG.tcaX;
ExpCfgParams.tcaY = CFG.tcaY;
ExpCfgParams.flipv = CFG.flipv;
ExpCfgParams.twoD = CFG.twoD;
ExpCfgParams.bisection = CFG.bisection;
ExpCfgParams.i = CFG.i;
ExpCfgParams.positive = CFG.positive;
ExpCfgParams.presentdur = CFG.presentdur;
ExpCfgParams.npresent = CFG.npresent;
ExpCfgParams.dotsize = CFG.dotsize;
ExpCfgParams.dotseparation = CFG.dotseparation;
ExpCfgParams.gaussw = CFG.gaussw;
ExpCfgParams.barheight = CFG.barheight;
ExpCfgParams.orientationAngle = CFG.orientationAngle; %##### JBF ADDED 2/29/12 #####
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
ExpCfgParams.red = CFG.red;
ExpCfgParams.ir = CFG.ir;
ExpCfgParams.gainclamp = CFG.gainclamp;
ExpCfgParams.drift = CFG.drift;
ExpCfgParams.drift_angle = CFG.drift_angle;
ExpCfgParams.drift_speed = CFG.drift_speed;
ExpCfgParams.drift_cpd = CFG.drift_cpd;
ExpCfgParams.drift_width = CFG.drift_width;
ExpCfgParams.drift_ir = CFG.drift_ir;
ExpCfgParams.drift_red = CFG.drift_red;
ExpCfgParams.drift_nframes = CFG.drift_nframes;
ExpCfgParams.scan = CFG.scan;

if strcmp(CFG.optotype,'3dots'); ExpCfgParams.optotype = 1;
elseif strcmp(CFG.optotype,'2bars'); ExpCfgParams.optotype = 0;
elseif strcmp(CFG.optotype,'grid'); ExpCfgParams.optotype = 2;
elseif strcmp(CFG.optotype,'E'); ExpCfgParams.optotype = 3;
end

if strcmp(CFG.method,'2d1u'); ExpCfgParams.method = 1;
else ExpCfgParams.method = 0; end

if strcmp(CFG.stim,'subp'); ExpCfgParams.stim = 1;
else ExpCfgParams.stim = 0; end

%save('lastVernierCFG.mat', 'SYSPARAMS', 'StimParams', 'VideoParams', 'ExpCfgParams','CFG')
save('lastVernierCFG.mat', 'ExpCfgParams','CFG')


close;



function loadLastValues (handles,last)

global SYSPARAMS StimParams VideoParams ExpCfgParams;

if last==1
    load('lastVernierCFG.mat');
else
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.fieldsize = 1.2; % Rastersize in degrees
    ExpCfgParams.record = 1; %Toggle record video, 0 = off
    ExpCfgParams.videodur = 1; % Video recording time in seconds
    ExpCfgParams.off = 0; % 0 = no offset
    ExpCfgParams.Xoff = 0; % Xoffset
    ExpCfgParams.Yoff = 0; % Yoffset
    ExpCfgParams.TCA = 0; % Draw TCA lines, 0=off
    ExpCfgParams.TCAcorrection = 0; % Use TCA correction, 0=off
    ExpCfgParams.tcaX = 0; % TCA correction in X
    ExpCfgParams.tcaY = 0; % TCA correction in Y
    ExpCfgParams.flipv = 0 % Toggles vertical flip of stimulus
    ExpCfgParams.i = 0; % if 1: Make bars in a 'i' or '!' fashion
    ExpCfgParams.twoD = 0; % if 1: Offset in X and Y
    ExpCfgParams.positive = 0; % Stimulus drawn with positive contrast, otherwise negative
    ExpCfgParams.bisection = 0; % Only vertical offsets for 3dot Optotype
    ExpCfgParams.presentdur = 9; % [ms] presentation duration
    ExpCfgParams.npresent = 30; % trials
    ExpCfgParams.method = 1; %1=2d1u, 0=adjust
    ExpCfgParams.first = 10; % [Pixels] first offset
    ExpCfgParams.stepfactor = 1.75; % factor for next intensity (either * or /)
    ExpCfgParams.minstep = 0.1; % smallest stepsize
    ExpCfgParams.optotype = 1;   %1=dots, 0=bars, 2=grid, 3=E
    ExpCfgParams.barheight = 20; % [Pixels] bar length
    ExpCfgParams.dotsize = 15; % [Pixels] dot/bar width
    ExpCfgParams.dotseparation = 20; % [Pixels] dot/bar separation
    ExpCfgParams.orientationAngle = 0; % [degrees]                                % ##### JBF ADDED 2/29/12 #####
    ExpCfgParams.scan = 0; % Toggles distortion scanning stimulus
    ExpCfgParams.drift = 0; % Toggles Drifting pre-Stimulus
    ExpCfgParams.drift_angle = 45; % Drift pattern angle
    ExpCfgParams.drift_speed = 1.5; % Drift pattern speed
    ExpCfgParams.drift_cpd = 10; % Drift pattern spatial frequency
    ExpCfgParams.drift_width = 100; % Drift pattern width
    ExpCfgParams.drift_ir = 0; % Drift pattern in IR (mutual exclusive with below)
    ExpCfgParams.drift_red = 1; % Drift pattern in RED 
    ExpCfgParams.drift_nframes = 30; % Drift pattern presentation duration 
    ExpCfgParams.stim = 1; %1=Gauss filter, 0=discrete
    ExpCfgParams.gaussw = 1; %[Pixels] Gauss filter sigma
    ExpCfgParams.gain = 0; % Gain for stabilization
    ExpCfgParams.angle = 0; % Angle for stabilization
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
    ExpCfgParams.plotcomplex = 1; % 0 = Fit for psychometric functions
    ExpCfgParams.red = 0; % mutually exclusive with below setting
    ExpCfgParams.ir = 1; % mutually exclusive with above setting
    ExpCfgParams.gainclamp = 0; % gain = 1 only before and after stimulus presentation
end

set(handles.check_drift,'Value', ExpCfgParams.drift);
set(handles.edit_drift_angle,'String', num2str(ExpCfgParams.drift_angle));
set(handles.edit_drift_speed,'String', num2str(ExpCfgParams.drift_speed));
set(handles.edit_drift_cpd,'String', num2str(ExpCfgParams.drift_cpd));
set(handles.edit_drift_width,'String', num2str(ExpCfgParams.drift_width));
set(handles.radio_drift_ir,'Value', ExpCfgParams.drift_ir);
set(handles.radio_drift_red,'Value', ExpCfgParams.drift_red);
set(handles.edit_drift_nframes,'String', num2str(ExpCfgParams.drift_nframes));

set(handles.check_scan,'Value', ExpCfgParams.scan);

if ExpCfgParams.drift==1 || ExpCfgParams.scan==1
    set(handles.panel_drift,'Visible','On');
else
    set(handles.panel_drift,'Visible','Off');
end

if ExpCfgParams.scan==1
    %set(handles.panel_drift,'Visible','On');
    set(handles.edit_drift_angle,'Enable', 'Off');
    set(handles.edit_drift_cpd,'Enable', 'Off');
    set(handles.edit_drift_width,'Enable', 'Off');
else
    %set(handles.panel_drift,'Visible','Off');
    set(handles.edit_drift_angle,'Enable', 'On');
    set(handles.edit_drift_cpd,'Enable', 'On');
    set(handles.edit_drift_width,'Enable', 'On');
end


set(handles.presentdur, 'String', ExpCfgParams.presentdur);
set(handles.dotsize, 'String', ExpCfgParams.dotsize);
set(handles.dotseparation, 'String', ExpCfgParams.dotseparation);
set(handles.edit_barheight, 'String', ExpCfgParams.barheight);
set(handles.edit_orientationAngle, 'String', ExpCfgParams.orientationAngle); % ##### JBF ADDED 2/29/12 #####
set(handles.edit_gaussw,'String',ExpCfgParams.gaussw);
%set(handles.stimpath, 'String',[pwd,'\tempStimulus\']);
set(handles.ok_button, 'Enable', 'on');
set(handles.initials, 'String', ExpCfgParams.initials);
% set(handles.initials, 'String', VideoParams.vidprefix);
set(handles.fieldsize, 'String', ExpCfgParams.fieldsize);
set(handles.vidprefix, 'String', VideoParams.vidprefix);
set(handles.check_record,'Value',ExpCfgParams.record);
% set(handles.videodur, 'String', VideoParams.videodur);
set(handles.videodur, 'String', ExpCfgParams.videodur);
set(handles.check_subpixel,'Value',ExpCfgParams.stim);
set(handles.check_off,'Value',ExpCfgParams.off);
set(handles.edit_Xoff,'String',ExpCfgParams.Xoff);
set(handles.edit_Yoff,'String',ExpCfgParams.Yoff);
set(handles.check_TCA,'Value',ExpCfgParams.TCA);
set(handles.check_TCAcorrection,'Value',ExpCfgParams.TCAcorrection);
set(handles.edit_tcaX,'String',ExpCfgParams.tcaX);
set(handles.edit_tcaY,'String',ExpCfgParams.tcaY);

set(handles.check_flipv,'Value',ExpCfgParams.flipv);
set(handles.check_2D,'Value',ExpCfgParams.twoD);
set(handles.check_positive,'Value',ExpCfgParams.positive);
set(handles.check_bisection,'Value',ExpCfgParams.bisection);
fieldsize=str2num(get(handles.fieldsize,'String'));
set(handles.text_actualbarheight,'String',num2str((60*fieldsize/512)*str2num(get(handles.edit_barheight,'String')),'%2.1f'));
set(handles.text_actualdotsize,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotsize,'String')),'%2.1f'));
set(handles.text_actualdotseparation,'String',num2str((60*fieldsize/512)*str2num(get(handles.dotseparation,'String')),'%2.1f'));
set(handles.text_actualduration,'String',num2str(round(33.333333*str2num(get(handles.presentdur,'String'))),'%2.1d'));

set(handles.radio_2d1u, 'Value', ExpCfgParams.method);
if ExpCfgParams.method==0
    set(handles.radio_adjust, 'Value', 1); end

set(handles.edit_1st,'String',ExpCfgParams.first);
set(handles.stepfactor,'String',ExpCfgParams.stepfactor);
set(handles.edit_minStep,'String',ExpCfgParams.minstep);
set(handles.npresent, 'String', ExpCfgParams.npresent);

if ExpCfgParams.optotype==1
    set(handles.radio_3dot, 'Value',1);
    set(handles.radio_2lines, 'Value',0);
    set(handles.radio_grid, 'Value',0);
    set(handles.radio_E, 'Value',0);
elseif ExpCfgParams.optotype==0
    set(handles.radio_3dot, 'Value',0);
    set(handles.radio_2lines, 'Value',1);
    set(handles.radio_grid, 'Value',0);
    set(handles.radio_E, 'Value',0);
elseif ExpCfgParams.optotype==2
    set(handles.radio_3dot, 'Value',0);
    set(handles.radio_2lines, 'Value',0);
    set(handles.radio_grid, 'Value',1);
    set(handles.radio_E, 'Value',0);
elseif ExpCfgParams.optotype==3
    set(handles.radio_3dot, 'Value',0);
    set(handles.radio_2lines, 'Value',0);
    set(handles.radio_grid, 'Value',0);
    set(handles.radio_E, 'Value',1);
end

set(handles.check_plot,'Value',ExpCfgParams.plotcomplex);
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
set(handles.check_i,'Value',ExpCfgParams.i);

if get(handles.radio_3dot,'Value')==1
    set(handles.text_stimsize,'String','Dot size')
    set(handles.text_separation,'String','Gaps')
    set(handles.text_barheight,'Visible','Off')
    set(handles.edit_barheight,'Visible','Off')
    set(handles.text_actualbarheight,'Visible','Off')
    set(handles.text_lengthdim,'Visible','Off')
    set(handles.check_2D,'Visible','On')
    set(handles.check_i,'Visible','Off')
    
elseif get(handles.radio_2lines,'Value')==1
    set(handles.text_stimsize,'String','Bar width')
    set(handles.text_separation,'String','Gap')
    set(handles.text_barheight,'Visible','On')
    set(handles.edit_barheight,'Visible','On')
    set(handles.text_actualbarheight,'Visible','On')
    set(handles.text_lengthdim,'Visible','On')
    set(handles.check_2D,'Visible','Off')
    set(handles.check_i,'Visible','On')
    
    
elseif get(handles.radio_grid,'Value')==1
    set(handles.text_separation,'String','Gaps')
    set(handles.text_barheight,'String','n rows')
    set(handles.text_barheight,'Value',4)
    set(handles.edit_barheight,'Visible','On')
    set(handles.text_actualbarheight,'Visible','Off')
    set(handles.text_lengthdim,'Visible','Off')
    set(handles.check_2D,'Visible','Off')
    set(handles.check_i,'Visible','Off')
    
    
elseif get(handles.radio_E,'Value')==1
    set(handles.check_subpixel,'Value',0)
    set(handles.radio_2d1u,'Value',1)
    set(handles.edit_minStep,'String',1)
    set(handles.stepfactor,'String',1.4)
    set(handles.edit_1st,'String',ExpCfgParams.first)
    set(handles.radio_3dot,'Value',0)
    set(handles.radio_2lines,'Value',0)
    set(handles.radio_grid,'Value',0)
    set(handles.dotseparation,'Visible','Off')
    set(handles.dotsize,'Visible','Off')
    set(handles.edit_barheight,'Visible','Off')
    set(handles.text_separation,'Visible','Off')
    set(handles.text_stimsize,'Visible','Off')
    set(handles.text_barheight,'Visible','Off')
    set(handles.text_actualdotseparation,'Visible','Off')
    set(handles.text_actualdotsize,'Visible','Off')
    set(handles.text_actualbarheight,'Visible','Off')
    set(handles.text47,'Visible','Off')
    set(handles.text48,'Visible','Off')
    set(handles.text_lengthdim,'Visible','Off')
    set(handles.check_2D,'Visible','Off')
    set(handles.check_i,'Visible','Off')
    
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

set(handles.radio_red,'Value',ExpCfgParams.red);

if get(handles.radio_red,'Value')==1
    set(handles.check_TCA,'Enable','On')
    set(handles.check_TCAcorrection,'Enable','On')
    SYSPARAMS.aoms_state(2)=1;
    set(handles.radio_ir,'Value',0);
else
    set(handles.check_TCA,'Enable','Off')
    set(handles.check_TCAcorrection,'Enable','Off')
    SYSPARAMS.aoms_state(2)=0;
    set(handles.radio_ir,'Value',1);
end

if get(handles.check_off,'Value')==1
    set (handles.edit_Xoff,'Enable','On')
    set (handles.edit_Yoff,'Enable','On')
else
    set (handles.edit_Xoff,'String','0')
    set (handles.edit_Yoff,'String','0')
    set (handles.edit_Xoff,'Enable','Off')
    set (handles.edit_Yoff,'Enable','Off')
end

if get(handles.check_TCAcorrection,'Value')==1
    set (handles.edit_tcaX,'Enable','On')
    set (handles.edit_tcaY,'Enable','On')
else
    set (handles.edit_tcaX,'String','0')
    set (handles.edit_tcaY,'String','0')
    set (handles.edit_tcaX,'Enable','Off')
    set (handles.edit_tcaY,'Enable','Off')
end

set(handles.radio_ir,'Value',ExpCfgParams.ir);
set(handles.edit_gain,'String',ExpCfgParams.gain);
set(handles.edit_angle,'String',ExpCfgParams.angle);
set(handles.check_gainclamp, 'Value', ExpCfgParams.gainclamp);
set(handles.axes_preview,'Visible','off')
set(handles.edit_previewOffset,'String',1);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[0.025 1.0]);

if ExpCfgParams.record==1
    set(handles.videodur,'Enable','On');
    set(handles.viddurlabel,'Enable','On');
else
    set(handles.videodur,'Enable','Off');
    set(handles.viddurlabel,'Enable','Off');
end


user_entry = get(handles.initials,'String');
if get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'String', user_entry)
elseif get(handles.auto_prefix, 'Value') == 0
    %do nothing
end


% --- Executes on button press in check_scan.
function check_scan_Callback(hObject, eventdata, handles)
% hObject    handle to check_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_scan

if get(hObject,'Value')==1
    set(handles.panel_drift,'Visible','On');
    set(handles.edit_drift_angle,'Enable', 'Off');
    set(handles.edit_drift_cpd,'Enable', 'Off');
    set(handles.edit_drift_width,'Enable', 'Off');
elseif ~get(handles.check_drift,'Value')==1
    set(handles.panel_drift,'Visible','Off');
end

drawPreview (handles);
set(handles.push_last,'Enable','On');
set(handles.push_default,'Enable','On');

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


