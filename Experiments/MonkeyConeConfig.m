function varargout = MonkeyConeConfig(varargin)
% MONKEYCONECONFIG M-file for MonkeyConeConfig.fig
%      MONKEYCONECONFIG, by itself, creates a new MONKEYCONECONFIG or raises the existing
%      singleton*.
%
%      H = MONKEYCONECONFIG returns the handle to a new MONKEYCONECONFIG or the handle to
%      the existing singleton*.
%
%      MONKEYCONECONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONKEYCONECONFIG.M with the given input arguments.
%
%      MONKEYCONECONFIG('Property','Value',...) creates a new MONKEYCONECONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MonkeyConeConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MonkeyConeConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MonkeyConeConfig

% Last Modified by GUIDE v2.5 22-Dec-2014 11:27:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MonkeyConeConfig_OpeningFcn, ...
    'gui_OutputFcn',  @MonkeyConeConfig_OutputFcn, ...
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


% --- Executes just before MonkeyConeConfig is made visible.
function MonkeyConeConfig_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MonkeyConeConfig (see VARARGIN)

% Choose default command line output for MonkeyConeConfig
global SYSPARAMS StimParams VideoParams ExpCfgParams;
handles.output = hObject;
guidata(hObject, handles);

if exist('lastMonkeyCFG.mat','file')==2
    loadLastValues(handles,1);
    set(handles.push_default,'Enable','On');
    set(handles.push_last,'Enable','Off');
else
    loadLastValues(handles,0);
    set(handles.push_default,'Enable','Off');
    set(handles.push_last,'Enable','On');
end

drawPreview (hObject,handles);
update_statusfield (hObject,handles);


% --- Outputs from this function are returned to the command line.
function varargout = MonkeyConeConfig_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function axes_preview_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU>
function edit_initials_Callback(hObject, eventdata, handles)
function edit_initials_CreateFcn(hObject, eventdata, handles)
function edit_pupilsize_Callback(hObject, eventdata, handles)
function edit_pupilsize_CreateFcn(hObject, eventdata, handles)
function edit_fieldsize_Callback(hObject, eventdata, handles)
function edit_fieldsize_CreateFcn(hObject, eventdata, handles)
function edit_repeats_Callback(hObject, eventdata, handles)
function edit_repeats_CreateFcn(hObject, eventdata, handles)
function edit_framesOFF_CreateFcn(hObject, eventdata, handles)
function edit_framesON_CreateFcn(hObject, eventdata, handles)
function edit_pause_Callback(hObject, eventdata, handles)
function edit_pause_CreateFcn(hObject, eventdata, handles)
function basic_panel_CreateFcn(hObject, eventdata, handles)
function edit_gain_Callback(hObject, eventdata, handles)
function edit_gain_CreateFcn(hObject, eventdata, handles)
function edit_stimsize_CreateFcn(hObject, eventdata, handles)
function stim_panel_CreateFcn(hObject, eventdata, handles)
function edit_tca_greeny_Callback(hObject, eventdata, handles)
function edit_tca_greeny_CreateFcn(hObject, eventdata, handles)
function edit_tca_greenx_Callback(hObject, eventdata, handles)
function edit_tca_greenx_CreateFcn(hObject, eventdata, handles)
function edit_tca_redy_Callback(hObject, eventdata, handles)
function edit_tca_redy_CreateFcn(hObject, eventdata, handles)
function edit_tca_redx_Callback(hObject, eventdata, handles)
function edit_tca_redx_CreateFcn(hObject, eventdata, handles)
function check_previewCones_Callback(hObject, eventdata, handles)
drawPreview (hObject,handles)
function check_legend_Callback(hObject, eventdata, handles)
drawPreview (hObject,handles)
function check_showcross_Callback(hObject, eventdata, handles)
drawPreview (hObject,handles)
function check_antialiased_Callback(hObject, eventdata, handles)
drawPreview (hObject,handles);
function edit_stimsize_Callback(hObject, eventdata, handles)
drawPreview (hObject,handles);
function edit_mocsmax_Callback(hObject, eventdata, handles)
update_statusfield(hObject,handles);
function edit_mocsmax_CreateFcn(hObject, eventdata, handles)
function edit_mocsmin_Callback(hObject, eventdata, handles)
update_statusfield(hObject,handles);
function edit_mocsmin_CreateFcn(hObject, eventdata, handles)
function edit_mocsn_Callback(hObject, eventdata, handles)
update_statusfield(hObject,handles);
function edit_mocsn_CreateFcn(hObject, eventdata, handles)

