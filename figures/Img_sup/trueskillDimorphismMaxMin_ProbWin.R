oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))




par(mar=c(3.2,3.2,.33,3.2))

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
require(fields)
image(X,Y,Zred, col= rev(gray.colors(20)),axes=F)
image.plot(X,Y,Zred, col= rev(gray.colors(20)),legend.only = T,legend.line = 0,legend.mar = 2.9,
           legend.cex = 0.01, legend.width = 1, 
           axis.args = list(at = seq(0,1,by = 0.1),tck=-0.4,lwd=0,lwd.ticks=1),
           breaks =  seq(0,1,by = 0.05)) 
contour(X,Y,Zred,add=T,labcex = 1)
mtext("Skill difference between teams", side=1, line=1.5,cex = 1.5)
mtext("Maximum skill difference between teammates", side=2, line=1,cex = 1.5)
box()
axis(lwd=0,lwd.ticks=1,side=2, at=Y,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,las=1,cex.axis=1.33,line=-0.66)





dev.off()
setwd(oldwd)
par(oldpar, new=F)
