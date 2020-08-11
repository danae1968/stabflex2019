filename='P:\3017048.04\stabflex2019\results\Pooled\modelsCompFin.mat';
filenameCond='P:\3017048.04\stabflex2019\results\Pooled\modelsCompCondFin.mat';
devI_U=xlsread('P:\3017048.04\stabflex2019\results\Pooled\correlationsIPsPooled.csv','G2:G75');
noOutliers=xlsread('P:\3017048.04\stabflex2019\results\Pooled\correlationsIPsPooled.csv','A2:A75');
%cond=0 for modelling across ignore update conditions, cond=1 for modeling
%them separately
cond=1;
filenameDir='P:\3017048.04\stabflex2019\results\Pooled\directPooled.csv';
direct=readtable(filenameDir);

%load modeling output
% mod=load(filename);
if cond==1
mod=load(filenameCond);
elseif cond==0
    mod=load(filename); 
end

%find best model
minBic=min(mean(mod.model_results.bic));
minAic=min(mean(mod.model_results.aic)); 
indexAic=mean(mod.model_results.aic)== minAic;
indexBic=mean(mod.model_results.bic)== minBic;


if cond==0
winBic=mod.model_results.model_names(indexBic);
winAic=mod.model_results.model_names(indexAic);
elseif cond==1
winBicIgn= mod.model_results.model_names(indexBic(:,:,1));   
winBicUpd=mod.model_results.model_names(indexBic(:,:,2));
winAicIgn= mod.model_results.model_names(indexAic(:,:,1));   
winAicUpd=mod.model_results.model_names(indexAic(:,:,2));
end
%discounting parameter of winning model(linear)

if cond==0
    condition=1;
    elseif cond==1
        condition=1:2;
end
        
for sub=1:length(mod.model_results.params)
    for conInd=condition% one column for each condition (ignore/update)
        kappa(sub,conInd)=[mod.model_results.params{sub,indexBic(:,:,conInd),conInd}(1)];
beta(sub,conInd)=[mod.model_results.params{sub,indexBic(:,:,conInd),conInd}(2)];
% kappa(sub)=[mod.model_results.params{sub,indexBic}(1)];
% beta(sub)=[mod.model_results.params{sub,indexBic}(2)];
end
end

%% find best model per participant
if cond==0
 minPP=min(mod.model_results.bic,[],2);
 indexPP=mod.model_results.bic==minPP;
 %find participants who prefer ignore and update
 prefI=intersect(direct.subNo(direct.IP>2),noOutliers);
 prefU=intersect(direct.subNo(direct.IP<2),noOutliers);
 devI=intersect(noOutliers(devI_U<0),noOutliers);
 devU=intersect(noOutliers(devI_U>0),noOutliers);
 bicN=[noOutliers mod.model_results.bic];
 
 ignoreModPref=mean(bicN(ismember(noOutliers,prefI),2:end));
 updateModPref=mean(bicN(ismember(noOutliers,prefU),2:end));
 
 ignoreModDev=mean(bicN(ismember(noOutliers,devI),2:end));
 updateModDev=mean(bicN(ismember(noOutliers,devU),2:end));
 
 for n=1:size(indexPP,2)
 bestMod(indexPP(:,n)==1)=n;
 end
 bestModName=mod.model_names(bestMod);
end
 %% save data

if cond==1
     outputFile='P:\3017048.04\stabflex2019\results\Pooled\discParamsCondFin.csv';
     outputFileOut='P:\3017048.04\stabflex2019\results\Pooled\discParamsCondFinOutl.csv';

    names={'sub','kappa_I','kappa_U','beta_I','beta_U'};
    paramMat=[noOutliers kappa beta];
     writetable(cell2table([names;num2cell(paramMat)]),outputFile,'writevariablenames',0)

[outliers,paramOut]=findOutliers(paramMat(paramMat(:,1)~=46,:));outliers=[outliers;46]; %add participant who pressed only 1 button in outliers and estimate outliers without them

if ~isempty(outliers)
writetable(cell2table([names;num2cell(paramOut)]),outputFileOut,'writevariablenames',0)
end

elseif cond==0
         outputFile='P:\3017048.04\stabflex2019\results\Pooled\discParams.csv';
 names={'sub','kappa','beta','bestModel'};
 writetable(cell2table([names;num2cell([noOutliers kappa beta bestMod'])]),outputFile,'writevariablenames',0)

end
% csvwrite(outputFile,[names;num2cell([noOutliers kappa beta])])
