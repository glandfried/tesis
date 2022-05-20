oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))

#setwd("~/gaming/trabajos/conquerClub/db/conquerSkill/Imagenes")
par(mar=c(3.75,3.75,0.33,0.33))

a <- read.csv("data/skillProba2.csv")
a <- a[order(a$dif),] 
a <- a[a$count>35,] 

p <-a$avg
x <- a$dif
plot(x,p, ylab="", xlab="", pch=19, axes=F)
mtext("Skill difference", line=2, side=1,cex=1.75)
mtext("Probability of win", line=2, side=2,cex=1.75)
box()
axis(lwd=0,lwd.ticks=1,side=2, labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,cex.axis=1.25,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1, labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,line=-0.66,cex.axis=1.25) 

for(n_desvios in seq(2,4)){
  sup <- a$avg + n_desvios* sqrt((1/a$count)*a$avg*(1-a$avg))
  inf <- a$avg - n_desvios* sqrt((1/a$count)*a$avg*(1-a$avg))
  
  polygon(c(x,rev(x)), c(sup,rev(inf)),col = rgb(0,0,0,0.3),border = F)
  
}


model <- cbind(x,p)
colnames(model) <- c("ts","p")
model <- as.data.frame(model)
fit <-glm(model[,2]~model[,1],family=quasibinomial,weights = a$count)

beta<-coef(fit)
lines(x,exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x)),col=1,lwd=2)
abline(h=0.5,lty=2)
abline(v=0,lty=2)  

##polygon(c(x.na.omit,rev(x.na.omit)),
##        c(exp(beta.ci[2,1]+beta.ci[2,2]*x.na.omit)/(1+exp(beta.ci[2,1]+beta.ci[2,2]*x.na.omit))
##          ,rev(exp(beta.ci[1,1]+beta.ci[2,1]*x.na.omit)/(1+exp(beta.ci[1,1]+beta.ci[2,1]*x.na.omit))) )
##        , col=rgb(0,0,0,0.2) , border=F)


#x <- seq(0,10)
#y.enX <- exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
#plot(x,exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x)))



dev.off()
setwd(oldwd)
par(oldpar, new=F)
