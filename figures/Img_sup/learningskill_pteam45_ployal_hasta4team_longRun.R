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




lst89 <- read.csv("data/learningskill_pteam45_ployalSuperior_hasta4team.csv", header =T)
rn.max<-500
lst89 <- lst89[1:rn.max,] 
nn.89 <- lst89[,"count"] 
zz.89 <- 2#qt(1 - alpha/2, nn.89 - 1)
aa.89 <- lst89[,"avg"]  - zz.89 * lst89[,"stddev_pop"] /sqrt(nn.89)
bb.89 <- lst89[,"avg"]  + zz.89 * lst89[,"stddev_pop"] /sqrt(nn.89)

lst01 <- read.csv("data/learningskill_pteam45_ployalInferior_hasta4team.csv", header =T)
lst01 <- lst01[1:rn.max,] 
nn.01 <- lst01[,"count"] 
zz.01 <- 2#qt(1 - alpha/2, nn.01 - 1)
aa.01 <- lst01[,"avg"]  - zz.01 * lst01[,"stddev_pop"] /sqrt(nn.01)
bb.01 <- lst01[,"avg"]  + zz.01 * lst01[,"stddev_pop"] /sqrt(nn.01)

lst <- read.csv("data/learningskill_pteam45_hasta4team.csv", header =T)
lst <- lst[1:rn.max,]
nn <- lst[,"count"] 
zz <- 2#qt(1 - alpha/2, nnlearningskill_pteam45_ployalInferior_hasta4team.csv - 1)
aa <- lst[,"avg"]  - zz * lst[,"stddev_pop"] /sqrt(nn)
bb <- lst[,"avg"]  + zz * lst[,"stddev_pop"] /sqrt(nn)

lsm <- read.csv("data/learningskill_pteam89_ployalSup_hasta4team.csv", header =T)
rn.max<-500
lsm <- lsm[1:rn.max,] 
nn.m <- lsm[,"count"] 
zz.m <- qt(1 - alpha/2, nn.m - 1)
aa.m <- lsm[,"avg"]  - zz.m * lsm[,"stddev_pop"] /sqrt(nn.m)
bb.m <- lsm[,"avg"]  + zz.m * lsm[,"stddev_pop"] /sqrt(nn.m)


ls <- read.csv("data/learningskill.csv", header =T)
ls <- ls[1:rn.max,]
nn.a <- ls[,4]
zz.a <- qt(1 - alpha/2, nn.a - 1)
aa.a <- ls[,2] - zz.a * ls[,3]/sqrt(nn.a)
bb.a <- ls[,2] + zz.a * ls[,3]/sqrt(nn.a)



y.max <- max(c(bb.89,bb.a,bb.m))
y.min <- min(c(min(lst01[,2], na.rm = T),min(ls[,2], na.rm = T)
               , min(lst89[,2], na.rm = T)))




plot(ls[,2][1:rn.max], type="l",ylab="",col="white", 
     ylim=c(y.min, y.max), xlim=c(1,rn.max)
     ,xlab="",axes=F)
mtext("Skill", side=2, line=2,cex = 2)
mtext("Games played", side=1, line=2,cex = 2)
#mtext("Population: all players. Subpopulation: players with all game finished", side=1, line=3, cex=0.85)

