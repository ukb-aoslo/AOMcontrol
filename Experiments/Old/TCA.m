function TCA

global SYSPARAMS StimParams VideoParams;
if exist('handles','var') == 0;
    handles = guihandles; else %donothing
end


startup;  % creates tempStimlus folder and dummy frame for initialization

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
uiwait(TCAConfig('M')); % wait for user input in Config dialog
CFG = getappdata(hAomControl, 'CFG');
psyfname = [];

if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
    CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
    if CFG.ok == 1
        StimParams.stimpath = CFG.stimpath;
        VideoParams.vidprefix = CFG.vidprefix;
        %disable slider control during exp
        % set(handles.align_slider, 'Enable', 'off');
        set(handles.aom1_state, 'String', 'Configuring Experiment...');
        set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
        if CFG.record == 1;
            VideoParams.videodur = CFG.videodur;
        end
        psyfname = set_VideoParams_PsyfileName();
        hAomControl = getappdata(0,'hAomControl');
        Parse_Load_Buffers(1); % not sure what the argument does...
        set(handles.image_radio1, 'Enable', 'off');
        set(handles.seq_radio1, 'Enable', 'off');
        set(handles.im_popup1, 'Enable', 'off');
        set(handles.display_button, 'String', 'Running Exp...');
        set(handles.display_button, 'Enable', 'off');
        set(handles.aom1_state, 'String', 'On - Experiment Mode - Running Experiment');
    else
        return;
    end
end

%setup the keyboard constants from config
kb_StimConst = CFG.kb_StimConst;
kb_AbortConst = CFG.kb_AbortConst;
kb_Modifier = CFG.kb_Modifier;
kb_BadConst = CFG.kb_BadConst;
kb_Left = CFG.kb_Left;
kb_Right = CFG.kb_Right;
kb_hileft = CFG.kb_LeftHi;
kb_loleft = CFG.kb_LeftLo;
kb_loright = CFG.kb_RightLo;
kb_hiright = CFG.kb_RightHi;

fps = 30;
ntrials = CFG.npresent;
viddurtotal = VideoParams.videodur*fps;
stimdur = floor(CFG.presentdur);

%set up MSC params
gain = CFG.gain;
angle = CFG.angle;
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;

writePsyfileHeader; %Experiment specific psyfile header

%generate a sequence that can be used thru out the experiment
framenum_IR = 2; %index of bitmap IR
framenum_R = 3; %index of bitmap RED
if strcmp(CFG.optotype,'2bars')==1
    framenum_G = 4; %index of bitmap green
else
    framenum_G = 3; %index of bitmap green
end

%IR
aom0seq = ones(30)*framenum_IR;
aom0pow = ones(size(aom0seq));
aom0pow(:) = 1.000;
% aom0locx = CFG.Xoff.*ones(size(aom0seq));
% aom0locy = -CFG.Yoff.*ones(size(aom0seq)); % Attention: MSC Y coordinates are swapped relative to Matlab Figure
aom0seq(end) = 0; %

%RED
aom1seq = ones(30)*framenum_R;
aom1pow = ones(size(aom1seq));
aom1pow(:) = 1.000;
% aom1offx = CFG.tcaX.*ones(size(aom1seq));
% aom1offy = -CFG.tcaY.*ones(size(aom1seq));

%GREEN
% aom2seq = ones(30)*framenum_G;
% aom2pow = ones(size(aom2seq));
% aom2pow(:) = 1.000;
% % aom2offx = CFG.tcaX.*ones(size(aom2seq));
% % aom2offy = -CFG.tcaY.*ones(size(aom2seq));

SYSPARAMS.aoms_state(2)=1; % SWITCH RED ON
% SYSPARAMS.aoms_state(3)=1; % SWITCH GREEN ON?

if CFG.gainclamp
    gainseq = [ones(1,startframe-1).*gain zeros(1,stimdur) ones(1,30-startframe+1-stimdur).*gain];
else
    gainseq = ones(size(aom1seq)).*gain;
end

angleseq = ones(size(aom1seq)).*angle;

