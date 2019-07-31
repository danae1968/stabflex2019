function [IPmatrix]=regressionCOGED(data,perRedo,varargin)
%% plots for pilot 2 choice data per participant showing amounts on the x axis and
% choice between easy and hard on the y axis. Running this function will
% also save the plots on cwp. IPmatrix is an 11*6 matrix, every row is a
% participant and every column the IP for different setsizes. (i2, i3, i4,
% u2,u3,u4)
% 
% projectDir='P:\3017048.04';
% analysisDir=fullfile(projectDir,'code','Choices');
% resultsDir=fullfile(projectDir,'results','Choices');
% dataDir=fullfile(projectDir,'data','ChoiceTask');

% if ~exist(resultsDir,'dir')
%     mkdir(resultsDir) 
% end


switch nargin
    case 2
 saveD=0;
 doPlots=0;
 subNo=1:62;
    case 3
io=varargin{1};
saveD=io.saveD;
doPlots=io.doPlots;
subNo=io.subNo;

end

% no redo (no effort) offers
easyOffer=[0.1 round((0.2:0.2:2.2)*10)/10];
hardOffer=2;
maxValue=max(easyOffer);
minValue=min(easyOffer);

loop=1;
subNo=data(:,1);cond=data(:,2);sz=data(:,3);offer=data(:,4);choice=data(:,5);rt=data(:,6);block=data(:,7);

for i=subNo
    
    choiceMatrix=[];
    easyOfferMatrix=[];
    % yfit=zeros(24,6);
    Isz1=[]; Isz2=[]; Isz3=[];Isz4=[];
    Usz1=[];Usz2=[];Usz3=[];Usz4=[];
    
    yI=[];yU=[];yTask=[];
    yI1=[];yI2=[];yI3=[];yI4=[];
    yU1=[];yU2=[];yU3=[];yU4=[];
    
    Ignore=[];taskValue=[];
    Update=[];
    
    subdir=fullfile(io.dataDir,sprintf('Choices_sub_%d',i));
    participant=(fullfile(subdir,sprintf('ColorFunChoice_s%d.mat',i)));
    load(participant)
    
    %% typeTask: variable coding for condition and set size of given trial.
    %%1,2,3  represents ignore with increasing set size and 4,5,6 update
    %%Choice: 1 represents choosing easy and 2 choosing hard offer
    
    for n=1:length(data.typeTask)
        if data.version(n)==1 % task vs no effort choices
            
            %data are made in 0,1 way.
            if data.choice(n)==2
                data.choice(n)=0;
                
            end
            %replace 9 with NaN when participant did not respond
            if data.choice(n)==9
                data.choice(n)=NaN;
            end
            
                switch data.typeTask(n)
                    case 1
                        Isz1=[Isz1;data.easyOffer(n)];
                        yI1=[yI1;data.choice(n)];
                    case 2
                        Isz2=[Isz2;data.easyOffer(n)];
                        yI2=[yI2;data.choice(n)];
                        
                    case 3
                        Isz3=[Isz3;data.easyOffer(n)];
                        yI3=[yI3;data.choice(n)];
                        
                    case 4
                        Isz4=[Isz4;data.easyOffer(n)];
                        yI4=[yI4;data.choice(n)];
                        
                    case 5
                        Usz1=[Usz1;data.easyOffer(n)];
                        yU1=[yU1;data.choice(n)];
                        
                    case 6
                        Usz2=[Usz2;data.easyOffer(n)];
                        
                        yU2=[yU2;data.choice(n)];
                        
                    case 7
                        Usz3=[Usz3;data.easyOffer(n)];
                        yU3=[yU3;data.choice(n)];
                        
                    case 8
                        Usz4=[Usz4;data.easyOffer(n)];
                        yU4=[yU4;data.choice(n)];
                        
                        
                end
                
                switch data.typeTask(n)
                    case {1 2 3 4}
                        
                        Ignore=[Ignore;data.easyOffer(n)];
                        yI=[yI;data.choice(n)];
                        
                    case { 5 6 7 8}
                        
                        Update=[Update;data.easyOffer(n)];
                        yU=[yU;data.choice(n)];
                        
                        
                        
                end %switch data.typeTask(n)
                taskValue=[taskValue;data.easyOffer(n)];
                yTask=[yTask; data.choice(n)];
