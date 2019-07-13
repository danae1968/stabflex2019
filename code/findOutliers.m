function [outliers,dataOut,zscores]=findOutliers(data, varargin)
%%%function that finds outliers based on deviation from mean. It calculates
%%%z scores and then based on the given criterion finds which subject
%%%numbers are outliers. Data matrix must contain subject number as its
%%%first column.

switch nargin 
    case 1
        criterion=3;
    case 2
        criterion=varargin{2};
end


%zcore data and find participants that meet the criterion for outliers
zscores=zscore(data(:,2:end));
outMat=zscores>criterion | zscores<-criterion;

%find the participant numbers
outlierRows=data(any(outMat==1,2),:);
outliers=outlierRows(:,1);

%data without outliers
dataOut=setdiff(data,outlierRows,'rows');




