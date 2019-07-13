function [yfit,IP,betas,varargout]=RegressionAnalysis(x, y,xxMin,xxMax,varargin)
%Logistic regression of choices. We used the equation
%f(x)/(1-f(x))=e^(beta0+beta1*x) to extract the Indifference Point(x),
%while f(x)=0.5. We use xx instead of x in glmval so that we represent the
%whole curve of all choices instead of only the easy choices viewed by each ppt. 

switch nargin
    case 4
         xx = linspace(xxMin,xxMax);
    case 5
        xx=varargin{1};
    case 6
        xx=varargin{1};
        probability=varargin{2};
end

eqProb=0.5;
betas = glmfit(x, y,'binomial','link','logit'); 
yfit = glmval(betas, x, 'logit');
IP=(log(eqProb/(1-eqProb))-betas(1))/betas(2);

switch nargout
    case 4
    varargout=(log(probability/(1-probability))-betas(1))/betas(2);
end

    


end