%             end %if data.choice(n)~=9
        end %if data.version==1
    end %n=1:length(data.typeTask)
    
    
    %% Regression analyses
    [yfitI,IPI(loop),betasI(loop,:)]=RegressionAnalysis(Ignore,yI,minValue,maxValue);
    [yfitU,IPU(loop),betasU(loop,:)]=RegressionAnalysis(Update,yU,minValue,maxValue);
    [yfit1,IP1(loop),betas1(loop,:)]=RegressionAnalysis(Isz1,yI1,minValue,maxValue);
    [yfit2,IP2(loop),betas2(loop,:)]=RegressionAnalysis(Isz2,yI2,minValue,maxValue);
    [yfit3,IP3(loop),betas3(loop,:)]=RegressionAnalysis(Isz3,yI3,minValue,maxValue);
    [yfit4,IP4(loop),betas4(loop,:)]=RegressionAnalysis(Isz4,yI4,minValue,maxValue);
    [yfit5,IP5(loop),betas5(loop,:)]=RegressionAnalysis(Usz1,yU1,minValue,maxValue);
    [yfit6,IP6(loop),betas6(loop,:)]=RegressionAnalysis(Usz2,yU2,minValue,maxValue);
    [yfit7,IP7(loop),betas7(loop,:)]=RegressionAnalysis(Usz3,yU3,minValue,maxValue);
    [yfit8,IP8(loop),betas8(loop,:)]=RegressionAnalysis(Usz4,yU4,minValue,maxValue);
    [yfitTask,IPtask(loop)]=RegressionAnalysis(taskValue,yTask,minValue,maxValue);
    
    
    IPmatrixAll=[IPI' IPU' IPtask' IP1',IP2',IP3',IP4',IP5',IP6',IP7',IP8'];
    IPmatrixAll(all(IPmatrixAll==0,2),:)=[];
    IPmatrixAll(IPmatrixAll<minValue)=minValue;
    IPmatrixAll(IPmatrixAll>maxValue)=maxValue;
    IPmatrix=IPmatrixAll(:,4:end);
    b0Mat=[betasI(:,1) betasU(:,1) betas1(:,1) betas2(:,1) betas3(:,1) betas4(:,1) betas5(:,1) betas6(:,1) betas7(:,1) betas8(:,1)];
    b1Mat=[betasI(:,2) betasU(:,2)  betas1(:,2)  betas2(:,2)  betas3(:,2)  betas4(:,2)  betas5(:,2)  betas6(:,2)  betas7(:,2) betas8(:,2) ];
    b0Mat(all(b0Mat==0,2),:)=[];
    b1Mat(all(b1Mat==0,2),:)=[];

    
 
    
%%%%% Plots %%%%   % horizontal line at y=0.5
    lineX= 0:0.1:maxValue;
    lineY =0.5 * ones(size(lineX));
    
if doPlots
   
    % regression plots
 xx = easyOffer;
 aI=unique([Ignore,yfitI],'rows');
 aU=unique([Update,yfitU],'rows');
a1=unique([Isz1,yfit1],'rows');
a2=unique([Isz2, yfit2],'rows');
a3=unique([Isz3, yfit3],'rows');
a4=unique([Isz4, yfit4],'rows');
a5=unique([Usz1,yfit5],'rows');
a6=unique([Usz2, yfit6],'rows');
a7=unique([Usz3, yfit7],'rows');
a8=unique([Usz4, yfit8],'rows');
% 
 bI=unique([Ignore,yI],'rows');
 bU=unique([Update,yU],'rows');
saI(loop,:)=aI(:,2)';saU(loop,:)=aU(:,2)';
msaI=mean(saI);msaU=mean(saU);



% figure;
% hold all
% plot(a1(:,1),a1(:,2),'m')
% plot(a2(:,1),a2(:,2),'b')
% plot(a3(:,1),a3(:,2),'r')
% plot(a4(:,1),a4(:,2),'g')
% 
% plot(lineX,lineY,'c')
% scatter(Isz1,yI1,'m','jitter','on')
% scatter(Isz2,yI2,'b','jitter','on')
% scatter(Isz3,yI3,'r','jitter','on')
% scatter(Isz4,yI4,'g','jitter','on')
% ylabel('Probability of accepting No Redo');
%   xlabel('Offer for No Redo');
% legend('Ignore 1','Ignore 2','Ignore 3','Ignore 4','Threshold','location','southeast')
%   title(sprintf('Probability of accepting No Redo for participant %d Ignore',i));
%  ylim([0 1])
%   xlim([minValue maxValue])
%   hold off
%     % saveas(gcf,sprintf('sub%dNRI',i),'bmp')
% 
%  figure;
% hold all
% plot(a5(:,1),a5(:,2),'m')
% plot(a6(:,1),a6(:,2),'b')
% plot(a7(:,1),a7(:,2),'r')
% plot(a8(:,1),a8(:,2),'g')
% 
% plot(lineX,lineY,'c')
% scatter(Usz1,yU1,'m','jitter','on')
% scatter(Usz2,yU2,'b','jitter','on')
% scatter(Usz3,yU3,'r','jitter','on')
% scatter(Usz4,yU4,'g','jitter','on')
% ylabel('Probability of accepting No Redo');
%   xlabel('Offer for No Redo');
% legend('Update 1','Update 2','Update 3','Update 4','Threshold','location','southeast')
%   title(sprintf('Probability of accepting No Redo for participant %d Update',i));
%  ylim([0 1])
%   xlim([minValue maxValue])
%   hold off
     %saveas(gcf,sprintf('sub%dNRU',i),'bmp')    
end
loop=loop+1;
end

figure;
hold all
plot(aI(:,1),msaI,'m')
scatter(aI(:,1),aI,'m','jitter','on')

plot(aU(:,1),msaU,'g')
ylabel('Probability of accepting No Redo');
  xlabel('Offer for No Redo');
 ylim([0 1])
  xlim([minValue maxValue])
 plot(lineX,lineY,'--k')
  h = zeros(2, 1);
h(1) = plot(NaN,NaN,'m');
h(2) = plot(NaN,NaN,'g');
% h(3) = plot(NaN,NaN,'g');
legend(h, 'Ignore','Update');
hold off
% end %for i=1:11

if saveD==1
filename=fullfile(io.resultsDir,sprintf('IPmatrix%d.xlsx',max(subNo)));
filenameAc=fullfile(io.resultsDir,sprintf('IPAcross%d.xlsx',max(subNo)));
filenameTask=fullfile(io.resultsDir,sprintf('IPtask%d.xlsx',max(subNo)));
filenameInter=fullfile(io.resultsDir,sprintf('Intercept%d.xlsx',max(subNo)));
filenameSlope=fullfile(io.resultsDir,sprintf('Slope%d.xlsx',max(subNo)));
xlswrite(filename,[subNo' IPmatrixAll(:,3:end)],1,'A2')
xlswrite(filenameAc,[subNo' IPmatrixAll(:,1:2)],1,'A2')  
xlswrite(filenameTask,[subNo' IPmatrixAll(:,3)],1,'A2')  
xlswrite(filenameInter,[subNo',b0Mat(:,3:end)],1,'A2')
xlswrite(filenameSlope,[subNo',b1Mat(:,3:end)],1,'A2')

% normSV=IPmatrix/fixedValue;
% %  xlswrite('SVNoRedo',normSV)
names={'subNo' 'I1' 'I2' 'I3' 'I4' 'U1' 'U2' 'U3' 'U4' };
namesAcc={'subNo' 'I' 'U'};
namesTask={'subNo' 'SVtask'};

xlswrite(filename,names,1,'A1:I1')
xlswrite(filenameAc,namesAcc,1,'A1:C1')
xlswrite(filenameInter,names,1,'A1:I1')
xlswrite(filenameSlope,names,1,'A1:I1')
xlswrite(filenameTask,namesTask,1,'A1')


end
end %function
