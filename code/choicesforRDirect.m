function [IPggplotDirect,choicesR,keyAnal]=choicesforRDirect

cd(pwd);
% numSubs=24;
numSubs=1:32; numSubs(4:7)=[];
fixedValue=2;
easyOffer=[0.1 round((0.2:0.2:4)*10)/10];
[IPmatrix,~,normSV]=DirectComparisonAnalysis(numSubs,fixedValue,easyOffer);
normSV(normSV<0)=0;
IPmatrix(IPmatrix<0)=0;
choicesR=[];choicesRNA=[]; keyResp=[];
setSize=1:4;
condition=[0 2];
for i=numSubs
    
    participant=sprintf('ColorFunChoice_s%d.mat',i);
    load(participant)
    
    for n=1:length(data.typeTask)
        %data are made in 0,1 way.
        if data.choice(n)==2
            data.choice(n)=0;
        end
        
        % forming condition into 0 and 2
        if data.condition(n)==22
            data.condition(n)=2;
        end
        
        if data.version(n)==2
            keyResp=[keyResp; i data.key(n,:)];
            if data.choice(n)~=9
                choicesR=[choicesR;i data.condition(n) data.sz(n) data.easyOffer(n) data.choice(n) data.choiceRT(n)];
            elseif data.choice(n)==9
                choicesRNA=[choicesRNA;i data.condition(n) data.sz(n) data.easyOffer(n) data.choice(n) data.choiceRT(n)];
            end
            
        end
    end
end
% csvwrite('choicesRprepilot2',choicesR)
%% check if they responded with same key
    keyFirst=keyResp(:,1:2); %first response
    subNo=keyResp(:,1);
    keyAnal=zeros(length(numSubs),2);
    
for j=numSubs
    keyAnal(j,:)=histc(keyFirst(subNo==j,2),[49, 50])';
end

reSV=reshape(normSV,size(normSV,1)*size(normSV,2),1);
reIP=reshape(IPmatrix,size(IPmatrix,1)*size(IPmatrix,2),1);
part=repmat(numSubs',length(reSV)/length(numSubs),1);part=part(:);
SZ=repmat(setSize,length(numSubs),1);SZ=SZ(:);
% SZ=repmat(setSize,numSubs,1);SZ=SZ(:);

IPggplotDirect=[part reSV reIP SZ];
 csvwrite('IPGGplotDirect',IPggplotDirect)
