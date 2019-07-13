function [statmatDev,statmatRT,statmatSZ]=performanceCW(varargin)

%[data]=performanceforR(0,0);
% subNo = subject number
% Type 0 = ignore (distractoer resistance working memory trials); Type 2 = update (flexible updating working memory trials)
% sz = set size: 1-4 items to be remembered

subNr=1:22;
saveD=0;
% projectDir='P:\3017048.04';
% analysisDir=fullfile(projectDir,'code','Colorwheel');
% resultsDir=fullfile(projectDir,'results','Colorwheel');

switch nargin
    case 1
        saveD=varargin{1};
        %[data]=load(fullfile(resultsDir,dataName));
    case 2
        saveD=varargin{1};
        subNr=varargin{2};
        %[data]=load(fullfile(resultsDir,dataName));
    case 3
        saveD=varargin{1};
        subNr=varargin{2};
        [data]=varargin{3};
    case 4
        saveD=varargin{1};
        subNr=varargin{2};
        [data]=varargin{3};
        io=varargin{4};
            case 5
        saveD=varargin{1};
        subNr=varargin{2};
        [data]=varargin{3};
        io=varargin{4};
        dataType=varargin{5};
end

dataName=sprintf('performanceRBeh%d',max(subNr));

switch dataType
    case 1
subNo=data(:,1);dev=data(:,2);rt=data(:,3);sz=data(:,4);cond=data(:,5);lure=data(:,7);degreesCorrect=data(:,8); degreesClick=data(:,9); degreesLure=data(:,10); signedDev=data(:,11); %signed, not absolute deviance
    case 2
        subNo=data(:,1);dev=data(:,2);rt=data(:,3);sz=data(:,4);cond=data(:,5);lure=data(:,6);redoCond=data(1,7);
end

loup=1;
for i=subNr
    
    error1(:,loup)=signedDev(subNo==i & sz==1);
    error2(:,loup)=signedDev(subNo==i & sz==2);
    error3(:,loup)=signedDev(subNo==i & sz==3);
    error4(:,loup)=signedDev(subNo==i & sz==4);
    errorI(:,loup)=signedDev(subNo==i & cond==0);
    errorU(:,loup)=signedDev(subNo==i & cond==2);

    errorI1(:,loup)=signedDev(subNo==i & cond==0 & sz==1);
    errorI2(:,loup)=signedDev(subNo==i & cond==0 & sz==2);
    errorI3(:,loup)=signedDev(subNo==i & cond==0 & sz==3);
    errorI4(:,loup)=signedDev(subNo==i & cond==0 & sz==4);

    errorU1(:,loup)=signedDev(subNo==i & cond==2 & sz==1);
    errorU2(:,loup)=signedDev(subNo==i & cond==2 & sz==2);
    errorU3(:,loup)=signedDev(subNo==i & cond==2 & sz==3);
    errorU4(:,loup)=signedDev(subNo==i & cond==2 & sz==4);
    
    Ignore(loup)=nanmean(dev(subNo==i & cond==0));
    Update(loup)=nanmean(dev(subNo==i & cond==2));
    IgnoreRT(loup)=nanmean(rt(subNo==i & cond==0));
    UpdateRT(loup)=nanmean(rt(subNo==i & cond==2));
   
    IgnoreL(loup)=nanmean(lure(subNo==i & cond==0));
    UpdateL(loup)=nanmean(lure(subNo==i & cond==2));

          
    sz1(loup)=nanmean(dev(subNo==i &  sz==1)); % set size 1; calculating median while ignoring NaN values
    sz2(loup)=nanmean(dev(subNo==i &  sz==2));
    sz3(loup)=nanmean(dev(subNo==i &  sz==3));
    sz4(loup)=nanmean(dev(subNo==i &  sz==4));
    
    sz1L(loup)=nanmean(lure(subNo==i &  sz==1)); % set size 1 lure calculating median while ignoring NaN values
    sz2L(loup)=nanmean(lure(subNo==i &  sz==2));
    sz3L(loup)=nanmean(lure(subNo==i &  sz==3));
    sz4L(loup)=nanmean(lure(subNo==i &  sz==4));  
    
    
    I1(loup)=nanmean(dev(subNo==i & cond==0 & sz==1)); %Ignore, set size 1; calculating median while ignoring NaN values
    I2(loup)=nanmean(dev(subNo==i & cond==0 & sz==2));
    I3(loup)=nanmean(dev(subNo==i & cond==0 & sz==3));
    I4(loup)=nanmean(dev(subNo==i & cond==0 & sz==4));
    
    U1(loup)=nanmean(dev(subNo==i & cond==2 & sz==1));
    U2(loup)=nanmean(dev(subNo==i & cond==2 & sz==2));
    U3(loup)=nanmean(dev(subNo==i & cond==2 & sz==3));
    U4(loup)=nanmean(dev(subNo==i & cond==2 & sz==4));
    
    I1RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==1));
    I2RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==2));
    I3RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==3));
    I4RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==4));
    
    
    U1RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==1));
    U2RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==2));
    U3RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==3));
    U4RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==4));
    
    I1L(loup)=nanmean(lure(subNo==i & cond==0 & sz==1)); %Ignore, set size 1, lure; calculating median while ignoring NaN values
    I2L(loup)=nanmean(lure(subNo==i & cond==0 & sz==2));
    I3L(loup)=nanmean(lure(subNo==i & cond==0 & sz==3));
    I4L(loup)=nanmean(lure(subNo==i & cond==0 & sz==4));
    
    U1L(loup)=nanmean(lure(subNo==i & cond==2 & sz==1));
    U2L(loup)=nanmean(lure(subNo==i & cond==2 & sz==2));
    U3L(loup)=nanmean(lure(subNo==i & cond==2 & sz==3));
    U4L(loup)=nanmean(lure(subNo==i & cond==2 & sz==4));   
    
    
