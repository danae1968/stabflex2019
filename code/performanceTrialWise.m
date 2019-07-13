function [performanceR]=performanceTrialWise(varargin)
%%% function that creates atrial-wise matrix for the colorwheel working
%%% memory task peroformance. Output variable: performanceR; input
%%% variables: io: struct defined in main script CW_analysis.m,
%%% including directory paths, IDs(subNr) and saveD(save data or not). type: 1 for
%%% main colorwheel task, 2 for the redo after the COGED.


switch nargin
    case 0
        saveD=0;
        subNr=1:62;
    case 1
        io=varargin{1};
        saveD=io.saveD;
        subNr=io.subNo;
        type=1;
    case 2
        io=varargin{1};
        saveD=io.saveD;
        subNr=io.subNo;
        type=varargin{2};
end

%% section added to retrieve lure angle in degrees
numWheelColors=512;

%define colors in RGB values
colors=hsv(numWheelColors)*255;

%theta represents the angle for every color
theta=zeros(length(colors),1);
for index=1:length(colors)
    theta(index)=(360*index)/length(colors);
end

performanceR=[];


addpath(io.dataDir,io.analysisDir)
cd(io.dataDir);

for j=subNr
    if io.experiment==1
        participant=fullfile(io.dataDir,sprintf('ColorFun_s%d.mat',j));
    else
        subdir=fullfile(io.dataDir,sprintf('Colorwheel_sub_%d',j));
        
        % type=1 for training and type=2 for redo
        switch type
            case 1
                participant=(fullfile(subdir,sprintf('ColorFun_s%d.mat',j)));
            case 2
                participant=(fullfile(subdir,sprintf('ColorFun_s%d_Redo.mat',j)));
        end
    end
    
    load(participant)
    
    for x=1:length(data)
        for y=1:size(data,2)
            data(x,y).respDif=abs(data(x,y).respDif);
            switch type
                case 1
                    
                    %% added to retrieve lure angle
                    % colortheta is a structure with number of Colors fields linking "color" to "angle" of presentation
                    
                    colortheta=struct;
                    
                    for n=1:length(colors)
                        colortheta(n).color=colors(n,:); %pick color n from all colors
                        colortheta(n).theta=theta(n)+trial(x,y).wheelStart;    %pick angle n from all angles and add initial shift (wheelStart)
                    end
                    
                    for n=1:length(colortheta)
                        if colortheta(n).color==trial(x,y).lureColor
                            thetaLure=colortheta(n).theta;
                        end
                    end
                    
                    %correcting for added offset in angles
                    if thetaLure>360
                        thetaLure=thetaLure-360;
                    end
                    
                    signedDev=data(x,y).thetaCorrect-data(x,y).tau;
                    if signedDev>180
                        signedDev=mod(360,signedDev);
                    elseif signedDev<-180
                        signedDev=mod(-360,signedDev);
                    end
                    %% generate matrix
                    performanceR=[performanceR;j data(x,y).respDif data(x,y).rt data(x,y).setsize data(x,y).type trial(x,y).probeColNum data(x,y).lureDif data(x,y).thetaCorrect data(x,y).tau thetaLure signedDev];
                case 2
                    
                    performanceR=[performanceR;j data(x,y).respDif data(x,y).rt data(x,y).setsize data(x,y).type data(x,y).lureDif];
                    
            end
        end
    end
    
    % find redo main condition
    if type==2
        condRedo=[data.type];
        if sum(condRedo==2)>10
            performanceR(:,size(performanceR,2)+1)=2;
        elseif sum(condRedo==2)<10
            performanceR(:,size(performanceR,2)+1)=0;
        end
    end
    
    
    if saveD
        filename=fullfile(io.resultsDir,'performanceRBeh%d.csv');
        csvwrite(filename,performanceR)
    end
    
end