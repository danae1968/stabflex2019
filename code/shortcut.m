if isunix   
projectDir = '/project/3017048.04';
elseif ispc
    projectDir = 'P:\3017048.04';
end

load(fullfile(projectDir,'stabflex2019','results','Pooled','simulations','simulatedData.mat'));
mod=load(fullfile(projectDir,'stabflex2019','results','Pooled','modelsCompCondOut.mat'));
params=readtable(fullfile(projectDir,'stabflex2019','results','Pooled','discParamsCond.csv'));
tic
%extracted parameters from hyperbolic model
discountI=params.kappa_I;
discountU=params.kappa_U;
betaI=params.beta_I;
betaU=params.beta_U;
%experiment parameters
sub=params.sub;
setSize=unique(mod.effort); %number of squares
easyOffers=unique(mod.offer); %offers for easy (no effort)
hardOffer=2;
numReps=3; %repetitions of each pair of offers
cond=[0 2]; %conditions(ignore update)
nTrials=length(cond)*numReps*length(easyOffers)*length(setSize);
Nsubs=length(sub);
choiceOptions=[0 1];

hardTrial=mod.data1(mod.data1(:,1)==101, 2:4); %pick trial set up from any subject (101)
numSims=1000;

io.resultsDir=fullfile(projectDir,'stabflex2019','results','Pooled','simulations');
io.saveD=1;
io.doPlots=0;
io.subNo=1:[Nsubs*numSims];
[perRedo]=PercentageEasy(dataSim,io,1);
time2=toc
[ipmat]=regressionCOGED(dataSim,perRedo,io);
time3=toc