oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))



#source("~/gaming/aux/R/header.R")
par(mar=c(3.75,3.75,0.33,0.33))
ftot_perf <- read.csv("data/dosClases.csv", header =T)

h<-hist(ftot_perf[,"mean"],breaks = 50,freq = F,main="", xlab="",ylab="",axes=F)
abline(v=mean(ftot_perf[,"mean"],na.rm=T),lty=2,lwd=1)
d <- density(ftot_perf[,"mean"],na.rm=T) # returns the density data
lines(d) # plots the results 
n <- dnorm(x=d$x,mean = mean(ftot_perf[,"mean"],na.rm = T), sd = sd(ftot_perf[,"mean"],na.rm = T))
lines(d$x,n,lwd=2)

mtext("Skill", side=1, line=2, cex=2)
mtext("Density", side=2, line=2,cex=2)

axis(lwd=1,lwd.ticks=1,side=2,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=1,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,cex.axis=1.33,line=-0.66)
axis(lwd=0,side=1, line=-0.66,cex.axis=1.33) 


#ks.test(ftot_perf[,"mean"], "pnorm", mean=mean(ftot_perf[,"mean"],na.rm=T), sd=sd(ftot_perf[,"mean"],na.rm=T))

#plot(ecdf(ftot_perf[,"mean"]))
#lines(seq(0,50),pnorm(seq(0,50),mean=mean(ftot_perf[,"mean"],na.rm=T),sd=sd(ftot_perf[,"mean"],na.rm=T)),lwd=2)



#s <- read.csv("../Datos/learningskill_skill90.csv", header =T)

#ks.test(s[,"mean"], "pnorm", mean=mean(s[,"mean"],na.rm=T), sd=sd(s[,"mean"],na.rm=T)) 
#hist(s[[1]])

dev.off()
setwd(oldwd)
par(oldpar, new=F)