function edit_framesON_Callback(hObject, eventdata, handles)
onframes = str2num(get(handles.edit_framesON,'String'));
offframes = str2num(get(handles.edit_framesOFF,'String'));
frequency = 30/(onframes+offframes);
set(handles.text_onfreq,'String',['Stimulus Frequency (Hz): ',num2str(frequency,3)]);
if mod(30,(onframes+offframes))==0
    set(handles.edit_framesON,'ForegroundColor',[0 0 0]);
    set(handles.edit_framesON,'BackgroundColor',[1 1 1]);
    set(handles.edit_framesOFF,'ForegroundColor',[0 0 0]);
    set(handles.edit_framesOFF,'BackgroundColor',[1 1 1]);
    set(handles.push_ok,'Enable','on');
else
    set(handles.edit_framesON,'ForegroundColor',[1 1 1]);
    set(handles.edit_framesON,'BackgroundColor',[1 0 0]);
    set(handles.edit_framesOFF,'ForegroundColor',[1 1 1]);
    set(handles.edit_framesOFF,'BackgroundColor',[1 0 0]);
    set(handles.push_ok,'Enable','off');
end

function edit_framesOFF_Callback(hObject, eventdata, handles)
onframes = str2num(get(handles.edit_framesON,'String'));
offframes = str2num(get(handles.edit_framesOFF,'String'));
frequency = 30/(onframes+offframes);
set(handles.text_onfreq,'String',['Stimulus Frequency (Hz): ',num2str(frequency,3)]);
if mod(30,(onframes+offframes))==0
    set(handles.edit_framesON,'ForegroundColor',[0 0 0]);
    set(handles.edit_framesON,'BackgroundColor',[1 1 1]);
    set(handles.edit_framesOFF,'ForegroundColor',[0 0 0]);
    set(handles.edit_framesOFF,'BackgroundColor',[1 1 1]);
    set(handles.push_ok,'Enable','on');
else
    set(handles.edit_framesON,'ForegroundColor',[1 1 1]);
    set(handles.edit_framesON,'BackgroundColor',[1 0 0]);
    set(handles.edit_framesOFF,'ForegroundColor',[1 1 1]);
    set(handles.edit_framesOFF,'BackgroundColor',[1 0 0]);
    set(handles.push_ok,'Enable','off');
end

function radio_linspace_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.radio_logspace,'Value',0);
else
    set(handles.radio_logspace,'Value',1);
end
update_statusfield(hObject,handles);

function radio_logspace_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.radio_linspace,'Value',0);
else
    set(handles.radio_linspace,'Value',1);
end
update_statusfield(hObject,handles);


function check_red_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
set(handles.radio_ir,'Value',0);
else
    if get(handles.check_green,'Value')==0
        set(handles.radio_ir,'Value',1)
    end
end

drawPreview (hObject,handles);
update_statusfield(hObject,handles);

function check_green_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
set(handles.radio_ir,'Value',0);
else
    if get(handles.check_red,'Value')==0
        set(handles.radio_ir,'Value',1)
    end
end
drawPreview (hObject,handles);
update_statusfield(hObject,handles);

function radio_ir_Callback(hObject, eventdata, handles)
set(handles.check_red,'Value',0);
set(handles.check_green,'Value',0);
set(hObject,'Value',1);
drawPreview (hObject,handles);
update_statusfield(hObject,handles);




