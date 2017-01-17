%Generate list of offsets for cone mapping experiments

clear all
close all
clc

stand_path = ['J:\SCP\LvsM\10001R\06_25_2012\Sumframes'];

[fname, pname] = uigetfile('*.tif', 'Select image for cone selection', stand_path);

image = im2double(imread([pname fname]));

figure, imshow(image), hold on

[x1 y1] = ginput(1);
x1 = round(x1); y1 = round(y1);
plot(x1,y1,'r+');

hold off
close all

halfwidth = 25;

rect = [x1-halfwidth y1-halfwidth halfwidth*2 halfwidth*2];

image_crop = imcrop(image, rect);

imagesc(image_crop), axis square, hold on, colormap gray

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
xi2 = x1-halfwidth-1+xi;
yi2 = y1-halfwidth-1+yi;

xi2 = round(xi2); yi2 = round(yi2);
figure, imshow(image), hold on
plot(xi2,yi2, 'g+')
hold off

fid = fopen([cd '\offset_script.txt'], 'w+');

for n = 1:size(xi2,1)
    x_off = x1-xi2(n);
    y_off = yi2(n)-y1;
    fprintf(fid, '%g\t %g\t %g\r\n', n, x_off, y_off);
end

fclose(fid);
