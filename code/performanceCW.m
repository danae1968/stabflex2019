function [statmatDev,statmatRT,statmatSZ]=performanceCW(data,varargin)
%%% function that generates main derivatives and analysis files for the
%%% colorwheel working memory task. Input: data: trial-wise matrix of
%%% colorwheel performance data, derived from performanceTrialWise.m
%%% script. io: analysis parameters defined in main analysis script.
%%% including directory paths, IDs(subNr) and saveD(save data or not).
%%% dataType: main task analysis 1, 2 for redo data analysis. functions
%%% called: findOutliers.m 

switch nargin
    case 1
        subNr=1:62;
        saveD=0; 
        dataType=1;

    case 2
        io=varargin{1};
        subNr=io.subNo;
        saveD=io.saveD;
        dataType=1;
            case 3
        io=varargin{1};
        subNr=io.subNo;
        saveD=io.saveD;
        dataType=varargin{2};
end

switch dataType %main task or redo
    case 1
subNo=data(:,1);dev=data(:,2);rt=data(:,3);sz=data(:,4);cond=data(:,5);lure=data(:,7);degreesCorrect=data(:,8); degreesClick=data(:,9); degreesLure=data(:,10); signedDev=data(:,11); %signed, not absolute deviance
    case 2
        subNo=data(:,1);dev=data(:,2);rt=data(:,3);sz=data(:,4);cond=data(:,5);lure=data(:,6);redoCond=data(1,7);
end

loup=1;
for i=subNr
    
    %signed deviance per set size
    error1(:,loup)=signedDev(subNo==i & sz==1);
    error2(:,loup)=signedDev(subNo==i & sz==2);
    error3(:,loup)=signedDev(subNo==i & sz==3);
    error4(:,loup)=signedDev(subNo==i & sz==4);
    
    % signed deviance per condition
    errorI(:,loup)=signedDev(subNo==i & cond==0);
    errorU(:,loup)=signedDev(subNo==i & cond==2);

    %signed deviance per cell
    errorI1(:,loup)=signedDev(subNo==i & cond==0 & sz==1);
    errorI2(:,loup)=signedDev(subNo==i & cond==0 & sz==2);
    errorI3(:,loup)=signedDev(subNo==i & cond==0 & sz==3);
    errorI4(:,loup)=signedDev(subNo==i & cond==0 & sz==4);

    errorU1(:,loup)=signedDev(subNo==i & cond==2 & sz==1);
    errorU2(:,loup)=signedDev(subNo==i & cond==2 & sz==2);
    errorU3(:,loup)=signedDev(subNo==i & cond==2 & sz==3);
    errorU4(:,loup)=signedDev(subNo==i & cond==2 & sz==4);
    
    % absolute deviance per condition
    Ignore(loup)=nanmedian(dev(subNo==i & cond==0));
    Update(loup)=nanmedian(dev(subNo==i & cond==2));
    
 
   % absolute lure deviance (degrees from lure color)
    IgnoreL(loup)=nanmedian(lure(subNo==i & cond==0));
    UpdateL(loup)=nanmedian(lure(subNo==i & cond==2));

   % absolute deviance per set size       
    sz1(loup)=nanmedian(dev(subNo==i &  sz==1)); 
    sz2(loup)=nanmedian(dev(subNo==i &  sz==2));
    sz3(loup)=nanmedian(dev(subNo==i &  sz==3));
    sz4(loup)=nanmedian(dev(subNo==i &  sz==4));

    % absolute lure deviance per set size       

    sz1L(loup)=nanmedian(lure(subNo==i &  sz==1));
    sz2L(loup)=nanmedian(lure(subNo==i &  sz==2));
    sz3L(loup)=nanmedian(lure(subNo==i &  sz==3));
    sz4L(loup)=nanmedian(lure(subNo==i &  sz==4));  
    
    %absolute deviance per cell
    I1(loup)=nanmedian(dev(subNo==i & cond==0 & sz==1)); 
    I2(loup)=nanmedian(dev(subNo==i & cond==0 & sz==2));
    I3(loup)=nanmedian(dev(subNo==i & cond==0 & sz==3));
    I4(loup)=nanmedian(dev(subNo==i & cond==0 & sz==4));
    
    U1(loup)=nanmedian(dev(subNo==i & cond==2 & sz==1));
    U2(loup)=nanmedian(dev(subNo==i & cond==2 & sz==2));
    U3(loup)=nanmedian(dev(subNo==i & cond==2 & sz==3));
    U4(loup)=nanmedian(dev(subNo==i & cond==2 & sz==4));
   
    %absolute lure deviance per cell
    I1L(loup)=nanmedian(lure(subNo==i & cond==0 & sz==1)); %Ignore per cell, lure; calculating median while ignoring NaN values
    I2L(loup)=nanmedian(lure(subNo==i & cond==0 & sz==2));
    I3L(loup)=nanmedian(lure(subNo==i & cond==0 & sz==3));
    I4L(loup)=nanmedian(lure(subNo==i & cond==0 & sz==4));
    
    U1L(loup)=nanmedian(lure(subNo==i & cond==2 & sz==1));
    U2L(loup)=nanmedian(lure(subNo==i & cond==2 & sz==2));
    U3L(loup)=nanmedian(lure(subNo==i & cond==2 & sz==3));
    U4L(loup)=nanmedian(lure(subNo==i & cond==2 & sz==4));  
       
    %Reaction times, per condition and cell
    IgnoreRT(loup)=nanmedian(rt(subNo==i & cond==0));
    UpdateRT(loup)=nanmedian(rt(subNo==i & cond==2));
    
    I1RT(loup)=nanmedian(rt(subNo==i & cond==0 & sz==1));
    I2RT(loup)=nanmedian(rt(subNo==i & cond==0 & sz==2));
    I3RT(loup)=nanmedian(rt(subNo==i & cond==0 & sz==3));
    I4RT(loup)=nanmedian(rt(subNo==i & cond==0 & sz==4));
    
    
    U1RT(loup)=nanmedian(rt(subNo==i & cond==2 & sz==1));
    U2RT(loup)=nanmedian(rt(subNo==i & cond==2 & sz==2));
    U3RT(loup)=nanmedian(rt(subNo==i & cond==2 & sz==3));
    U4RT(loup)=nanmedian(rt(subNo==i & cond==2 & sz==4));
    
    loup=loup+1;