function push_ok_Callback(hObject, eventdata, handles)
hAomControl = getappdata(0,'hAomControl');
stimpath = [pwd,'\tempStimulus\'];
setappdata(hAomControl, 'stimpath', stimpath);

WO_Matrix = WorkOrder(handles);

CFG.ok = 1;
CFG.stimpath = stimpath;
CFG.initials = get(handles.edit_initials, 'String');
CFG.pupilsize = str2num(get(handles.edit_pupilsize, 'String'));
CFG.fieldsize = str2num(get(handles.edit_fieldsize, 'String'));
CFG.repeats = str2num(get(handles.edit_repeats, 'String'));
CFG.vidprefix = get(handles.edit_initials, 'String');
CFG.record = 1;
CFG.framesON = str2num(get(handles.edit_framesON, 'String'));
CFG.pause = str2num(get(handles.edit_pause,'String'));
CFG.stimsize = str2num(get(handles.edit_stimsize, 'String'));
CFG.ir = get(handles.radio_ir, 'Value');
CFG.red = get(handles.check_red, 'Value');
CFG.green = get(handles.check_green, 'Value');

if get(handles.radio_circle, 'Value') == 1;
    CFG.stim_shape = 'Circle';
elseif get(handles.radio_square, 'Value') == 1;
    CFG.stim_shape = 'Square';
end
CFG.antialiased = get(handles.check_antialiased,'Value');
CFG.mocsmin = str2num(get(handles.edit_mocsmin, 'String'));
CFG.mocsmax = str2num(get(handles.edit_mocsmax, 'String'));
CFG.mocsstep = str2num(get(handles.edit_mocsn, 'String'));
CFG.linspaced = get(handles.radio_linspace,'Value');
CFG.offset_script = get(handles.offset_script, 'Value');
CFG.multidot = get(handles.checkbox_multidot,'Value');
CFG.summation = get(handles.checkbox_summation,'Value');
CFG.pairs = get(handles.radio_pairs,'Value');
CFG.singlemax = get(handles.radio_max,'Value');
CFG.twopoint = get(handles.checkbox_twopoint,'Value');
CFG.gain = str2num(get(handles.edit_gain, 'String'));
CFG.green_x_offset = str2num(get(handles.edit_tca_greenx,'String'));
CFG.green_y_offset = str2num(get(handles.edit_tca_greeny,'String'));
CFG.red_x_offset = str2num(get(handles.edit_tca_redx,'String'));
CFG.red_y_offset = str2num(get(handles.edit_tca_redy,'String'));

% Save the same for retrieval while loading last values
ExpCfgParams = CFG;
setappdata(hAomControl, 'CFG', CFG);
save('lastMonkeyCFG.mat', 'ExpCfgParams','CFG')

close;


function push_cancel_Callback(hObject, eventdata, handles)
hAomControl = getappdata(0,'hAomControl');
CFG.ok = 0;
setappdata(hAomControl, 'CFG', CFG);
close;

function loadLastValues (handles,last)

global SYSPARAMS StimParams VideoParams ExpCfgParams; %#ok<*NUSED>

if last==1
    load('lastMonkeyCFG.mat');
else %Set default values here
    ExpCfgParams.initials = 'Sample';
    ExpCfgParams.pupilsize = 6.0;
    ExpCfgParams.fieldsize = 1.2;
    ExpCfgParams.videodur = 1;
    ExpCfgParams.presentdur = 1;
    ExpCfgParams.iti = 5;
    ExpCfgParams.stimsize = 5;
    ExpCfgParams.gain = 1;
    ExpCfgParams.ir_stim_color = 0;
    ExpCfgParams.red_stim_color = 0;
    ExpCfgParams.green_stim_color = 1;
    ExpCfgParams.stim_shape = 'Square';
    ExpCfgParams.antialiased = 0;
    ExpCfgParams.method = 'MOCS';
    ExpCfgParams.mocsmin = 0;
    ExpCfgParams.mocsmax = 1;
    ExpCfgParams.mocsstep = 10;
    ExpCfgParams.linspaced = 1;
    ExpCfgParams.offset_script = 0;
    ExpCfgParams.multidot = 0;
    ExpCfgParams.summation = 0;
    ExpCfgParams.twopoint = 0;
    ExpCfgParams.pairs = 0;
    ExpCfgParams.singlemax = 0;
    ExpCfgParams.npresent = 22;
    ExpCfgParams.green_x_offset = 0;
    ExpCfgParams.green_y_offset = 0;
    ExpCfgParams.red_x_offset = 0;
    ExpCfgParams.red_y_offset = 0;
end

set(handles.edit_initials, 'String', ExpCfgParams.initials);
set(handles.edit_initials, 'String', VideoParams.vidprefix);

set(handles.edit_pupilsize, 'String', ExpCfgParams.pupilsize);
set(handles.edit_fieldsize, 'String', ExpCfgParams.fieldsize);
set(handles.edit_repeats, 'String', ExpCfgParams.videodur);
% set(handles.vidprefix, 'String', VideoParams.vidprefix);
set(handles.edit_framesON, 'String', ExpCfgParams.presentdur);
set(handles.edit_pause, 'String', ExpCfgParams.iti);
set(handles.edit_stimsize, 'String', ExpCfgParams.stimsize);
set(handles.radio_ir, 'Value', ExpCfgParams.ir_stim_color);
set(handles.check_red, 'Value', ExpCfgParams.red_stim_color);
set(handles.check_green, 'Value', ExpCfgParams.green_stim_color);
if strcmp(ExpCfgParams.stim_shape,'Circle')
    set(handles.radio_circle, 'Value', 1);
    set(handles.radio_square, 'Value', 0);
else
    set(handles.radio_circle, 'Value', 0);
    set(handles.radio_square, 'Value', 1);
end
set(handles.check_antialiased,'Value', ExpCfgParams.antialiased);
set(handles.edit_mocsmin, 'String', ExpCfgParams.mocsmin);
set(handles.edit_mocsmax, 'String', ExpCfgParams.mocsmax);
set(handles.edit_mocsn, 'String', ExpCfgParams.mocsstep);
set(handles.radio_linspace,'Value',ExpCfgParams.linspaced);
set(handles.offset_script, 'Value', ExpCfgParams.offset_script);
set(handles.checkbox_multidot,'Value', ExpCfgParams.multidot);
set(handles.checkbox_summation,'Value', ExpCfgParams.summation);
set(handles.radio_pairs,'Value', ExpCfgParams.pairs);
set(handles.radio_max,'Value', ExpCfgParams.singlemax);
set(handles.checkbox_twopoint,'Value', ExpCfgParams.twopoint);
set(handles.edit_gain, 'String', ExpCfgParams.gain);
set(handles.edit_tca_greenx, 'String', ExpCfgParams.green_x_offset);
set(handles.edit_tca_greeny, 'String', ExpCfgParams.green_y_offset);
set(handles.edit_tca_redx, 'String', ExpCfgParams.red_x_offset);
set(handles.edit_tca_redy, 'String', ExpCfgParams.red_y_offset);

if get(handles.checkbox_summation,'Value')==1
    set(handles.uipanel_summation,'Visible','On');
else
    set(handles.uipanel_summation,'Visible','Off');
end

set(handles.push_ok, 'Enable', 'on');




function offset_script_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
    set(handles.checkbox_summation,'Value',0);
    set(handles.checkbox_multidot,'Value',0);
    set(handles.checkbox_twopoint,'Value',0);
    set(handles.uipanel_summation,'Visible','Off');
    set(handles.edit_mocsmin,'BackgroundColor',[1 1 1]);
    set(handles.edit_mocsn,'BackgroundColor',[1 1 1]);
end

function checkbox_multidot_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
    set(handles.checkbox_summation,'Value',0);
    set(handles.offset_script,'Value',0);
    set(handles.checkbox_twopoint,'Value',0);
    set(handles.uipanel_summation,'Visible','Off');
    set(handles.edit_mocsmin,'BackgroundColor',[1 1 1]);
    set(handles.edit_mocsn,'BackgroundColor',[1 1 1]);
end

function checkbox_summation_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
    set(handles.uipanel_summation,'Visible','On');
    set(handles.checkbox_multidot,'Value',0);
    set(handles.checkbox_twopoint,'Value',0);
    set(handles.offset_script,'Value',0);
    set(handles.edit_mocsmin,'BackgroundColor',[1 1 1]);
    set(handles.edit_mocsn,'BackgroundColor',[1 1 1]);
else
    set(handles.uipanel_summation,'Visible','Off');
end

function checkbox_twopoint_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
    set(handles.checkbox_summation,'Value',0);
    set(handles.checkbox_multidot,'Value',0);
    set(handles.offset_script,'Value',0);
    set(handles.uipanel_summation,'Visible','Off');
    set(handles.edit_mocsmin,'BackgroundColor',[1 0 0]);
    set(handles.edit_mocsn,'BackgroundColor',[1 0 0]);
else
    set(handles.edit_mocsmin,'BackgroundColor',[1 1 1]);
    set(handles.edit_mocsn,'BackgroundColor',[1 1 1]);
end


function radio_pairs_Callback(hObject, eventdata, handles) %#ok<*INUSD>
if get(hObject,'Value')
    set(handles.radio_max,'Value',0);
end

function radio_max_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.radio_pairs,'Value',0);
end




