set.seed(1)
betaRates <- c(BaselineHazard,ContBetaRate_1,BinBetaRate_1,BinBetaRate_2)
BaseVar <- rep(1,InitialPopulatoin)
ContVar_1 <- runif(InitialPopulatoin)
summary(ContVar_1)
ContVar_2 <- rnorm(InitialPopulatoin,1.0,0.30)
ContVar_2[ContVar_2 < 0] <- 0 
summary(ContVar_2)
BinVar_1 <- rbinom(InitialPopulatoin,1,BinPrevalence1)
table(BinVar_1)
BinVar_2 <- rbinom(InitialPopulatoin,1,BinPrevalence2)
table(BinVar_2)

dataFeatures <- as.matrix(cbind(BaseVar,(ContVar_1+ContVar_2)/2,BinVar_1*ContVar_2,BinVar_2*ContVar_2))
hazardRate <- as.numeric(dataFeatures %*% betaRates)
summary(hazardRate)
hist(hazardRate)

aliveSet <- c(1:InitialPopulatoin)
eventSet <- numeric(InitialPopulatoin)
timetoEvent <- numeric(InitialPopulatoin)

for (time in c(1:(timeSpan/timeInterval)))
{
  randProb <- runif(length(aliveSet))
  Iscensored <- randProb <= censoredProb
  Isevent <- randProb <= (1.0-exp(-hazardRate[aliveSet]))
  Iscensored <- Iscensored & !Isevent
  eventSet[aliveSet] <- Isevent
  timetoEvent[aliveSet] <- time*timeInterval-timeInterval/2
  isCensoredOrEvent <- Iscensored | Isevent
  aliveSet <- aliveSet[!isCensoredOrEvent]
  #  cat(length(aliveSet),"(",sum(isCensoredOrEvent),",",sum(Isevent),",",sum(Iscensored),")\n")
}
timetoEvent[aliveSet] <- time*timeInterval + timeInterval/2
summary(timetoEvent)
table(eventSet)
pevent <- (1.0-exp(-hazardRate))
summary(pevent)
simulatedDataFrame <- as.data.frame(cbind(status=eventSet,time=timetoEvent,pevent=pevent,dataFeatures))
