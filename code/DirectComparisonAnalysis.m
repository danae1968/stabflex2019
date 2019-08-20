function [IPmatrixAll]=DirectComparisonAnalysis(data,perIgnore,varargin)
%%% script that extracts indifference points via logistic regression
%%% from the COGED ignore vs update choices. Input: data: trial-wise matrix of
%%% COGED data, derived from choicesTrialWise.m script.
%%% perIgnore: ratio of ignore offers participants accepted
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

% update offers
easyOffer=[0.1 0.2:0.2:4];easyOffer=round(easyOffer*10)/10;
maxValue=max(easyOffer);
minValue=min(easyOffer);

loop=1;
subNo=data(:,1);sz=data(:,3);offer=data(:,4);choice=data(:,5);


for i=subNr
    
    x=offer(subNo==i,:);
    y=choice(subNo==i,:);
    x1=offer(subNo==i & sz==1);
    x2=offer(subNo==i & sz==2);
    x3=offer(subNo==i & sz==3);
    x4=offer(subNo==i & sz==4);
    
    y1=choice(subNo==i & sz==1);
    y2=choice(subNo==i & sz==2);
    y3=choice(subNo==i & sz==3);
    y4=choice(subNo==i & sz==4);
    
    %% Regression analyses
    [yfit,IP(loop),betas(loop,:)]=RegressionAnalysis(x,y,minValue,maxValue);
    [yfit1,IP1(loop),betas1(loop,:)]=RegressionAnalysis(x1,y1,minValue,maxValue);
    [yfit2,IP2(loop),betas2(loop,:)]=RegressionAnalysis(x2,y2,minValue,maxValue);
    [yfit3,IP3(loop),betas3(loop,:)]=RegressionAnalysis(x3,y3,minValue,maxValue);
    [yfit4,IP4(loop),betas4(loop,:)]=RegressionAnalysis(x4,y4,minValue,maxValue);
    
 
    
    %% regression plots
    if doPlots
        
        % horizontal line at y=0.5
        lineX= easyOffer;
        lineY =0.5 * ones(size(lineX));
        
        xx = easyOffer;
        a1=unique([x1,yfit1],'rows');
        a2=unique([x2, yfit2],'rows');
        a3=unique([x3, yfit3],'rows');
        a4=unique([x4, yfit4],'rows');
        
        figure;
        hold all
        plot(a1(:,1),a1(:,2),'m')
        plot(a2(:,1),a2(:,2),'b')
        plot(a3(:,1),a3(:,2),'r')
        plot(a4(:,1),a4(:,2),'g')
        
        plot(lineX,lineY,'c')
        scatter(x1,y1,'m','jitter','on')
        scatter(x2,y2,'b','jitter','on')
        scatter(x3,y3,'r','jitter','on')
        scatter(x4,y4,'g','jitter','on')
        ylabel('Probability of accepting Update');
        xlabel('Offer for Update');
        legend('Set size 1','Set size 2','Set size 3','Set size 4','Threshold','location','southeast')
        title(sprintf('Probability of accepting Update for participant %d',i));
        ylim([0 1])
        xlim([minValue maxValue])
        hold off
        
        
        
        figure;
        
        subplot(2,2,1)
        hold all
        plot(a1(:,1),a1(:,2),'m')
        plot(lineX,lineY,'c')
        scatter(x1,y1,'m','jitter','on')
        ylim([0 1])
        xlim([minValue maxValue])
        title('Set size 1')
        hold off
        
        subplot(2,2,2)
        hold all
        plot(a2(:,1),a2(:,2),'b')
        plot(lineX,lineY,'c')
        scatter(x2,y2,'b','jitter','on')
        title('Set size 2')
        ylim([0 1])
        xlim([minValue maxValue])
        hold off
        
        subplot(2,2,3)
        hold all
        plot(a3(:,1),a3(:,2),'r')
        plot(lineX,lineY,'c')
        title('Set size 3')
        scatter(x3,y3,'r','jitter','on')
        ylim([0 1])
        xlim([minValue maxValue])
        hold off
        
        subplot(2,2,4)
        hold all
        title('Set size 4')
        plot(a4(:,1),a4(:,2),'g')
        plot(lineX,lineY,'c')
        scatter(x4,y4,'g','jitter','on')
        ylim([0 1])
        xlim([minValue maxValue])
        hold off
        suptitle(sprintf('participant %d',i))
    end
    loop=loop+1;
end
%% create matrix
IPmatrixAll=[IP',IP1',IP2',IP3',IP4'];

%% correct for issue in regression when participants chose only one offer and
%replace with minimum or maximum offer based on the ratio easy or hard
%offer they chose extracted from PercentageEasy.m script

for x=1:length(IPmatrixAll)
    for y=1:size(IPmatrixAll,2)
        if IPmatrixAll(x,y)<=0 || IPmatrixAll(x,y)>maxValue
            if perIgnore(x,y)<0.5
                IPmatrixAll(x,y)=minValue;
            elseif perIgnore(x,y)>0.5
                IPmatrixAll(x,y)=maxValue;
            end
        end
    end
end


%% find outliers in COGED
%first remove participants for which IPs across set size had to be changed because they were not estimated
IPAc=[subNr' IPmatrixAll(:,1)];
noIPRows=setdiff(IPAc,[subNr' IP'],'rows');
IPAcNoIP=setdiff(IPAc,noIPRows,'rows');

%find outliers based on standard deviation
[outliers]=findOutliers( IPAcNoIP);
outliers=[outliers;noIPRows(:,1)];

%% save data
if saveD==1
    filename=fullfile(io.resultsDir,'IPDirect.csv');
    
    names={'subNo','IP','IP1','IP2','IP3','IP4' };
    IPfin=[subNr' IPmatrixAll];
    writetable(cell2table([names;num2cell(IPfin)]),filename,'writevariablenames',0)
    
    if ~isempty(outliers)
        
        filenameOut=fullfile(io.resultsDir,'IPDirectOut.csv');
        writetable(cell2table([names;num2cell(IPfin(~(ismember(subNr,outliers)),:)) ]),filenameOut,'writevariablenames',0)
    end
end

end

