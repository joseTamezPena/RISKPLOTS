expObs <- function(obsexp,title)
{
  maxx <- 1.1*max(c(obsexp$Observed,obsexp$Expected))
  minx <- 0.9*min(c(obsexp$Observed,obsexp$Expected))
  
  plot(obsexp$Expected,obsexp$Observed,
       xlim=c(minx,maxx),
       ylim=c(minx,maxx),
       main=title,
       ylab="Observed",
       xlab="Expected",
       col=rainbow(nrow(obsexp)),
       log="xy")
  
  errbar(obsexp$Expected,obsexp$Observed,obsexp$L.CI,obsexp$H.CI,add=TRUE,pch=0,errbar.col=rainbow(nrow(obsexp)),cex=0.75)
  lines(x=c(1,maxx),y=c(1,maxx),lty=2)
  text(obsexp$Expected,obsexp$Observed,rownames(obsexp),pos=2,cex=0.75)
}

expObsTime <- function(rranalysis,title)
{
  
  exptime <- boxplot(rranalysis$timetoEventData$expectedTime~rranalysis$timetoEventData$class,plot=FALSE)
  obstime <- boxplot(rranalysis$timetoEventData$eTime~rranalysis$timetoEventData$class,plot=FALSE)
  classnames <- attr(rranalysis$timetoEventData,"ClassNames") 
  timesdata <- cbind(obstime$stats[c(2,3,4),],exptime$stats[c(2,3,4),])
  rownames(timesdata) <- c("1Q","Median","3Q")
  colnames(timesdata) <- c(paste("O",classnames,sep=":"),paste("E",classnames,sep=":"))
  
  minv <- min(c(exptime$stats[2,],obstime$stats[2,]))
  if (minv<0.001) minv <-0.001
  maxv <- max(c(exptime$stats[4,],obstime$stats[4,]))
  theColors <- c("green","pink","red")
  errbar(exptime$stats[3,],obstime$stats[3,],obstime$stats[2,],obstime$stats[4,],log="xy",
         xlab="Mean Expected Time",
         ylab="Mean Observed",
         xlim=c(minv,maxv),
         ylim=c(minv,maxv),
         main=title,
         col=theColors)
  
  lines(x=c(minv,maxv),y=c(minv,maxv),col="black",lty=2)
  legend("topleft",legend=classnames,lty=c(0),pch=c(16),col=theColors,cex=0.80)
  return (timesdata)
}
