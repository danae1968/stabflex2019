% wrapper script for analyses of paper titled: "Quantifying the cost of
% cognitive stability and flexibility". Functions called:
% colorTestAnalysis.m, performanceTrialWise.m, performanceCW.m,
% choicesTrialWise.m, PercentageEasy.m, regressionCOGED.m,
% DirectComparisonAnalysis.m

clear all
io=struct();

% here add directory in which files were saved
if isunix   
io.projectDir = '/project/3017048.04';
elseif ispc
    io.projectDir = 'M:\project\colorwheel\stabflex2019';
end

% enter 1 for analysing original experiment 1 and 2 for replication
% experiment 2
io.experiment=1;

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
todo. Colortest = 0; % color sensitivity test
todo. Colorwheel = 0; % colorwheel working memory task performance
todo. ChoiceNR = 0; % choices task vs no effort
todo. ChoiceD = 0; % direct comparison choices (ignore vs update)
todo. modeling = 0; % modeling of the discounting curve 
todo. simulations = 1; 

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Modeling the discounting curve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if todo.modeling
     fprintf(1,[repmat('-',1,72),'\n'])
    fprintf(1,'Running ''Discount curve modeling'' \n')
    
io.data2=csvread(fullfile(io.projectDir,'results', 'Experiment2', 'COGED' ,'choicesRNR.csv')); %experiment 2 data
io.data1=csvread(fullfile(io.projectDir,'results' ,'Experiment1','COGED' ,'choicesRNR.csv')); %experiment 1 data
io.resultsDir=fullfile(io.projectDir,'results', 'Pooled');
io.subNr=xlsread(fullfile(io.resultsDir,'correlationsIPsPooled.csv'),'A2:A75'); %retrieve only included subNo from both studies

%ensure different subNo for the two experiments
io.data1(:,1)=io.data1(:,1)+100;
io.data=[io.data1 ;io.data2];
io.condNum = 2; %number of conditions: 2 if separate for ignore/update, 1 if modelling is ran across conditions
io.condNames = {'across', 'ignore','update'}; %perform modelling for each condition or across
model_results = modelscriptTrevor(io);
modelingAnal(io, model_results)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if todo.simulations
     fprintf(1,[repmat('-',1,72),'\n'])
    fprintf(1,'Running ''Simulations for discount curve modeling'' \n')

io.dataDir=fullfile(io.projectDir,'results','Pooled');
io.resultsDir=fullfile(io.dataDir,'simulations');
io.numSims = 1; %number of simulations
io.modNames = {'parabolic','linear','hyperbolic','exponential'};
%run simulations
dataSimulated = simulations(io);
end