function model_results = modelscriptTrevor




data2=csvread('P:\3017048.04\stabflex2019\results\Experiment2\COGED\choicesRNR.csv');
data1=csvread('P:\3017048.04\stabflex2019\results\Experiment1\COGED\choicesRNR.csv');
noOutliers=xlsread('P:\3017048.04\stabflex2019\results\Pooled\correlationsIPsPooled.csv','A2:A75');
filename='P:\3017048.04\stabflex2019\results\Pooled\modelsComp.mat';
%ensure different subNo for the two experiments
data1(:,1)=data1(:,1)+100;

data=[data1 ;data2];
%remove NaN trials (no response)
dataN= data(~isnan(data(:,5)),:);
subNo=dataN(:,1);cond=dataN(:,2);sz=dataN(:,3);offer=dataN(:,4);choice=dataN(:,5);

num_subs = length(unique(subNo));  % Number of subjects

models = { % Models to apply
    @(p, reward, effort, chosen) prob_lin(p, reward, effort, chosen);%1
    @(p, reward, effort, chosen) prob_para(p, reward, effort, chosen);%2
    @(p, reward, effort, chosen) prob_hyp(p, reward, effort, chosen);%3
    };

model_names = {'linear', 'parabolic', 'hyperbolic'};  % Model names
model_params = [2 2 2];  % Number of parameters for each model

aic = nan(num_subs, length(models));
bic = nan(num_subs, length(models));

iter=1;
for sub =noOutliers'  % For each subject
    
    effort = sz(subNo == sub); % Effort
    reward = offer(subNo == sub); % Reward
    chosen = choice(subNo == sub); % Choice
    
    for modNum = 1:length(models)  % For each model
        pfunc = (models{modNum});
        %eps: minimum Z matlab can recognize in which Z+1=1
        neg_likelihood_func = @(p) -sum(log(eps+pfunc(p,reward,effort,chosen))) ;
        p{modNum}=[]; nll(modNum)=inf;
        
        for k = 1:20 % Randomise starting values
            startp(1) = rand;
            startp(2) = rand;
            constrained_nll = @(p) neg_likelihood_func(p) + (p(1)<0)*realmax + (p(2)<0)*realmax ;
            %fminsearch: nonlinear programming solver. Searches for the minimum of a problem specified by
            [pk, nllk] = fminsearch( constrained_nll, startp, optimset('MaxFunEvals',48000,'MaxIter',48000) );  % Find the optimal parameters
            if nllk<nll(modNum)  % Is this better than previous estimates?
                nll(modNum)=nllk; p{modNum}=pk; % If so, update the 'best' estimate
            end
            model_results.all_nll(iter,modNum,k) = nllk;
            model_results.all_p{iter,modNum,k}  = pk;
        end
        
        % For each model, store probabilities of each trial
        model_results.prob{iter,modNum} =   pfunc(p{modNum},reward, effort, chosen);
        aic(modNum) = (2*model_params(modNum)) - (2*-nll(modNum));
        % original: bic(j) = log(length(chosen)) * model_params(j)) - (2*-nll(j);
        % formulas: aic=?2(logL)+2(numParam) ;bic=?2(logL)+numParam?log(numObs)
        bic(modNum) = log(length(chosen)) * model_params(modNum) - (2*-nll(modNum));
        model_results.aic(iter,modNum) = aic(modNum);  % AIC
        model_results.bic(iter,modNum) = bic(modNum);  % BIC
        model_results.likelihood(iter,modNum) = nll(modNum); % Likelihood
        model_results.params{iter,modNum} = p{modNum}; % Parameters
        
    end % Next model
    iter=iter+1;
end

model_results.models       = models;
model_results.model_names  = model_names;
model_results.model_params = model_params;

save(filename);

%% For all these discounting functions:
% p(1) = discount parameter
% p(2) = softmax beta

function [prob, val] = prob_lin(p,reward,effort,chosen)
discount = p(1);
beta = p(2);
val =   reward - (discount .* effort);
base =  1 - discount;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

function [prob, val] = prob_para(p,reward,effort,chosen)
discount = p(1);
beta = p(2);
val = reward - (discount .* effort.^2);
base = 1 - discount;
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

function [prob, val] = prob_hyp(p,reward,effort,chosen)
discount = p(1);
beta = p(2);
val = reward ./ ( 1 +(discount .* effort));
base = 1 ./ (1 + discount);
prob =  exp(beta.*val)./(exp(beta.*base) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

return