%set up the movie parameters
%Mov.duration = viddurtotal;
% Mov.duration = size(aom0seq,2);
% Mov.aom0seq = aom0seq;
% Mov.aom1seq = aom1seq;
% Mov.aom0pow = aom0pow;
% Mov.aom1pow = aom1pow;
% Mov.aom0locx = aom0locx;
% Mov.aom0locy = aom0locy;
% Mov.aom1offx = aom1offx;
% Mov.aom1offy = aom1offy;
% Mov.gainseq = gainseq;
% Mov.angleseq = angleseq;
% Mov.frm = 1;
% Mov.seq = '';
% Mov.dir = dirname;
% Mov.suppress = 0;
% Mov.pfx = fprefix;

%set initial while loop conditions
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
runExperiment = 1;
trial = 1;
%PresentStimulus = 1;
GetResponse = 0;
%good_check = 1;
%intensity=CFG.first;

[outer inner]=createStimulus; % create IR, red and green BMPs

% Create initial offsets
signr=rand;
sign=(0.5-signr)/abs(0.5-signr);
xoff_ini_R=sign*ceil(CFG.first*rand);
signr=rand;
sign=(0.5-signr)/abs(0.5-signr);
yoff_ini_R=sign*ceil(CFG.first*rand);
xoff_R=xoff_ini_R;
yoff_R=yoff_ini_R;
signr=rand;
sign=(0.5-signr)/abs(0.5-signr);
xoff_ini_G=sign*ceil(CFG.first*rand);
signr=rand;
sign=(0.5-signr)/abs(0.5-signr);
yoff_ini_G=sign*ceil(CFG.first*rand);
xoff_G=xoff_ini_G;
yoff_G=yoff_ini_G;

%%Create image to display in Matlab Window
%
% displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G)
if SYSPARAMS.realsystem == 1
    command = ['Gain#0#'];
    netcomm('write',SYSPARAMS.netcommobj,int8(command));
end

