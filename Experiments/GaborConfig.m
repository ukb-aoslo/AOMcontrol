function varargout = GaborConfig(varargin)
% GABORCONFIG MATLAB code for GaborConfig.fig
%      GABORCONFIG, by itself, creates a new GABORCONFIG or raises the existing
%      singleton*.
%
%      H = GABORCONFIG returns the handle to a new GABORCONFIG or the handle to
%      the existing singleton*.
%
%      GABORCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GABORCONFIG.M with the given input arguments.
%
%      GABORCONFIG('Property','Value',...) creates a new GABORCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GaborConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GaborConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GaborConfig

% Last Modified by GUIDE v2.5 03-Mar-2015 16:55:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GaborConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @GaborConfig_OutputFcn, ...
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


% --- Executes just before GaborConfig is made visible.
function GaborConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GaborConfig (see VARARGIN)

% Choose default command line output for GaborConfig
global SYSPARAMS StimParams VideoParams ExpCfgParams;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GaborConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);
hAomControl = getappdata(0,'hAomControl');
% exp = getappdata(hAomControl, 'exp');

if exist('lastGaborCFG.mat','file')==2
    loadLastValues(handles,1);
else
    loadLastValues(handles,0);
end

set(handles.ok_button, 'Enable', 'on');
set(handles.edit_gain, 'Visible', 'On');

drawPreview (handles);



function stim_size_Callback(hObject, eventdata, handles)

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



function initials_Callback(hObject, eventdata, handles)

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
CFG.record = get(handles.record, 'Value');
CFG.presentdur = str2num(get(handles.presentdur, 'String'));
CFG.iti = str2num(get(handles.iti,'String'));
CFG.check_Gabor = get(handles.check_Gabor, 'Value');
CFG.stimsize = str2num(get(handles.stim_size, 'String'));
CFG.ir_stim_color = get(handles.ir_stim_radio, 'Value');
CFG.red_stim_color = get(handles.red_stim_radio, 'Value');
CFG.green_stim_color = get(handles.green_stim_radio, 'Value');
if get(handles.TwoDown_radio, 'Value') == 1;
    CFG.method = '2d1u';
    CFG.ContrastMin = str2num(get(handles.edit_ContrastMin, 'String'));
    CFG.PeriodsVector = str2num(get(handles.edit_PeriodsVector, 'String'));
    if get(handles.radio_ConLog, 'Value') == 1;
        CFG.ConLogSpace = 1;
    elseif get (handles.radio_ConLin, 'Value') == 1;
        CFG.ConLogSpace = 0;
    end
elseif get (handles.adjust_radio, 'Value') == 1;
    CFG.method = 'Adjust';
    CFG.Period = str2num(get(handles.edit_Period, 'String'));
end
CFG.npresent = str2num(get(handles.npresent, 'String'));
CFG.edit_gain = str2num(get(handles.edit_gain, 'String'));    
CFG.kb_Rotation = get(handles.edit_kb_Rotation, 'String');
CFG.kb_FreqIn = get(handles.edit_kb_FreqIn, 'String');
CFG.kb_FreqDe = get(handles.edit_kb_FreqDe, 'String');
CFG.kb_ContrastInS = get(handles.edit_kb_ContrastInS, 'String');
CFG.kb_ContrastInL = get(handles.edit_kb_ContrastInL, 'String');
CFG.kb_ContrastDeS = get(handles.edit_kb_ContrastDeS, 'String');
CFG.kb_ContrastDeL = get(handles.edit_kb_ContrastDeL, 'String');
CFG.green_x_offset = str2num(get(handles.green_x_offset,'String'));
CFG.green_y_offset = str2num(get(handles.green_y_offset,'String'));
CFG.red_x_offset = str2num(get(handles.red_x_offset,'String'));
CFG.red_y_offset = str2num(get(handles.red_y_offset,'String'));

CFG.sigma = str2num(get(handles.edit_sigma, 'String'));
CFG.ContrastMax = str2num(get(handles.edit_ContrastMax, 'String'));