function drawPreview (hObject, handles)

% Initiate plot
ax_position = get(gca,'Position');
ax_width = ax_position(3);
ax_height = ax_position(4);
alphaadjust = 0.6; % Setting the transparency of stimuli in preview

emptyaxes = rand(ax_height,ax_width,3);
hi = imshow(emptyaxes);

% If no location has been set yet
if ~isfield(handles,'baseI')
    usfac = 15;
    I = rand(ax_height,ax_width,3);
    I = imcrop(I,[0 0 round(ax_width/usfac) round(ax_height/usfac)]);
    I = imresize(I,usfac);
    I = imadjust(I,[],[0 0.4]);
    set(hi,'CData',I);
    set(handles.text_fileselection,'String','-  No cones selected  -');
    
    % Do the following after a retinal location has been selected
else
    
    set(handles.text_fileselection,'String',handles.fname);
    
    % Stimulus parameters
    Im = handles.baseI;
    dotsize = str2num(get(handles.edit_stimsize,'String'));
    if get(handles.radio_square,'Value')
        dottype = 'Square';
    else
        dottype = 'Circle';
    end
    xi = handles.xi
    yi = handles.yi
    antialias = get(handles.check_antialiased,'Value');
    crossx = handles.crossx; crossy = handles.crossy;
    cropsize = 5+max([abs(crossx-min(xi)),abs(max(xi)-crossx),abs(crossy-min(yi)),abs(max(yi)-crossy)]);
    
    % Make stimulus image
    S = zeros(size(Im,1),size(Im,1),length(xi));
    for j = 1:length(xi)
        S(:,:,j) = makeStimulus (size(Im,1), size(Im,2), dotsize, dottype, xi(j), yi(j), antialias);
    end
    S = sum(S,3)./max(max(sum(S,3)));
    S = S.*alphaadjust;
    
    % Make cone image and cross overlay
    I = cat(3,im2double(handles.baseI),im2double(handles.baseI),im2double(handles.baseI));
    if get(handles.check_showcross,'Value')
        I(crossy-5:crossy+5,ones(11,1)*crossx,:) = 1;
        I(ones(11,1)*crossy,crossx-5:crossx+5,:) = 1;
    end
    
    % Cropping to display
    Ic = imcrop(I,[crossx-cropsize+1 crossy-cropsize+1 cropsize*2 cropsize*2]);
    Sc = imcrop(S,[crossx-cropsize+1 crossy-cropsize+1 cropsize*2 cropsize*2]);
    %     Cc = imcrop(C,[crossx-cropsize+1 crossy-cropsize+1 cropsize*2 cropsize*2]);
    
    % Constructing the display
    [sh sw dump] = size(Sc);
    green = cat(3,zeros(sh,sw),ones(sh,sw),zeros(sh,sw));
    red = cat(3,ones(sh,sw),zeros(sh,sw),zeros(sh,sw));
    ir = cat(3,zeros(sh,sw),zeros(sh,sw),zeros(sh,sw));
    yellow = cat(3,ones(sh,sw),ones(sh,sw),zeros(sh,sw));
    
    emptyaxes = rand(2*cropsize,2*cropsize,3);
