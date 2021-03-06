function [F,kapa,ep, o] = practical_VBA_DP()

% design
% -------------------------------------------------------------------------
% Here we describe the stimuli of a simple delay discounting task in which
% participants have to choose between an low reward but immediate option (1
% euro today) and a higher reard but delayed option (eg. 4 euros in 15
% days)
%
% Usually this script provides a moderatly good recovery performance
% (estimation error around 10%) and correct but unconclusive model
% selection. You can try to play around with the prior to see if you can 
% improve a bit the performances (Tip: we do not expect large parameters). 
% You could also try to simulate multiple subjects! 
% Or maybe you should conclude that drawing random stimuli is not a smart
% move and a more carefully devised design would provide better recovery
% preformances. Use your intuition, or brute force via design optimisation.

%add toolbox to path
 addpath(genpath('C:\Users\danpap\Documents\GitHub\VBA-toolbox'))
% Here, we must predict the probability of accepting the delayed option.

% observation function (hyperbolic)
    function g = g_discount_hyp (~, phi, u, ~)
        % subjective value of the easy option
        SV_hard = u(2) ./ (1 + phi * u(3));
        % subjective value of the task option
        SV_easy = u(1);   
        % mapping from the value space to [0 1]
        g = VBA_sigmoid (SV_hard - SV_easy);
    end

% observation function (exponential)
    function g = g_discount_exp (~, phi, u, ~)
        SV_hard = u(2) .* exp (- phi * u(3));
        SV_easy = u(1);   
        g = VBA_sigmoid (SV_hard - SV_easy);
    end

% observation function (parabolic)
    function g = g_discount_para (~, phi, u, ~)
        SV_hard = u(2)-phi*(u(3))^2;
        SV_easy = u(1);   
        g = VBA_sigmoid (SV_hard - SV_easy);
    end


% observation function (linear)
    function g = g_discount_lin (~, phi, u, ~)
        SV_hard = u(2) .* (1 - phi * u(3));
        SV_easy = u(1);   
        g = VBA_sigmoid (SV_hard - SV_easy);
    end

% % observational function (sigmoidal)
% function g = g_discount_sig (~, phi, u, ~)
%         SV_easy = u(1) .* (1 - phi * u(3));
%         SV_hard = u(2);   
%         g = VBA_sigmoid (SV_hard - SV_easy);
%     end
% V = M (1- (1/(1+exp(-k*(C-p)))- 1/(1+exp(k*p))) (1 + 1/exp(k*p)))

data2=csvread('P:\3017048.04\stabflex2019\results\Experiment2\COGED\choicesRNR.csv');
data1=csvread('P:\3017048.04\stabflex2019\results\Experiment1\COGED\choicesRNR.csv');
noOutliers=xlsread('P:\3017048.04\stabflex2019\results\Pooled\correlationsIPsPooled.csv','A2:A75');

%ensure different subNo for the two experiments
data1(:,1)=data1(:,1)+100;

data=[data1 ;data2];
%remove NaN trials (no response)
dataN= data(~isnan(data(:,5)),:);
subNo=dataN(:,1);cond=dataN(:,2);sz=dataN(:,3);offer=dataN(:,4);choice=dataN(:,5);

%number of trials
N=288/2;
iter=1;
loup=1;
for condition=unique(cond)'
for sub=noOutliers'
% sub=1;

% trial conditions
value_easy = offer(subNo==sub & cond==condition)';
value_hard = 2* ones(1,length(value_easy));
set = sz(subNo==sub & cond==condition)';
subChoice=1-choice(subNo==sub & cond==condition)'; %convert choice to 1 being accept hard offer


% value_easy = repmat(easyOffer,max_set,3);value_easy=value_easy(:);
% value_hard = 2* ones(1,N);
% set = repmat(1:max_set, 1, N/max_set);

% model inputs (each column is a new trial)
u = [ value_easy; 
      value_hard; 
      set]; 


% model definition
% -------------------------------------------------------------------------
% Here we define our different hypotheses about how delay discounts value.
% We implement two competing models: hyperbolic and exponential
% discounting.

% In the VBA, the evolution (state dynamics) and observation (state to
% observation) mappings are always written in the same canonical form. It
% takes as an input the current state, the parameters (theta for the evolution,
% phi for the observation), the current input, and an optional structure 
% (passed via options.inF or options.inG). This function must return the
% next state (for the evolution) or the data prediction (observation).


% simulation
% -------------------------------------------------------------------------
% In this section we simulate artificial data according to the hyperbolic
% model.

% parameters for the simulation (delay discounting rate)
phi = 0.1;

