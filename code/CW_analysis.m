% wrapper script for analyses of paper titled: "Quantifying the cost of
% cognitive stability and flexibility". Functions called:
% colorTestAnalysis.m, performanceTrialWise.m, performanceCW.m,
% choicesTrialWise.m, PercentageEasy.m, regressionCOGED.m,
% DirectComparisonAnalysis.m

clear all
io=struct();

% here add directory in which files were saved
io.projectDir='P:\3017048.04\stabflex2019';

% enter 1 for analysing original experiment 1 and 2 for replication
% experiment 2
io.experiment=2;

if io.experiment==1
    io.lost=4:7; %lost data files
    io.subNo=[1:32];io.subNo(io.lost)=[] ;
else
    io.subNo=[1:62] ;
end

io.analysisDir=fullfile(io.projectDir,'code');
addpath(io.analysisDir)

io.saveD=1; %save output files
io.doPlots=1; %do plots

%Which tasks to analyse
todo.Colortest=0; % color sensitivity test
todo.Colorwheel=1; % colorwheel working memory task performance
todo.ChoiceNR=0; % choices task vs no effort
todo.ChoiceD=0; % direct comparison choices (ignore vs update)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Color sensitivity test performance analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if todo.Colortest
    fprintf(1,[repmat('-',1,72),'\n'])
    fprintf(1,'Running ''Analyzing performance in color sensitivity task'' \n')
    io.dataDir=fullfile(io.projectDir,'data',sprintf('Experiment%d',io.experiment),'Colorwheel');
    io.resultsDir=fullfile(io.projectDir,'results',sprintf('Experiment%d',io.experiment),'Colorwheel');
    if ~exist(io.resultsDir,'dir')
        mkdir(io.resultsDir)
    end
    [colorTestMean, colorTestMed]=colorTestAnalysis(io);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Colorwheel performance analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if todo.Colorwheel
    fprintf(1,[repmat('-',1,72),'\n'])
    fprintf(1,'Running ''Analyzing deviance and RTs of Colorwheel working memory task'' \n')
    
    io.dataDir=fullfile(io.projectDir,'data',sprintf('Experiment%d',io.experiment),'Colorwheel');
    io.resultsDir=fullfile(io.projectDir,'results',sprintf('Experiment%d',io.experiment),'Colorwheel');
    
    if ~exist(io.resultsDir,'dir')
        mkdir(io.resultsDir)
    end
    
    [trialData]=performanceTrialWise(io,1);
    [statmatAcc,statmatRT,statmatSZ]=performanceCW(trialData,io);
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Choices task vs No Redo analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if todo.ChoiceNR
    fprintf(1,[repmat('-',1,72),'\n'])
    fprintf(1,'Running ''Analyzing Indifference Points for No Redo (task vs no effort) choices'' \n')

    io.dataDir=fullfile(io.projectDir,'data',sprintf('Experiment%d',io.experiment),'COGED');
    io.resultsDir=fullfile(io.projectDir,'results',sprintf('Experiment%d',io.experiment),'COGED');
    
    if ~exist(io.resultsDir,'dir')
        mkdir(io.resultsDir)
    end
    
    [choicesNR]=choicesTrialWise(io,1);
    [perRedo]=PercentageEasy(choicesNR,io,1);
    [IPmatrixNR]=regressionCOGED(choicesNR,perRedo,io);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Choices Ignore vs Update analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if todo.ChoiceD
    fprintf(1,[repmat('-',1,72),'\n'])
    fprintf(1,'Running ''Analyzing Indifference Points for Direct Comparison choices'' \n')
    
    io.dataDir=fullfile(io.projectDir,'data',sprintf('Experiment%d',io.experiment),'COGED');    
    io.resultsDir=fullfile(io.projectDir,'results',sprintf('Experiment%d',io.experiment),'COGED');
    
    if ~exist(io.resultsDir,'dir')
        mkdir(io.resultsDir)
    end
    
    [choicesDir]=choicesTrialWise(io,2);    
    [perIgnore]=PercentageEasy(choicesDir,io,2);
    [IPmatrixD]=DirectComparisonAnalysis(choicesDir,perIgnore,io);
    
    
    
end

