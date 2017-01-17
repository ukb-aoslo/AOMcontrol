%commands
%sequence command
% aom1seq = frame number for IR
% aom1pow = contains the power values for each IR frame (any number in [0-1000])
% aom0seq = frame number for Red
% aom0pow = contains the power values for each Red frame (any number in [0-1000])
% aom0offsx = contains xoffs of Red wrt IR [-10,10]
% aom0offsy = contains yoffs of Red wrt IR [-10,10]
% stimlocx = contains new stimulus x location for each frame
% stimlocy = contains new stimulus y location for each frame
% aomsgain = contains the gain value of the stimulus tracking (any real number between [-3.0, 3.0])
%for each frame the syntax is as below
%IRfr#,IRpow,Redfr#,Redpow,RedoffsX,RedoffsY,StimLocX,StimLocY,Gain - P
%for a 30fps sequence, you should have the above sets 30 times/frame with
%values changing in between as per your expeirment requirements
%Sequence#P1 P2 P3 P4 P5........P30# each one seperated by a tab

%Gain#realvalue# [-3.0 to 3.0]

%Offset#OffsX#OffsY# - offset location of a stimulus with respect to imaging channel [-10 to 10] (generally used for TCA correction )

%UpdatePower#aom#value# [0 to 1000]

%StimLoc#LocX#LocY# - new stimulus location

%StimLocFix#option# - fix the stimulus location use 'r' for current position or use 'c' for center of stabilized frame

%Load#stimuluspath#prefix#startind#endind#format# 
%       stimuluspath - directory where stimulus files are located
%       prefix - prefix of filename
%       startind - starting index of stimulus files (usually 2)
%       endind - ending index of stimulus files
%       format - bmp(8-bit bitmap)/buf(14-bit binary)

%Loop# - to run a sequence continuously in a loop

%Trigger# - to start a sequence and record a video

%Update#fr1#fr2# - to update the stimulus on corresponding aom channels - (fr1 - Red, fr2 - IR)

%once the required command is formatted in the above format they are sent 
%to FPGA as follows
% Ex:- command = ['Gain#' num2str(1.5) '#']
% netcomm('write',netcommobj,int8(command))
%to strategic boards (some commands are not valid, for invalid commands you wont see any effect)
% MatlabAOMcontrol32(command)

% other parts to edit when adding a new experiment.


function Template(handles)

global board mode StimParams videofolder netcommobj %#ok<NUSED>

if exist('handles','var') == 0;
    handles = guihandles;
else
    %donothing
end

%get experiment config data stored in appdata for 'hAomControl'
hAomControl = getappdata(0,'hAomControl');
CFG = getappdata(hAomControl, 'CFG');

% Start user code block
% to add/code your experiment, start from here...

% End user code block

end