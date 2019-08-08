function [statmatPer,statmatPT,statmatNan]=PercentageEasy(data,varargin)
%function tha calculates the ratio of the easy offer participants accepted
%during the COGED task. In the Ignore versus Update choices (type==2)
%ratio easy represents ratio Update, while for the task vs no effort
%choices, the "no redo" no effort offer. Input variables: data, a matrix
%output of the choicesTrialWise.m function, that offers information of
%condition (0 for ignore, 2 for update), set size, offer, choice, rt and
%block of every trial of the COGED task. io: parameter struct defined in   
%main script CW_analysis.type: defines which version of choices to analyse:
%1 for task vs no effort(default), 2 for ignore versus update.
%Output variables: statmatPer: matrix of ratio easy per cell.
%statmatPT: matrix of ratio easy per set size; statmatNan: matrix showing
%no responses (misses) per cell. If io.saveD is set to 1, then the function
%will create csv files of the main output variables for further analyses.

switch nargin
    case 1
        saveD=0;
        subNr=1:62;
        type=1;
    case 2
        io=varargin{1};
        saveD=io.saveD;
        subNr=io.subNo;
        type=1;
    case 3
        io=varargin{1};
        saveD=io.saveD;
        subNr=io.subNo;
        type=varargin{2};
end


subNo=data(:,1);cond=data(:,2);sz=data(:,3);offer=data(:,4);choice=data(:,5);

