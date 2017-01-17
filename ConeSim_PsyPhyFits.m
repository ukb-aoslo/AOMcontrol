% --------------------------------------------------------------------------
% ***********    Read ConeSim Data and generate psy-functions    ***********
% --------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save Options
SavePNG = 0;
SaveFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

english = 1;
suMMary = 0;
S1ZE = 8;
figA = figure;
figB = figure;
l04d = 1;


% Colors
Color_StatA = [61 108 125]/255;
Color_StatB = [205 239 251]/255;
Color_StatC = [130 169 185]/255;
Color_DynA = [105 90 23]/255;
Color_DynB = [237 201 38]/255;
Color_DynC = [168 143 30]/255;


%% loop
File = struct;

if l04d
    load('PsyPhyPathStruct.mat')
else
    for abc = 1:S1ZE
        Name=['Subject' num2str(abc)];
        [File.Names.(Name),File.Paths.(Name),~] = uigetfile('D:\Video_Folder');
    end
end

HM=size(fieldnames(File.Names),1);


for zyx = 1:HM
    
    %% load Data
    Name=['Subject' num2str(zyx)];
    load([File.Paths.(Name) '\' File.Names.(Name)])
    
    Nyquist = 6;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% read Data
    Subject = File.Names.(Name)(1:8);
    
    data=abs(rawData);
    stim_int=abs(data(:,2));
    
    % Compute result matrix
    stimuli=unique(sort(stim_int));
    nstimuli=size(stimuli,1);
    
    result_dyn=zeros(nstimuli,3,'double');
    result_stat=zeros(nstimuli,3,'double');
    rightcor=zeros(nstimuli,1,'double');
    righttotal=zeros(nstimuli,1,'double');
    rightfalse=zeros(nstimuli,1,'double');
    leftfalse=zeros(nstimuli,1,'double');
    leftcor=zeros(nstimuli,1,'double');
    
    for i=1:size(data,1);
        pos = find(stimuli==data(i,2));
        if data(i,5)==1 && data(i,6)==0
            result_stat(pos,2)=result_stat(pos,2)+1;
        elseif data(i,5)==1
            result_dyn(pos,2)=result_dyn(pos,2)+1;
        end
        
        if data(i,3)==1 && data(i,4)==1
            rightcor(pos,1)=rightcor(pos,1)+1;end
        
        if data(i,3)==0 && data(i,4)==1
            leftcor(pos,1)=leftcor(pos,1)+1;end
        
        if data(i,3)==1 && data(i,4)==0
            rightfalse(pos,1)=rightfalse(pos,1)+1;end
        
        if data(i,3)==0 && data(i,4)==0
            leftfalse(pos,1)=leftfalse(pos,1)+1;end
        
        if (data(i,3)==1)
            righttotal(pos,1)=righttotal(pos,1)+1;end
        
        result_stat(:,1)=stimuli;
        
        result_dyn(:,1)=stimuli;
    end
    
    for ihx=1:nstimuli
        result_stat(ihx,3)=sum(data(:,6)==0 & data(:,2)==stimuli(ihx));       % number trials
        result_dyn(ihx,3)= sum(data(:,6)~=0 & data(:,2)==stimuli(ihx));       % number trials
    end
    
    ncorrect_stat = result_stat(:,2);
    ncorrect_dyn = result_dyn(:,2);
    
    for i=1:nstimuli;
        result_stat(i,2)= result_stat(i,2)/result_stat(i,3);
        result_dyn(i,2)= result_dyn(i,2)/result_dyn(i,3);
    end;
    
    % result_stat = [result_stat ncorrect_stat];
    % result_dyn = [result_dyn ncorrect_dyn];
    %
    % results_static= num2str(result_stat,'   %1.3f');
    % results_dynamic= num2str(result_dyn,'   %1.3f');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% prepare and analyse Data
    
    data_stab(:,:) = result_stat;
    data_dyn(:,:) = result_dyn;
    
    %     StimSize  p-corr   n-trials
    %     [3.0000   0.5000    2.0000
    %     4.0000    0.7500    4.0000
    %     4         0.46      300
    %     5.0000    0.5278   36.0000
    %     7.0000    0.8605   43.0000
    %    10.0000    1.0000   16.0000];
    
    % Nyquist limits for subjects
    % nyquist = [0.87; 0.86; 0.8];
    
    % norm nyquist
    data_stab(:,1)=data_stab(:,1)./Nyquist;
    data_dyn(:,1)=data_dyn(:,1)./Nyquist;
    
    
    % Compute fits
    pfit_data = data_dyn(:,:);
    pfit_data_stab = data_stab(:,:);
    pfit_data_log = [log10(data_dyn(:,1)) data_dyn(:,2:3)];
    pfit_data_stab_log = [log10(data_stab(:,1)) data_stab(:,2:3)];
    
    options = PAL_minimize('options');
    PF = @PAL_Logistic;
    PF_log = @PAL_Gumbel;
    B = 100;
    searchGrid.alpha = 0.5:.1:1;
    searchGrid.beta = -1:.5:5;
    searchGrid.gamma = 0.25;
    searchGrid.lambda = 0;
    paramsFree = [1 1 0 0];
    
    % Fitting in LIN space
    StimLevels = (pfit_data(:,1))';
    NumPos = (pfit_data(:,2).*pfit_data(:,3))';
    OutOfNum = (pfit_data(:,3))';
    
    [fit, LL] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, ...
        searchGrid, paramsFree, PF,'searchOptions',options);
    warning('off','PALAMEDES:convergeFail');
    [SD, paramsSim, LLSim, converged] = ...
        PAL_PFML_BootstrapParametric(StimLevels, OutOfNum, ...
        fit, paramsFree, B, PF,'searchGrid', searchGrid);
    
    StimLevels = (pfit_data_stab(:,1))';
    NumPos = (pfit_data_stab(:,2).*pfit_data_stab(:,3))';
    OutOfNum = (pfit_data_stab(:,3))';
    
    [fit_stab, LL_stab] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, ...
        searchGrid, paramsFree, PF,'searchOptions',options);
    warning('off','PALAMEDES:convergeFail');
    [SD_stab, paramsSim_stab, LLSim_stab, converged_stab] = ...
        PAL_PFML_BootstrapParametric(StimLevels, OutOfNum, ...
        fit_stab, paramsFree, B, PF,'searchGrid', searchGrid);
    
    % Fitting in LOG space
    StimLevels = (pfit_data_log(:,1))';
    NumPos = (pfit_data_log(:,2).*pfit_data_log(:,3))';
    OutOfNum = (pfit_data_log(:,3))';
    
    [fit_log, LL_log] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, ...
        searchGrid, paramsFree, PF_log,'searchOptions',options);
    warning('off','PALAMEDES:convergeFail');
    [SD_log, paramsSim_log, LLSim_log, converged_log] = ...
        PAL_PFML_BootstrapParametric(StimLevels, OutOfNum, ...
        fit_log, paramsFree, B, PF_log,'searchGrid', searchGrid);
    
    StimLevels = (pfit_data_stab_log(:,1))';
    NumPos = (pfit_data_stab_log(:,2).*pfit_data_stab(:,3))';
    OutOfNum = (pfit_data_stab_log(:,3))';
    
    [fit_stab_log, LL_stab_log] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, ...
        searchGrid, paramsFree, PF_log,'searchOptions',options);
    warning('off','PALAMEDES:convergeFail');
    [SD_stab_log, paramsSim_stab_log, LLSim_stab_log, converged_stab_log] = ...
        PAL_PFML_BootstrapParametric(StimLevels, OutOfNum, ...
        fit_stab_log, paramsFree, B, PF_log,'searchGrid', searchGrid);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%% Generate Psychometric fits
    
