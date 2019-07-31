function [choicesR]=choicesTrialWise(varargin)

saveD=1;
subNr=1:62;
choicesR=[];
keypress=[];

switch nargin
    case 0
        saveD=0;
        subNr=1:62;
        type=1; %1 for No redo 2 for direct comparison
    case 1
        io=varargin{1};
        type=1; %1 for No redo 2 for direct comparison
        subNr=io.subNo;
        saveD=io.saveD;
    case 2
                io=varargin{1};
                type=varargin{2};
                     subNr=io.subNo;
        saveD=io.saveD;  

end

% addpath(io.dataDir,io.analysisDir)
cd(io.dataDir);

for i=subNr
   
    subdir=fullfile(io.dataDir,sprintf('Choices_sub_%d',i));
    participant=(fullfile(subdir,sprintf('ColorFunChoice_s%d.mat',i)));
    
    
    load(participant)
    
    for n=1:length(data.typeTask)
        
        %data are transformed to 0,1 for regression
        if data.choice(n)==2
            data.choice(n)=0; %0 is hard task
        end
        

        % replacing 9 with NaN when participants did not respond
        if data.choice(n)==9
            data.choice(n)=NaN;
        end
        
        keypress=[keypress; i data.key(n,1)];
    
                
                    choicesR=[choicesR;i data.condition(n) data.sz(n) data.easyOffer(n) data.choice(n) data.choiceRT(n) data.block(n) data.key(n,1)];
                                    
       
        
        
    end
    
end


if saveD
    keyName=fullfile(io.resultsDir,sprintf('keysPressed%d.mat',max(subNr)));
    save(keyName,'keypress')
    
    switch type
        case 1
            
            filename=fullfile(io.resultsDir,'choicesRNR.csv');
            csvwrite(filename,choicesR)
        case 2
            
            filename=fullfile(io.resultsDir,'choicesRDir.csv');
            csvwrite(filename,choicesR)
    end
end
end