#lines(ls[,2][1:rn.max],lwd=3,col="gray")
lines(ls[,2][1:rn.max],lwd=1)
lines(lst[,2][1:rn.max],lwd=1.33,lty=3)
lines(lst01[,2][1:rn.max],lwd=1.33,lty=3)
lines(lst89[,2][1:rn.max],lwd=1.33,lty=3)
box()
y.at =seq(ceiling(y.min), floor(y.max))
x.at = seq(0,rn.max,by=50)
axis(lwd=0,lwd.ticks=1,side=2, at=y.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,lwd.ticks=1,side=1, at=x.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(lwd=0,side=1, line=-0.66,cex.axis=1.33) 


mod <- rn.max%/%16
Z5.1 <- seq(rn.max)%%mod==1
lst01.points <- lst01[,2][1:rn.max];lst.points <- lst[,2][1:rn.max]; lst89.points <- lst89[,2][1:rn.max]
lst01.points[!Z5.1] <- NA;lst.points[!Z5.1] <- NA;lst89.points[!Z5.1] <- NA
lst.points<-lst[,2][1:rn.max]
lst.points[!Z5.1] <- NA

#points(lsc.points, pch=15, cex=0.66)
#points(ls.points, pch=1,lwd=1.33,cex=1.33)
points(lst01.points,pch=8,lwd=1.33,cex=1.33)
points(lst.points, pch=2,lwd=1.33,cex=1.33)
points(lst89.points,pch=0,lwd=1.33,cex=1.33)


polygon(c(lst01[,1],rev(lst01[,1])),
        c(aa.01, rev(bb.01)), 
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)
#polygon(c(lst[,1],rev(lst[,1])),
#        c(aa, rev(bb)), 
#        col = rgb(0, 0, 0, 0.2),lty=2, border=F)
polygon(c(lst89[,1],rev(lst89[,1])),
        c(aa.89, rev(bb.89)), 
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)

par(xpd=TRUE)
legend(0,y.max,
       c("All players","Medium TOB ","Loyal subclass", "Casual subclass"),
       lty=c(1,3,3,3),pch=c(NA,2,0,8),
       lwd=c(1,1.33,1.33,1.33),cex=1.33, box.lty=0, bg="transparent")

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.475
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.025
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.075  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.425
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)

count.max<-max(c(log(lst01[,"count"],10),
                 log(lst[,"count"],10),
                 log(lst89[,"count"],10)),
               na.rm=T)
count.min<-min(c(log(lst01[,"count"],10),
                 log(lst[,"count"],10),
                 log(lst89[,"count"],10)),
               na.rm=T)
ys.min <- count.min
ys.max<- count.max



at.y <- log(outer(1:9, 10^(floor(ys.min):ceiling(ys.max))),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
lab.y <- lab.y[lab.y>=signif(ys.min,2) & lab.y<=signif(ys.max,2)]
labels <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)

labelsOk <-  c(at.y)<=signif(ys.max,2) & c(at.y)>=signif(ys.min,2)

for (i in seq(1,length(labelsOk)-1)){
  if (labelsOk[i]==F & labelsOk[i+1]==T){
    labelsOk[i]=T
  }
  if (labelsOk[i]==T & labelsOk[i+1]==F){
    labelsOk[i+1]=T 
    break
  }
}

at.y <- c(at.y)[labelsOk]



plot(log(lst01[,"count"],10),type="l"
     , ylim=c(min(at.y),max(at.y)), xlim=c(1,rn.max), 
     axes=F,ann=F,lty=3)
lines(log(lst[,"count"],10),lty=3)
lines(log(lst89[,"count"],10),lty=3)

mod <- rn.max%/%16
Z.1 <- seq(rn.max)%%mod==1
lst01.count <- log(lst01[,"count"],10);lst.count <- log(lst[,"count"],10);
lst89.count <- log(lst89[,"count"],10);
lst01.count[!Z.1] <- NA;lst.count[!Z.1] <- NA;lst89.count[!Z.1] <- NA

points(lst01.count,pch=8,lwd=1.33,cex=1.33)
points(lst.count, pch=1,lwd=1.33,cex=1.33)
points(lst89.count,pch=0,lwd=1.33,cex=1.33)

axis(side=2, at=at.y, labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=2, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03)
axis(lwd=0,side=2, at=lab.y, labels=labels,las=1,cex.lab=0.6,tck=0.08,line=-0.9)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(labels=NA, side=1,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=1, line=-0.9,cex.lab=0.6) 

mtext(side=2,"Population size", line=1.66,cex=1.33)


dev.off()
setwd(oldwd)
par(oldpar, new=F)
