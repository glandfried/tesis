oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
require(fields)



pdf(paste0(nombre,".pdf"))
par(mar=c(3.75,3.75,.33,.33))

grilla <- c(50,seq(100,1300,by=100))
param <- matrix(NA,ncol=8,nrow=length(grilla))
rownames(param)<-grilla
paramLineal <- matrix(NA,ncol=6,nrow=length(grilla))
rownames(paramLineal)<-grilla
size <- matrix(NA,nrow = length(grilla),ncol=1)
rownames(size)<-grilla
i<-30
for (i in grilla){
  
  file <- paste0(paste0("data/dosClases",toString(i)),".csv")
  #file <- "../Datos/dosClases50.csv"
  ftot_perf <- read.csv(file, header =T)
  
  activity <- ftot_perf[,"team_times1"]>=4
  size[toString(i),1] <- length(activity)
  
  loyalty <- ftot_perf[,"max_times12"][activity]/ftot_perf[,"team_times1"][activity]
  teamOriented <- ftot_perf[,"team_times1"][activity]/ftot_perf[,"times1"][activity]
  skill <- ftot_perf[,"mean"][activity]

  fit <-lm(skill~loyalty*teamOriented)
  param[toString(i),5:8] <- summary(fit)$coefficients[,4]
  param[toString(i),1:4] <- summary(fit)$coefficients[,1]  
  
  fitLineal <-lm(skill~loyalty+teamOriented)
  paramLineal[toString(i),4:6] <- summary(fitLineal)$coefficients[,4]
  paramLineal[toString(i),1:3] <- summary(fitLineal)$coefficients[,1]  
  
}

colnames(param) <- c(rownames(summary(fit)$coefficients),rownames(summary(fit)$coefficients))

ylim=c(min(param[,2:4]),max(param[,2:4]))
ylim=c(min(param[,2:4]),5.5)
plot(as.integer(rownames(param)),param[,4],type="l",ylim=ylim,axes=F,ylab="",xlab="")
abline(h=0,col=rgb(0,0,0,0.3))
points(as.integer(rownames(param))[param[,8]<0.01],param[,4][param[,8]<0.01],pch=19,cex=0.8)
points(as.integer(rownames(param))[param[,8]>=0.01],param[,4][param[,8]>=0.01],pch=1,cex=0.8)
lines(as.integer(rownames(param)),param[,3],lty=2)
points(as.integer(rownames(param))[param[,7]<0.01],param[,3][param[,7]<0.01],pch=19,cex=0.8)
points(as.integer(rownames(param))[param[,7]>=0.01],param[,3][param[,7]>=0.01],pch=1,cex=0.8)
lines(as.integer(rownames(param)),param[,2],lty=3)
points(as.integer(rownames(param))[param[,6]<0.01],param[,2][param[,6]<0.01],pch=19,cex=0.8)
points(as.integer(rownames(param))[param[,6]>=0.01],param[,2][param[,6]>=0.01],pch=1,cex=0.8)

axis(lwd=0,lwd.ticks=1,at=c(50,500,1000,1500),labels=NA, side=1,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=1,las=1,at=c(50,500,1000,1500),cex.lab=0.6,tck=0.08,line=-0.5,cex.axis=1.33)
axis(lwd=0,lwd.ticks=1,labels=NA, side=2,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=2, cex.lab=0.6,tck=0.08,line=-0.5,cex.axis=1.33)

box()

mtext(side=1,"Games played", line=2,cex=1.75)
mtext(side=2,expression(Slope~(beta)), line=2,cex=1.75)

legend(100,2.3,
       title = "p-value",c("<0.01",">0.01"),pch=c(19,1),cex=1.25, box.lty=0, bg="transparent")

legend(150,ylim[2] - (ylim[2]-ylim[1])*0.8
       ,c("Feature:","Loyalty","Team-oriented behavior", "Faithfulness"),lty=c(NA,3,2,1),cex=1.25, box.lty=0, bg="transparent")


##########################
##########################

par(xpd=TRUE)

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.36
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.03
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.54  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.26
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)

faithfullEffect <- c((param[,2]+param[,3]+param[,4])[1:5],(paramLineal[,2]+paramLineal[,3])[-(1:5)])

plot(grilla,faithfullEffect,type="l",axes=F,ylab="",xlab="",ylim=c(0,4))
points(grilla[1:5],(param[,2]+param[,3]+param[,4])[1:5],pch=10)
points(grilla[-(1:5)],(paramLineal[,2]+paramLineal[,3])[-(1:5)],pch=12)
abline(h=2,col=rgb(0,0,0,0.5))
axis(lwd=1,lwd.ticks=1,at=c(50,500,1000,1500),labels=NA, side=1,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=1,las=1,at=c(50,500,1000,1500),cex.lab=0.6,tck=0.08,line=-0.5,cex.axis=1)
axis(lwd=1,lwd.ticks=1,labels=NA, side=2,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=2, cex.lab=0.6,tck=0.08,line=-0.5,cex.axis=1)

mtext(side=2,"faithfulness effect", line=1.5,cex=1.25)


legend(100,1.5,ncol=2,
       c("With interaction","Without interaction"),pch=c(10,12),cex=1, box.lty=0, bg="transparent")



par(xpd=TRUE)

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.425
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.03
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.8  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.01
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)



plot(grilla,log(size[,1],10),type="l",axes=F,ylab="",xlab="",ylim=c(3,4.5))
points(grilla,log(size[,1],10),pch=19,cex=0.33)

mtext(side=2,"Size", line=1.5,cex=1.25)


ys.min <- log(min(size[,1]),10)
ys.max <- log(max(size[,1]),10)

at.y <- log(outer(1:9, 10^(floor(ys.min):ceiling(ys.max))),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
lab.y <- lab.y[lab.y>=3 & lab.y<=4.3]
labels <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)

at.y <- c(at.y)[c(at.y)<=4.4 & c(at.y)>=3]


axis(side=2, at=at.y, labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=2, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03)
axis(lwd=0,side=2, at=lab.y, labels=labels,las=1,cex.lab=0.6,tck=0.08,line=-0.9)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(labels=NA, at=grilla[seq(1,14)%%4==2], side=1,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=1, at=grilla[seq(1,14)%%4==2], line=-0.9,cex.lab=0.6) 



dev.off()
setwd(oldwd)
par(oldpar, new=F)