while(runExperiment ==1)
    
    uiwait;
    modifier = get(handles.aom_main_figure,'CurrentModifier');
    key = get(handles.aom_main_figure,'CurrentKey');
    
    if strcmp(key,kb_AbortConst)   % Abort Experiment
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Off - Experiment Aborted - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        set(handles.aom1_state, 'String',message);
        
    elseif strcmp(key,kb_StimConst)    % check if present stimulus button was pressed
        
        if ~(trial==1)
            psyfid = fopen(psyfname,'a+');
            fprintf(psyfid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n',num2str(trial-1),num2str(xoff_ini_R),num2str(yoff_ini_R),num2str(xoff_ini_G),num2str(yoff_ini_G),num2str(xoff_R),num2str(yoff_R),num2str(xoff_G),num2str(yoff_G));
            fclose(psyfid);
            rawData(trial-1,:)=[trial-1,xoff_ini_R,yoff_ini_R,xoff_ini_G,yoff_ini_G,xoff_R,yoff_R,xoff_G,yoff_G];
        end
        
        if(trial > ntrials)
            runExperiment = 0;
            set(handles.aom_main_figure, 'keypressfcn','');
            uiresume;
            TerminateExp;
            message = ['Off - Experiment Complete'];
            set(handles.aom1_state, 'String',message);
            
            display(rawData);
            display(' ');
            display(' Offset [Pixel]');
            display(' ');
            display('      Red X     Red Y     Green X     Green Y');
            display(' --------------------------------------------');
            display([' Mean: ', num2str(mean(rawData(:,6)),'%2.2f'),'     ',...
                num2str(mean(rawData(:,7)),'%2.2f'),'     ',...
                num2str(mean(rawData(:,8)),'%2.2f'),'     ',...
                num2str(mean(rawData(:,9)),'%2.2f')]);
            display(['  STD: ', num2str(std(rawData(:,6)),'%2.2f'),'      ',...
                num2str(std(rawData(:,7)),'%2.2f'),'      ',...
                num2str(std(rawData(:,8)),'%2.2f'),'      ',...
                num2str(std(rawData(:,9)),'%2.2f')]);
            display(' ');
            
        end
        
        signr=rand;
        sign=(0.5-signr)/abs(0.5-signr);
        xoff_ini_R=sign*ceil(CFG.first*rand);
        signr=rand;
        sign=(0.5-signr)/abs(0.5-signr);
        yoff_ini_R=sign*ceil(CFG.first*rand);
        xoff_R=xoff_ini_R;
        yoff_R=yoff_ini_R;
        signr=rand;
        sign=(0.5-signr)/abs(0.5-signr);
        xoff_ini_G=sign*ceil(CFG.first*rand);
        signr=rand;
        sign=(0.5-signr)/abs(0.5-signr);
        yoff_ini_G=sign*ceil(CFG.first*rand);
        xoff_G=xoff_ini_G;
        yoff_G=yoff_ini_G;
        
        if CFG.TCA==1
            xoff_R=0;
            yoff_R=0;
            xoff_G=0;
            yoff_G=0;
        end
        
        
        
        %%%%%%%% IS THAT PART OK TO OFFSET INDIVIDUAL CHANNELS
        if SYSPARAMS.realsystem == 1
            StimParams.stimpath = dirname;
            StimParams.fprefix = fprefix;
            StimParams.sframe = 2;
            if (strcmp(CFG.optotype,'2bars')==1) || (CFG.TCA==1)
                StimParams.eframe = 4;
            else
                StimParams.eframe = 3;
            end
            
            StimParams.eframe = 3;     %%%%% TWO CHANNEL syetem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
            
            StimParams.fext = 'bmp';
            Parse_Load_Buffers(0);
            
            if (strcmp(CFG.optotype,'2bars')==1) || (CFG.TCA==1)
                command = ['Update#2#3#4#-2#'];
            else
                command = ['Update#2#3#3#-2#'];
            end
            netcomm('write',SYSPARAMS.netcommobj,int8(command));
            
            % OFFSET RED ?
            command = ['UpdateOffset#1#' num2str(xoff_R) '#' num2str(yoff_R) '#'];
            netcomm('write',SYSPARAMS.netcommobj,int8(command));
            
%             % OFFSET GREEN ?
%             command = ['UpdateOffset#2#' num2str(xoff_G) '#' num2str(yoff_G) '#'];
%             netcomm('write',SYSPARAMS.netcommobj,int8(command));
%             
        end
        %%%%%%%% IS THAT PART OK TO OFFSET INDIVIDUAL CHANNELS
        
        Mov.frm = 1;
        Mov.duration = CFG.videodur*fps;
        message = ['Running Experiment - Trial ' num2str(trial) ' of ' num2str(ntrials)];
        Mov.msg = message;
        Mov.seq = '';
        setappdata(hAomControl, 'Mov',Mov);
        
        VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%
        % PlayMovie;
        % PresentStimulus = 0;
        
        displayFigure(outer, inner, xoff_R, yoff_R, xoff_G, yoff_G);
        
        trial=trial+1;
        GetResponse = 1;
        
    elseif(GetResponse == 1)
        
        if strcmp(modifier,kb_Modifier)  % Adjust GREEN channel position
            if strcmp(key,'uparrow')
                yoff_G=yoff_G-CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA GREEN OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#2#' num2str(xoff_G) '#' num2str(yoff_G) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            elseif strcmp(key,'downarrow')
                yoff_G=yoff_G+CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA GREEN OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#2#' num2str(xoff_G) '#' num2str(yoff_G) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            elseif strcmp(key,'rightarrow')
                xoff_G=xoff_G+CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA GREEN OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#2#' num2str(xoff_G) '#' num2str(yoff_G) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            elseif strcmp(key,'leftarrow')
                xoff_G=xoff_G-CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA GREEN OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#2#' num2str(xoff_G) '#' num2str(yoff_G) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            end
            
        else
            if strcmp(key,'uparrow')     % Adjust RED channel position
                yoff_R=yoff_R-CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA RED OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#1#' num2str(xoff_R) '#' num2str(yoff_R) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            elseif strcmp(key,'downarrow')
                yoff_R=yoff_R+CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA RED OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#1#' num2str(xoff_R) '#' num2str(yoff_R) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            elseif strcmp(key,'rightarrow')
                xoff_R=xoff_R+CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA RED OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#1#' num2str(xoff_R) '#' num2str(yoff_R) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            elseif strcmp(key,'leftarrow')
                xoff_R=xoff_R-CFG.stepfactor;
                displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G);
                % UPDATE TCA RED OFFSET COMMAND?
                if SYSPARAMS.realsystem == 1
                    command = ['UpdateOffset#1#' num2str(xoff_R) '#' num2str(yoff_R) '#'];
                    netcomm('write',SYSPARAMS.netcommobj,int8(command));
                end
                
            end
            
        end
        
    end
    