%     hi = imshow(emptyaxes,'InitialMagnification','Fit');
    hi = imshow(Ic,'InitialMagnification','Fit'); hold on
    
    % Show stimuli in color 
    if get(handles.check_previewCones,'Value');
        if ((get(handles.check_green,'Value'))&&~(get(handles.check_red,'Value')))
            hi = imshow(green);
        elseif ((get(handles.check_red,'Value'))&&~(get(handles.check_green,'Value')))
            hi = imshow(red);
        elseif (get(handles.radio_ir,'Value'))
            hi = imshow(ir);
        elseif ((get(handles.check_red,'Value'))&&(get(handles.check_green,'Value')))
            hi = imshow(yellow);
        end
        set(hi,'AlphaData',Sc);
    end
    
    % Show legend items (click order, summation crop window)
    if get(handles.check_legend,'Value')
        for k = 1:size(xi,1);
            x = cropsize+xi(k)-crossx;
            y = cropsize+yi(k)-crossy;
            plot(floor(x),floor(y),'y.');
            t = text(x+2,y,num2str(k)); set(t,'Color','y');
        end
        
        [row col] = find((mean(Sc,3))~=0);
        cc = min(min(col),size(Sc,1)+1-max(col))-1;
        cr = min(min(row),size(Sc,1)+1-max(row));
        cw = sw-2*cc;
        ch = sh-2*cr;
        hr = rectangle('Position',[cc-2 cr-1 cw+2 ch]); set(hr,'EdgeColor','y');
        ht = text(cc,cr+1,num2str(cw)); set(ht,'Color','y','FontSize',8,'Fontweight','bold');
        ht = text(cc,cr+8,num2str(ch)); set(ht,'Color','y','Rotation',90,'FontSize',8,'Fontweight','bold');
        
    end
                 
    
    
    hold off
    
