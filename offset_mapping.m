function [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence, selection_figure] = offset_mapping(CFG);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here; num_levels = CFG.beta; trialsperlevel = CFG.delta;
color_script = colormap('HSV');

if strcmp(CFG.method,'Mocs');
    numtrials = CFG.beta.*CFG.delta;
    ncatch = 0; nlapse = 0;
    range = CFG.priorSD/100;
    if range == 1.0;
        Intensity_Vector = (0:range/(CFG.beta-1):1.0)';
    else
        Intensity_Vector = (CFG.thresholdGuess-(range/2):range/(CFG.beta-1):CFG.thresholdGuess+(range/2))';
        [row,col] = find(Intensity_Vector >1);
        Intensity_Vector(row,col) = [];
        numtrials = size(Intensity_Vector,1).*CFG.delta;
    end
else
    numtrials = CFG.npresent+CFG.ncatch+CFG.nlapse;
    ncatch = CFG.ncatch; nlapse = CFG.nlapse;
    range = []; Intensity_Vector = [];
end

% if exist('C:\Programs\AOMcontrol_V3_2\lastConeMapping.mat', 'file')==2
if exist([cd '\lastConeMapping.mat'], 'file')==2
    % load('C:\Programs\AOMcontrol_V3_2\lastConeMapping.mat');
    load([cd '\lastConeMapping.mat']);
    if exist('directory', 'var') ==1
        if isstr(directory)==1;
            
        else
            directory = 'D\Video_Folder\';
        end
        %use directory to go to last offset_mapping video
    else
        directory = 'D\Video_Folder\';
    end
else
    directory = 'D:\Video_Folder\';
end
[fname, pname] = uigetfile('*.avi;*.tif', 'Select image or video for cone selection', directory);
% vidpathfinder = 'C:\Programs\AOMcontrol_V3_2\lastConeMapping.mat';
vidpathfinder = [cd '\lastConeMapping.mat'];

% disp(pname);
directory = pname; 
save(vidpathfinder, 'directory');
[pathstr, name, ext] = fileparts([pname fname]);
movie_name = [pname fname];
if strcmp(ext,'.avi')==1
    [x1 y1] = FCIM(movie_name);
    [image] = mov_norm(pname, fname);
    %save image for use later;
    imwrite(image, [pname fname(1:end-4) '_sumframe.tif'], 'tif', 'compression', 'none');

elseif strcmp(ext,'.tif')==1
    image = imread([pname fname]);
    [x y dump] = textread([cd '\IR_target.txt'], '%s %s %s');
    x1 = median(str2num(char(x)));
    y1 = median(str2num(char(y)));
else
    %do nothing
end

% [f2, p2] = uigetfile('*.bmp', 'Select associated reference frame', pname);
% 
% x1 = str2num(f2(end-10:end-8)); y1 = str2num(f2(end-6:end-4));
% 
% figure('Position',[300 300 500 500]), imshow(im2double(image)), hold on
% plot(x1,y1,'r+');
% hold off
% close(gcf)

halfwidth = 50;

rect = [x1-halfwidth y1-halfwidth halfwidth*2 halfwidth*2];

if CFG.red_stim_color == 1
    tcashift_x = CFG.red_x_offset;
    tcashift_y = CFG.red_y_offset;
else
    tcashift_x = CFG.green_x_offset;
    tcashift_y = CFG.green_y_offset;
end
rw = 32-(2*abs(tcashift_x)); rh = 64-(2*abs(tcashift_y)); %edit 9:08AM
% rx = halfwidth+1-(rw/2)-tcashift_x; ry = halfwidth+1-(rh/2)+tcashift_y; %edit 4:06PM

rx = halfwidth+1-(rw/2); ry = halfwidth+1-(rh/2); %edit 8:40AM

image_crop = imcrop(image, rect);
% clim=[min(image_crop(:)) max(image_crop(:))];
figure('Position',[300 300 600 600]), imshow(image_crop,'InitialMagnification','fit'), axis square, hold on, colormap gray
plot(rx+rw/2,ry+rh/2,'ro', 'MarkerFaceColor','r');
h=rectangle('Position',[rx ry rw rh]);
set(h,'EdgeColor',[1 0 0]);
conecount = 1;
but = 1;
while but == 1
    [x,y,but] = ginput(1);
    plot(x,y,'g+')
    xi(conecount,1) = x;
    yi(conecount,1) = y;
    cone_id(conecount,1) = conecount;
    conecount = conecount+1;
