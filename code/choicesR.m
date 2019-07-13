function [choicesR]=choicesR(varargin)

saveD=1;
subNr=1:62;
choicesR=[];
keypress=[];

switch nargin
    case 1
        saveD=varargin{1};
    case 2
        saveD=varargin{1};
        subNr=varargin{2};
    case 3
        saveD=varargin{1};
        subNr=varargin{2};
        io=varargin{3};
    case 4
        saveD=varargin{1};
        subNr=varargin{2};
        io=varargin{3};
        type=varargin{4}; %1 for No redo 2 for direct comparison
end

% addpath(io.dataDir,io.analysisDir)
cd(io.dataDir);

for i=subNr
    if io.original
            participant=(fullfile(io.dataDir,sprintf('ColorFunChoice_s%d.mat',i)));
    else
    subdir=fullfile(io.dataDir,sprintf('Choices_sub_%d',i));
    participant=(fullfile(subdir,sprintf('ColorFunChoice_s%d.mat',i)));
    end
    
    load(participant)
    
    for n=1:length(data.typeTask)
        %data are made in 0,1 way.mean
        if data.choice(n)==2
            data.choice(n)=0; %0 is hard task
        end
        
        % forming condition into 0 and 2
        if data.condition(n)==22
            data.condition(n)=2;
        end
        
        % replacing 9 with NaN when participants did not respond
        if data.choice(n)==9
            data.choice(n)=NaN;
        end
        
        keypress=[keypress; i data.key(n,1)];
        
        switch type
            case 1
                
                if data.version(n)==1
                    choicesR=[choicesR;i data.condition(n) data.sz(n) data.easyOffer(n) data.choice(n) data.choiceRT(n) data.block(n) data.key(n,1)];
                                    end
            case 2
                
                if data.version(n)==2
                    choicesR=[choicesR;i data.condition(n) data.sz(n) data.easyOffer(n) data.choice(n) data.choiceRT(n) data.block(n) data.key(n,1)];
                end
        end
        
    end
    
end


if saveD
    keyName=fullfile(io.resultsDir,sprintf('keysPressed%d.mat',max(subNr)));
    save(keyName,'keypress')
    
    switch type
        case 1
            
            filename=fullfile(io.resultsDir,sprintf('choicesRNR%d.csv',max(subNr)));
            csvwrite(filename,choicesR)
        case 2
            
            filename=fullfile(io.resultsDir,sprintf('choicesRDir%d.csv',max(subNr)));
            csvwrite(filename,choicesR)
    end
end
end