%  if typeData==2
%      redo(loup)=redoCond(subNo==1);
%  end  
    loup=loup+1;
end

statmatDev=[I1' I2' I3' I4' U1' U2' U3' U4'];
statmatLure=[I1L' I2L' I3L' I4L' U1L' U2L' U3L' U4L'];
statmatRT=[I1RT' I2RT' I3RT' I4RT' U1RT' U2RT' U3RT' U4RT'];
statmatSZ=[sz1' sz2' sz3' sz4'];
statmatSZLure=[sz1L' sz2L' sz3L' sz4L'];

names={'subNo' 'I1' 'I2' 'I3' 'I4' 'U1' 'U2' 'U3' 'U4'};
namesAc={'subNo' 'Ignore' 'Update'};

devAc=[Ignore' Update'];
lureAc=[IgnoreL' UpdateL'];
rtAc=[IgnoreRT' UpdateRT'];

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
saveas(gcf,'repErrorAllPlots.pdf')


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
saveas(gcf,'repErrorCondPlots.pdf')


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

saveas(gcf,'repErrorPlots.pdf')

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

saveas(gcf,'repErrorCondSZPlots.pdf')

end
   if dataType==2

%% deviance and RTs
con=[0 2];
setsizeNr=1:4;

participant=repmat(io.subNo',length(statmatDev(:))/length(io.subNo),1);
cond=repmat(con,length(statmatDev(:))/length(con),1);cond=cond(:);
setsize=repmat(setsizeNr,length(subNr),length(con));setsize=setsize(:);

devR=[participant statmatDev(:) statmatRT(:) cond setsize session];
%sort performance based on IP format
devS=sortrows(devR,[6 4 5 1]);  

    end
%Save data: the range should change based on number of subjects
if saveD
    devName=fullfile(io.resultsDir,sprintf('MeanAcc%d.xlsx',max(subNr)));
    rtName=fullfile(io.resultsDir,sprintf('MeanRT%d.xlsx',max(subNr)));
%     lureName=fullfile(io.resultsDir,sprintf('LureDev%d.xlsx',max(subNr)));
%     errorName=fullfile(io.resultsDir, sprintf('error%d.csv',max(subNr)));
%     
%     csvwrite(errorName,errorMat)
    xlswrite(devName,names,1,'A1:I1')
    xlswrite(devName,[subNr' statmatDev],1,'A2')
    xlswrite(devName,namesAc,2,'A1:C1')
    xlswrite(devName,[subNr' devAc],2,'A2')
%     xlswrite(lureName,[subNr' statmatLure],1,'A2')
%     xlswrite(lureName,names,1,'A1:I1')
%     xlswrite(lureName,namesAc,2,'A1:C1')
%     xlswrite(lureName,[subNr' lureAc],2,'A2')

    
    xlswrite(rtName,names,1,'A1:I1')
    xlswrite(rtName,[subNr' statmatRT],1,'A2')
    xlswrite(rtName,namesAc,2,'A1:C1')
    xlswrite(rtName,[subNr' rtAc],2,'A2')    
end




