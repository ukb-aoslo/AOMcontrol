function [trial_matrix, index_sequence, offset_matrix, numcones, exp_sequence] = offset_mapping(CFG);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numtrials = CFG.npresent+CFG.ncatch+CFG.nlapse;
directory = 'D:\Video_Folder\';
[fname, pname] = uigetfile('*.avi;*.tif', 'Select image or video for cone selection', directory);
[pathstr, name, ext] = fileparts([pname fname]);
movie_name = [pname fname];
if strcmp(ext,'.avi')==1
    [image] = mov_norm(pname, fname);
    %save image for use later;
    imwrite(image, [pname fname(1:end-4) '_sumframe.tif'], 'tif', 'compression', 'none');
    [x1 y1] = FCIM(movie_name);
elseif strcmp(ext,'.tif')==1
    image = imread([pname fname]);
    [x y] = textread([cd '\IR_target.txt'], '%s %s');
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
rw = 18; rh = 36;
if CFG.red_stim_color == 1
    tcashift_x = CFG.red_x_offset;
    tcashift_y = CFG.red_y_offset;
else
    tcashift_x = CFG.green_x_offset;
    tcashift_y = CFG.green_y_offset;
end
    
rx = halfwidth+1-(rw/2)-tcashift_x; ry = halfwidth+1-(rh/2)+tcashift_y; %edit 4:06PM

image_crop = imcrop(image, rect);
% clim=[min(image_crop(:)) max(image_crop(:))];
figure('Position',[300 300 600 600]), imshow(image_crop,'InitialMagnification','fit'), axis square, hold on, colormap gray
plot(rx+rw/2,ry+rh/2,'r+');
h=rectangle('Position',[rx ry rw rh]);
set(h,'EdgeColor',[1 0 0]);


conecount = 1;
but = 1;
while but == 1
    [x,y,but] = ginput(1);
    plot(x,y,'g+')
    xi(conecount,1) = x;
    yi(conecount,1) = y;
    conecount = conecount+1;
end
hold off
print(gcf, [pname fname(1:end-4) '_conemap.eps'], '-depsc2');
close(gcf)

xi2 = x1-halfwidth-1+xi;
yi2 = y1-halfwidth-1+yi;

xi2 = round(xi2); yi2 = round(yi2);
figure('Position',[300 300 500 500]), imshow(image), hold on
plot(xi2,yi2, 'g+')
hold off

offset_matrix(:,1) = xi2-x1+tcashift_x;
% offset_matrix(:,2) = yi2+y1;
offset_matrix(:,2) = -(y1-yi2+tcashift_y);  %EDIT 4:10 PM

numcones = size(offset_matrix,1);
trial_matrix = zeros(numtrials, numcones);

for nc = 1:numcones
    temp_mat = ones(numtrials,2);
    temp_mat(:,1)=randn(numtrials,1);
    temp_mat(1:CFG.ncatch,2) = 0; %0 indicates catch trial
    temp_mat(end-CFG.nlapse+1:end,2) = 2; %2 indicates lapse trial
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
        exp_sequence(n,2) = trial_matrix(m,index_sequence(p,1,m)); %trial_flag
        exp_sequence(n,3) = offset_matrix(index_sequence(p,1,m),1); %x offset
        exp_sequence(n,4) = offset_matrix(index_sequence(p,1,m),2); %y offset
        exp_sequence(n,5) = m;
        n = n+1;
    end
end
end