end

statmatDev=[I1' I2' I3' I4' U1' U2' U3' U4'];
statmatLure=[I1L' I2L' I3L' I4L' U1L' U2L' U3L' U4L'];
statmatRT=[I1RT' I2RT' I3RT' I4RT' U1RT' U2RT' U3RT' U4RT'];
statmatSZ=[sz1' sz2' sz3' sz4'];
statmatSZLure=[sz1L' sz2L' sz3L' sz4L'];


devAc=[Ignore' Update'];
lureAc=[IgnoreL' UpdateL'];
rtAc=[IgnoreRT' UpdateRT'];


%% find outliers in performance
[outliers]=findOutliers([subNr' devAc rtAc]);


%% plots
%% Errors for histograms
xError=-180:2:180;

[xI]=hist(errorI,xError);
[xU]=hist(errorU,xError);
[x4]=hist(error4,xError);[x3]=hist(error3,xError);[x2]=hist(error2,xError);[x1]=hist(error1,xError);
[xI1]=hist(errorI1,xError);[xI2]=hist(errorI2,xError);[xI3]=hist(errorI3,xError);[xI4]=hist(errorI4,xError);
[xU1]=hist(errorU1,xError);[xU2]=hist(errorU2,xError);[xU3]=hist(errorU3,xError);[xU4]=hist(errorU4,xError);

errorDenAc=[ mean(xI,2)  mean(xU,2)  mean(x1,2)  mean(x2,2)  mean(x3,2) mean(x4,2)]; 
errorStdAc=[ std(xI,0,2)  std(xU,0,2)  std(x1,0,2)  std(x2,0,2)  std(x3,0,2) std(x4,0,2)];
errorSteAc=errorStdAc /( sqrt(size(x1,2)));

errorDen= [mean(xI1,2) mean(xI2,2) mean(xI3,2) mean(xI4,2) mean(xU1,2) mean(xU2,2) mean(xU3,2) mean(xU4,2) ];
errorStd=[ std(xI1,0,2) std(xI2,0,2) std(xI3,0,2) std(xI4,0,2) std(xU1,0,2) std(xU2,0,2) std(xU3,0,2) std(xU4,0,2)];
errorSte=errorStd /( sqrt(size(x1,2)));


if io.doPlots
    

x=xError;

figure; %4 set sizes
y=errorDenAc;
s=errorSteAc;
hold on
plotshaded(x,[y(:,3)-(s(:,3)),y(:,3)+(s(:,3))],'b')
plot(x,[y(:,3)],'b')
plotshaded(x,[y(:,4)-(s(:,4)),y(:,4)+(s(:,4))],'g')
plot(x,[y(:,4)],'g')
plotshaded(x,[y(:,5)-(s(:,5)),y(:,5)+(s(:,5))],'m')
plot(x,[y(:,5)],'m')
plotshaded(x,[y(:,6)-(s(:,6)),y(:,6)+(s(:,6))],'r')
plot(x,[y(:,6)],'r')
ylim([0 3.5]); xlim([-50 50])
hold off
%saveas(gcf,'repErrorAllPlots.pdf')


figure;% 2 conditions
hold on
plotshaded(x,[y(:,1)-(s(:,1)),y(:,1)+(s(:,1))],'g')
plot(x,[y(:,1)],'g')
ylim([0 7]); xlim([-30 30])
title('Ignore')

subplot(2,1,2);
hold on
plotshaded(x,[y(:,2)-s(:,2),y(:,2)+s(:,2)],'m')
plot(x,[y(:,2)],'m')
ylim([0 7]); xlim([-30 30])
title('Update')
hold off
%saveas(gcf,'repErrorCondPlots.pdf')


figure; % all cells in different plots
y=errorDen;
s=errorSte;
subplot(4,2,1);
hold on
plotshaded(x,[y(:,1)-(s(:,1)),y(:,1)+(s(:,1))],'b')
plot(x,[y(:,1)],'b')
ylim([0 2]); xlim([-30 30])
title('Ignore set size 1')
hold off

subplot(4,2,3);
hold on
plotshaded(x,[y(:,2)-s(:,2),y(:,2)+s(:,2)],'g')
plot(x,[y(:,2)],'g')
ylim([0 2]); xlim([-30 30])
title('Ignore Set size 2')

subplot(4,2,5);
hold on
plotshaded(x,[y(:,3)-s(:,3),y(:,3)+s(:,3)],'m')
plot(x,[y(:,3)],'m')
ylim([0 2]); xlim([-30 30])
title('Ignore Set size 3')

hold off
subplot(4,2,7);
hold on
plotshaded(x,[y(:,4)-s(:,4),y(:,4)+s(:,4)],'r')
plot(x,[y(:,4)],'r')
ylim([0 2]); xlim([-30 30])
title('Ignore Set size 4')
hold off

subplot(4,2,2);
hold on
plotshaded(x,[y(:,5)-s(:,5),y(:,5)+s(:,5)],'b')
plot(x,[y(:,5)],'b')
ylim([0 2]); xlim([-30 30])
title('Update Set size 1')
hold off

subplot(4,2,4);
hold on
plotshaded(x,[y(:,6)-s(:,6),y(:,6)+s(:,6)],'g')
plot(x,[y(:,6)],'g')
ylim([0 2]); xlim([-30 30])
title('Update Set size 2')
hold off

subplot(4,2,8);
hold on
plotshaded(x,[y(:,8)-s(:,8),y(:,8)+s(:,8)],'r')
plot(x,[y(:,8)],'r')
ylim([0 2]); xlim([-30 30])
title('Update Set size 4')
hold off

subplot(4,2,6);
hold on
plotshaded(x,[y(:,7)-s(:,7),y(:,7)+s(:,7)],'m')
plot(x,[y(:,7)],'m')
ylim([0 2]); xlim([-30 30])
title('Update Set size 3')
hold off

%saveas(gcf,'repErrorPlots.pdf')

figure; % all cells in different plots
y=errorDen;
s=errorSte;

subplot(2,2,1);
hold on
plotshaded(x,[y(:,1)-(s(:,1)),y(:,1)+(s(:,1))],'b')
plot(x,[y(:,1)],'b')
plotshaded(x,[y(:,5)-s(:,5),y(:,5)+s(:,5)],'m')
plot(x,[y(:,5)],'m')
ylim([0 2]); xlim([-30 30])
title('Set size 1')
hold off

subplot(2,2,2);
hold on
plotshaded(x,[y(:,2)-s(:,2),y(:,2)+s(:,2)],'b')
plot(x,[y(:,2)],'b')
plotshaded(x,[y(:,6)-s(:,6),y(:,6)+s(:,6)],'m')
plot(x,[y(:,6)],'m')
ylim([0 2]); xlim([-30 30])
title('Set size 2')

subplot(2,2,3);
hold on
plotshaded(x,[y(:,3)-s(:,3),y(:,3)+s(:,3)],'b')
plot(x,[y(:,3)],'b')
plotshaded(x,[y(:,7)-s(:,7),y(:,7)+s(:,7)],'m')
plot(x,[y(:,7)],'m')
ylim([0 2]); xlim([-30 30])
title('Set size 3')

hold off
subplot(2,2,4);
hold on
plotshaded(x,[y(:,4)-s(:,4),y(:,4)+s(:,4)],'b')
plot(x,[y(:,4)],'b')
plotshaded(x,[y(:,8)-s(:,8),y(:,8)+s(:,8)],'m')
plot(x,[y(:,8)],'m')
ylim([0 2]); xlim([-30 30])
title('Set size 4')
hold off

%saveas(gcf,'repErrorCondSZPlots.pdf')

end
%% save Data
if saveD
     
    devName=fullfile(io.resultsDir,'MedianAcc.csv');
    rtName=fullfile(io.resultsDir,'MedianRT.csv');   
     names={'subNo' 'Ignore' 'Update' 'I1' 'I2' 'I3' 'I4' 'U1' 'U2' 'U3' 'U4'};

     deviance=[subNr' devAc statmatDev];
     RTs=[subNr' rtAc statmatRT];
   
     writetable(cell2table([names;num2cell(deviance) ]),devName,'writevariablenames',0)
     writetable(cell2table([names;num2cell(RTs)]),rtName,'writevariablenames',0)
     
     if ~isempty(outliers)
           devNameOut=fullfile(io.resultsDir,'MedianAccOut.csv');
    rtNameOut=fullfile(io.resultsDir,'MedianRTOut.csv');  
          devianceOut=deviance(~(ismember(subNr,outliers)),:);
     RTsOut=RTs(~(ismember(subNr,outliers)),:);    
     writetable(cell2table([names;num2cell(devianceOut) ]),devNameOut,'writevariablenames',0)
     writetable(cell2table([names;num2cell(RTsOut)]),rtNameOut,'writevariablenames',0)
     end
end




