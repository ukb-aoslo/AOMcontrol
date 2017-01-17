% function dataPlotting(matfname)
%read in psy file struct
close all; clc;

load('D:\video_folder\20019R\12_2_2012_17_32\20019R_12_2_2012_17_32_threshold_data.mat');
load(matfname);


for col = 1:numcones;
    for row = 4:size(response_matrix,1);
        trialMatrix(row,col) = response_matrix(row,col).trialIntensity;
        questMatrix(row,col) = response_matrix(row,col).questIntensity;
        respMatrix(row,col) = response_matrix(row,col).response;
        threshMatrix(row,col) = response_matrix(row,col).questMean;
        sdMatrix(row,col) = response_matrix(row,col).questSD;
        flagMatrix(row,col) = response_matrix(row,col).trial_flag;
    end
end

for n = 1:numcones
    [ctrials] = find(flagMatrix(:,n)==0);
    [ltrials] = find(flagMatrix(:,n)==2);
    [row] = find(flagMatrix(:,n)==1);
    questMatrix2(:,n) = questMatrix(row,n);
    trialMatrix2(:,n) = trialMatrix(row,n);
    ctrialMatrix(:,n) = respMatrix(ctrials,n);
    ltrialMatrix(:,n) = respMatrix(ltrials,n);
    clear row ctrial ltrials
end

fontsize = 14; markersize = 6; fwidth = 350; fheight = 350; linewidth = 2;
f1 = figure('Position', [400 200 fwidth fheight]); a1 = axes; hold(a1,'all');
xlabel('Trial number','FontSize',fontsize);
ylabel('Test intensity (au)','FontSize',fontsize);
xlim([0 size(questMatrix2,1)]),ylim([-1.2 1.2]), axis square
set(a1,'YTick',[-1.0 -0.5 0 0.5 1.0],'XTick',[1:2:size(questMatrix2,1)]);
set(a1,'FontSize',fontsize);
set(a1,'LineWidth',1,'TickLength',[0.025 0.025]);
set(a1,'Color','none');
set(f1,'Color',[1 1 1]);
set(f1,'PaperPositionMode','auto');
set(f1, 'renderer', 'painters');
hold on
% for ii=1:size(questMatrix2,2)
%     plot(questMatrix2(:,ii), 'k-');
% end

for ii=1:size(trialMatrix2,2)
    plot(trialMatrix2(:,ii), 'r-', 'LineWidth', linewidth);
    plot([0 size(questMatrix2,1)], [0 0], 'k--');
end

hold off

cpercent = sum(ctrialMatrix(:))/length(ctrialMatrix(:));

disp(['False alarm rate: ' num2str(cpercent)])

lpercent = 1-(sum(ltrialMatrix(:))/length(ltrialMatrix(:)));

disp(['Lapse rate: ' num2str(lpercent)]);

questMatrix(end,:)