loop=1;
for i=subNr
    
    switch type
        
        case 1
            % find number of misses
            INan(loop)=sum(subNo==i & cond==0 & isnan(choice));
            INan1(loop)=sum(subNo==i & cond==0 & sz==1 & isnan(choice));
            INan2(loop)=sum(subNo==i & cond==0 & sz==2 & isnan(choice));
            INan3(loop)=sum(subNo==i & cond==0 & sz==3 & isnan(choice));
            INan4(loop)=sum(subNo==i & cond==0 & sz==4 & isnan(choice));
            
            UNan(loop)=sum(subNo==i & cond==2 & isnan(choice));
            UNan1(loop)=sum(subNo==i & cond==2 & sz==1 & isnan(choice));
            UNan2(loop)=sum(subNo==i & cond==2 & sz==2 & isnan(choice));
            UNan3(loop)=sum(subNo==i & cond==2 & sz==3 & isnan(choice));
            UNan4(loop)=sum(subNo==i & cond==2 & sz==4 & isnan(choice));
            
            
            PTNan(loop)=sum(subNo==i & isnan(choice));
            PTNan1(loop)=sum(subNo==i & sz==1 & isnan(choice));
            PTNan2(loop)=sum(subNo==i  & sz==2 & isnan(choice));
            PTNan3(loop)=sum(subNo==i  & sz==3 & isnan(choice));
            PTNan4(loop)=sum(subNo==i  & sz==4 & isnan(choice));
            
            % ratio redo per condition, removing NaNs
            Ignore(loop)=(sum(subNo==i & cond==0 & choice==0)/(sum(subNo==i & cond==0 )-INan(loop)));
            Update(loop)=(sum(subNo==i & cond==2 & choice==0)/(sum(subNo==i & cond==2 )-UNan(loop)));
            
            % ratio redo per cell
            I1(loop)=(sum(subNo==i & cond==0 & sz==1 & choice==0))/(sum(subNo==i & cond==0 & sz==1 )-INan1(loop));
            I2(loop)=(sum(subNo==i & cond==0 & sz==2 & choice==0))/(sum(subNo==i & cond==0 & sz==2 )-INan2(loop));
            I3(loop)=(sum(subNo==i & cond==0 & sz==3 & choice==0))/(sum(subNo==i & cond==0 & sz==3)-INan3(loop));
            I4(loop)=(sum(subNo==i & cond==0 & sz==4 & choice==0))/(sum(subNo==i & cond==0 & sz==4)-INan4(loop));
            
            U1(loop)=(sum(subNo==i & cond==2 & sz==1 & choice==0))/(sum(subNo==i & cond==2 & sz==1 )-UNan1(loop));
            U2(loop)=(sum(subNo==i & cond==2 & sz==2 & choice==0))/(sum(subNo==i & cond==2 & sz==2 )-UNan2(loop));
            U3(loop)=(sum(subNo==i & cond==2 & sz==3 & choice==0))/(sum(subNo==i & cond==2 & sz==3 )-UNan3(loop));
            U4(loop)=(sum(subNo==i & cond==2 & sz==4 & choice==0))/(sum(subNo==i & cond==2 & sz==4 )-UNan4(loop));
            
            % ratio redo across conditions
            PT(loop)=(sum(subNo==i & choice==0))/(sum(subNo==i)-PTNan(loop));
            PT1(loop)=(sum(subNo==i & sz==1 & choice==0))/(sum(subNo==i & sz==1 )-PTNan1(loop));
            PT2(loop)=(sum(subNo==i & sz==2 & choice==0))/(sum(subNo==i & sz==2 )-PTNan2(loop));
            PT3(loop)=(sum(subNo==i & sz==3 & choice==0))/(sum(subNo==i & sz==3)-PTNan3(loop));
            PT4(loop)=(sum(subNo==i & sz==4 & choice==0))/(sum(subNo==i & sz==4)-PTNan4(loop));
            
            %per offer
            easyOffer=unique(offer);
            
            I01(loop)=(sum(subNo==i & offer==0.1 & cond==0 & choice==0))/(sum(subNo==i & offer==0.1 & cond==0)-sum(subNo==i & offer==0.1 & cond==0 & isnan(choice)));
            I02(loop)=(sum(subNo==i & offer==0.2 & cond==0 & choice==0))/(sum(subNo==i & offer==0.2 & cond==0)-sum(subNo==i & offer==0.2 & cond==0 & isnan(choice)));
            I04(loop)=(sum(subNo==i & offer==0.4 & cond==0 & choice==0))/(sum(subNo==i & offer==0.4 & cond==0)-sum(subNo==i & offer==0.4 & cond==0 & isnan(choice)));
            I06(loop)=(sum(subNo==i & offer==0.6 & cond==0 & choice==0))/(sum(subNo==i & offer==0.6 & cond==0)-sum(subNo==i & offer==0.6 & cond==0 & isnan(choice)));
            I08(loop)=(sum(subNo==i & offer==0.8 & cond==0 & choice==0))/(sum(subNo==i & offer==0.8 & cond==0)-sum(subNo==i & offer==0.8 & cond==0 & isnan(choice)));
            I10(loop)=(sum(subNo==i & offer==1.0 & cond==0 & choice==0))/(sum(subNo==i & offer==1.0 & cond==0)-sum(subNo==i & offer==1.0 & cond==0 & isnan(choice)));
            I12(loop)=(sum(subNo==i & offer==1.2 & cond==0 & choice==0))/(sum(subNo==i & offer==1.2 & cond==0)-sum(subNo==i & offer==1.2 & cond==0 & isnan(choice)));
            I14(loop)=(sum(subNo==i & offer==1.4 & cond==0 & choice==0))/(sum(subNo==i & offer==1.4 & cond==0)-sum(subNo==i & offer==1.4 & cond==0 & isnan(choice)));
            I16(loop)=(sum(subNo==i & offer==1.6 & cond==0 & choice==0))/(sum(subNo==i & offer==1.6 & cond==0)-sum(subNo==i & offer==1.6 & cond==0 & isnan(choice)));
            I18(loop)=(sum(subNo==i & offer==1.8 & cond==0 & choice==0))/(sum(subNo==i & offer==1.8 & cond==0)-sum(subNo==i & offer==1.8 & cond==0 & isnan(choice)));
            I20(loop)=(sum(subNo==i & offer==2.0 & cond==0 & choice==0))/(sum(subNo==i & offer==2.0 & cond==0)-sum(subNo==i & offer==2.0 & cond==0 & isnan(choice)));
            I22(loop)=(sum(subNo==i & offer==2.2 & cond==0 & choice==0))/(sum(subNo==i & offer==2.2 & cond==0)-sum(subNo==i & offer==2.2 & cond==0 & isnan(choice)));
            
            
            U01(loop)=(sum(subNo==i & offer==0.1 & cond==2 & choice==0))/(sum(subNo==i & offer==0.1 & cond==2)-sum(subNo==i & offer==0.1 & cond==2 & isnan(choice)));
            U02(loop)=(sum(subNo==i & offer==0.2 & cond==2 & choice==0))/(sum(subNo==i & offer==0.2 & cond==2)-sum(subNo==i & offer==0.2 & cond==2 & isnan(choice)));
            U04(loop)=(sum(subNo==i & offer==0.4 & cond==2 & choice==0))/(sum(subNo==i & offer==0.4 & cond==2)-sum(subNo==i & offer==0.4 & cond==2 & isnan(choice)));
            U06(loop)=(sum(subNo==i & offer==0.6 & cond==2 & choice==0))/(sum(subNo==i & offer==0.6 & cond==2)-sum(subNo==i & offer==0.6 & cond==2 & isnan(choice)));
            U08(loop)=(sum(subNo==i & offer==0.8 & cond==2 & choice==0))/(sum(subNo==i & offer==0.8 & cond==2)-sum(subNo==i & offer==0.8 & cond==2 & isnan(choice)));
            U10(loop)=(sum(subNo==i & offer==1.0 & cond==2 & choice==0))/(sum(subNo==i & offer==1.0 & cond==2)-sum(subNo==i & offer==1.0 & cond==2 & isnan(choice)));
            U12(loop)=(sum(subNo==i & offer==1.2 & cond==2 & choice==0))/(sum(subNo==i & offer==1.2 & cond==2)-sum(subNo==i & offer==1.2 & cond==2 & isnan(choice)));
            U14(loop)=(sum(subNo==i & offer==1.4 & cond==2 & choice==0))/(sum(subNo==i & offer==1.4 & cond==2)-sum(subNo==i & offer==1.4 & cond==2 & isnan(choice)));
            U16(loop)=(sum(subNo==i & offer==1.6 & cond==2 & choice==0))/(sum(subNo==i & offer==1.6 & cond==2)-sum(subNo==i & offer==1.6 & cond==2 & isnan(choice)));
            U18(loop)=(sum(subNo==i & offer==1.8 & cond==2 & choice==0))/(sum(subNo==i & offer==1.8 & cond==2)-sum(subNo==i & offer==1.8 & cond==2 & isnan(choice)));
            U20(loop)=(sum(subNo==i & offer==2.0 & cond==2 & choice==0))/(sum(subNo==i & offer==2.0 & cond==2)-sum(subNo==i & offer==2.0 & cond==2 & isnan(choice)));
            U22(loop)=(sum(subNo==i & offer==2.2 & cond==2 & choice==0))/(sum(subNo==i & offer==2.2 & cond==2)-sum(subNo==i & offer==2.2 & cond==2 & isnan(choice)));
            
        case 2 %for direct comparison choices
            NanAc(loop)=sum(subNo==i  & isnan(choice));
            Nan1(loop)=sum(subNo==i & sz==1 & isnan(choice));
            Nan2(loop)=sum(subNo==i & sz==2 & isnan(choice));
            Nan3(loop)=sum(subNo==i  & sz==3 & isnan(choice));
            Nan4(loop)=sum(subNo==i  & sz==4 & isnan(choice));
            
            acDir(loop)=(sum(subNo==i & choice==0))/(sum(subNo==i)-NanAc(loop));
            sz1(loop)=(sum(subNo==i  & sz==1 & choice==0))/(sum(subNo==i  & sz==1 )-Nan1(loop));
            sz2(loop)=(sum(subNo==i & sz==2 & choice==0))/(sum(subNo==i &  sz==2 )-Nan2(loop));
            sz3(loop)=(sum(subNo==i  & sz==3 & choice==0))/(sum(subNo==i &  sz==3)-Nan3(loop));
            sz4(loop)=(sum(subNo==i  & sz==4 & choice==0))/(sum(subNo==i &  sz==4)-Nan4(loop));
            
            
    end
    loop=loop+1;
