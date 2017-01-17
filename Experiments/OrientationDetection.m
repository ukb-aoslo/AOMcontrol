function OrientationDetection
global SYSPARAMS StimParams VideoParams;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%~~~~~~~~~~ - - - - - - TO DOs - - - - - - ~~~~~~~~~~%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% --> Psyflag - Header: line 217 (23.06.2016)
%



if exist('handles','var') == 0;
    handles = guihandles;
end

startup;


psyflag = 1;
writePsyfileHeader
matfname = [psyfname(1:end-4) '_OrientDetect_data.mat'];
response_matrix=struct;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%~~~~~~~~~~ - - - - - - AOM  STUFF - - - - - - ~~~~~~~~~~%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AOM and Video Control code
%offsets
% green_x_offset = -CFG.green_x_offset; green_y_offset = CFG.green_y_offset;	%enter in negative of TCA measures
% red_x_offset = -CFG.red_x_offset; red_y_offset = CFG.red_y_offset;          %enter negative of TCA measure

%get the stimulus parameters
dirname = StimParams.stimpath;
fprefix = StimParams.fprefix;
% fieldsize = CFG.fieldsize;

%set up the movie parameters
Mov.dir = dirname;
Mov.suppress = 0;
Mov.pfx = fprefix;

SYSPARAMS.aoms_state(2)=1;      % SWITCH RED ON
SYSPARAMS.aoms_state(3)=1;      % SWITCH GREEN ON

%generate a sequence that can be used thru out the experiment
%set up the movie params
framenum = 2;                   %the index of your bitmap
framenum2 = 3;
framenum3 = 4;                  %cue stim
startframe = 1;                 %the frame at which it starts presenting stimulus
% cueframe = 5; cuedur = 2;
fps = 30;
stimdur = CFG.StimDur;       %how long is the presentation (in frames)
numframes = fps*CFG.videodur;
%AOM1 (RED) parameters
if CFG.red_stim_color == 1;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.red_stim_color == 0;
    aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,numframes-startframe+1-stimdur)];
end
% aom1seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];

aom1pow = ones(size(aom1seq));
aom1pow(:) = 1;
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
% aom1offx(:) = red_x_offset;
% aom1offy(:) = red_y_offset;

%AOM2 (GREEN) paramaters
if CFG.green_stim_color == 1;
    aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.green_stim_color == 0;
    aom2seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum2 zeros(1,numframes-startframe+1-stimdur)];
end

aom2pow = ones(size(aom1seq));
aom2pow(:) = 1;
aom2offx = zeros(size(aom1seq));
% aom2offx(:) = green_x_offset;
aom2offy = zeros(size(aom1seq));
% aom2offy(:) = green_y_offset;