end
update_statusfield(hObject, handles)


% --- Executes when selected object is changed in uipanel_shape.
function uipanel_shape_SelectionChangeFcn(hObject, eventdata, handles)
if get(handles.radio_circle, 'Value')==1;
    set(handles.radio_square, 'Value', 0);
elseif get(handles.radio_square, 'Value') ==1;
    set(handles.radio_circle, 'Value', 0);
end
drawPreview (hObject,handles);


% --- Executes on button press in push_last.
function push_last_Callback(hObject, eventdata, handles)

if exist('lastMonkeyCFG.mat','file')==2
    loadLastValues(handles,1)
else
    display('Last values not found')
end
set(hObject,'Enable','Off')
set(handles.push_default,'Enable','On');
drawPreview (hObject,handles);


% --- Executes on button press in push_default.
function push_default_Callback(hObject, eventdata, handles)

loadLastValues(handles,0)
set(hObject,'Enable','Off')
set(handles.push_last,'Enable','On');
drawPreview (hObject,handles);


% --- Executes on button press in push_selectcones.
function push_selectcones_Callback(hObject, eventdata, handles)

set(handles.check_lastlocation,'Value',0);
set(handles.check_lastlocation,'ForegroundColor',[0 0 0]);
set(handles.check_lastlocation,'String','Use last');
[crossx crossy baseI fname] = getPositionFromFile; % Find cross from tif or avi
[xi yi] = selectPattern(crossx, crossy, baseI, fname); % User input selects cone pattern to test
save('lastPattern.mat', 'baseI','crossx', 'crossy','xi','yi','fname');

handles.baseI = baseI;% Update main figure handles
handles.crossx = crossx;
handles.crossy = crossy;
handles.xi = xi;
handles.yi = yi;
handles.fname = fname;
guidata(hObject, handles);

drawPreview (hObject,handles)


% --- Executes on button press in check_lastlocation.
function check_lastlocation_Callback(hObject, eventdata, handles)

if(get(hObject,'Value'))
    if exist('lastPattern.mat','file')==2
        set(hObject,'String','Use last');
        load('lastPattern.mat');
        handles.baseI = baseI;
        handles.crossx = crossx;
        handles.crossy = crossy;
        handles.xi = xi;
        handles.yi = yi;
        handles.fname = fname;
        guidata(hObject, handles);
        drawPreview (hObject,handles)
    else
        set(hObject,'ForegroundColor',[0.8 0 0]);
        set(hObject,'String','No file');
        drawPreview (hObject,handles)
    end
else
    set(hObject,'ForegroundColor',[0 0 0]);
    set(hObject,'String','Use last');
    handles = rmfield(handles,{'baseI','crossx','crossy','xi','yi','fname'});
    guidata(hObject, handles);
    drawPreview (hObject,handles)
