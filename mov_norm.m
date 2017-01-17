%This program will add movie frames together and generate an average image that has been normalized by the the number of frames
%that have contributed to each pixel in the image. The result is that there
%are no intensity drop offs at the edges of the averaged image that would normally be casued by fewere frames contributing to those regions.
%On the other hand, the edges of the frames are noisier since they comprose fewer averaged frames.

% You only need one copy of this program. You need to identify
% the folder that contains the avi files. It will add all avi files in the
% selected directory
%Austin Roorda October 17, 2007
function [image] = mov_norm(pname, fname)

AVIdetails=aviinfo([pname fname]); warning off all

sumframe=zeros(AVIdetails.Height,AVIdetails.Width);
sumframebinary=ones(AVIdetails.Height,AVIdetails.Width);

startframe = 1;
endframe = AVIdetails.NumFrames-10; %change this range to add any subset of frames
% in 30 frame trial, last 10 often have blinks

[d1 d2 framewithcross] = textread([cd '\IR_target.txt'], '%s %s %s');
framewithcross=str2num(char(framewithcross));

% fprintf('Frames %g to %g are being co-added and saved to a tif file\n',startframe,endframe);

for framenum=startframe:endframe
    if ~ismember(framenum,framewithcross)
        currentframe = double(frame2im(aviread([pname fname],framenum)));
        % currentframe = double(frame2im(aviread([pname '\' fname{movienum}],framenum)));
        currentframebinary = im2bw(currentframe,0.01); %generate a binary image to locate the actual image pixels
        %if the image is not too distorted then add to sum
        if  sum(max(currentframebinary))<520 || sum(max(currentframebinary'))<520
            sumframe=sumframe+currentframe(:,:,1);
            sumframebinary = sumframebinary+currentframebinary; % generate an image to divide by the sum image to generate an average
            %imshow(sumframe./max(max(sumframe)));
            %drawnow;
        else
            %fprintf('Dropped frame# %g from movie %s\n', framenum, fname{movienum});
            %         fprintf('Dropped frame# %g from movie %s\n', framenum, a(movienum).name);
        end
    end
end
% name = [pname '\sumnorm_' fname '.tif'];
%name = [pname '\sumnorm_' fname '.tif']
sumframenew = sumframe./sumframebinary;
image1 = sumframenew/max(max(sumframenew));
image = image1;
% imshow(sumframenew/max(max(sumframenew)));drawnow;
% imwrite(sumframenew/max(max(sumframenew)),name,'tif','Compression','none');
end


