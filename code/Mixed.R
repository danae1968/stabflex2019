
rm(list=ls())

install.packages('lme4', repos =
                   c("http://lme4.r-forge.r-project.org/
                     repos", getOption("repos")))
library(lme4)

directory=("P:\\3017048.04\\results\\Choices\\N62\\choicesRNR62.csv")
directory2=("P:\\3017048.04\\results\\Choices\\N62\\PerRedo62OutANCOVA.csv")
directory3=("P:\\3017048.04\\results\\Choices\\N62\\PerDirect62Out.csv")
directory4=("P:\\3017048.04\\results\\Colorwheel\\N62\\MedianAcc62.csv")


################### percentage Redo data
PerData=read.csv(file=directory2,header=T,sep=',')
#names(PerData)=c("participant","condition","setSize","performance","perRedo") #seem to have headers

attach(PerData)

#check data for normality. A significant p-value of the shapiro test indicates that the data are NOT normally distributed.

hist(perRedo)
plot(density(perRedo))
plot(density(perRedo[setSize==4]))
shapiro.test(perRedo)
qqnorm(perRedo)

hist(performance)
plot(density(performance))
plot(density(performance[setSize==4]))
shapiro.test(performance)
qqnorm(performance)



#log data if not normally distributed


perRedoZ=scale(log(perRedo))
performanceZ=scale(log(Performance))
setSizeZ=scale(log(setSize))
conditionZ=scale(log(condition))

#model
m1=lmer(perRedo~condition+setSize+ performance+  (1+performance+condition+setSize|participant),data=PerData, control=lmerControl(optimizer="bobyqa"))
display(m1)
summary(m1)


#################### percentage Ignore: direct comparison

perDir=read.csv(file=directory3,header=T,sep=',')
devD=read.csv(file=directory4,header=T,sep=',')
attach(devD)


#calculate performance difference
ImU=cbind(subNo, I1-U1,I2-U2,I3-U3,I4-U4)
ImU=as.data.frame(ImU)
names(ImU)=c("participant","sz1","sz2","sz3","sz4")
attach(ImU)
View(ImU)
#convert data to a long format

#performance
ImULong=reshape(ImU,varying =c( "sz1","sz2","sz3","sz4"),direction = "long",idvar = "participant",timevar="setSize",sep="")
ImUL=reshape2:::melt.data.frame(ImULong,id.vars=c('participant','setSize'),value.name="perfDif")
ImUOut=ImUL[participant!=c(35,46), ]

# percentage Ignore
dirLong=reshape(perDir[ , c(1, 3:6) ],varying =c( "sz1","sz2","sz3","sz4"),direction = "long",idvar = "subNo",timevar="setSize",sep="")
dirL=reshape2:::melt.data.frame(dirLong,id.vars=c('subNo','setSize'),value.name="perIgn")

mat=cbind(dirL[ ,c(1,2,4)], ImUOut[ ,c(1,4)])


## model

m2=lmer(mat$perIgn~mat$setSize+ mat$perfDif+  (1+mat$perfDif+mat$setSize|mat$participant),data=mat, control=lmerControl(optimizer="bobyqa"))
summary(m2)

################## logistic regression model: No Redo
IPData=read.csv(file=directory,header=T,sep=',')
names(IPData)=c("participant","condition","setSize","easyOffer","choice","rt","block","button")

###performance data
directory4=("P:\\3017048.04\\results\\Colorwheel\\N62\\MedianAcc62.csv")
devD=read.csv(file=directory4,header=T,sep=',')
attach(devD)

#convert performance to long format
devLong=reshape(devD,varying =c( "I1","I2","I3","I4","U1","U2","U3","U4"),direction = "long",idvar = "subNo",timevar="setSize",sep="")
deviance=reshape2:::melt.data.frame(devLong,id.vars=c('subNo','setSize'),value.name="deviance",variable.name="condition",measure.vars=c("I","U"))
View(deviance)




#replace no answer with NA in choice data

IPData$choice[IPData$choice==9]=NA
as.factor(IPData$condition)
IPData$dev=NA

#assign deviance per cell 
for (val in unique(IPData$participant)){
  for (val2 in unique(IPData$setSize)){
IPData$dev[IPData$participant==val & IPData$setSize==val2 & IPData$condition==0]=deviance$deviance[deviance$subNo==val & deviance$condition=="I" & deviance$setSize==val2 ]
IPData$dev[IPData$participant==val & IPData$setSize==val2 & IPData$condition==2]=deviance$deviance[deviance$subNo==val & deviance$condition=="U" & deviance$setSize==val2 ]
}}


IPData$devZ=scale(log(IPData$dev))
attach(IPData)

#condition+setsize, intercept and slope all
mod1=glmer(choice~condition+setSize+(1+setSize+condition|participant),data=IPData,REML="false",family=binomial)
display(mod1)
summary(mod1)

mod1.1=glmer(choice~condition+setSize+easyOffer+(1+setSize+condition+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.1)
summary(mod1.1)

mod1.2=glmer(choice~condition+setSize+easyOffer+(1+setSize+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.2)
summary(mod1.2)

mod1.3=glmer(choice~condition+setSize+easyOffer+(1+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.3)
summary(mod1.3)

mod1.4=glmer(choice~condition+setSize+easyOffer+(1+condition+setSize|participant),data=IPData,REML="false",family=binomial)
display(mod1.4)
summary(mod1.4)

mod1.5=glmer(choice~setSize+easyOffer+dev+(1+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.5)
summary(mod1.5)

mod1.6=glmer(choice~condition*setSize*easyOffer*dev+(1+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.6)
summary(mod1.6)

mod1.7=glmer(choice~condition+setSize+easyOffer+devZ+(1|participant),data=IPData,REML="false",family=binomial)
display(mod1.7)
summary(mod1.7)

mod1.8=glmer(choice~condition+setSize+easyOffer+dev+setSize:dev+(1+condition+setSize|participant),data=IPData,REML="false",family=binomial)
display(mod1.8)
summary(mod1.8)

mod1.9=glmer(choice~condition+setSize+easyOffer+dev+dev:setSize+(1+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.9)
summary(mod1.9)

mod1.10=glmer(choice~condition+setSize+easyOffer+condition:setSize+(1+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.10)
summary(mod1.10)

mod1.11=glmer(choice~condition+setSize+easyOffer+dev+dev:setSize+(1+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.11)
summary(mod1.11)

mod1.11=glmer(choice~condition+setSize+easyOffer+dev+(1+setSize+easyOffer|participant),data=IPData,REML="false",family=binomial)
display(mod1.11)
summary(mod1.11)

######## example participant logit
IP12=IPData[participant==29 & setSize==3, ]

rs1=glm(IP12$choice~IP12$easyOffer+condition+setSize,data=IP12,family=binomial)
summary(rs1)

rs2=glm(IP12$choice~IP12$easyOffer,data=IP12,family=binomial)
summary(rs2)

plot(jitter(IP12$choice, factor=0.5)~IP12$easyOffer, ylab=" ", xlab=" ",xlim=c(0,2.2),yaxt='n')


# plot the predicted values using the sigmoid function
x <- c(0 ,0.5, 1 ,1.5 ,2)
b = rs2$coefficients[1] # intercept
m = rs2$coefficients[2] # slope
y <- exp((b + m*x)) / (1 + exp((b + m*x)))

par(new=TRUE) ##### REMEMBER THIS don't erase what's already on the plot!


## does not work: draw a curve based on prediction from logistic regression model
#easyOffer = IP12$easyOffer
#curve(predict(rs2, data.frame(easyOffer = x), type = "resp"), add = TRUE)

#points(IP12$easyOffer,fitted(rs2),pch=2.2, col='red')

plot(x, y, xlab="", ylab="", pch = 16, col='red',xlim=c(0,2.2),ylim=c(0,1))
title(main="Data & Predicted Values from \nLogistic Regression Model")