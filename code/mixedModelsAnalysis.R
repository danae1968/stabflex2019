rm(list=ls())

library(lme4)

experiment=1

if (experiment==2) {
  
  directory=("P:\\3017048.04\\stabflex2019\\results\\Experiment2\\COGED\\choicesRNR.csv")
  directoryDev=("P:\\3017048.04\\stabflex2019\\results\\Experiment2\\Colorwheel\\MedianAcc.csv")

}else if (experiment==1) {
  
  directory=("P:\\3017048.04\\stabflex2019\\results\\Experiment1\\COGED\\choicesRNR.csv")
  directoryDev=("P:\\3017048.04\\stabflex2019\\results\\Experiment1\\Colorwheel\\MedianAcc.csv")}


################## logistic regression model: No Redo data

  
  IPData=read.csv(file=directory,header=T,sep=',')
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

  
  #assign deviance per cell 
  for (val in unique(IPData$participant)){
    for (val2 in unique(IPData$setSize)){
      IPData$dev[IPData$participant==val & IPData$setSize==val2 & IPData$condition==0]=deviance$deviance[deviance$subNo==val & deviance$condition=="I" & deviance$setSize==val2 ]
      IPData$dev[IPData$participant==val & IPData$setSize==val2 & IPData$condition==2]=deviance$deviance[deviance$subNo==val & deviance$condition=="U" & deviance$setSize==val2 ]
      
    }}
  
  IPData$devZ=scale(log(IPData$dev))
  
  IPData$easyOfferZ=scale(log(IPData$easyOffer))
  attach(IPData)
  condition=as.factor(condition)
  
  
  
  mod1=glmer(choice~condition+setSize+easyOfferZ+(1+easyOfferZ+setSize+condition|participant),data=IPData,REML="false",family=binomial,control = glmerControl(optimizer =c("Nelder_Mead", "bobyqa"), optCtrl = list(maxfun=1e+9)))
  summary(mod1)
  
  mod2=glmer(choice~condition+setSize+easyOfferZ+devZ+(1+easyOfferZ+setSize+condition|participant),data=IPData,REML="false",family=binomial,control = glmerControl(optimizer =c("Nelder_Mead", "bobyqa"), optCtrl = list(maxfun=1e+9)))
  summary(mod2)
  
  mod3=glmer(choice~condition+setSize+easyOfferZ+devZ+(1+easyOfferZ+setSize+condition+devZ|participant),data=IPData,REML="false",family=binomial,control = glmerControl(optimizer =c("Nelder_Mead", "bobyqa"), optCtrl = list(maxfun=1e+9)))
  summary(mod3)
  
  findBetas <- function(modelName) {
  Vcov <- vcov(modelName, useScale = FALSE)
  betas <- fixef(modelName)
  se <- sqrt(diag(Vcov))
  zval <- betas / se
  pval <- 2 * pnorm(abs(zval), lower.tail = FALSE)
  pval<-round(pval,digits=6)
  return(cbind(betas, se, zval, pval))}
  
  #compare model with and without deviance (performance index)
  anova(mod1,mod2)
  #assess presence of condition effect after including deviance
  findBetas(mod3)