%AOM0 (IR) parameters
% aom0seq = ones(size(aom1seq));
% aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
if CFG.ir_stim_color == 1;
    aom0seq = [zeros(1,startframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
elseif CFG.ir_stim_color == 0;
    aom0seq = ones(size(aom1seq));
end
%for cuing in IR;
% aom0seq = [zeros(1,cueframe-1) ones(1,stimdur).*framenum3 zeros(1,numframes-startframe+1-stimdur)];
aom0locx = zeros(size(aom1seq));
aom0locy = zeros(size(aom1seq));
aom0pow = ones(size(aom1seq));

gainseq = zeros(size(aom1seq));
gainseq(:,:) = CFG.edit_gain;
angleseq = zeros(size(aom1seq));
stimbeep = zeros(size(aom1seq));
stimbeep(startframe+stimdur-1) = 1;
%stimbeep = [zeros(1,startframe+stimdur-1) 1 zeros(1,numframes-startframe-stimdur+2)];
%Set up movie parameters
Mov.duration = size(aom1seq,2);

Mov.aom0seq = aom0seq;
Mov.aom0pow = aom0pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;

Mov.aom1seq = aom1seq;
Mov.aom1pow = aom1pow;
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;

Mov.aom2seq = aom2seq;
Mov.aom2pow = aom2pow;
Mov.aom2offx = aom2offx;
Mov.aom2offy = aom2offy;

Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.stimbeep = stimbeep;
Mov.frm = 1;
Mov.seq = '';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%~~~~~~~~~ - - - - - - RUN  EXPERIMENT - - - - - - ~~~~~~~~~%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run Experiment
%set initial while loop conditions
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
runExperiment = 1;
trial = 1;

while (runExperiment == 1)
    uiwait;
    key = get(handles.aom_main_figure,'CurrentKey');
    
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%~~~~~~~~ - - - - - - IMBEDDED  FUNCTIONS - - - - - - ~~~~~~~~%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% other stuff
    function startup
        
        dummy=ones(10,10);
        if isdir([pwd,'\tempStimulus']) == 0;
            mkdir(pwd,'tempStimulus');
            cd([pwd,'\tempStimulus']);
            
            imwrite(dummy,'frame2.bmp');
            %     fid = fopen('frame2.bmp','w');
            %     fwrite(fid,size(dummy,2),'uint16');
            %     fwrite(fid,size(dummy,1),'uint16');
            %     fwrite(fid, dummy, 'double');
            %     fclose(fid);
        else
            cd([pwd,'\tempStimulus']);
            delete *.*
            imwrite(dummy,'frame2.bmp');
            %     fid = fopen('frame2.buf','w');
            %     fwrite(fid,size(dummy,2),'uint16');
            %     fwrite(fid,size(dummy,1),'uint16');
            %     fwrite(fid, dummy, 'double');
            %     fclose(fid);
        end
        cd ..;
        
        
        % Get experiment config data stored in appdata for 'hAomControl'
        hAomControl = getappdata(0,'hAomControl');
        uiwait(OrientationDetectionConfig);
        CFG = getappdata(hAomControl, 'CFG');
        psyfname = [];
        if isstruct(getappdata(getappdata(0,'hAomControl'),'CFG')) == 1;
            CFG = getappdata(getappdata(0,'hAomControl'),'CFG');
            if CFG.ok == 1
                StimParams.stimpath = CFG.stimpath;
                VideoParams.vidprefix = CFG.vidprefix;
                %disable slider control during exp
                %         set(handles.align_slider, 'Enable', 'off');
                set(handles.aom1_state, 'String', 'Configuring Experiment...');
                if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
                    set(handles.aom1_state, 'String', 'Off - Press Start Button To Begin Experiment');
                else
                    set(handles.aom1_state, 'String', 'On - Press Start Button To Begin Experiment');
                end
                if CFG.record == 1;
                    VideoParams.videodur = CFG.videodur;
                end
                psyfname1 = set_VideoParams_PsyfileName();
                hAomControl = getappdata(0,'hAomControl');
                Parse_Load_Buffers(1);
                set(handles.image_radio1, 'Enable', 'off');
                set(handles.seq_radio1, 'Enable', 'off');
                set(handles.im_popup1, 'Enable', 'off');
                set(handles.display_button, 'String', 'Running Exp...');
                set(handles.display_button, 'Enable', 'off');
                set(handles.aom1_state, 'String', 'On - Experiment Mode - Running Experiment');
            else
                display (' ');
                display (' ');
                display (' ');
                display (' --> Experiment cancelled ');
                display (' ');
                display (' ');
                display (' ');
                TerminateExp;
                return;
                
            end
        end
    end




    function writePsyfileHeader
        
        %         global VideoParams;
        psyfname = set_VideoParams_PsyfileName();
        
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
        
%         if psyflag == 1;
%             if strcmp(CFG.method,'adjust')
%                 fprintf(psyfid,'%s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n %s\r\n', psyfname, experiment, response_paradigm, subject, pupil,field, presentdur, iti, videoprefix, videodur);
%             end
%         end
    end



    function StimSettings
        
        hAomControl = getappdata(0,'hAomControl');
        trialIntensity = 1;
        
        if SYSPARAMS.realsystem == 1
            StimParams.stimpath = dirname;
            StimParams.fprefix = fprefix;
            StimParams.sframe = 2;
            StimParams.eframe = 4;
            StimParams.fext = 'bmp';
            Parse_Load_Buffers(0);
        end
        
        laser_sel = 0;
        if SYSPARAMS.realsystem == 1 && SYSPARAMS.board == 'm'
            bitnumber = round(8191*(2*trialIntensity-1));
        else
            bitnumber = round(trialIntensity*1000);
        end

        Mov.frm = 1;
        Mov.duration = CFG.videodur*fps;
        
        if strcmp(CFG.method,'Adjust')
            message = ['Rotation = ' num2str(Rotation) ' - ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast)];
        else
            message = ['Trial ' num2str(trial) ' of ' num2str(Alltrials) ' ' num2str(Period) ' cyc/degree - Contrast = ' num2str(Contrast)];
        end
        Mov.msg = message;
        Mov.seq = '';
        setappdata(hAomControl, 'Mov',Mov);
        
        VideoParams.vidname = [CFG.vidprefix '_' sprintf('%03d',trial)];%    sprintf('%03d',trial)
    end
end