end

function writePsyfileHeader

global VideoParams;
psyfname = set_VideoParams_PsyfileName();

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

fieldvalues=struct2cell(CFG);
fieldtags=fieldnames(CFG);
fields=size(fieldvalues,1);
tfolder = ['Video Folder: ' VideoParams.videofolder];


psyfid = fopen(psyfname,'a');
for k=1:fields
    if ischar(cell2mat(fieldvalues(k)))
        fprintf(psyfid,'%s\n',[char(fieldtags(k)),': ',char(cell2mat(fieldvalues(k)))]);
    else
        fprintf(psyfid,'%s\n',[char(fieldtags(k)),': ',num2str(cell2mat(fieldvalues(k)))]);
    end
end

fprintf(psyfid,'%s\n',tfolder);
fprintf(psyfid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\r\n', 'Trial', 'Start Offset X RED', 'Start Offset Y RED','Start Offset X GREEN','Start Offset Y GREEN', 'Offset X RED', 'Offset Y RED', 'Offset X GREEN', 'Offset Y GREEN')

fclose(psyfid);


function [outer inner]=createStimulus

CFG = getappdata(getappdata(0,'hAomControl'),'CFG');

if strcmp(CFG.optotype,'3dots')  % TCA crosses
    
    owidth=CFG.dotsize;
    olength=CFG.dotseparation;
    ol=3*olength;
    
    outer=ones(ol,ol);
    outer(1:olength,(ol-owidth)/2+1:(ol-owidth)/2+owidth)=0;
    outer(ol-olength+1:ol,(ol-owidth)/2+1:(ol-owidth)/2+owidth)=0;
    outer((ol-owidth)/2+1:(ol-owidth)/2+owidth,1:olength)=0;
    outer((ol-owidth)/2+1:(ol-owidth)/2+owidth,ol-olength+1:ol)=0;
    
    inner=ones(olength,olength);
    inner((olength-owidth)/2+1:(olength-owidth)/2+owidth,1:olength)=0;
    inner(1:olength,(olength-owidth)/2+1:(olength-owidth)/2+owidth)=0;
    inner=imcomplement(inner);
    
elseif strcmp(CFG.optotype,'2bars') % TCA blocks
    
    owidth=CFG.dotsize;
    outer = ones(owidth,owidth);
    outer(1:owidth/2,1:owidth/2)=0;
    outer(owidth/2+1:end,owidth/2+1:end)=0;
    inner=outer;
    outer = zeros(owidth,owidth);
    
elseif strcmp(CFG.optotype,'grid')   % TCA grid
    
    owidth=CFG.dotsize;
    outer=ones(owidth*3,owidth*3);
    outer(1:owidth,1:owidth)=0;
    outer(1:owidth,end-owidth:end)=0;
    outer(end-owidth:end,1:owidth)=0;
    outer(end-owidth:end,end-owidth:end)=0;
    inner=ones(owidth,owidth);
end

if CFG.TCA==1
    
    
    %%%%% THREE CHANNELS
    
    %     IR=zeros(256,126);
    %     R=IR;
    %     G=IR;
    %     R(:,2:3:end)=1;
    %     G(:,3:3:end)=1;
    %     IR(:,1:3:end)=1;
    
    
    %%%%% TWO CHANNELS
    
    IR=zeros(256,128);
    R=IR;
    IR(:,1:2:end)=1;
    R(:,2:2:end)=1;
    
    
    
end

if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    if CFG.TCA==1
        imwrite(IR,'frame2.bmp');
        imwrite(R,'frame3.bmp');
       % imwrite(G,'frame4.bmp');   %%%%% Activate for three channels !!!!!
        
    else
        imwrite(outer,'frame2.bmp');
        imwrite(inner,'frame3.bmp');
        if strcmp(CFG.optotype,'2bars')
            imwrite(imcomplement(inner),'frame4.bmp');
        end
    end
    
else
    cd([pwd,'\tempStimulus']);
end

if CFG.TCA==1
    imwrite(IR,'frame2.bmp');
    imwrite(R,'frame3.bmp');
    % imwrite(G,'frame4.bmp');   %%%%% Activate for three channels !!!!!
else
    imwrite(outer,'frame2.bmp');
    imwrite(inner,'frame3.bmp');
    if strcmp(CFG.optotype,'2bars')
        imwrite(imcomplement(inner),'frame4.bmp');
    end
end

cd ..;

function startup

dummy=ones(10,10);
if isdir([pwd,'\tempStimulus']) == 0;
    mkdir(pwd,'tempStimulus');
    cd([pwd,'\tempStimulus']);
    imwrite(dummy,'frame2.bmp');
    imwrite(dummy,'frame3.bmp');
    
else
    cd([pwd,'\tempStimulus']);
    delete ('*.*');
    imwrite(dummy,'frame2.bmp');
    imwrite(dummy,'frame3.bmp');
    
end
cd ..;


function  displayFigure(outer, inner, xoff_R,yoff_R,xoff_G,yoff_G)

handles = guihandles;
CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
axes(get(handles.im_panel1, 'Child'));

owidth=CFG.dotsize;
olength=CFG.dotseparation;
ol=3*olength;

field_IR=ones(512,512);
field_R=imcomplement(field_IR);
field_G=field_R;

IR=zeros(256,128);
R=IR;
% G=IR;
R(:,2:2:end)=1;
% G(:,2:3:end)=1;
IR(:,1:2:end)=1;

if CFG.TCA==1  % System TCA measurement
    
    field_IR((512-256)/2:(512-256)/2+256-1,(512-128)/2:(512-128)/2+128-1)=IR;
    field_R((512-256)/2+yoff_R:(512-256)/2+256-1+yoff_R,(512-128)/2+xoff_R:(512-128)/2+128-1+xoff_R)=R;
    % field_G((512-256)/2+yoff_G:(512-256)/2+256-1+yoff_G,(512-126)/2+xoff_G:(512-126)/2+126-1+xoff_G)=G;
    
else
    if strcmp(CFG.optotype,'3dots')  % TCA crosses
        
        field_IR((512-ol)/2:(512-ol)/2+ol-1,(512-ol)/2:(512-ol)/2+ol-1)=outer;
        field_R((512-olength)/2+yoff_R:(512-olength)/2+olength-1+yoff_R,(512-olength)/2+xoff_R:(512-olength)/2+olength-1+xoff_R)=inner;
        field_G((512-olength)/2+yoff_G:(512-olength)/2+olength-1+yoff_G,(512-olength)/2+xoff_G:(512-olength)/2+olength-1+xoff_G)=inner;
        
    elseif strcmp(CFG.optotype,'2bars') % TCA blocks
        
        field_IR((512-owidth)/2:(512-owidth)/2+owidth-1,(512-owidth)/2:(512-owidth)/2+owidth-1)=outer;
        field_R((512-owidth)/2+yoff_R:(512-owidth)/2+owidth-1+yoff_R,(512-owidth)/2+xoff_R:(512-owidth)/2+owidth-1+xoff_R)=inner;
        field_G((512-owidth)/2+yoff_G:(512-owidth)/2+owidth-1+yoff_G,(512-owidth)/2+xoff_G:(512-owidth)/2+owidth-1+xoff_G)=imcomplement(inner);
        
    elseif strcmp(CFG.optotype,'grid')   % TCA grid
        
        field_IR((512-owidth*3)/2:(512-owidth*3)/2+owidth*3-1,(512-owidth*3)/2:(512-owidth*3)/2+owidth*3-1)=outer;
        field_R((512-owidth)/2+yoff_R:(512-owidth)/2+owidth-1+yoff_R,(512-owidth)/2+xoff_R:(512-owidth)/2+owidth-1+xoff_R)=inner;
        field_G((512-owidth)/2+yoff_G:(512-owidth)/2+owidth-1+yoff_G,(512-owidth)/2+xoff_G:(512-owidth)/2+owidth-1+xoff_G)=inner;
    end
    
end

CurrentBuffer(:,:,1) = uint8(50*field_IR);
CurrentBuffer(:,:,1) = CurrentBuffer(:,:,1)+uint8(205*field_R);
CurrentBuffer(:,:,2) = uint8(0*ones(512,512));
% CurrentBuffer(:,:,2) = uint8(255*field_G);
CurrentBuffer(:,:,3) = uint8(0*ones(512,512));
imshow(CurrentBuffer)