end
for ii = 1:size(xi,1)
    row = round((ii/size(xi,1))*size(color_script,1));
    plot(xi(ii),yi(ii),'+','Color', color_script(row,:));
end

tm = datestr(now,13); dt = datestr(now,23);
tmstmp = [dt '_' tm]; c1 = find(tmstmp==':');c2 = find(tmstmp=='/');
tmstmp(c1)='_'; tmstmp(c2)='_';

h2 = title(tmstmp); set(h2,'interpreter', 'none');
selection_figure = getframe(gcf);

hold off
print(gcf, [pname fname(1:end-4) '_' tmstmp '_conemap.eps'], '-depsc2');
print(gcf, [pname fname(1:end-4) '_' tmstmp '_conemap.png'], '-dpng');
close(gcf)

xi2 = x1-halfwidth-1+xi;
yi2 = y1-halfwidth-1+yi;

xi2 = round(xi2); yi2 = round(yi2);
figure('Position',[300 300 500 500]), imshow(image), hold on
plot(xi2,yi2, 'g+')
hold off
offset_matrix = zeros(size(xi2,1),3);
for n = 1:size(xi2,1)
%     offset_matrix(n,1) = xi2(n)-x1+tcashift_x;
%     offset_matrix(n,2) = -(y1-yi2(n)+tcashift_y);  %EDIT 4:10 PM
    
    offset_matrix(n,1) = xi2(n)-x1;
    offset_matrix(n,2) = -(y1-yi2(n));  %EDIT 4:10 PM
    
    offset_matrix(n,3) = cone_id(n);
end

numcones = size(offset_matrix,1);
trial_matrix = zeros(numtrials, numcones);

for nc = 1:numcones
    temp_mat = ones(numtrials,2);
    temp_mat(:,1)=randn(numtrials,1);
    temp_mat(1:ncatch,2) = 0; %0 indicates catch trial
    temp_mat(end-nlapse+1:end,2) = 2; %2 indicates lapse trial
    temp_mat = sortrows(temp_mat,1);
    trial_matrix(:,nc) = temp_mat(:,2);
end
index_sequence = zeros(numcones,1,numtrials);
for nt = 1:numtrials
    temp_vector = zeros(numcones,2);
    temp_vector(:,1) = randn(numcones,1);
    temp_vector(:,2) = (1:numcones)';
    temp_vector = sortrows(temp_vector,1);
    index_sequence(:,1,nt) = temp_vector(:,2);
end
close(gcf)
exp_sequence = zeros(numcones*numtrials,5);
n = 1;
for m = 1:size(index_sequence,3)
    for p = 1:size(index_sequence,1)
        exp_sequence(n,1) = index_sequence(p,1,m); %cone
        if strcmp(CFG.method,'Mocs')
            exp_sequence(n,2) = 0; %fill in later; will be trial intensities in MOCS
        else
            exp_sequence(n,2) = trial_matrix(m,index_sequence(p,1,m)); %trial_flag
        end
        exp_sequence(n,3) = offset_matrix(index_sequence(p,1,m),1); %x offset
        exp_sequence(n,4) = offset_matrix(index_sequence(p,1,m),2); %y offset
        exp_sequence(n,5) = m;
        n = n+1;
    end
end

% %working on adding MOCS generation to offset_mapping
if strcmp(CFG.method,'Mocs')
    for nn = 1:numcones
        test_vector = rand(numtrials,1);
        test_vector(:,2) = 0;
        n = 1;
        for int = 1:CFG.beta;
            test_vector(n:CFG.delta*int,2) = int;
            n = n+CFG.delta;
        end
        
        test_sequence = sortrows(test_vector);
        test_sequence(:,1)= [];
        
        k = 1;
        [row,col] = find(exp_sequence(:,1)==nn);
        for row_num = 1:size(row,1)
            exp_sequence(row(row_num),2) = Intensity_Vector(test_sequence(k,1));
            k = k+1;
        end
    end
    %     clear test_sequence test_vector

end
