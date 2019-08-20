function [IPfin]=regressionCOGED(data,perRedo,varargin)
%%% script that extracts indifference points via logistic regression
%%% from the COGED task vs no offer data. Input: data: trial-wise matrix of
%%% COGED data, derived from choicesTrialWise.m script. 
%%% perRedo: ratio of the easy offer participants accepted
%%% during the COGED task, output variable of PercentageEasy.m
%%% io: analysis parameters defined in main analysis script, 
%%% including directory paths, IDs(subNr) and saveD(save data or not).
%%% Functions called: findOutliers.m, RegressionAnalysis.m


switch nargin
    case 2
        saveD=0;
        doPlots=0;
        subNr=1:62;
    case 3
        io=varargin{1};
        saveD=io.saveD;
        doPlots=io.doPlots;
        subNr=io.subNo;
        
end

% no redo (no effort) offers
easyOffer=[0.1 round((0.2:0.2:2.2)*10)/10];
maxValue=max(easyOffer);
minValue=min(easyOffer);

loop=1;
subNo=data(:,1);cond=data(:,2);sz=data(:,3);offer=data(:,4);choice=data(:,5);

for i=subNr
    
    %%Choice: 1 represents choosing easy and 2 choosing hard offer
    
    Isz1=offer(cond==0 & sz==1 & subNo==i);
    Isz2=offer(cond==0 & sz==2 & subNo==i);
    Isz3=offer(cond==0 & sz==3 & subNo==i);
    Isz4=offer(cond==0 & sz==4 & subNo==i);
    
    Usz1=offer(cond==2 & sz==1 & subNo==i);
    Usz2=offer(cond==2 & sz==2 & subNo==i);
    Usz3=offer(cond==2 & sz==3 & subNo==i);
    Usz4=offer(cond==2 & sz==4 & subNo==i);
    
    yI1=choice(cond==0 & sz==1 & subNo==i );
    yI2=choice(cond==0 & sz==2 & subNo==i);
    yI3=choice(cond==0 & sz==3 & subNo==i);
    yI4=choice(cond==0 & sz==4 & subNo==i);
    
    yU1=choice(cond==2 & sz==1 & subNo==i );
    yU2=choice(cond==2 & sz==2 & subNo==i);
    yU3=choice(cond==2 & sz==3 & subNo==i);
    yU4=choice(cond==2 & sz==4 & subNo==i);
    
    
    Ignore=offer(cond==0 & subNo==i);
    yI=choice(cond==0 & subNo==i);
    
    Update=offer(cond==2 & subNo==i);
    yU=choice(cond==2 & subNo==i);
    
    
    
    taskValue=offer(subNo==i);
    yTask=choice(subNo==i);
    
    
    %% Regression analyses
    [yfitI,IPI(loop),betasI(loop,:)]=RegressionAnalysis(Ignore,yI,minValue,maxValue);
    [yfitU,IPU(loop),betasU(loop,:)]=RegressionAnalysis(Update,yU,minValue,maxValue);
    [yfit1,IP1(loop),betas1(loop,:)]=RegressionAnalysis(Isz1,yI1,minValue,maxValue);
    [yfit2,IP2(loop),betas2(loop,:)]=RegressionAnalysis(Isz2,yI2,minValue,maxValue);
    [yfit3,IP3(loop),betas3(loop,:)]=RegressionAnalysis(Isz3,yI3,minValue,maxValue);
    [yfit4,IP4(loop),betas4(loop,:)]=RegressionAnalysis(Isz4,yI4,minValue,maxValue);
    [yfit5,IP5(loop),betas5(loop,:)]=RegressionAnalysis(Usz1,yU1,minValue,maxValue);
    [yfit6,IP6(loop),betas6(loop,:)]=RegressionAnalysis(Usz2,yU2,minValue,maxValue);
    [yfit7,IP7(loop),betas7(loop,:)]=RegressionAnalysis(Usz3,yU3,minValue,maxValue);
    [yfit8,IP8(loop),betas8(loop,:)]=RegressionAnalysis(Usz4,yU4,minValue,maxValue);
    [yfitTask,IPtask(loop)]=RegressionAnalysis(taskValue,yTask,minValue,maxValue);
    
    
    %%%%% Plots %%%%   % horizontal line at y=0.5
    lineX= 0:0.1:maxValue;
    lineY =0.5 * ones(size(lineX));
    
    if doPlots
        
        % regression plots
        xx = easyOffer;
        aI=unique([Ignore,yfitI],'rows');
        aU=unique([Update,yfitU],'rows');
        a1=unique([Isz1,yfit1],'rows');
        a2=unique([Isz2, yfit2],'rows');
        a3=unique([Isz3, yfit3],'rows');
        a4=unique([Isz4, yfit4],'rows');
        a5=unique([Usz1,yfit5],'rows');
        a6=unique([Usz2, yfit6],'rows');
        a7=unique([Usz3, yfit7],'rows');
        a8=unique([Usz4, yfit8],'rows');
        bI=unique([Ignore,yI],'rows');
        bU=unique([Update,yU],'rows');
        saI(loop,:)=aI(:,2)';saU(loop,:)=aU(:,2)';
        msaI=mean(saI);msaU=mean(saU);
        
        
        
        figure;
        hold all
        plot(a1(:,1),a1(:,2),'m')
        plot(a2(:,1),a2(:,2),'b')
        plot(a3(:,1),a3(:,2),'r')
        plot(a4(:,1),a4(:,2),'g')
        
        plot(lineX,lineY,'c')
        scatter(Isz1,yI1,'m','jitter','on')
        scatter(Isz2,yI2,'b','jitter','on')
        scatter(Isz3,yI3,'r','jitter','on')
        scatter(Isz4,yI4,'g','jitter','on')
        ylabel('Probability of accepting No Redo');
        xlabel('Offer for No Redo');
        legend('Ignore 1','Ignore 2','Ignore 3','Ignore 4','Threshold','location','southeast')
        title(sprintf('Probability of accepting No Redo for participant %d Ignore',i));
        ylim([0 1])
        xlim([minValue maxValue])
        hold off
        % saveas(gcf,sprintf('sub%dNRI',i),'bmp')
        
        figure;
        hold all
        plot(a5(:,1),a5(:,2),'m')
        plot(a6(:,1),a6(:,2),'b')
        plot(a7(:,1),a7(:,2),'r')
        plot(a8(:,1),a8(:,2),'g')
        
        plot(lineX,lineY,'c')
        scatter(Usz1,yU1,'m','jitter','on')
        scatter(Usz2,yU2,'b','jitter','on')
        scatter(Usz3,yU3,'r','jitter','on')
        scatter(Usz4,yU4,'g','jitter','on')
        ylabel('Probability of accepting No Redo');
        xlabel('Offer for No Redo');
        legend('Update 1','Update 2','Update 3','Update 4','Threshold','location','southeast')
        title(sprintf('Probability of accepting No Redo for participant %d Update',i));
        ylim([0 1])
        xlim([minValue maxValue])
        hold off
        % saveas(gcf,sprintf('sub%dNRU',i),'bmp')
    end
    loop=loop+1;
