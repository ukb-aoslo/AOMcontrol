function MinVis
global board netcommobj StimParams %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');
pixsize = StimParams.pixsize;
%setup the keyboard constants and response mappings from config
kb_AbortConst = 27; %abort constant - Esc Key
kb_LeftConst = 28; %ascii code for left arrow
kb_RightConst = 29; %ascii code for right arrow
kb_UpConst = 30; %ascii code for up arrow
kb_DownConst = 31; %ascii code for down arrow
%disable slider control during exp
set(handles.align_slider, 'Enable', 'off');

message = 'Starting Experiment...';
set(handles.aom1_state, 'String',message);

%set initial while loop conditions
runExperiment = 1;
set(handles.aom_main_figure, 'KeyPressFcn','uiresume');
while(runExperiment ==1)
    uiwait;
    resp = get(handles.aom_main_figure,'CurrentCharacter');
    if(resp == kb_AbortConst); %if they press escape
        runExperiment = 0;
        uiresume;
        TerminateExp;
        message = ['Experiment Complete - Minimum Size: ' num2str(pixsize)];
            set(handles.aom1_state, 'String',message);
    elseif(resp ~= kb_AbortConst);
        
        if(resp == kb_UpConst)
            pixsize = pixsize+1;
            response = 'Increase';
        elseif(resp == kb_DownConst)
            pixsize = pixsize-1;
            response = 'Decrease';
        elseif(resp == kb_LeftConst)
            pixsize = pixsize-1;
            response = 'Increase';
        elseif(resp == kb_RightConst)
            pixsize = pixsize+1;
            response = 'Decrease';
        else
            response = 'N';
        end;
        MakeMinVis(pixsize);
        dir = [pwd,'\temp'];
        Mov.dir = [dir '\'];
        
        
            command = ['Load#0#1#' dir '#analog#2#2#bmp#']; %#ok<NASGU>
            if board == 'm'
                %MATLABAomControl32(command);
            else
            end
            command = ['Load#1#1#' dir '#digital#2#2#bmp#']; %#ok<NASGU>
            if board == 'm'
                %MATLABAomControl32(command);
            else
            end
            Mov.pfx = 'analog';
            aom0seq = [ones(1,2).*2];
            aom1seq = aom0seq;
            for i = 1:length(aom0seq)
                if i == 1
                    seq = [num2str(aom0seq(i)) ',' num2str(aom1seq(i)) sprintf('\t')];
                elseif i>1 && i<length(aom0seq)
                    seq = [seq sprintf('\t') num2str(aom0seq(i)) ',' num2str(aom1seq(i)) sprintf('\t')]; %#ok<AGROW>
                elseif i == length(aom0seq)
                    seq = [seq sprintf('\t') num2str(aom0seq(i)) ',' num2str(aom1seq(i))]; %#ok<AGROW>
                end
            end
            Mov.aom0seq = aom0seq;
            Mov.aom1seq = aom1seq;
            Mov.frm = 1;
            Mov.sfr = 1;
            Mov.seq = seq;
            Mov.efr = 2;
            Mov.lng = 2;
            
        message = ['Running Experiment - Current Size: ' num2str(pixsize) ' Pixels.'];
        Mov.msg = message;
        setappdata(hAomControl, 'Mov',Mov);
        PlayMovie;
        if(response ~= 'N')
            message = ['Running Experiment - Current Size: ' num2str(pixsize) ' Response: ' response];
                set(handles.aom1_state, 'String',message);
        else %continue experiment
        end

    end
end