end


% Find cross location from selected video
function [crossx crossy I fname] = getPositionFromFile()
directory = 'D:\Video_Folder';
[fname, pname] = uigetfile('*.avi;*.tif', 'Select image or video for cone selection', directory);
[~, ~, ext] = fileparts([pname fname]);
movie_name = [pname fname];
if strcmp(ext,'.avi')==1
    I = mov_norm(pname, fname);
    %save image for use later;
    imwrite(I, [pname fname(1:end-4) '_sumframe.tif'], 'tif', 'compression', 'none');
    [crossx crossy] = FCIM(movie_name);
elseif strcmp(ext,'.tif')==1
    I = imread([pname fname]);
    [x y ~] = textread([cd '\IR_target.txt'], '%s %s %s');
    crossx = median(str2num(char(x)));
    crossy = median(str2num(char(y)));
end


% Show ROI and let user select cones from zoomed image
function [xi yi] = selectPattern (stimposx, stimposy, I, fname)

halfwidth = 50;
fsize = [512 512]; screensize = get(0,'ScreenSize');
fposx = ceil((screensize(3)-fsize(2))/2); fposy = ceil((screensize(4)-fsize(1))/2);
figure('position',[fposx, fposy, fsize(2), fsize(1)],...
    'Name','Cone Selection Window');

I(stimposy,stimposx)=0;
Ic = imcrop(I,[stimposx-halfwidth stimposy-halfwidth halfwidth*2+1 halfwidth*2+1]);
imshow(Ic,'InitialMagnification','fit'); hold on;
h.title = title(['Select cones for stimulation, press any key when done',char(10),'(Right-click deselects)']);
h.xlabel = xlabel(fname);
set(h.xlabel,'BackgroundColor',[0.5 0.5 0.5],'Fontsize',14,'Color',[1 1 1],'Interpreter','none');
set(h.title,'BackgroundColor','y','Fontsize',12)

% Select cones from image with possibility of deselecting
[xi,yi] = deal([]);
conecount = 0; cont = 1;
while cont == 1
    [x,y,button] = ginput(1);
    if (button == 3) %DESELECT
        cla; imshow(Ic,'InitialMagnification','fit'); hold on;
        if (numel(xi)>0)
            conecount = conecount-1;
            
            xi(end)=[]; yi(end)=[];
            if ~(numel(xi)==0)
                
                for k = 1:size(xi,1);
                    x = xi(k);
                    y = yi(k);
                    plot(floor(x),floor(y),'y.');
                    t = text(x+2,y,num2str(k)); set(t,'Color','y');
                end
            end
            
        end
    end
    if button == 1 % SELECT
        xi(conecount+1,1) = floor(x); yi(conecount+1,1) = floor(y);
        plot(floor(x),floor(y),'y.');
        t = text(x+2,y,num2str(conecount+1)); set(t,'Color','y');
        conecount = conecount+1;
    end
    if ~(button==1) && ~(button==3) %HAPPY WITH SELECTION
        cont=0;
    end
end

%  Correct cone locations for cropping offset
xi = xi + stimposx-halfwidth-1;
yi = yi + stimposy-halfwidth-1;
close(gcf)


% Generate and return stimulus bitmap
function s = makeStimulus (sheight, swidth, dotsize, dottype, dotposx, dotposy, antialias)
s = zeros(sheight, swidth);

if strcmp(dottype,'Square')
    for n = 1:size(dotposx,1)
        if mod(dotsize,2)==0
            s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2)-1,...
                dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)-1) = 1;
            
        else
            s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2),...
                dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)) = 1;
        end
    end
    