% observation distribution. By default, the toolbox will assume a gaussian
% distribution. 
options.sources.type = 1; % 0: gaussian, 1: binary, 2: categorical
options.GnFigs=0;
options.verbose=0;
options.DisplayWin = false;
% By default, the toolbox displays information and graphs to show the progress 
% of the invertion and the final results. You can however speed up the inversion
% by swithcing off those infos.
% Uncomment the following lines to switch off the progression infos
% options.verbose = false; % display text in the command window
% options.DisplayWin = false; % display figures

% simulate data using hyperbolic discounting
% fprintf('Simulating data using hyperbolic discounting with k = %3.2f\n',phi); 
% y = VBA_simulate (N, [], @g_discount_hyp ,[], phi, u, [], [], options);
% type help VBA_simulate for more details about the arguments
% inversion
% -------------------------------------------------------------------------
% In this section we estimate the parameters (posterior distribution) and
% the evidence for the two competing models

% model dimensions
dim.n_phi = 1;

% If we want, we can change the default prior. Try it out!
% options.priors.muPhi = 0;
% options.priors.SigmaPhi = .3; % uncommenting this line shrinks the
% default prior 

% invert hyperbolic discounting model
[posterior(1), out(1)] = VBA_NLStateSpaceModel (subChoice, u, [], @g_discount_hyp, dim, options);
% invert exponential discounting model
[posterior(2), out(2)] = VBA_NLStateSpaceModel (subChoice, u, [], @g_discount_exp, dim, options);
[posterior(3), out(3)] = VBA_NLStateSpaceModel (subChoice, u, [], @g_discount_para, dim, options);
[posterior(4), out(4)] = VBA_NLStateSpaceModel (subChoice, u, [], @g_discount_lin, dim, options);

% Note: if you switched off the display (options.DisplayWin = false), you 
% can still show the final results from the posterior and out structures:
% VBA_ReDisplay(posterior(1), out(1))

% Here, we know the true model and parameters that generated the data. We 
% can therefore compute the parameter estimation error to check the
% performance of our experimental design.
estimation_error = posterior(1).muPhi - phi;

% model selection
% -------------------------------------------------------------------------
% perform model selection to compare hyperbolic and exponential dicounting
% hypotheses. Of course, you would need to simulate more subjects and try
% different discount factors to really assess the validity of the design

% Note: it is a bit weird to use random effect model selection with only
% one subject. In that case, one would usually just use the Bayes factor:
%   log_BF_1 = out(1).F - out(2).F
%   prob_m1 = VBA_sigmoid(log_BF_1) % ideally, this should be larger than
%   0.5, as 1 is the true model
% However, for the sake of the exercice, we will here use a random effect
% (group level) analysis.
close all
% Collect the model x subject matrix of (approximate) model evidences
F(:,iter,loup) = [out.F]; 
kapa(:,iter,loup)=[posterior.muPhi];
iter=iter+1;
end
loup=loup+1;
iter=1;
end
% % Random effect model selection. 
% [p, o] = VBA_groupBMC(F);

%between conditions 
[ep, o] = VBA_groupBMC_btwConds(F) ;
% check help VBA_groupBMC for more details about the output. the most
% interesting ones are:
% o.Ef % expected model frequency
% o.pxp % protected exceedance probability
% 
% % display statistics
% [~, idxWinner] = max(o.Ef);
% fprintf('The best model is the model %d: Ef = %4.3f (pxp = %4.3f)\n',idxWinner, o.Ef(idxWinner), o.pxp(idxWinner));
% 
% % display
% % -------------------------------------------------------------------------
% % It is ALWAYS a good idea to (1) plot your data and (2) plot your model
% % predictions in a similar fashion. This is the best way to check how your
% % different models make differential predictions about specific data
% % patterns, and to which degree your data indeed support the best model.
% 
% % loop over conditions
% loop=1;
% for val = unique(value_easy)
%     for d = unique(set)
%         % find corresponding trials
%         trial_idx = find(u(1, :) == val & u(3, :) == d);
%         if ~ isempty (trial_idx)
%             % average response rate
%             result.pr(loop, d) = mean (subChoice(trial_idx));
%             % prediction (no need for average!)
%             result.gx1(loop, d) = out(1).suffStat.gx(trial_idx(1));
%             result.gx2(loop, d) = out(2).suffStat.gx(trial_idx(1));
%         else
%             result.pr(loop, d) = nan;
%             result.gx1(loop, d) = nan;
%             result.gx2(loop, d) = nan;
%         end
%     end
%     loop=loop+1;
% end
%        
% % overlay data and model predictions
% VBA_figure();
% 
% subplot (1, 2, 1); 
% title ('hyperbolic model');
% hold on;
% plot (result.pr', 'o');
% % set (gca, 'ColorOrderIndex', 1);
% plot (result.gx1');
% 
% subplot (1, 2, 2); 
% title ('exponential model');
% hold on;
% plot (result.pr', 'o');
% % set (gca, 'ColorOrderIndex', 1);
% plot (result.gx2');
% 


end
