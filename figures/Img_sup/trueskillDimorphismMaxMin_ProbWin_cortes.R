oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))

par(mar=c(3.75,3.75,0.33,0.33))

if (!file.exists("data/trueskillDimorphismMaxMin.RData")){
  source("data/trueskillDimorphismMaxMin.R")
}
load("data/trueskillDimorphismMaxMin.RData",envir = trueskillDimorphism <- new.env())  


Z <- trueskillDimorphism$winSinSim/trueskillDimorphism$allSinSim
Z[trueskillDimorphism$allSinSim<=32] <- NA

x.0 <- seq(length(trueskillDimorphism$x))[apply(Z,1,function(x) all(is.na(x)) )]
y.0 <- seq(length(trueskillDimorphism$y))[apply(Z,2,function(x) all(is.na(x)) )]

X <- trueskillDimorphism$x[-x.0]
Y <- trueskillDimorphism$y[-y.0]


Zred<-Z[-x.0,-y.0]

plot(10,10, ylab="", xlab="", 
     pch=19, cex=0.8, main="",ylim=c(0,1),xlim = c(min(X),max(X)),axes = F)
mtext("Skill difference", line=2, side=1,cex=1.5)
mtext("Probability of win", line=2, side=2,cex=1.5)
box()
axis(lwd=0,lwd.ticks=1,side=2,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,las=1,cex.axis=1.33,line=-0.66)

abline(h=0.5,lty=2)
abline(v=0,lty=2)  

for (y in 1:length(Y)){
  lines(X,Zred[,y])
}




dev.off()
setwd(oldwd)
par(oldpar, new=F)
