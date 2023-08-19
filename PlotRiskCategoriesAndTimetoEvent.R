
obsexp <- RRAnalysisCI$OERatio$atThrEstimates
maxx <- 1.1*max(c(obsexp$Observed,obsexp$Expected))
minx <- 0.9*min(c(obsexp$Observed,obsexp$Expected))

plot(obsexp$Expected,obsexp$Observed,
     xlim=c(minx,maxx),
     ylim=c(minx,maxx),
     main="Cal. Expected vs Observed",
     ylab="Observed",
     xlab="Expected",
     col=rainbow(nrow(obsexp)),
     log="xy")

errbar(obsexp$Expected,obsexp$Observed,obsexp$L.CI,obsexp$H.CI,add=TRUE,pch=0,errbar.col=rainbow(nrow(obsexp)),cex=0.75)
lines(x=c(1,maxx),y=c(1,maxx),lty=2)
text(obsexp$Expected,obsexp$Observed,rownames(obsexp),pos=2,cex=0.75)


isevent <- RRAnalysisCI$timetoEventData$eStatus == 1
exptime <- boxplot(RRAnalysisCI$timetoEventData$expectedTime[isevent]~RRAnalysisCI$timetoEventData$class[isevent],
                   xlab="Class",
                   ylab="Time",
                   main="Expected Time",plot=FALSE)
obstime <- boxplot(RRAnalysisCI$timetoEventData$eTime[isevent]~RRAnalysisCI$timetoEventData$class[isevent],
                   xlab="Class",
                   ylab="Time",
                   main="Observed Time",
                   at=exptime$stats[3,],plot=FALSE)
classnames <- attr(RRAnalysisCI$timetoEventData,"ClassNames") 
timesdata <- cbind(obstime$stats[c(2,3,4),],exptime$stats[c(2,3,4),])
rownames(timesdata) <- c("1Q","Median","3Q")
colnames(timesdata) <- c(paste("O",classnames,sep=":"),paste("E",classnames,sep=":"))

minv <- min(c(exptime$stats[2,],obstime$stats[2,]))
if (minv<0.001) minv <-0.001
maxv <- max(c(exptime$stats[4,],obstime$stats[4,]))
errbar(exptime$stats[3,],obstime$stats[3,],obstime$stats[2,],obstime$stats[4,],log="xy",
       xlab="Mean Expected Time",
       ylab="Mean Observed",
       xlim=c(minv,maxv),
       ylim=c(minv,maxv),
       main="Estimated Time to Event",col=rainbow(length(classnames)))

lines(x=c(minv,maxv),y=c(minv,maxv),col="black",lty=2)
legend("topleft",legend=classnames,lty=c(0),pch=c(16),col=rainbow(length(classnames)),cex=0.80)
