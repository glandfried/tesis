oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))

par(mar=c(3,3,0.5,3.6))

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

tsD2 <- read.csv("data/teamskillDimorphismMaxMin.csv", header =T)
names(tsD2)
Y<-seq(0,8.5,by=0.5)
lista_cortes <- list()
for (i in 1:(length(Y)-1)){
  lista_cortes[[paste0("l",toString(i))]] <- tsD2[tsD2[,"dif"]>=Y[i] &  tsD2[,"dif"]<Y[i+1],]
}

m = matrix(nrow = length(X),ncol = length(Y)-1)

for (i in 1:length(lista_cortes)){
  l <- paste0("l",i)
  model <- cbind(lista_cortes[[l]][,"delta"], as.integer(lista_cortes[[l]][,"gana"])-1)
  model <- as.data.frame(model)
  fit <-glm(model[,2]~model[,1],family=quasibinomial)
  beta<-coef(fit)
  m[,i]<-exp(beta[1]+beta[2]*X)/(1+exp(beta[1]+beta[2]*X))
  #lines(X,exp(beta[1]+beta[2]*X)/(1+exp(beta[1]+beta[2]*X)),col=gray.colors(length(lista_cortes))[i],lwd=1)
}

require(fields)
image(X,Y,m, col= rev(gray.colors(20)),axes=F)
image.plot(X,Y,m, col= rev(gray.colors(20)),legend.only = T,legend.line = 0,legend.mar = 3.2,
           legend.cex = 0.01, legend.width = 1, 
           axis.args = list(at = seq(0,1,by = 0.1),tck=-0.4,lwd=0,lwd.ticks=1),
           breaks =  seq(0,1,by = 0.05)) 
contour(X,(Y+0.25)[1:length(Y)-1],m,add=T,labcex = 1)
mtext("Skill difference between teams", side=1, line=1.5,cex = 1.5)
mtext("Maximum skill difference between teammates", side=2, line=1,cex = 1.5)
box()
axis(lwd=0,lwd.ticks=1,side=2, at=Y,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,las=1,cex.axis=1.33,line=-0.66)

par(xpd=NA);text(28.5,8.35,"P(win)",cex=1.33);par(xpd=F)


dev.off()
setwd(oldwd)
par(oldpar, new=F)

