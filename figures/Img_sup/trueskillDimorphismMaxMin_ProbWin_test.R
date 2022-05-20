oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))
#setwd("~/gaming/trabajos/conquerClub/SociosPorConveniencia/Imagenes")


par(mar=c(3.2,3.2,.33,.33))

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
lista_cortes <- list()
for (i in 1:(length(Y)-1)){
  lista_cortes[[paste0("l",toString(i))]] <- tsD2[tsD2[,"dif"]>=Y[i] &  tsD2[,"dif"]<Y[i+1],]
}

plot(10,10, ylab="", xlab="", 
     pch=19, cex=0.8, main="",ylim=c(0,1),xlim = c(min(X),max(X)),axes = F)
mtext("Skill difference", line=2, side=1,cex=1.5)
mtext("Probability of win", line=2, side=2,cex=1.5)
box()
axis(lwd=0,lwd.ticks=1,side=2,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,las=1,cex.axis=1.33,line=-0.66)

lista_modelos <- list()
betas1 <- c()
for (i in 1:length(lista_cortes)){
  l <- paste0("l",i)
  model <- cbind(lista_cortes[[l]][,"delta"], as.integer(lista_cortes[[l]][,"gana"])-1)
  model <- as.data.frame(model)
  fit <-glm(model[,2]~model[,1],family=quasibinomial)
  beta<-coef(fit)
  lista_modelos[[l]]<-exp(beta[1]+beta[2]*X)/(1+exp(beta[1]+beta[2]*X))
  lines(X,exp(beta[1]+beta[2]*X)/(1+exp(beta[1]+beta[2]*X)),lwd=1)
}

abline(h=0.5,lty=2)
abline(v=0,lty=2)  

total.signif <- 0
total <- 0
for (i in 1:(length(lista_cortes)-1)){
  for (j in (i+1):length(lista_cortes)){
    li <- paste0("l",i)
    lj <- paste0("l",j)
    test <- ks.test(lista_modelos[[li]],lista_modelos[[lj]])
    total <- total + 1
    if (test$p.value > 0.99){
      total.signif <- total.signif + 1
    }
  }
}

total.signif/ total



dev.off()
setwd(oldwd)
par(oldpar, new=F)

