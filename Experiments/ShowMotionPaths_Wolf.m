close all; clear all; clc;

load('MotionPathsUCB_20053R_2.mat');


lastxy = [0 0];
catxy = AllPaths(:,:,1);


for IDX = 2: size(AllPaths,3)
    current = AllPaths(:,:,IDX);
    lastxy = AllPaths(end,:,IDX-1);
    catxy = [catxy; current+repmat(lastxy,size(current,1),1)];
end


Paths = zeros(size(AllPaths,1),5,size(AllPaths,3));
for IDX = 1: size(AllPaths,3)
    current = AllPaths(:,:,IDX);
   
    for idx = 2: size(current,1)
       
        offset(idx,:) = current(idx,:)-current(idx-1,:);
        speed(idx,1) = sqrt(offset(idx,1)^2+offset(idx,2)^2);
       
       
    end
    Paths(:,:,IDX)= [current offset speed];
end







%% Plot concatenated
figure, hold all;
xlim([-100 100])
ylim([-100 100])
axis square
title('All paths concatenated')
xlabel('x-Position (Pixel)')
ylabel('y-Position (Pixel)')
set(gca,'Color','k');

plot(catxy(:,1),catxy(:,2),'r');


%% Plot from origin
figure, hold all;
xlim([-50 50])
ylim([-50 50])
axis square
title('All paths separately')
xlabel('x-Position (Pixel)')
ylabel('y-Position (Pixel)')
set(gca,'Color','k');



for IDX = 1: size(AllPaths,3)
    current = AllPaths(:,:,IDX);
    plot(current(:,1),current(:,2),'r');
end

%% Plot single
figure, hold all;
xlim([-60 60])
ylim([-60 60])
axis square
title('All paths separately')
xlabel('x-Position (Pixel)')
ylabel('y-Position (Pixel)')
set(gca,'Color','k');
colors = colormap('hot');

for IDX = 1: size(AllPaths,3)
   
   
    current = Paths(:,:,IDX);
    maxspeed = 80;
   
    for idx = 2: size(current,1)
       
        speed = current(idx,5);
        if speed==0
            linecolor = colors(1,:);
        elseif isnan(speed)
            linecolor = colors(1,:);
           
        elseif log(speed)==0
            linecolor = colors(1,:);
        else
            linecolor = colors(round(size(colors,1)*log(speed)/log(maxspeed)),:);
        end
       
        plot(current(idx-1:idx,1),current(idx-1:idx,2),...
            'Color',linecolor);
       
    end
   
   
end

%%
speeds = [];
for IDX = 1: size(Paths,3);
    speeds=[speeds; Paths(:,5,IDX)];
end