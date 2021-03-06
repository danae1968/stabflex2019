if isunix   
projectDir = '/project/3017048.04';
elseif ispc
    projectDir = 'P:\3017048.04';
end

mod=load(fullfile(projectDir,'stabflex2019','results','Pooled','modelsCompCondOut.mat'));
params=readtable(fullfile(projectDir,'stabflex2019','results','Pooled','discParamsCond.csv'));
saveDir=fullfile(projectDir,'stabflex2019','results','Pooled','simulations','simulatedData.mat');
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
dataSim=[];
numSims=1000;

simSub=1;%simulated subject number
for N=1:numSims
for subNo=sub'
    for condition=cond
randomTrial = hardTrial(randperm(size(hardTrial, 1)), :);
trialData=randomTrial(randomTrial(:,1)==condition,:);
 effort=trialData(:,2); rewardEasy=trialData(:,3);

switch condition
    case 0
        discount=discountI(sub==subNo);
        beta=betaI(sub==subNo);
    case 2
           discount=discountU(sub==subNo);
        beta=betaU(sub==subNo);    
end

rewardHard=hardOffer*ones(length(rewardEasy),1);
val = rewardHard ./ ( 1 +(discount .* effort));
base=rewardEasy;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
%simulate choices based on probabilities
choices=nan(length(prob),1);
for i=1:length(prob)
choices(i)=randsample(choiceOptions,1,true,[prob(i) 1-prob(i)]);
end

simSubNo=repmat(simSub,length(prob),1);
dataSim=[dataSim;[simSubNo trialData choices]];
    end
    simSub=simSub+1;
end
end

save(saveDir,'dataSim')
time=toc

saveDir=fullfile(projectDir,'stabflex2019','results','Pooled','simulations','simulatedData.mat');

io.resultsDir=fullfile(projectDir,'stabflex2019','results','Pooled','simulations');
io.saveD=1;
io.doPlots=0;
io.subNo=1:[Nsubs*numSims];
[perRedo]=PercentageEasy(dataSim,io,1);
time2=toc
[ipmat]=regressionCOGED(dataSim,perRedo,io);
time3=toc