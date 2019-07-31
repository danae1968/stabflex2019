function [statmatDev,statmatRT,statmatSZ]=performanceCW(data,varargin)


% Type 0 = ignore (distractoer resistance working memory trials); Type 2 = update (flexible updating working memory trials)
% sz = set size: 1-4 items to be remembered


% projectDir='P:\3017048.04';
% analysisDir=fullfile(projectDir,'code','Colorwheel');
% resultsDir=fullfile(projectDir,'results','Colorwheel');

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

%dataName=sprintf('performanceRBeh%d',max(subNr));

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
    Ignore(loup)=nanmean(dev(subNo==i & cond==0));
    Update(loup)=nanmean(dev(subNo==i & cond==2));
    
 
   % absolute lure deviance (degrees from lure color)
    IgnoreL(loup)=nanmean(lure(subNo==i & cond==0));
    UpdateL(loup)=nanmean(lure(subNo==i & cond==2));

   % absolute deviance per set size       
    sz1(loup)=nanmean(dev(subNo==i &  sz==1)); 
    sz2(loup)=nanmean(dev(subNo==i &  sz==2));
    sz3(loup)=nanmean(dev(subNo==i &  sz==3));
    sz4(loup)=nanmean(dev(subNo==i &  sz==4));

    % absolute lure deviance per set size       

    sz1L(loup)=nanmean(lure(subNo==i &  sz==1));
    sz2L(loup)=nanmean(lure(subNo==i &  sz==2));
    sz3L(loup)=nanmean(lure(subNo==i &  sz==3));
    sz4L(loup)=nanmean(lure(subNo==i &  sz==4));  
    
    %absolute deviance per cell
    I1(loup)=nanmean(dev(subNo==i & cond==0 & sz==1)); 
    I2(loup)=nanmean(dev(subNo==i & cond==0 & sz==2));
    I3(loup)=nanmean(dev(subNo==i & cond==0 & sz==3));
    I4(loup)=nanmean(dev(subNo==i & cond==0 & sz==4));
    
    U1(loup)=nanmean(dev(subNo==i & cond==2 & sz==1));
    U2(loup)=nanmean(dev(subNo==i & cond==2 & sz==2));
    U3(loup)=nanmean(dev(subNo==i & cond==2 & sz==3));
    U4(loup)=nanmean(dev(subNo==i & cond==2 & sz==4));
   
    %absolute lure deviance per cell
    I1L(loup)=nanmean(lure(subNo==i & cond==0 & sz==1)); %Ignore per cell, lure; calculating median while ignoring NaN values
    I2L(loup)=nanmean(lure(subNo==i & cond==0 & sz==2));
    I3L(loup)=nanmean(lure(subNo==i & cond==0 & sz==3));
    I4L(loup)=nanmean(lure(subNo==i & cond==0 & sz==4));
    
    U1L(loup)=nanmean(lure(subNo==i & cond==2 & sz==1));
    U2L(loup)=nanmean(lure(subNo==i & cond==2 & sz==2));
    U3L(loup)=nanmean(lure(subNo==i & cond==2 & sz==3));
    U4L(loup)=nanmean(lure(subNo==i & cond==2 & sz==4));  
       
    %Reaction times, per condition and cell
    IgnoreRT(loup)=nanmean(rt(subNo==i & cond==0));
    UpdateRT(loup)=nanmean(rt(subNo==i & cond==2));
    
    I1RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==1));
    I2RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==2));
    I3RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==3));
    I4RT(loup)=nanmean(rt(subNo==i & cond==0 & sz==4));
    
    
    U1RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==1));
    U2RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==2));
    U3RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==3));
    U4RT(loup)=nanmean(rt(subNo==i & cond==2 & sz==4));
    
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
          devianceOut=deviance(subNr~=outliers,:);
     RTsOut=RTs(subNr~=outliers,:);    
     writetable(cell2table([names;num2cell(devianceOut) ]),devNameOut,'writevariablenames',0)
     writetable(cell2table([names;num2cell(RTsOut)]),rtNameOut,'writevariablenames',0)
     end
end