figure(figA)
    if S1ZE>1
       sA = subplot(2,4,zyx,'Parent',figA);
    end
    
    box on, hold on;
    drawnow
    
    M4X_A = max(data_dyn(:,1));
    
    xfit=0.01:0.01:M4X_A+.5*M4X_A;
    xlims=[-0.1 M4X_A+0.1*M4X_A]; ylims=[0.10 1.05];
    axis(sA,[xlims ylims]);
    %     xlabel('Stimulus size [arcmin]');
    if english
        xlabel (sA,'Gap size')
        ylabel(sA,'p (correct)');
    else
        xlabel (sA,'Spaltbreite')
        ylabel(sA,'p (korrekt)');
    end
    axis (sA,'square')
    title(sA,Subject, 'Interpreter', 'none')
    
    % All bootstrapped estimates
    for idx = 1: size(paramsSim,1)
        alpha= paramsSim(idx,1);
        beta= paramsSim(idx,2);
        gamma= paramsSim(idx,3);
        lambda= paramsSim(idx,4);
        ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha)))); % only if @PAL_Logistic
        plot(sA,xfit,ypsi,'Color',[0.90 0.90 0.90]); hold on
    end
    for idx = 1: size(paramsSim,1)
        alpha= paramsSim_stab(idx,1);
        beta= paramsSim_stab(idx,2);
        gamma= paramsSim_stab(idx,3);
        lambda= paramsSim_stab(idx,4);
        ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha)))); % only if @PAL_Logistic
        plot(sA,xfit,ypsi,'Color',[1 0.90 0.90]); hold on
    end
    
    % Data points
    x=pfit_data(:,1); y=pfit_data(:,2); z=pfit_data(:,3);
    maxN=12; minN=2; marksize=minN+floor((maxN-minN)*(z/max(z)-1/max(z)));
    for zz=1:size(x,1)
        plot11A1 = plot(sA,...
            x(zz),y(zz),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerEdgeColor',[0.0 0.0 0.0],...
            'MarkerFaceColor',[0.5 0.5 0.5],...
            'MarkerSize',marksize(zz)); hold on
    end
    x=pfit_data_stab(:,1); y=pfit_data_stab(:,2); z=pfit_data_stab(:,3);
    maxN=12; minN=2; marksize=minN+floor((maxN-minN)*(z/max(z)-1/max(z)));
    for zz=1:size(x,1)
        plot11A2 = plot(sA,...
            x(zz),y(zz),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerEdgeColor',[1 0.0 0.0],...
            'MarkerFaceColor',[1 0.5 0.5],...
            'MarkerSize',marksize(zz)); hold on
    end
    uistack(plot11A2,'top');
    
    alpha= fit(1);
    beta= fit(2);
    gamma= fit(3);
    lambda= fit(4);
    ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha))));
    ythresh = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(alpha-alpha))));
    plot(sA,xfit,ypsi,'k','LineWidth',2), hold on
    plot(sA,alpha,ythresh,'ok','LineWidth',2,'MarkerFaceColor','k'); hold on
    if english
        text(0,1,['Thr:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD(1),'%1.2f')],'Parent',sA);
        text(0,0.92,['Slope:  ',num2str(beta,'%1.2f'),' +-',num2str(SD(2),'%1.2f')],'Parent',sA);
        text(0,0.84,['N = ',num2str(sum(pfit_data(:,3)),'%3.0i'),'/n = ',num2str(pfit_data(1,3)),' (dyn)'],'Parent',sA);
    else
        text(0,1,['SchW:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD(1),'%1.2f')],'Parent',sA);
        text(0,0.92,['Stg:  ',num2str(beta,'%1.2f'),' +-',num2str(SD(2),'%1.2f')],'Parent',sA);
        text(0,0.84,['dynamisch (N = ',num2str(sum(pfit_data(:,3)),'%3.0i'),')'],'Parent',sA);
    end
    Threshold_dyn (zyx) = alpha;
%     SD_Thresh_dyn (zyx) = SD(1);
    Slope_dyn (zyx) = beta;
%     SD_Slope_dyn (zyx) = SD(2);
    
    
    alpha= fit_stab(1);
    beta= fit_stab(2);
    gamma= fit_stab(3);
    lambda= fit_stab(4);
    ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha))));
    ythresh = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(alpha-alpha))));
    plot(sA,xfit,ypsi,'r','LineWidth',2), hold on
    plot(sA,alpha,ythresh,'ok','LineWidth',2,'MarkerFaceColor','r','MarkerEdgeColor','r'); hold on
    if english
        text(0,0.96,['Thr:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD_stab(1),'%1.2f')],'Color','r','Parent',sA);
        text(0,0.88,['Slope:  ',num2str(beta,'%1.2f'),' +-',num2str(SD_stab(2),'%1.2f')],'Color','r','Parent',sA);
        text(0,0.80,['N = ',num2str(sum(pfit_data_stab(:,3)),'%3.0i'),'/n = ',num2str(pfit_data_stab(1,3)),' (stat)'],'Color','r','Parent',sA);
    else
        text(0,0.96,['SchW:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD_stab(1),'%1.2f')],'Color','r','Parent',sA);
        text(0,0.88,['Stg:  ',num2str(beta,'%1.2f'),' +-',num2str(SD_stab(2),'%1.2f')],'Color','r','Parent',sA);
        text(0,0.80,['statisch (N = ',num2str(sum(pfit_data_stab(:,3)),'%3.0i'),')'],'Color','r','Parent',sA);
    end
    
    Threshold_stat (zyx) = alpha;
%     SD_Thresh_stat (zyx) = SD_stab(1);
    Slope_stat (zyx) = beta;
%     SD_Slope_stat (zyx) = SD_stab(2);
    
%     line([nyquist nyquist],[0 1],'Color','k')
    


%% Generate Psychometric fits (log-Data)

figure(figB)
    
    if S1ZE>1
        sB = subplot(2,4,zyx,'Parent',figB);
    end
    
    box on, hold on;
    drawnow
    
    M4X_B = max(data_dyn(:,1));
    
    xfit=0.01:0.01:M4X_B+.5*M4X_B;
%     xfit2 = log(xfit);
    xlims=[-1 M4X_B+0.1*M4X_B]; ylims=[0 1.05];
    axis(sB,[xlims ylims]);
    %     xlabel('Stimulus size [arcmin]');
    if english
        xlabel (sB,'Gap size')
        ylabel(sB,'p (correct)');
    else
        xlabel (sB,'Spaltbreite')
        ylabel(sB,'p (korrekt)');
    end
    axis square
    title(sB,Subject, 'Interpreter', 'none')
    
    % All bootstrapped estimates
    for idx = 1: size(paramsSim_log,1)
        alpha= paramsSim_log(idx,1);
        beta= paramsSim_log(idx,2);
        gamma= paramsSim_log(idx,3);
        lambda= paramsSim_log(idx,4);
        ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha)))); % only if @PAL_Logistic
        plot(xfit,ypsi,'Color',[0.90 0.90 0.90],'Parent',sB); 
    end
    for idx = 1: size(paramsSim_log,1)
        alpha= paramsSim_stab_log(idx,1);
        beta= paramsSim_stab_log(idx,2);
        gamma= paramsSim_stab_log(idx,3);
        lambda= paramsSim_stab_log(idx,4);
        ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha)))); % only if @PAL_Logistic
        plot(xfit,ypsi,'Color',[1 0.90 0.90],'Parent',sB); 
    end
    
    % Data points
    x=pfit_data_log(:,1); y=pfit_data_log(:,2); z=pfit_data_log(:,3);
    maxN=12; minN=2; marksize=minN+floor((maxN-minN)*(z/max(z)-1/max(z)));
    for zz=1:size(x,1)
        plot11B1 = plot(...
            x(zz),y(zz),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerEdgeColor',[0.0 0.0 0.0],...
            'MarkerFaceColor',[0.5 0.5 0.5],...
            'MarkerSize',marksize(zz),...
            'Parent',sB); 
    end
    x=pfit_data_stab_log(:,1); y=pfit_data_stab_log(:,2); z=pfit_data_stab_log(:,3);
    maxN=12; minN=2; marksize=minN+floor((maxN-minN)*(z/max(z)-1/max(z)));
    for zz=1:size(x,1)
        plot11B2 = plot(...
            x(zz),y(zz),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerEdgeColor',[1 0.0 0.0],...
            'MarkerFaceColor',[1 0.5 0.5],...
            'MarkerSize',marksize(zz),...
            'Parent',sB); 
    end
    uistack(plot11B2,'top');
    
    alpha= fit_log(1);
    beta= fit_log(2);
    gamma= fit_log(3);
    lambda= fit_log(4);
    ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha))));
    ythresh = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(alpha-alpha))));
    plot(xfit,ypsi,'k','LineWidth',2,'Parent',sB)
    plot(alpha,ythresh,'ok','LineWidth',2,'MarkerFaceColor','k','Parent',sB);
    if english
        text(0,1,['Thr:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD_log(1),'%1.2f')],'Parent',sB);
        text(0,0.92,['Slope:  ',num2str(beta,'%1.2f'),' +-',num2str(SD_log(2),'%1.2f')],'Parent',sB);
        text(0,0.84,['N = ',num2str(sum(pfit_data_log(:,3)),'%3.0i'),'/n = ',num2str(pfit_data_log(1,3)),' (dyn)'],'Parent',sB);
    else
        text(0,1,['SchW:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD_log(1),'%1.2f')],'Parent',sB);
        text(0,0.92,['Stg:  ',num2str(beta,'%1.2f'),' +-',num2str(SD_log(2),'%1.2f')],'Parent',sB);
        text(0,0.84,['dynamisch (N = ',num2str(sum(pfit_data_log(:,3)),'%3.0i'),')'],'Parent',sB);
    end
    Threshold_dyn (zyx) = alpha;
%     SD_Thresh_dyn (zyx) = SD(1);
    Slope_dyn (zyx) = beta;
%     SD_Slope_dyn (zyx) = SD(2);
    
    
    alpha= fit_stab_log(1);
    beta= fit_stab_log(2);
    gamma= fit_stab_log(3);
    lambda= fit_stab_log(4);
    ypsi = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(xfit-alpha))));
    ythresh = gamma + (1 - gamma - lambda).*(1./(1+exp(-1*(beta).*(alpha-alpha))));
    plot(xfit,ypsi,'r','LineWidth',2,'Parent',sB)
    plot(alpha,ythresh,'ok','LineWidth',2,'MarkerFaceColor','r','MarkerEdgeColor','r','Parent',sB);
    if english
        text(0,0.96,['Thr:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD_stab_log(1),'%1.2f')],'Color','r','Parent',sB);
        text(0,0.88,['Slope:  ',num2str(beta,'%1.2f'),' +-',num2str(SD_stab_log(2),'%1.2f')],'Color','r','Parent',sB);
        text(0,0.80,['N = ',num2str(sum(pfit_data_stab_log(:,3)),'%3.0i'),'/n = ',num2str(pfit_data_stab_log(1,3)),' (stat)'],'Color','r','Parent',sB);
    else
        text(0,0.96,['SchW:  ',num2str(alpha,'%1.2f'),' +-',num2str(SD_stab_log(1),'%1.2f')],'Color','r','Parent',sB);
        text(0,0.88,['Stg:  ',num2str(beta,'%1.2f'),' +-',num2str(SD_stab_log(2),'%1.2f')],'Color','r','Parent',sB);
        text(0,0.80,['statisch (N = ',num2str(sum(pfit_data_stab_log(:,3)),'%3.0i'),')'],'Color','r','Parent',sB);
    end


    disp(['done_' Subject])
end

%% Summary
if suMMary
    STAT_SD_Thresh = std(Threshold_stat);
    DYN_SD_Thresh = std(Threshold_dyn);
    STAT_SD_Slope = std(Slope_stat(Slope_dyn<10));
    DYN_SD_Slope = std(Slope_dyn(Slope_dyn<10));
    
    
    figure(),
    hula=subplot (1,2,1);
    % h1 = boxplot(Threshold_stat,'Color',Color_StatA,'Positions', 1); hold on
    % set(h1,'LineWidth',2);
    % h2 = boxplot(Threshold_dyn,'Color',Color_DynA,'Positions', 2);
    % set(h2,'LineWidth',2);
    bar(1,mean(Threshold_stat),'FaceColor',Color_StatA), hold on
    bar(2,mean(Threshold_dyn),'FaceColor',Color_DynA), hold on
    errorbar([1 2],[mean(Threshold_stat) mean(Threshold_dyn)],[STAT_SD_Thresh DYN_SD_Thresh],...
        'LineStyle', 'none','LineWidth',3,'Color',[0 0 0],'MarkerSize',5,'Marker','x')
    set(gca, 'FontSize', 14);
    set(hula,'XTickLabel',{' '})
    text('Position',[.8,-.03],'String',['N= ' num2str(length(Threshold_stat))],'FontWeight','bold', 'FontSize',14)
    text('Position',[1.8,-.03],'String',['N = ' num2str(length(Threshold_dyn))],'FontWeight','bold', 'FontSize',14)
    if english
        title ('Thresholds', 'FontSize',14,'FontWeight','bold','Color',[0 0 0] );
    else
        title ('Schwellenwerte', 'FontSize',14,'FontWeight','bold','Color',[0 0 0] );
    end
    axis(hula,[0.5 2.5 2 4.6])
    
    
    hula2=subplot (1,2,2);
    % h3 = boxplot(Slope_stat(Slope_dyn<10),'Color',Color_StatA,'Positions', 1); hold on
    % set(h3,'LineWidth',2);
    % h4 = boxplot(Slope_dyn(Slope_dyn<10),'Color',Color_DynA,'Positions', 2);
    % set(h4,'LineWidth',2);
    bar(1,mean(Slope_stat(Slope_dyn<10)),'FaceColor',Color_StatA), hold on
    bar(2,mean(Slope_dyn(Slope_dyn<10)),'FaceColor',Color_DynA), hold on
    errorbar([1 2],[mean(Slope_stat(Slope_dyn<10)) mean(Slope_dyn(Slope_dyn<10))],[STAT_SD_Slope DYN_SD_Slope],...
        'LineStyle', 'none','LineWidth',3,'Color',[0 0 0],'MarkerSize',5,'Marker','x')
    set(gca, 'FontSize', 14);
    set(hula2,'XTickLabel',{' '})
    text('Position',[.8,-.03],'String',['N= ' num2str(length(Slope_stat))],'FontWeight','bold', 'FontSize',14)
    text('Position',[1.8,-.03],'String',['N = ' num2str(length(Slope_dyn))],'FontWeight','bold', 'FontSize',14)
    if english
        title ('Slopes', 'FontSize',14,'FontWeight','bold','Color',[0 0 0] );
    else
        title ('Steigungen', 'FontSize',14,'FontWeight','bold','Color',[0 0 0] );
    end
    axis(hula2,[0.5 2.5 1 4.6])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% save

if SavePNG
    set(figA,'PaperPositionMode','auto')
    print(figA,'-dpng',[Subject '_' 'PF_SnellenE.png'])
end