CFG.RotStepSize = str2num(get(handles.edit_RotStepSize, 'String'));
CFG.ConSStepSize = str2num(get(handles.edit_ConSStepSize, 'String'));
CFG.ConLStepSize = str2num(get(handles.edit_ConLStepSize, 'String'));
CFG.PeriodStepSize = str2num(get(handles.edit_PeriodStepSize, 'String'));


% Save the same for retrieval while loading last values
ExpCfgParams = CFG;

setappdata(hAomControl, 'CFG', CFG);

save('lastGaborCFG.mat', 'ExpCfgParams','CFG')

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


% --- Executes when selected object is changed in method_radio_panel.
function method_radio_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in method_radio_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.TwoDown_radio, 'Value') == 1;
    set(handles.text23, 'Visible', 'on', 'String', 'Next');
    set(handles.text22, 'Visible', 'on', 'String', 'right tilted');
    set(handles.text28, 'Visible', 'on', 'String', 'left tilted');
    set(handles.text52, 'Visible', 'on', 'String', 'Contrast Min');
    set(handles.text39, 'Visible', 'on', 'String', 'Contrast Max');
    set(handles.text38, 'Visible', 'on', 'String', 'Periods [cyc/deg]');
    set(handles.edit_PeriodsVector, 'Visible', 'on');
    set(handles.edit_ContrastMin, 'Visible','on');
    set(handles.radio_ConLog,'Visible','on');
    set(handles.radio_ConLin,'Visible','on');
    set(handles.edit_Period,'Visible','off');
    set(handles.text24, 'Visible', 'off');
    set(handles.text32, 'Visible', 'off');
    set(handles.text25, 'Visible', 'off');
    set(handles.text31, 'Visible', 'off');
    set(handles.text33, 'Visible', 'off');
    set(handles.text30, 'Visible', 'off');
    set(handles.text46, 'Visible', 'off');
    set(handles.text47, 'Visible', 'off');
    set(handles.text48, 'Visible', 'off');
    set(handles.edit_ConSStepSize, 'Visible', 'off');
    set(handles.edit_ConLStepSize, 'Visible', 'off');
    set(handles.edit_PeriodStepSize, 'Visible', 'off');
    set(handles.edit_kb_ContrastInS, 'Visible', 'off');
    set(handles.edit_kb_ContrastDeS, 'Visible', 'off');
    set(handles.edit_kb_ContrastInL, 'Visible', 'off');
    set(handles.edit_kb_ContrastDeL, 'Visible', 'off');

elseif get(handles.adjust_radio, 'Value') == 1;
	set(handles.text23, 'Visible', 'on', 'String', 'Rotation');
    set(handles.text22, 'Visible', 'on', 'String', 'Freq. Increase');
    set(handles.text28, 'Visible', 'on', 'String', 'Freq. Decrease');
    set(handles.text52, 'Visible', 'off');
    set(handles.text39, 'Visible', 'on', 'String', 'Contrast');
    set(handles.text38, 'Visible', 'on', 'String', 'Period [cyc/deg]');
    set(handles.edit_PeriodsVector, 'Visible', 'off');
    set(handles.edit_ContrastMin, 'Visible','off');
    set(handles.radio_ConLog,'Visible','off');
    set(handles.radio_ConLin,'Visible','off');
    set(handles.edit_Period,'Visible','on');
    set(handles.text24, 'Visible', 'on');
    set(handles.text32, 'Visible', 'on');
    set(handles.text25, 'Visible', 'on');
    set(handles.text31, 'Visible', 'on');
    set(handles.text33, 'Visible', 'on');
    set(handles.text30, 'Visible', 'on');
    set(handles.text46, 'Visible', 'on');
    set(handles.text47, 'Visible', 'on');
    set(handles.text48, 'Visible', 'on');
    set(handles.edit_ConSStepSize, 'Visible', 'on');
    set(handles.edit_ConLStepSize, 'Visible', 'on');
    set(handles.edit_PeriodStepSize, 'Visible', 'on');
    set(handles.edit_kb_ContrastInS, 'Visible', 'on');
    set(handles.edit_kb_ContrastDeS, 'Visible', 'on');
    set(handles.edit_kb_ContrastInL, 'Visible', 'on');
    set(handles.edit_kb_ContrastDeL, 'Visible', 'on');
