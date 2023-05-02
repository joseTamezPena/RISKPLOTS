library(survival)
library(FRESA.CAD)

op <- par(no.readonly = TRUE)

### Libraries

data(cancer, package="survival")
lungD <- lung
lungD$inst <- NULL
lungD$status <- lungD$status - 1
lungD <- lungD[complete.cases(lungD),]


## Exploring Raw Features with RRPlot

convar <- colnames(lungD)[lapply(apply(lungD,2,unique),length) > 10]
convar <- convar[convar != "time"]
topvar <- univariate_BinEnsemble(lungD[,c("status",convar)],"status")
print(names(topvar))
topv <- min(5,length(topvar))
topFive <- names(topvar)[1:topv]
RRanalysis <- list();
idx <- 1
for (topf in topFive)
{
  RRanalysis[[idx]] <- RRPlot(cbind(lungD$status,lungD[,topf]),
                              atProb=c(0.90),
                              timetoEvent=lungD$time,
                              title=topf,
                              #                  plotRR=FALSE
  )
  idx <- idx + 1
}
names(RRanalysis) <- topFive

## Reporting the Metrics

ROCAUC <- NULL
CstatCI <- NULL
RRatios <- NULL
LogRangp <- NULL
Sensitivity <- NULL
Specificity <- NULL

for (topf in topFive)
{
  CstatCI <- rbind(CstatCI,RRanalysis[[topf]]$c.index$cstatCI)
  RRatios <- rbind(RRatios,RRanalysis[[topf]]$RR_atP)
  LogRangp <- rbind(LogRangp,RRanalysis[[topf]]$surdif$pvalue)
  Sensitivity <- rbind(Sensitivity,RRanalysis[[topf]]$ROCAnalysis$sensitivity)
  Specificity <- rbind(Specificity,RRanalysis[[topf]]$ROCAnalysis$specificity)
  ROCAUC <- rbind(ROCAUC,RRanalysis[[topf]]$ROCAnalysis$aucs)
}
rownames(CstatCI) <- topFive
rownames(RRatios) <- topFive
rownames(LogRangp) <- topFive
rownames(Sensitivity) <- topFive
rownames(Specificity) <- topFive
rownames(ROCAUC) <- topFive

print(ROCAUC)
print(CstatCI)
print(RRatios)
print(LogRangp)
print(Sensitivity)
print(Specificity)

meanMatrix <- cbind(ROCAUC[,1],CstatCI[,1],Sensitivity[,1],Specificity[,1],RRatios[,1])
colnames(meanMatrix) <- c("ROCAUC","C-Stat","Sen","Spe","RR")
print(meanMatrix)

## COX Modeling
ml <- BSWiMS.model(Surv(time,status)~1,data=lungD,NumberofRepeats = 10)
sm <- summary(ml)
print(sm$coefficients)

### Cox Model Performance


timeinterval <- 2*mean(subset(lungD,status==1)$time)

h0 <- sum(lungD$status & lungD$time <= timeinterval)
h0 <- h0/sum((lungD$time > timeinterval) | (lungD$status==1))
print(t(c(h0=h0,timeinterval=timeinterval)),caption="Initial Parameters")

index <- predict(ml,lungD)

rdata <- cbind(lungD$status,ppoisGzero(index,h0))

rrAnalysisTrain <- RRPlot(rdata,atProb=c(0.90),
                          timetoEvent=lungD$time,
                          title="Raw Train: lung Cancer",
                          ysurvlim=c(0.00,1.0),
                          riskTimeInterval=timeinterval)


### Reporting Performance 


print(rrAnalysisTrain$keyPoints,caption="Key Values")
print(rrAnalysisTrain$OERatio,caption="O/E Test")
print(t(rrAnalysisTrain$OE95ci),caption="O/E Mean")
print(rrAnalysisTrain$OARatio,caption="O/Acum Test")
print(t(rrAnalysisTrain$OAcum95ci),caption="O/Acum Mean")
print(rrAnalysisTrain$c.index$cstatCI,caption="C. Index")
print(t(rrAnalysisTrain$ROCAnalysis$aucs),caption="ROC AUC")
print((rrAnalysisTrain$ROCAnalysis$sensitivity),caption="Sensitivity")
print((rrAnalysisTrain$ROCAnalysis$specificity),caption="Specificity")
print(t(rrAnalysisTrain$thr_atP),caption="Probability Thresholds")
print(t(rrAnalysisTrain$RR_atP),caption="Risk Ratio")
print(rrAnalysisTrain$surdif,caption="Logrank test")
