rm(list=ls())

library(lme4)

# experiment =1 for original study, 2 for replication and 3 for both studies pooled
experiment=3

if (experiment==2) {
  
  directory=("P:\\3017048.04\\stabflex2019\\results\\Experiment2\\COGED\\choicesRDir.csv")
  directoryDev=("P:\\3017048.04\\stabflex2019\\results\\Experiment2\\Colorwheel\\MedianAcc.csv")
  directoryOut=dirname(directory)
  prefix='rep'
  
}else if (experiment==1) {
  
  directory=("P:\\3017048.04\\stabflex2019\\results\\Experiment1\\COGED\\choicesRDir.csv")
  directoryDev=("P:\\3017048.04\\stabflex2019\\results\\Experiment1\\Colorwheel\\MedianAcc.csv")
  directoryOut=dirname(directory)
  prefix='ori'
  
  
}else if (experiment==3) {
  directoryDev=("P:\\3017048.04\\stabflex2019\\results\\Pooled\\MedianAcc.csv")
  directory1= ("P:\\3017048.04\\stabflex2019\\results\\Experiment1\\COGED\\choicesRDir.csv")
  directory2=("P:\\3017048.04\\stabflex2019\\results\\Experiment2\\COGED\\choicesRDir.csv")
  directoryOut=dirname(directoryDev)
  prefix='all'
  
  
}


################## logistic regression model: No Redo data

if (experiment==3) {
  #read data from both experiments
  IPData1=IPData=read.csv(file=directory1,header=F,sep=',')
  IPData2=IPData=read.csv(file=directory2,header=F,sep=',')
  #add 100 to subjects IDs from experiment 1 to avoid matching IDs
  IPData1$V1=IPData1$V1+100
  IPData=rbind(IPData2, IPData1)
}else {
  IPData=read.csv(file=directory,header=F,sep=',')
}

names(IPData)=c("participant","condition","setSize","easyOffer","choice","rt","block","button")


###performance data
devD=read.csv(file=directoryDev,header=T,sep=',') #deviance accuracy
attach(devD)


#convert performance to long format

devLong=reshape(devD,varying =c( "I1","I2","I3","I4","U1","U2","U3","U4"),direction = "long",idvar = "subNo",timevar="setSize",sep="")
deviance=reshape2:::melt.data.frame(devLong,id.vars=c('subNo','setSize'),value.name="deviance",variable.name="condition",measure.vars=c("I","U"))

#replace no answer with NA in choice data
IPData$choice[IPData$choice==9]=NA
as.factor(IPData$condition)
IPData$dev=NA


#assign ignore minus update deviance per cell 
for (val in unique(IPData$participant)){
  for (val2 in unique(IPData$setSize)){
    IPData$dev[IPData$participant==val & IPData$setSize==val2]=deviance$deviance[deviance$subNo==val & deviance$condition=="I" & deviance$setSize==val2 ]-deviance$deviance[deviance$subNo==val & deviance$condition=="U" & deviance$setSize==val2 ]

  }}

IPData$devZ=scale(log(IPData$dev))

IPData$easyOfferZ=scale(log(IPData$easyOffer))
attach(IPData)
IPData$condition=as.factor(IPData$condition)

#remove outlier (did not perform choice tas) from experiment 2
if (experiment!=1){
  IPDataF=IPData[IPData$participant!=46, ]
}else{ 
  IPDataF=IPData}

mod4=glmer(choice~setSize+easyOffer+(1+easyOffer+setSize|participant),data=IPDataF,REML="false",family=binomial,control = glmerControl(optimizer ="bobyqa", optCtrl = list(maxfun=1e+9)))
summary(mod4)
save("mod4", file = sprintf("%s/mod4_%sDirect.RData",directoryOut,prefix))


mod5=glmer(choice~setSize+easyOffer+dev+(1+easyOffer+setSize|participant),data=IPDataF,REML="false",family=binomial,control = glmerControl(optimizer ="bobyqa", optCtrl = list(maxfun=1e+9)))
summary(mod5)
save("mod5", file = sprintf("%s/mod5_%sDirect.RData",directoryOut,prefix))


#mod6=glmer(choice~setSize+easyOffer+dev+(1+easyOffer+setSize+dev|participant),data=IPDataF,REML="false",family=binomial,control = glmerControl(optimizer ="bobyqa", optCtrl = list(maxfun=1e+9)))
#summary(mod6)
#save("mod6", file = sprintf("%s/mod6_%sDirect.RData",directoryOut,prefix))


findBetas <- function(modelName) {
  Vcov <- vcov(modelName, useScale = FALSE)
  betas <- fixef(modelName)
  se <- sqrt(diag(Vcov))
  zval <- betas / se
  pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
  pval<-round(pval,digits=6)
  return(cbind(betas, se, zval, pval))}

#compare model with and without deviance (performance index)
anova(mod4,mod5)
#assess presence of condition effect after including deviance