end


function loadLastValues (handles,last)

global SYSPARAMS StimParams VideoParams ExpCfgParams; %#ok<*NUSED>

if last==1
    load('lastGaborCFG.mat');
else %Set default values here
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.pupilsize = 6.0;
    ExpCfgParams.fieldsize = 1.28; 
    ExpCfgParams.videodur = 1; 
    ExpCfgParams.record = 1;
    ExpCfgParams.presentdur = 30;
    ExpCfgParams.iti = 1000;
    ExpCfgParams.check_Gabor = 1;
    ExpCfgParams.stimsize = 128;
    ExpCfgParams.ir_stim_color = 0;
    ExpCfgParams.red_stim_color = 0;
    ExpCfgParams.green_stim_color = 1;
    ExpCfgParams.method = 'Adjust';
    ExpCfgParams.npresent = 40;
    ExpCfgParams.edit_gain = 1;
    ExpCfgParams.kb_Rotation = 'space';
    ExpCfgParams.kb_FreqIn = 'rightarrow';
    ExpCfgParams.kb_FreqDe = 'leftarrow';
    ExpCfgParams.kb_ContrastInS = 'uparrow';
    ExpCfgParams.kb_ContrastInL = 'shift';
    ExpCfgParams.kb_ContrastDeS = 'downarrow';
    ExpCfgParams.kb_ContrastDeL = 'control';
    ExpCfgParams.kb_Abort = 'escape';
    ExpCfgParams.green_x_offset = 0;
    ExpCfgParams.green_y_offset = 0;
    ExpCfgParams.red_x_offset = 0;
    ExpCfgParams.red_y_offset = 0;
    ExpCfgParams.sigma= 20;
    ExpCfgParams.Period = 10;
    ExpCfgParams.PeriodsVector = [2 5 30 50];
    ExpCfgParams.ContrastMax = 1;
    ExpCfgParams.ConLogSpace = 1;
    ExpCfgParams.RotStepSize = 45;
    ExpCfgParams.ConSStepSize = .01;
    ExpCfgParams.ConLStepSize = .1;
    ExpCfgParams.PeriodStepSize = 1;

end

set(handles.initials, 'String', ExpCfgParams.initials);
set(handles.pupilsize, 'String', ExpCfgParams.pupilsize);
set(handles.fieldsize, 'String', ExpCfgParams.fieldsize);
set(handles.videodur, 'String', ExpCfgParams.videodur);
set(handles.vidprefix, 'String', VideoParams.vidprefix);
set(handles.record, 'Value', ExpCfgParams.record);
set(handles.presentdur, 'String', ExpCfgParams.presentdur);
set(handles.iti, 'String', ExpCfgParams.iti);
set(handles.check_Gabor, 'Value', ExpCfgParams.check_Gabor);
set(handles.stim_size, 'String', ExpCfgParams.stimsize);
set(handles.ir_stim_radio, 'Value', ExpCfgParams.ir_stim_color);
set(handles.red_stim_radio, 'Value', ExpCfgParams.red_stim_color);
set(handles.green_stim_radio, 'Value', ExpCfgParams.green_stim_color);

set(handles.npresent, 'String', ExpCfgParams.npresent);
set(handles.edit_gain, 'String', ExpCfgParams.edit_gain);
set(handles.edit_kb_Rotation, 'String',ExpCfgParams.kb_Rotation);
set(handles.edit_kb_FreqIn, 'String',ExpCfgParams.kb_FreqIn);
set(handles.edit_kb_FreqDe, 'String',ExpCfgParams.kb_FreqDe);
set(handles.edit_kb_ContrastInS, 'String',ExpCfgParams.kb_ContrastInS);
set(handles.edit_kb_ContrastInL, 'String',ExpCfgParams.kb_ContrastInL);
set(handles.edit_kb_ContrastDeS, 'String',ExpCfgParams.kb_ContrastDeS);
set(handles.edit_kb_ContrastDeL, 'String',ExpCfgParams.kb_ContrastDeL);
set(handles.green_x_offset, 'String', ExpCfgParams.green_x_offset);
set(handles.green_y_offset, 'String', ExpCfgParams.green_y_offset);
set(handles.red_x_offset, 'String', ExpCfgParams.red_x_offset);
set(handles.red_y_offset, 'String', ExpCfgParams.red_y_offset);

