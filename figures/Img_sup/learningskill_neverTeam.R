oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))

par(mar=c(3.75,3.75,.33,.33))

alpha = 0.05
rn.max<-500


lsc <- read.csv("data/learningskill_comprometidos.csv", header =T)

lsc <- lsc[1:rn.max,]
nn.c <- lsc[,4]
zz.c <- 2#qt(1 - alpha/2, nn.c - 1)
aa.c <- lsc[,2]  - zz.c * lsc[,3] /sqrt(nn.c)
bb.c <- lsc[,2]  + zz.c * lsc[,3] /sqrt(nn.c)


lsnt <- read.csv("data/learningskill_neverTeam.csv", header =T)
lsnt <- lsnt[1:rn.max,]
nn.nt <- lsnt[,4]
zz.nt <- 2#qt(1 - alpha/2, nn.nt - 1)
aa.nt <- lsnt[,2]  - zz.nt * lsnt[,3] /sqrt(nn.nt)
bb.nt <- lsnt[,2]  + zz.nt * lsnt[,3] /sqrt(nn.nt)


ls <- read.csv("data/learningskill.csv", header =T)
ls <- ls[1:rn.max,]
nn <- ls[,4]
zz <- 2#qt(1 - alpha/2, nn - 1)
aa <- ls[,2] - zz * ls[,3]/sqrt(nn)
bb <- ls[,2] + zz * ls[,3]/sqrt(nn)




lst89 <- read.csv("data/learningskill_pteam89.csv", header =T)
lst89 <- lst89[1:rn.max,]
nn.89 <- lst89[,"count"] 
zz.89 <- 2 #qt(1 - alpha/2, nn.89 - 1)
aa.89 <- lst89[,"avg"]  - zz.89 * lst89[,"stddev_pop"] /sqrt(nn.89)
bb.89 <- lst89[,"avg"]  + zz.89 * lst89[,"stddev_pop"] /sqrt(nn.89)

lst01 <- read.csv("data/learningskill_pteam10.csv", header =T)
lst01 <- lst01[1:rn.max,]
nn.01 <- lst01[,"count"] 
zz.01 <- 2#qt(1 - alpha/2, nn.01 - 1)
aa.01 <- lst01[,"avg"]  - zz.01 * lst01[,"stddev_pop"] /sqrt(nn.01)
bb.01 <- lst01[,"avg"]  + zz.01 * lst01[,"stddev_pop"] /sqrt(nn.01)

lst45 <- read.csv("data/learningskill_pteam45.csv", header =T)
lst45 <- lst45[1:rn.max,]
nn.45 <- lst45[,"count"] 
zz.45 <- 2#qt(1 - alpha/2, nn.45 - 1)
aa.45 <- lst45[,"avg"]  - zz.45 * lst45[,"stddev_pop"] /sqrt(nn.45)
bb.45 <- lst45[,"avg"]  + zz.45 * lst45[,"stddev_pop"] /sqrt(nn.45)

y.max <- max(bb.89,na.rn=T)
y.min <- min(c(min(lst01[,2], na.rm = T),min(lst45[,2], na.rm = T), min(lst89[,2], na.rm = T)
               ,min(lsc[,2], na.rm = T),min(ls[,2], na.rm = T)))
y.max<-31


plot(ls[,1],ls[,2],ylab="",xlab = "",col="white", ylim=c(y.min, y.max),axes=F)
mtext("Skill", side=2, line=2,cex = 2)
mtext("Games played", side=1, line=2,cex = 2)
#mtext("Population: all players. Subpopulation: players with all game finished", side=1, line=3, cex=0.85)
lines(ls[,2],lwd=1.33)

lines(lsnt[,2],lty=3,lwd=2)
box()
y.at =seq(ceiling(y.min), floor(y.max))
x.at = seq(0,500,by=100)
axis(lwd=0,lwd.ticks=1,side=2, at=y.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,lwd.ticks=1,side=1, at=x.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(lwd=0,side=1, line=-0.66,cex.axis=1.33) 


polygon(c(ls[,1],rev(ls[,1])),
        c(aa, rev(bb)), 
        col = rgb(0, 0, 0, 0.3), border=F)
#polygon(c(lsc[,1] ,rev(lsc[,1] )),
#        c(aa.c, rev(bb.c)), 
#        col = rgb(0, 0, 0, 0.3),lty=2, border=F)
polygon(c(lsnt[,1] ,rev(lsnt[,1] )),
        c(aa.nt, rev(bb.nt)), 
        col = rgb(0, 0, 0, 0.3),lty=2, border=F)



par(xpd=TRUE)
legend(-1,y.max+(y.max-y.min)*(0.05),
       c("All players",
         "Players without team games played"),
       lty=c(1,3),
       lwd=c(1.33,2),cex=1.33, box.lty=0, bg="transparent")



plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.325
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.025
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.075  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.375
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)

ys.max <- max(log(ls[,4][ls[,1]<=rn.max],10))
ys.min <- min(log(lsnt[,4],10))

plot(ls[,1][ls[,1]<=rn.max],log(ls[,4][ls[,1]<=rn.max],10), lty=1, type="l", cex.axis=0.7
     ,ylab="",ann=F,ylim=c(signif(ys.min,2),signif(ys.max,2)),
     axes=F ,lwd=1.33)
#axis(labels=NA, side=2, 
#     at=log(seq(1,ceiling((10^ys.max)/10000)*10000,by = 10),10),
#     cex.axis=0.6,tck=-0.01) 

at.y <- log(outer(1:9, 10^(floor(ys.min):ceiling(ys.max))),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
lab.y <- lab.y[lab.y>=signif(ys.min,2) & lab.y<=signif(ys.max,2)]
labels <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)

at.y <- c(at.y)[c(at.y)<=signif(ys.max) & c(at.y)>=signif(ys.min)]


axis(side=2, at=at.y, labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=2, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03)
axis(lwd=0,side=2, at=lab.y, labels=labels,las=1,cex.lab=0.6,tck=0.08,line=-0.9)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(labels=NA, side=1,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=1, line=-0.9,cex.lab=0.6) 

mtext(side=2,"Population size", line=1.66,cex=1.33)

#lines(lsc[,1] ,log(lsc[,4],10) , lty=2,lwd=1.33)
lines(lsnt[,1] ,log(lsnt[,4],10) , lty=3,lwd=2)


#######################################
# t-test for each point of experiencie
#f<-500
#count <- 0
#pvalues <- rep(NA,f)
#for (i in 1:f){
#  pvalue <- 2*pt(-abs((ls[i,"avg"] - lsnt[i,"avg"]) 
#     * sqrt(lsnt[i,"count"])/lsnt[i,"stddev_pop"]), 
#     lsnt[i,"count"] - 1)
#  if (pvalue > 0.01 ){count <- count + 1} 
#  pvalues[i]<-pvalue
#}
#count/f
#plot(pvalues)
# At each point the means of the populations are different
#########################################



dev.off()
setwd(oldwd)
par(oldpar, new=F)
