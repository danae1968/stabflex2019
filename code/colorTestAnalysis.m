function [aveDev,medDev]=colorTestAnalysis(varargin)
%%% function for the analysis of the color sensitivity data. The task
%%% involves a colored square and a colorwheel, participants have to
%%% identify the color of the square on the color wheel and click with a
%%% mouse. Output variables: aveDev: average deviance (distance in degrees
%%% from correct color) medDev: median deviance. 

performance=[];

% default experiment 1
subNr=1:32; subNr(4:8)=[]; %subject numbers I want to analyze
saveD=1;

switch nargin 
    case 1
        io=varargin{1};
        subNr=io.subNo;
       saveD=io.saveD;
end

if io.experiment==1
    subNr(subNr==8)=[]; % this file was lost 
end

for j=subNr
    %load participant
     load(fullfile(io.dataDir,sprintf('Colorwheel_sub_%d',j),sprintf('ColorTest_s%d.mat',j)))
     
     %respDif: absolute deviance from probed color; rt: reaction time;
     %probeColor: RBG values of color probed
     for x=1:length(colorTestData)
         performance=[performance;j colorTestData(x).respDif colorTestData(x).rt colorTestData(x).probeColor colorTestData(x).colorPosition];
     end
end

aveDev=[];medDev=[];
for i=subNr
    aveDev=[aveDev; mean(performance(performance(:,1)==i,2))];
    medDev=[medDev; median(performance(performance(:,1)==i,2))];
end

aveDevAll=mean(aveDev);
medDevAll=median(medDev);
aveMedDev=mean(medDev);
stdev=std(aveDev);
stdevMed=std(medDev);


if saveD
 filename=fullfile(io.resultsDir,'colorTestDev.csv');
  names={'subNo' 'mean Deviance' 'Median Deviance'};
  writetable(cell2table([names;num2cell([subNr' aveDev, medDev]) ]),filename,'writevariablenames',0)

end