function model_results = modelscriptTrevor(io)

% data2=csvread('P:\3017048.04\stabflex2019\results\Experiment2\COGED\choicesRNR.csv');
% data1=csvread('P:\3017048.04\stabflex2019\results\Experiment1\COGED\choicesRNR.csv');
% noOutliers=xlsread('P:\3017048.04\stabflex2019\results\Pooled\correlationsIPsPooled.csv','A2:A75');

% filenameAc='P:\3017048.04\stabflex2019\results\Pooled\modelsComp.mat';
% filenameCond='P:\3017048.04\stabflex2019\results\Pooled\modelsCompCondFin.mat';
filenameCond= fullfile( io.resultsDir,'modelsCompNorm.mat');
%
% %ensure different subNo for the two experiments
% data1(:,1)=data1(:,1)+100;
% data=[data1 ;data2];

% remove NaN trials (no response)
dataN= io.data(~isnan(io.data(:,5)),:);
subNo=dataN(:,1);cond=dataN(:,2);sz=dataN(:,3);offer=dataN(:,4);choice=1-dataN(:,5);

num_subs = length(unique(subNo));  % Number of subjects

models = { % Models to apply
    @(p, reward, rewardH, effort, chosen) prob_para(p, reward, rewardH, effort, chosen);%2
    @(p, reward, rewardH, effort, chosen) prob_hyp(p, reward,rewardH, effort, chosen);%3
    @(p, reward, rewardH, effort, chosen) prob_lin(p, reward,rewardH, effort, chosen);%1
    @(p, reward, rewardH, effort, chosen) prob_exp(p, reward, rewardH, effort, chosen);%4
    };

model_names = {'parabolic', 'hyperbolic','linear', 'exponential'};  % Model names
model_params = [2 2 2 2];  % Number of parameters for each model

aic = nan(num_subs, length(models));
bic = nan(num_subs, length(models));

iter=1;
loop=1;

for condition= io.condNames
    
    for sub=io.subNr'%unique(subNo)'  % For each subject  sub =noOutliers'
        switch cell2mat(condition)
            case 'across'
                effort = sz(subNo == sub)/ max(sz); % Effort
                rewardEasy = offer(subNo == sub)/max(offer); % Reward for easy offer
                chosen = choice(subNo == sub); % Choice
            case 'ignore'
                effort = sz(subNo == sub & cond==0)/ max(sz); % Effort ignore
                rewardEasy = offer(subNo == sub & cond==0)/max(offer); % Reward for easy offer
                chosen = choice(subNo == sub & cond==0); % Choice
            case 'update'
                effort = sz(subNo == sub & cond==2)/ max(sz); % Effort update
                rewardEasy = offer(subNo == sub & cond==2)/max(offer); % Reward for easy offer
                chosen = choice(subNo == sub & cond==2); % Choice
        end
        rewardHard=2*ones(length(rewardEasy),1)/max(offer); %reward for hard offer was always 2 for us

        for modNum = 1:length(models)  % For each model
            pfunc = (models{modNum});
            %eps: minimum Z matlab can recognize in which Z+1=1
            neg_likelihood_func = @(p) -sum(log(eps+pfunc(p,rewardEasy,rewardHard,effort,chosen))) ;
            p{modNum}=[]; nll(modNum)=inf;
            
            for k = 1:20 % Randomise starting values
                startp(1) = rand;
                startp(2) = rand;
                
                constrained_nll = @(p) neg_likelihood_func(p) + (p(1)<0)*realmax + (p(2)<0)*realmax ; %if negative max, if positive 0
                %fminsearch: nonlinear programming solver. Searches for the minimum of a problem specified by
                %pk: local minimum p (parameter), nllk: y=fun(x), where x=p/likelihood
                [pk, nllk] = fminsearch( constrained_nll, startp, optimset('MaxFunEvals',100000,'MaxIter',100000) );  % Find the optimal parameters
                if nllk<nll(modNum)  % Is this better than previous estimates?
                    nll(modNum)=nllk; p{modNum}=pk; % If so, update the 'best' estimate
                end
                model_results.all_nll(iter,modNum,k,loop) = nllk;
                model_results.all_p{iter,modNum,k,loop}  = pk;
            end
            
            % For each model, store probabilities of each trial
            model_results.prob{iter,modNum,loop} =   pfunc(p{modNum},rewardEasy,rewardHard, effort, chosen);
            aic(modNum) = (2*model_params(modNum)) - (2*-nll(modNum));
            % original: bic(j) = log(length(chosen)) * model_params(j)) - (2*-nll(j);
            % formulas: aic=?2(logL)+2(numParam) ;bic=?2(logL)+numParam?log(numObs)
            bic(modNum) = log(length(chosen)) * model_params(modNum) - (2*-nll(modNum));
            model_results.aic(iter,modNum,loop) = aic(modNum);  % AIC
            model_results.bic(iter,modNum,loop) = bic(modNum);  % BIC
            model_results.likelihood(iter,modNum,loop) = nll(modNum); % Likelihood
            model_results.params{iter,modNum,loop} = p{modNum}; % Parameters
            
        end % Next model
        iter=iter+1;
%         sub
    end
    loop=loop+1;
    iter=1;
end
model_results.models          = models;
model_results.model_names     = model_names;
model_results.model_params    = model_params;
model_results.model_condNames = io.condNames;
save(filenameCond);

%% For all these discounting functions:
% p(1) = discount parameter
% p(2) = softmax beta

function [prob, val] = prob_lin(p,rewardEasy,rewardHard,effort,chosen)
discount = p(1);
beta = p(2);
val =   rewardHard - (discount .* effort);
% base =  1 - discount; %money for doing nothing
base=rewardEasy;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

function [prob, val] = prob_para(p,rewardEasy,rewardHard,effort,chosen)
discount = p(1);
beta = p(2);
val = rewardHard - (discount .* effort.^2);
% base = 1 - discount;
base=rewardEasy;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);


function [prob, val] = prob_hyp(p,rewardEasy,rewardHard,effort,chosen)
discount = p(1);
beta = p(2);
val = rewardHard ./ ( 1 +(discount .* effort));
% base = 1 ./ (1 + discount);
base=rewardEasy;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);


function [prob, val] = prob_exp(p,rewardEasy,rewardHard,effort,chosen)
discount = p(1);
beta = p(2);
val =   rewardHard .*exp(-discount .* effort);
% base =  1 - discount;
base=rewardEasy;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);
return

