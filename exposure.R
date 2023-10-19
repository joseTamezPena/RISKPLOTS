library(tidyverse)
library(FRESA.CAD)

data <- read.csv("ReportsFINAL2014_2019.csv")
data$exposureM1<-data$KV^2*data$MA*data$Exp/data$B_TKN

data <- data %>%
    mutate(miu_tissue = case_when(
    Breast_density == 1 ~ 118.8,
    Breast_density == 2 ~ (118.8+154.6)/2,
    Breast_density == 3 ~ 154.6,
    Breast_density == 3 ~ 154.6,
    TRUE ~ NA
  ))
data$exposureM2<-data$MA*data$Exp*(1-exp(data$miu_tissue*data$B_TKN*-1))

data$Cancer <- ifelse(data$ToDX < -365, 1, 0)
data$Cancer <- ifelse(is.na(data$Cancer), 0, data$Cancer)

df<-cbind(data$Cancer,data$exposureM1)
df <- na.omit(df)
analysisRR <- RRPlot(df)

analysisRR$keyPoints
analysisRR$ROCAnalysis$aucs
analysisRR$c.index
analysisRR$surdif