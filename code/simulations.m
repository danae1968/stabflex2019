function dataSim = simulations(io)

filename=fullfile(fileparts(io.resultsDir),'modelsCompNorm.mat');
load(filename,'model_results');


saveDir=fullfile(io.resultsDir,'simulatedDataN.mat');

tic
%% extract parameters from all models
for n=1:length(io.modNames)
    useMod=io.modNames{n};
    for sub=1:length(model_results.params)
        if any(strcmp(useMod,model_results.model_names))
            discountTask(sub).(useMod) = [model_results.params{sub,find(strcmp(model_results.model_names,useMod)),1}(1)]; %discounting factor kappa is the first parameter in matrix
            discountI(sub).(useMod) = [model_results.params{sub,find(strcmp(model_results.model_names,useMod)),2}(1)];
            discountU(sub).(useMod) = [model_results.params{sub,find(strcmp(model_results.model_names,useMod)),3}(1)];
            
            betaTask(sub).(useMod) = model_results.params{sub,find(strcmp(model_results.model_names,useMod)),1}(2); %inverse temperature beta is the second parameter
            betaI(sub).(useMod) = model_results.params{sub,find(strcmp(model_results.model_names,useMod)),2}(2);
            betaU(sub).(useMod) = model_results.params{sub,find(strcmp(model_results.model_names,useMod)),3}(2);
        end
    end
end
%% retrieve task design
mod= load(filename,'rewardEasy','effort','rewardHard','dataN'); %load parameters from modelling

%experiment parameters
setSize=unique(mod.effort); %number of squares
easyOffers=unique(mod.rewardEasy); %offers for easy (no effort)
hardOffer=unique(mod.rewardHard);
numReps=3; %repetitions of each pair of offers
cond=[0 2]; %conditions(ignore update)
nTrials=length(cond)*numReps*length(easyOffers)*length(setSize);
Nsubs=length(discountTask);
choiceOptions=[0 1];

hardTrial=mod.dataN(mod.dataN(:,1)==101, 2:4); %pick trial set up from any subject (101)
% hardTrial(:,2)= hardTrial(:,2)/max(hardTrial(:,2)); %normalize effort and reward
% hardTrial(:,3)= hardTrial(:,2)/max(hardTrial(:,3));

%% run Simulations
dataSim=struct;

simSub=1;%simulated subject number
for n=1:length(io.modNames)
    useMod=io.modNames{n};
    if any(strcmp(useMod,model_results.model_names))
        dataSim.(useMod)=[];
        for N=1:io.numSims
            for subInd=1:Nsubs
                for condition=cond
                    randomTrial = hardTrial(randperm(size(hardTrial, 1)), :);
                    trialData=randomTrial(randomTrial(:,1)==condition,:);
                    effort=trialData(:,2)/max(trialData(:,2)); rewardEasy=trialData(:,3)/max(trialData(:,3)); %normalize model inputs
                    % find separate discounting factor per condition
                    switch condition
                        case 0
                            discount=discountI(subInd).(useMod);
                            beta=betaI(subInd).(useMod);
                        case 2
                            discount=discountU(subInd).(useMod);
                            beta=betaU(subInd).(useMod);
                    end
                    
                    rewardHard=hardOffer*ones(length(rewardEasy),1);
                    switch useMod
                        case 'hyperbolic'
                            val = rewardHard ./ ( 1 +(discount .* effort));
                        case 'linear'
                            val =   rewardHard - (discount .* effort);
                            
                        case 'parabolic'
                            val = rewardHard - (discount .* effort.^2);
                            
                        case 'exponential'
                            val =   rewardHard .*exp(-discount .* effort);
                            
                    end
                    base=rewardEasy;
                    prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
                    %simulate choices based on probabilities
                    choices=nan(length(prob),1);
                    for i=1:length(prob)
                        choices(i)=randsample(choiceOptions,1,true,[prob(i) 1-prob(i)]);
                    end
                    
                    simSubNo=repmat(simSub,length(prob),1);
                    dataSim.(useMod)=[dataSim.(useMod);[simSubNo trialData choices]];
                end
                simSub=simSub+1;
            end
        end
    end
end

    save(saveDir,'dataSim')
    timeSimulations=toc
    %% analyze simulated data and perform parameter recovery
    %saveDir=fullfile(projectDir,'stabflex2019','results','Pooled','simulations','simulatedData.mat');
    %io.resultsDir=fullfile(projectDir,'stabflex2019','results','Pooled','simulations');
    %io.saveD=1;
    io.doPlots=0;
    io.subNo=1:[Nsubs*io.numSims];
    for n=1:length(io.modNames)
        useMod=io.modNames{n};
        if any(strcmp(useMod,model_results.model_names))
            io.resultsDir = fullfile(io.dataDir,'simulations',useMod);
            io.condNames = {'across', 'ignore','update'}; %perform modelling for each condition or across
            if ~exist(io.resultsDir,'dir')
                mkdir(io.resultsDir)
            end
            io.data = dataSim.(useMod); 
            io.subNr = unique(dataSim.(useMod)(:,1)); 
            [perRedo]=PercentageEasy(io.data,io,1);
            [ipmat]=regressionCOGED(io.data,perRedo,io);
            timeAnalysis.(useMod)=toc
            modelscriptTrevor(io)
            timeParameterRecovery.(useMod)=toc
        end
    end
    
end
