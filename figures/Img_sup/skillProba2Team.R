oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))

par(mar=c(3.75,3.75,0.33,0.33))

a1 <- read.csv("data/skillProba2.csv")
a1 <- a1[order(a1$dif),] 
a2 <- read.csv("data/skillProba2Team.csv")
a2 <- a2[order(a2$dif),] 

plot(1,1, ylab="", xlab="", cex=0.2, col=rgb(1,1,1,0) ,pch=19, axes=F,
     ylim = c(0,1),xlim=c(-20,20))
mtext("Skill difference", line=2, side=1,cex=1.75)
mtext("Probability of win", line=2, side=2,cex=1.75)
box()
axis(lwd=0,lwd.ticks=1,side=2, labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,cex.axis=1.25,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1, labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,line=-0.66,cex.axis=1.25) 
abline(h=0.5,lty=2)
abline(v=0,lty=2)  

#points(x[-1],(ganados/totales)[-1], pch=19, cex=0.8)
points(a2$dif[a2$dif>=-20 & a2$dif<=20 ],a2$avg[a2$dif>=-20 & a2$dif<=20 ],pch=15,col=rgb(0,0,0,0.5))
points(a1$dif[a1$dif>=-20 & a1$dif<=20 ],a1$avg[a1$dif>=-20 & a1$dif<=20 ],pch=19,col=rgb(0,0,0,0.5))

model <- cbind(a2$dif,a2$avg)
colnames(model) <- c("ts","p")
model <- as.data.frame(model)
fit <-glm(model[,2]~model[,1],family=quasibinomial,weights = a2$count)

x <- seq(-20,20,by=0.01)

beta<-coef(fit)
lines(x,exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x)),col=1,lwd=2,lty=2)
abline(h=0.5,lty=2)
abline(v=0,lty=2)  

model <- cbind(a1$dif,a1$avg)
colnames(model) <- c("ts","p")
model <- as.data.frame(model)
fit <-glm(model[,2]~model[,1],family=quasibinomial,weights = a1$count)

beta<-coef(fit)
lines(x,exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x)),col=1,lwd=2)
abline(h=0.5,lty=2)
abline(v=0,lty=2)  


avg <- a2$avg[a2$dif>=-20 & a2$dif<=20 ]
count <- a2$count[a2$dif>=-20 & a2$dif<=20 ]
dif <- a2$dif[a2$dif>=-20 & a2$dif<=20 ]
for(n_desvios in seq(3,4)){
  sup <- avg + n_desvios* sqrt((1/count)*avg*(1-avg))
  inf <- avg - n_desvios* sqrt((1/count)*avg*(1-avg))
  
  polygon(c(dif,rev(dif)), c(sup,rev(inf)),col = rgb(0,0,0,0.2),border = F)
}

avg <- a1$avg[a1$dif>=-20 & a1$dif<=20 ]
count <- a1$count[a1$dif>=-20 & a1$dif<=20 ]
dif <- a1$dif[a1$dif>=-20 & a1$dif<=20 ]
for(n_desvios in seq(3,4)){
  sup <- avg + n_desvios* sqrt((1/count)*avg*(1-avg))
  inf <- avg - n_desvios* sqrt((1/count)*avg*(1-avg))
  
  polygon(c(dif,rev(dif)), c(sup,rev(inf)),col = rgb(0,0,0,0.2),border = F)
}

legend(-20,1, 
       c("1 vs 1","2 vs 2"),
       lwd=c(2,2),lty=c(1,2), pch=c(19,15), col=1, cex=1.33, box.lty=0, bg="transparent")





dev.off()
setwd(oldwd)
par(oldpar, new=F)

