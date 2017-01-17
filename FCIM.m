function [x1 y1] = FCIM(movie_name)
%Find cross in movies for cone mapping selection
%W. Tuten October 2nd, 2012

cross=zeros(11); cross(:,6)=1/11; %cross(6,:)=1;    %cross shape to search for


cdir = cd();
name = [cdir '\IR_target.txt'];     %create stimlocations text file
fid = fopen(name,'wt');
AVIdetails=aviinfo(movie_name); %warning off last

startframe = 1;
endframe = AVIdetails.NumFrames-10; %change this range to add any subset of frames
% in 30 frame trial,last 10 usually have eyeblink
n = 1;
for framenum=startframe:endframe
    currentframe = double(frame2im(aviread(movie_name,framenum))); %warning off last
%     currentframe = currentframe(:,:,1);
    currentframe = currentframe/max(max(currentframe));

    currentframe = imfilter(currentframe,cross);
    % [row,col] = find(currentframe>0.9959);
    % currentframe(row,col)=0;
    % currentframebinary = im2bw(currentframe,0.9919); %changed from .9962
    currentframebinary = im2bw(currentframe,0.9960); %to find IR cross

    if(max(max(currentframebinary))==1)
        [i,j]=max(max(currentframebinary));
        [k,l]=max(currentframebinary(:,j));
        x(n,1) = j;
        y(n,1) = l;
        fprintf(fid,'%g\t%g\t%g\n',j,l,framenum); %write info to stimlocations.txt file for future reference
        n = n+1;
    end
end
x1 = median(x);
y1 = median(y);
end