set(handles.edit_sigma, 'String', ExpCfgParams.sigma);
set(handles.edit_ContrastMax, 'String', ExpCfgParams.ContrastMax);

set(handles.edit_RotStepSize, 'String',ExpCfgParams.RotStepSize);
set(handles.edit_ConSStepSize, 'String',ExpCfgParams.ConSStepSize);
set(handles.edit_ConLStepSize, 'String',ExpCfgParams.ConLStepSize);
set(handles.edit_PeriodStepSize, 'String',ExpCfgParams.PeriodStepSize);

set(handles.ok_button, 'Enable', 'on');

if strcmp(ExpCfgParams.method,'2d1u')
    set(handles.adjust_radio, 'Value',0);
    set(handles.TwoDown_radio, 'Value',1);
elseif strcmp(ExpCfgParams.method,'Adjust')
    set(handles.adjust_radio, 'Value',1);
    set(handles.TwoDown_radio, 'Value',0);
end
if get(handles.TwoDown_radio, 'Value') == 1;
    set(handles.text23, 'Visible', 'on', 'String', 'Next');
    set(handles.text22, 'Visible', 'on', 'String', 'right tilted');
    set(handles.text28, 'Visible', 'on', 'String', 'left tilted');
    set(handles.text52, 'Visible', 'on', 'String', 'Contrast Min');
    set(handles.text39, 'Visible', 'on', 'String', 'Contrast Max');
    set(handles.text38, 'Visible', 'on', 'String', 'Periods [cyc/deg]');
    set(handles.edit_PeriodsVector, 'Visible', 'on','String', num2str(ExpCfgParams.PeriodsVector));
    set(handles.edit_ContrastMin, 'Visible','on','String', ExpCfgParams.ContrastEnd);
    if ExpCfgParams.ConLogSpace
        set(handles.radio_ConLog,'Visible','on','Value',1);
        set(handles.radio_ConLin,'Visible','on','Value',0);
    else
        set(handles.radio_ConLog,'Visible','on','Value',0);
        set(handles.radio_ConLin,'Visible','on','Value',1);
    end
    set(handles.edit_Period,'Visible','off');
    set(handles.text24, 'Visible', 'off');
    set(handles.text32, 'Visible', 'off');
    set(handles.text25, 'Visible', 'off');
    set(handles.text31, 'Visible', 'off');
    set(handles.text33, 'Visible', 'off');
    set(handles.text30, 'Visible', 'off');
    set(handles.text46, 'Visible', 'off');
    set(handles.text47, 'Visible', 'off');
    set(handles.text48, 'Visible', 'off');
    set(handles.edit_ConSStepSize, 'Visible', 'off');
    set(handles.edit_ConLStepSize, 'Visible', 'off');
    set(handles.edit_PeriodStepSize, 'Visible', 'off');
    set(handles.edit_kb_ContrastInS, 'Visible', 'off');
    set(handles.edit_kb_ContrastDeS, 'Visible', 'off');
    set(handles.edit_kb_ContrastInL, 'Visible', 'off');
    set(handles.edit_kb_ContrastDeL, 'Visible', 'off');

