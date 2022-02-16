oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- "posteriors"
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"), width = 8, height = 5  )
setwd(this.dir)
###############################

par(mar=c(3.75,3.75,0.25,0.25))
#>>> p1 = Player(Gaussian(5,1),1,0)
#>>> p2 = Player(Gaussian(0,3),1,0)
# [Gaussian(mu=4.454215, sigma=0.964121)]
# [Gaussian(mu=4.912068, sigma=1.814344)]
#g = ttt.Game([[p1],[p2]],[0.0,1.0])
# [Gaussian(mu=5.043907, sigma=0.989837)]
# [Gaussian(mu=-0.395162, sigma=2.713298)]

s = seq(-10,10,by=0.01)

plot(s,dnorm(s,5,1),type="l",lwd=4, col=rgb(0.6,0.1,0.1),lty=1,axes = F,ann = F)
lines(s,dnorm(s,0,3),lwd=4, col=rgb(0.1,0.6,0.1),lty=1)
lines(s,dnorm(s,4.45,0.964),lwd=2, col=rgb(0.6,0.1,0.1,1),lty=5)
lines(s,dnorm(s,4.91,1.81),lwd=2, col=rgb(0.1,0.6,0.1,1),lty=5)
axis(side=2, labels=NA,cex.axis=0.6,tck=0.015)
axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
axis(lwd=0,side=1, cex.axis=1.25,line=-0.3)
axis(lwd=0,side=2, cex.axis=1.25,line=-0.3)
mtext(text ="Density" ,side =2,line=2,cex=1.75)  
mtext(text ="Skill" ,side =1,line=2,cex=1.75)  
legend(-9.5,0.4,lty=c(1,1,5,5),lwd=c(4,4,2,2),col=c(rgb(0.1,0.6,0.1,1),rgb(0.6,0.1,0.1,1)), legend = c("Player's prior","Opponent's prior","Player's posterior", "Opponent's posterior"),bty = "n",cex = 1.5)


plot(s,dnorm(s,5,1),type="l",lwd=4, col=rgb(0.6,0.1,0.1),lty=1,axes = F,ann = F)
lines(s,dnorm(s,0,3),lwd=4, col=rgb(0.1,0.6,0.1),lty=1)
lines(s,dnorm(s,5.043,0.9898),lwd=2, col=rgb(0.6,0.1,0.1,1),lty=5)
lines(s,dnorm(s,-0.395,2.713),lwd=2, col=rgb(0.1,0.6,0.1,1),lty=5)
points(0,max(dnorm(s,4.45,0.964)),col=rgb(0.9,0.9,0.9,0.1),cex=0.1)
axis(side=2, labels=NA,cex.axis=0.6,tck=0.015)
axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
axis(lwd=0,side=1, cex.axis=1.25,line=-0.3)
axis(lwd=0,side=2, cex.axis=1.25,line=-0.3)
mtext(text ="Density" ,side =2,line=2,cex=1.75)  
mtext(text ="Skill" ,side =1,line=2,cex=1.75)
legend(-9.5,0.4,lty=c(1,1,5,5),lwd=c(4,4,2,2),col=c(rgb(0.1,0.6,0.1,1),rgb(0.6,0.1,0.1,1)), legend = c("Player's prior","Opponent's prior","Player's posterior", "Opponent's posterior"),bty = "n",cex = 1.5)

#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################
