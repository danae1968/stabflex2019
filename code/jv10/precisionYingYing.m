

%Calculate the precision for ColorWheel test

MeasureName='Tau';

[names,idx]=arraysquish(TXT,'Tau',1)

CondNames={'Ignore','Update'};

SubjectNums=unique(NUM(:,2));

a=-pi; b=pi

rando = a + (b-a).*rand(16,1)

ChancePerf=circ_std(rando);

 

figure(999);hold on

count=0

shapes={'o','x'}

colours={'r','b'};

 

fid=fopen('Precision.txt','w+');

fprintf(fid,'SubjectNumber\tSess\tDrug\tCond\tN\tPrecision\n');

for Sess=1:2 %loop over testing sessions

    for Cond=1:2 %loop over conditions: 1==ignore, 2==update

    count=count+1;

    offset=(linspace(-1,1,4))

    offset=offset(count)/10

        %title(['PDF fitted to Von Mises + uniform distribution for ',sprintf('%s%s Sess %d',CondNames{Cond},MeasureName,Sess),' condition (estimated with MLE)'] );

        Nn=[];

        P=[];

        Ee=[];

       

        for N=1:4 %loop over four levels

           for SN=SubjectNums'

               %lookup the drug/sess cond:

               TheseRows=find(NUM2(:,5)==SN);

               TheseRows=intersect(TheseRows,find(NUM2(:,7)==Sess));

               DRUG=Sess; %YES CONFUSING

               SESS=NUM2(TheseRows(1),6); %SESS=Session

               

               Lines=NUM(:,2)==SN;

                %Get index of columns:

                ColName=sprintf('%s%s%dS%d',CondNames{Cond},MeasureName,N,Sess);

                [names,idx]=arraysquish(TXT,ColName,1);

                p=degtorad(NUM(Lines,idx));%convert the degrees to radians and put relevant data into temporary variable p

                if mean(p)~=nanmean(p)

                    fprintf('Seems to be missing data in: %s\n',ColName); %report it

                    p(find(arrayfun(@isnan, p)==1))=[]; %remove the nans

                end

           

            

            Nn=[Nn;N];

            P=[P(:);(1/circ_std(p))-ChancePerf]; %Calculate the precision as 1/s.d.

            fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%0.3f\n',SN,SESS,DRUG,Cond,N,1/circ_std(p))

           

            end

        end

       

    end

end

fclose(fid)