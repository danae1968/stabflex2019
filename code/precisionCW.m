function [precision,bias]=precisionCW(varargin)

clear all
saveD=1;
experiment=2; 
typeT=1; % typeT: precision comparing to target or lure color, 1 for target 2 for lure
switch experiment  % original study=1, replication=2
    case 1
         projectDir='M:\.matlab\GitHub\backup\QuantifyingCC';
        lost=4:7;
        subNr=[1:32];subNr(lost)=[] ;
        resultsDir=fullfile(projectDir,'results','Colorwheel',sprintf('N%d',max(subNr)));

    case 2
        subNr=1:62;
projectDir='P:\3017048.04';
resultsDir=fullfile(projectDir,'results','Colorwheel',sprintf('N%d',max(subNr)));
end 

analysisDir=fullfile(projectDir,'code','Colorwheel','jv10');addpath(analysisDir)
% 
% switch nargin
%     case 1
%         saveD=varargin{1};
%         %[data]=load(fullfile(resultsDir,dataName));
%     case 2
%         saveD=varargin{1};
%         subNr=varargin{2};
%         %[data]=load(fullfile(resultsDir,dataName));
%     case 3
%         saveD=varargin{1};
%         subNr=varargin{2};
%         [data]=varargin{3};
%     case 4
%         saveD=varargin{1};
%         subNr=varargin{2};
%         [data]=varargin{3};
%         io=varargin{4};
%             case 5
%         saveD=varargin{1};
%         subNr=varargin{2};
%         [data]=varargin{3};
%         io=varargin{4};
% end

dataName=sprintf('performanceRBeh%d.csv',max(subNr));

[dataNan]=load(fullfile(resultsDir,dataName)); 
data=dataNan(~isnan(dataNan(:,2)),:);
subNo=data(:,1);dev=data(:,2);rt=data(:,3);sz=data(:,4);cond=data(:,5);lure=data(:,7);degreesCorrect=data(:,8); degreesClick=data(:,9);degreesLure=data(:,10);
 

if typeT==2 
    degreesCorrect=degreesLure;
end

loup=1;
for i=subNr
%convert to -pie pie, X is click, T is target 

X1=wrap(degtorad(degreesClick(subNo==i & sz==1))) ;
X2=wrap(degtorad(degreesClick(subNo==i & sz==2))) ;
X3=wrap(degtorad(degreesClick(subNo==i & sz==3))) ;
X4=wrap(degtorad(degreesClick(subNo==i & sz==4))) ;

XI1=wrap(degtorad(degreesClick(subNo==i & cond==0 & sz==1))) ;
XI2=wrap(degtorad(degreesClick(subNo==i & cond==0 & sz==2)) );
XI3=wrap(degtorad(degreesClick(subNo==i & cond==0 & sz==3))) ;
XI4=wrap(degtorad(degreesClick(subNo==i & cond==0 & sz==4))) ;
XI=wrap(degtorad(degreesClick(subNo==i & cond==0))) ;


XU1=wrap(degtorad(degreesClick(subNo==i & cond==2 & sz==1)) );
XU2=wrap(degtorad(degreesClick(subNo==i & cond==2 & sz==2))) ;
XU3=wrap(degtorad(degreesClick(subNo==i & cond==2 & sz==3))) ;
XU4=wrap(degtorad(degreesClick(subNo==i & cond==2 & sz==4))) ;
XU=wrap(degtorad(degreesClick(subNo==i & cond==2))) ;

T1=wrap(degtorad(degreesCorrect(subNo==i &  sz==1))) ;
T2=wrap(degtorad(degreesCorrect(subNo==i &  sz==2))) ;
T3=wrap(degtorad(degreesCorrect(subNo==i &  sz==3))) ;
T4=wrap(degtorad(degreesCorrect(subNo==i &  sz==4))) ;


TI1=wrap(degtorad(degreesCorrect(subNo==i & cond==0 & sz==1))) ;
TI2=wrap(degtorad(degreesCorrect(subNo==i & cond==0 & sz==2))) ;
TI3=wrap(degtorad(degreesCorrect(subNo==i & cond==0 & sz==3)) );
TI4=wrap(degtorad(degreesCorrect(subNo==i & cond==0 & sz==4)) );
TI=wrap(degtorad(degreesCorrect(subNo==i & cond==0)) );


TU1=wrap(degtorad(degreesCorrect(subNo==i & cond==2 & sz==1)) );
TU2=wrap(degtorad(degreesCorrect(subNo==i & cond==2 & sz==2)) );
TU3=wrap(degtorad(degreesCorrect(subNo==i & cond==2 & sz==3)) );
TU4=wrap(degtorad(degreesCorrect(subNo==i & cond==2 & sz==4)) );
TU=wrap(degtorad(degreesCorrect(subNo==i & cond==2)) );

% precision and bias
[PI1(loup) biasI1(loup)]=JV10_error(XI1,TI1);
[PI2(loup) biasI2(loup)]=JV10_error(XI2,TI2);
[PI3(loup) biasI3(loup)]=JV10_error(XI3,TI3);
[PI4(loup) biasI4(loup)]=JV10_error(XI4,TI4);

[P1(loup) bias1(loup) ]=JV10_error(X1,T1);
[P2(loup) bias2(loup) ]=JV10_error(X2,T2);
[P3(loup) bias3(loup) ]=JV10_error(X3,T3);
[P4(loup) bias4(loup) ]=JV10_error(X4,T4);


[PU1(loup) biasU1(loup)]=JV10_error(XU1,TU1);
[PU2(loup) biasU2(loup)]=JV10_error(XU2,TU2);
[PU3(loup) biasU3(loup)]=JV10_error(XU3,TU3);
[PU4(loup) biasU4(loup)]=JV10_error(XU4,TU4);

[PU(loup) biasU(loup)]=JV10_error(XU,TU);
[PI(loup) biasI(loup)]=JV10_error(XI,TI);

loup=loup+1;
end
 

precision=[PI' PU' PI1' PI2' PI3' PI4' PU1' PU2' PU3' PU4'];
bias=[biasI' biasU' biasI1' biasI2' biasI3' biasI4' biasU1' biasU2' biasU3' biasU4'];
% error=[errorI' errorU' error1' error2' error3' error4'];

if saveD
names={'subNo' 'I' 'U' 'I1' 'I2' 'I3' 'I4' 'U1' 'U2' 'U3' 'U4'};
namesE={'subNo' 'I' 'U' 'E1' 'E2' 'E3' 'E4'};
if typeT==1
precisionName=fullfile(resultsDir,sprintf('precisionUncor%d.xlsx',max(subNr)));
elseif typeT==2
precisionName=fullfile(resultsDir,sprintf('precisionLureUncor%d.xlsx',max(subNr)));
end    
    xlswrite(precisionName,names,1,'A1')
    xlswrite(precisionName,[subNr' precision],1,'A2')
      xlswrite(precisionName,names,2,'A1')
    xlswrite(precisionName,[subNr' bias],2,'A2')


end

end