elseif get(handles.adjust_radio, 'Value') == 1;
	set(handles.text23, 'Visible', 'on', 'String', 'Rotation');
    set(handles.text22, 'Visible', 'on', 'String', 'Freq. Increase');
    set(handles.text28, 'Visible', 'on', 'String', 'Freq. Decrease');
    set(handles.text52, 'Visible', 'off');
    set(handles.text39, 'Visible', 'on', 'String', 'Contrast');
    set(handles.text38, 'Visible', 'on', 'String', 'Period [cyc/deg]');
    set(handles.edit_PeriodsVector, 'Visible', 'off');
    set(handles.edit_ContrastMin, 'Visible','off');
    set(handles.radio_ConLog,'Visible','off');
    set(handles.radio_ConLin,'Visible','off');
    set(handles.edit_Period,'Visible','on');
    set(handles.text24, 'Visible', 'on');
    set(handles.text32, 'Visible', 'on');
    set(handles.text25, 'Visible', 'on');
    set(handles.text31, 'Visible', 'on');
    set(handles.text33, 'Visible', 'on');
    set(handles.text30, 'Visible', 'on');
    set(handles.text46, 'Visible', 'on');
    set(handles.text47, 'Visible', 'on');
    set(handles.text48, 'Visible', 'on');
    set(handles.edit_Period, 'String', ExpCfgParams.Period);
    set(handles.edit_ConSStepSize, 'Visible', 'on');
    set(handles.edit_ConLStepSize, 'Visible', 'on');
    set(handles.edit_PeriodStepSize, 'Visible', 'on');
    set(handles.edit_kb_ContrastInS, 'Visible', 'on');
    set(handles.edit_kb_ContrastDeS, 'Visible', 'on');
    set(handles.edit_kb_ContrastInL, 'Visible', 'on');
    set(handles.edit_kb_ContrastDeL, 'Visible', 'on');
end



user_entry = get(handles.initials,'String');
if get(handles.auto_prefix, 'Value') == 1
    set(handles.vidprefix, 'String', user_entry)
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


function drawPreview (handles)

Contrast = str2num(get(handles.edit_ContrastMax, 'String'));

%% Gabor
imSize = str2num(get(handles.stim_size, 'String'));                           % image size: n X n
Period = str2num(get(handles.edit_Period, 'String')); % wavelength (number of pixels per cycle)

Field = 512/str2num(get(handles.fieldsize, 'String'));
lambda = Field/Period;

theta = 0;                        % grating orientation
sigma = str2num(get(handles.edit_sigma, 'String'));      % 10                 % gaussian standard deviation in pixels
% phase = .25;                             % phase (0 -> 1)
phase = round(rand(1)*10)/10;
trim = .005;        % .005               % trim off gaussian values smaller than this

X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;                 % rescale X -> -1 to 1

freq = imSize/lambda;                    % compute frequency from wavelength
phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi

[Xm,Ym] = meshgrid(X0, X0);             % 2D matrices

thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
grating = sin( XYf + phaseRad);         % make 2D sinewave and add Contrast adjustment

s = sigma / imSize;                     % gaussian width as fraction of imageSize

gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian

gauss(gauss < trim) = 0;                 % trim around edges (for 8-bit colour displays)
prepreGabor = grating.* gauss;           % use .* dot-product

preGabor = prepreGabor+abs(min(prepreGabor(:)));    % adjust Gabor to min = 0
Gabor=preGabor/max(preGabor(:)).*Contrast;          % adjust Gabor to max = 1 and add Contrast adjustment
Gabor=Gabor+(.5-mean(Gabor(:)));                    % adjust to a Gabor mean of .5
Gabor(Gabor<0)=0; Gabor(Gabor>1)=1;
        
if get(handles.check_Gabor, 'Value')
    Gabor = Gabor+1;
    PreviewBuffer = Gabor./2;
else
%     Gabor(Gabor<0)=0;
    PreviewBuffer = Gabor;
end

PreviewBufferB = zeros(imSize,imSize,3);

if get(handles.red_stim_radio, 'Value')==1;
    PreviewBufferB(:,:,1) = PreviewBuffer;
elseif get(handles.green_stim_radio, 'Value') ==1;
    PreviewBufferB(:,:,2) = PreviewBuffer;
elseif get(handles.ir_stim_radio, 'Value') == 1;
    PreviewBufferB(:,:,1) = PreviewBuffer;
    PreviewBufferB(:,:,2) = PreviewBuffer;
    PreviewBufferB(:,:,3) = PreviewBuffer;