end



switch type
    case 1
        
        statmatPT=[PT' PT1' PT2' PT3' PT4'];
        statmatPer=[Ignore' Update' I1' I2' I3' I4' U1' U2' U3' U4'];
        statmatNan=[INan1' INan2' INan3' INan4' UNan1' UNan2' UNan3' UNan4'];
        statmatRew=[I01' I02' I04' I06' I08' I10' I12' I14' I16' I18' I20' I22' U01' U02' U04' U06' U08' U10' U12' U14' U16' U18' U20' U22'];
        
    case 2
        statmatPer=[acDir' sz1' sz2' sz3' sz4'];
        
        statmatNan=[Nan1' Nan2' Nan3' Nan4'];
end

%% save Data
if saveD
    switch type
        case 1
            
            names={'subNo' 'I' 'U' 'I1' 'I2' 'I3' 'I4' 'U1' 'U2' 'U3' 'U4'};
            namesAc={'subNo' 'Across' 'sz1' 'sz2' 'sz3' 'sz4'};
            namesRew={'subNo' 'I01' 'I02' 'I04' 'I06' 'I08' 'I10' 'I12' 'I14' 'I16' 'I18' 'I20' 'I22' 'U01' 'U02' 'U04' 'U06' 'U08' 'U10' 'U12' 'U14' 'U16' 'U18' 'U20' 'U22'};
            perName=fullfile(io.resultsDir,'perRedo.csv');
            missesNRName=fullfile(io.resultsDir,'missesNR.csv');
            PTName= fullfile(io.resultsDir,'PerRedoSZ.csv');
            rewName=fullfile(io.resultsDir,'rewardSens.csv');
            
            
            writetable(cell2table([names;num2cell([io.subNo' statmatPer]) ]),perName,'writevariablenames',0)
            writetable(cell2table([namesAc;num2cell([io.subNo' statmatPT]) ]),PTName,'writevariablenames',0)
            names(2:3)=[];
            writetable(cell2table([names;num2cell([io.subNo' statmatNan]) ]),missesNRName,'writevariablenames',0)
            writetable(cell2table([namesRew;num2cell([io.subNo' statmatRew]) ]),rewName,'writevariablenames',0)
            
            
        case 2
            names={'subNo' 'Across' 'sz1' 'sz2' 'sz3' 'sz4'};
            perName=fullfile(io.resultsDir,'perDirect.csv');
            writetable(cell2table([names;num2cell([io.subNo' statmatPer]) ]),perName,'writevariablenames',0)
    end
    
    
end