elseif strcmp(dottype,'Circle')
    
    [rr cc] = meshgrid(1:dotsize+1);
    if mod(dotsize,2)==0
        ci = sqrt((rr-((dotsize+1)/2)).^2+(cc-((dotsize+1)/2)).^2)<=((dotsize)/2);
    else
        if dotsize <= 3
            ci = sqrt((rr-ceil((dotsize)/2)).^2+(cc-ceil((dotsize)/2)).^2)<=ceil((dotsize-1)/2);
        elseif dotsize <=5
            ci = sqrt((rr-floor((dotsize+1)/2)).^2+(cc-floor((dotsize+1)/2)).^2)<=((dotsize)/2);
        else
            ci = sqrt((rr-floor((dotsize+1)/2)).^2+(cc-floor((dotsize+1)/2)).^2)<=((dotsize)/2);
        end
        
    end
    ci(:,sum(ci,1)==0)=[];
    ci(sum(ci,2)==0,:)=[];
    
    for n = 1:size(dotposx,1)
        if mod(dotsize,2)==0
            s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2)-1,...
                dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)-1) = ci;
        else
            s(dotposy(n)-floor(dotsize/2):dotposy(n)+floor(dotsize/2),...
                dotposx(n)-floor(dotsize/2):dotposx(n)+floor(dotsize/2)) = ci;
        end
    end
end

if antialias == 1
    f = fspecial('gaussian',[3 3],1);
    s = imfilter(s,f,'replicate');
end




function update_statusfield(hObject, handles)

intmin = str2num(get(handles.edit_mocsmin,'String'));
intmax = str2num(get(handles.edit_mocsmax,'String'));
intn = str2num(get(handles.edit_mocsn,'String'));


if get(handles.radio_logspace,'Value')
    if intmin ==0
        intmin = 0.01;
    end
    intensities = logspace(log10(intmin),log10(intmax),intn);
    if str2num(get(handles.edit_mocsmin,'String'))==0;
        intensities(1) = 0;
    end
else
    intensities = linspace(intmin,intmax,intn);
end
handles.intensities = intensities;

% make intensities text to display in status field
int_text = [''];
for idx = 1:length(intensities)
    int_text = [int_text,sprintf('%1.2f',intensities(idx)),'; '];
end
int_text = int_text(1:end-2); %Remove last ';'
set(handles.text_intensities,'String',['Intensities: ',int_text]);

% display number of cones
if ~isfield(handles,'baseI')
    set(handles.text_conecount,'String','Number of cones to test: N.A.');
else
    set(handles.text_conecount,'String',['Number of cones to test: ',num2str(length(handles.xi))]);
end

% display timing information

set(handles.text_setduration,'String','Duration of one set (s): TODO');
set(handles.text_fullduration,'String','Duration of full exp. (s): TODO');

guidata(hObject,handles);



function WO_Struct = WorkOrder(handles)

WO_Struct = struct;

WO_Struct.Cross.X = handles.crossx;
WO_Struct.Cross.Y = handles.crossy;
WO_Struct.Target.Xi = handles.xi;
WO_Struct.Target.Yi = handles.yi;


X = [0 1];   % a location can either be tested or not
N = length(WO_Struct.Target.Xi); % how many locationes were clicked
if N>1
    [Y{N:-1:1}] = ndgrid(X) ; % create a list of all possible combinations of N elements
    Y = reshape(cat(N+1,Y{:}),[],N) ; % concatenate into one matrix, reshape into 2D and flip columns
else
    Y = X(:) ; % no combinations have to be made
end
Z = [sum(Y,2) Y]; Z = sortrows(Z); Y = Z(:,2:end); Y = fliplr(Y); % sort to preserve click order


probeY = sum(Y,2);
singledoubles = probeY<3;
singles = probeY<2;
singles(end,1)=1;  % includes the max selection value also


if get(handles.checkbox_summation,'Value')==1
    WO_Struct.SumEvery = 1;
    WO_Struct.SumPairs = 0;
    WO_Struct.SumSingMax = 0;
    WorkOrderMatrix = Y;
elseif get(handles.checkbox_summation,'Value')==1 && get(handles.radio_pairs,'Value')==1
    WO_Struct.SumEvery = 0;
    WO_Struct.SumPairs = 1;
    WO_Struct.SumSingMax = 0;
    WorkOrderMatrix = Y(singledoubles,:);
elseif get(handles.checkbox_summation,'Value')==1 && get(handles.radio_max,'Value')==1
    WO_Struct.SumEvery = 0;
    WO_Struct.SumPairs = 0;
    WO_Struct.SumSingMax = 1;
    WorkOrderMatrix = Y(singles,:);
end

WO_Struct.DataMatrix = WorkOrderMatrix;