end

imshow(PreviewBufferB,'Parent',handles.axes_preview)
axis(handles.axes_preview,'off')
disp('drawn');



function edit_RotStepSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RotStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RotStepSize as text
%        str2double(get(hObject,'String')) returns contents of edit_RotStepSize as a double


% --- Executes during object creation, after setting all properties.
function edit_RotStepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RotStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Period_Callback(hObject, eventdata, handles)
drawPreview (handles)

% PxlPerDegree = 512/str2num(get(handles.fieldsize,'String'));
% Val_CycPerDegree = PxlPerDegree/str2num(get(handles.edit_Period,'String'));
% Val_CycPerDegree = round(Val_CycPerDegree*10)/10;
% Insert = [num2str(Val_CycPerDegree) ' cyc/degree'];



% --- Executes during object creation, after setting all properties.
function edit_Period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ContrastMax_Callback(hObject, eventdata, handles)
drawPreview (handles)

% --- Executes during object creation, after setting all properties.
function edit_ContrastMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ContrastMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sigma_Callback(hObject, eventdata, handles)
drawPreview (handles)

% --- Executes during object creation, after setting all properties.
function edit_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
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



function edit_ConLStepSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ConLStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ConLStepSize as text
%        str2double(get(hObject,'String')) returns contents of edit_ConLStepSize as a double


% --- Executes during object creation, after setting all properties.
function edit_ConLStepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ConLStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ConSStepSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ConSStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ConSStepSize as text
%        str2double(get(hObject,'String')) returns contents of edit_ConSStepSize as a double


% --- Executes during object creation, after setting all properties.
function edit_ConSStepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ConSStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_PeriodStepSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PeriodStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PeriodStepSize as text
%        str2double(get(hObject,'String')) returns contents of edit_PeriodStepSize as a double


% --- Executes during object creation, after setting all properties.
function edit_PeriodStepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PeriodStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Outputs from this function are returned to the command line.
function varargout = GaborConfig_OutputFcn(hObject, eventdata, handles) 
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



function edit_kb_ContrastInS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastInS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_ContrastInS as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_ContrastInS as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_ContrastInS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastInS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_FreqDe_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_FreqDe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_FreqDe as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_FreqDe as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_FreqDe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_FreqDe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_FreqIn_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_FreqIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_FreqIn as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_FreqIn as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_FreqIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_FreqIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_Rotation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_Rotation as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_Rotation as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_Rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_ContrastInL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastInL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_ContrastInL as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_ContrastInL as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_ContrastInL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastInL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_ContrastDeS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastDeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_ContrastDeS as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_ContrastDeS as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_ContrastDeS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastDeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kb_ContrastDeL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastDeL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kb_ContrastDeL as text
%        str2double(get(hObject,'String')) returns contents of edit_kb_ContrastDeL as a double


% --- Executes during object creation, after setting all properties.
function edit_kb_ContrastDeL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kb_ContrastDeL (see GCBO)
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


% --- Executes on button press in check_Gabor.
function check_Gabor_Callback(hObject, eventdata, handles)
% hObject    handle to check_Gabor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_Gabor
drawPreview (handles)



% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of record



function edit_ContrastMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ContrastMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ContrastMin as text
%        str2double(get(hObject,'String')) returns contents of edit_ContrastMin as a double


% --- Executes during object creation, after setting all properties.
function edit_ContrastMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ContrastMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radio_ConLog.
function radio_ConLog_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ConLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ConLog
set(handles.radio_ConLin,'Value',0);

% --- Executes on button press in radio_ConLin.
function radio_ConLin_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ConLin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ConLin
set(handles.radio_ConLog,'Value',0);


function edit_PeriodsVector_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PeriodsVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PeriodsVector as text
%        str2double(get(hObject,'String')) returns contents of edit_PeriodsVector as a double


% --- Executes during object creation, after setting all properties.
function edit_PeriodsVector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PeriodsVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
