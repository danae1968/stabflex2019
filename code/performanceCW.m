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