end %for i =subNr
%% matrices
IPmatrixAll=[IPI' IPU' IP1',IP2',IP3',IP4',IP5',IP6',IP7',IP8'];
%% correct for issue in regression when participants chose only one offer and
%replace with minimum or maximum offer based on the ratio easy or hard
%offer they chose extracted from PercentageEasy.m script

for x=1:length(IPmatrixAll)
    for y=1:size(IPmatrixAll,2)
        if IPmatrixAll(x,y)<=0 || IPmatrixAll(x,y)>maxValue
            if perRedo(x,y)<0.5
                IPmatrixAll(x,y)=minValue;
            elseif perRedo(x,y)>0.5
                IPmatrixAll(x,y)=maxValue;
            end
        end
    end
end


%% find outliers in COGED
%first remove participants for which IPs across set size had to be changed because they were not estimated
IPAc=[subNr' IPmatrixAll(:,1:2)]; %corrected IPs
noIPRows=setdiff(IPAc,[subNr' IPI' IPU'],'rows'); %compare with original IPs
IPAcNoIP=setdiff(IPAc,noIPRows,'rows');

%find outliers based on standard deviation
[outliers]=findOutliers( IPAcNoIP);
outliers=[outliers;noIPRows(:,1)];

%% plots
if doPlots
    
    figure;
    hold all
    plot(aI(:,1),msaI,'m')
    scatter(aI(:,1),aI,'m','jitter','on')
    
    plot(aU(:,1),msaU,'g')
    ylabel('Probability of accepting No Redo');
    xlabel('Offer for No Redo');
    ylim([0 1])
    xlim([minValue maxValue])
    plot(lineX,lineY,'--k')
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'m');
    h(2) = plot(NaN,NaN,'g');
    legend(h, 'Ignore','Update');
    hold off
    
end

if saveD
    
    filename=fullfile(io.resultsDir,'IPmatrix.csv');
    filenameTask=fullfile(io.resultsDir,'IPtask.csv');
    names={'subNo' 'I' 'U' 'I1' 'I2' 'I3' 'I4' 'U1' 'U2' 'U3' 'U4' };
    namesTask={'subNo' 'SVtask'};
    
    IPfin=[subNr' IPmatrixAll];
    IPtaskFin=[subNr' IPtask'];
    
    writetable(cell2table([num2cell(names);num2cell(IPfin)]),filename,'writevariablenames',0)
    writetable(cell2table([num2cell(namesTask);num2cell(IPtaskFin) ]),filenameTask,'writevariablenames',0)
    
    if ~isempty(outliers)
        
        filenameOut=fullfile(io.resultsDir,'IPmatrixOut.csv');
        filenameTaskOut=fullfile(io.resultsDir,'IPtaskOut.csv');
        
        
        writetable(cell2table([num2cell(names);num2cell(IPfin(~(ismember(subNr,outliers)),:)) ]),filenameOut,'writevariablenames',0)
        writetable(cell2table([num2cell(namesTask);num2cell(IPtaskFin(~(ismember(subNr,outliers)), :)) ]),filenameTaskOut,'writevariablenames',0)
        
    end
end
end %function
