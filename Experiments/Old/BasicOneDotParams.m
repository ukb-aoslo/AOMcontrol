%if you want to record videos for each trial, specify the duration of the video in seconds
VideoParams.videodur = 1.4; % in seconds, should be longer than p.presentdur
%p.presentdur = 500; %in millisec
p.fps = 30; %system frames per second

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% User setup parameters %%%%%%%%%%
%setup the keyboard constants and response mappings, you can get these from matlab help file for key return constants
% the first two constants are standard accross all experiments, hence try not to change them if possible
kb.AbortConst = 'escape'; %abort constant - Esc Key
kb.StimConst = 'space';

% user defined response mappings
% kb.BadConst = 'uparrow'; %ascii code for up arrow
% kb.YesConst = 'rightarrow'; %ascii code for right arrow
% kb.NoConst = 'leftarrow'; %ascii code for left arrow

% specify the experiment parameters
p.ntrials = 10;
p.fieldsize = 1.2;
p.pupilsize = 6;

% cue definition
p.cueBMPnumber =3;
p.cueRadius = 60; %pixels
p.cueThickness = 3; %5 pixels
p.cueFrames = [4 10]; % start and end frames of cue
p.cueContrast = 1;

% target definition
p.targetBMPnumber = 2;
p.dotsize = 50; %pixels
p.dotFrames= [ 11 29]; % start and end frames of dot
p.dotcontrast = [0 .3 .6 .9];
p.dotcontrast = [.9 .9 .9 .9];

p.badTrial = 0; 
p.trial = 1; % 1st trial
p.nextLevel = ceil(rand *4); %1st trial level
p.respByCond=zeros(4,4); % four levels * 4 responsese
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%