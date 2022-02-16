oldpar <- par(no.readonly = TRUE)

# No hace falta tanta generalidad
# oldwd <- getwd()
# this.dir <- dirname(parent.frame(2)$ofile)
# setwd(this.dir)
# nombre.R <-  sys.frame(1)$ofile
# require(tools)
# nombre <- print(file_path_sans_ext(nombre.R))
# pdf(paste0(nombre,".pdf"))

# El nombre del archivo de salida est'a fijo.
nombre <- 'Fig3.pdf'
pdf(nombre)
par(mar=c(3.75,3.75,.33,.33))

alpha = 0.05

lst89_summary <- read.csv("data/lstSup_summary.csv")
lst89 <- lst89_summary[,"median"]
nn.89 <- lst89_summary[,"count"] 
zz.89 <- 2 #qt(1 - alpha/2, nn.89 - 1)
aa.89 <- lst89_summary[,"w_ic_i"] #lst89[,"avg"]  - zz.89 * lst89[,"stddev_pop"] /sqrt(nn.89)
bb.89 <- lst89_summary[,"w_ic_s"] #lst89[,"avg"]  + zz.89 * lst89[,"stddev_pop"] /sqrt(nn.89)

lst01_summary <- read.csv("data/lstInf_summary.csv")
lst01 <- lst01_summary[,"median"]
nn.01 <- lst01_summary[,"count"] 
aa.01 <- lst01_summary[,"w_ic_i"] 
bb.01 <- lst01_summary[,"w_ic_s"]

lst_summary <- read.csv("data/lst89_summary.csv")
lst <- lst_summary[,"median"]
nn <- lst_summary[,"count"] 

rn.max <- 500

ls <- read.csv("data/learningskill.csv", header =T)
ls <- ls[1:rn.max,]
nn.a <- ls[,4]



y.max <- max(c(bb.89,bb.01))
y.min <- min(c(min(lst01, na.rm = T),min(ls[,"avg"], na.rm = T)
               , min(lst89, na.rm = T)))




plot(ls[,2][1:rn.max], type="l",ylab="",col="white", 
     ylim=c(y.min, y.max), xlim=c(1,rn.max)
     ,xlab="",axes=F)
mtext("Skill", side=2, line=2,cex = 1.75)
mtext("Games played", side=1, line=2,cex = 1.75)
#mtext("Population: all players. Subpopulation: players with all game finished", side=1, line=3, cex=0.85)

#lines(ls[,2][1:rn.max],lwd=3,col="gray")
lines(ls[,2][1:rn.max],lwd=1)
lines(lst,lwd=2,lty=3)
lines(lst01,lwd=1.33,lty=3)
lines(lst89,lwd=1.33,lty=3)
box()
y.at =seq(ceiling(y.min), floor(y.max))
x.at = seq(0,rn.max,by=50)
axis(lwd=0,lwd.ticks=1,side=2, at=y.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,lwd.ticks=1,side=1, at=x.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(lwd=0,side=1, line=-0.66,cex.axis=1.33) 

abline(v=100,lty=2,lwd=0.5)

mod <- rn.max%/%16
Z5.1 <- seq(rn.max)%%mod==1
lst01.points <- lst01;lst.points <- lst; lst89.points <- lst89
lst01.points[!Z5.1] <- NA;lst.points[!Z5.1] <- NA;lst89.points[!Z5.1] <- NA
lst.points<-lst
lst.points[!Z5.1] <- NA

#points(lsc.points, pch=15, cex=0.66)
#points(ls.points, pch=1,lwd=1.33,cex=1.33)
points(lst01.points,pch=8,lwd=1.33,cex=1.33)
points(lst.points, pch=1,lwd=1.33,cex=1.33)
points(lst89.points,pch=0,lwd=1.33,cex=1.33)


polygon(c(1:500,rev(1:500)),
        c(aa.01, rev(bb.01)), 
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)

polygon(c(1:500,rev(1:500)),
        c(aa.89, rev(bb.89)), 
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)

par(xpd=TRUE)
legend(300,29.25,
       c("All players","Strong TOB ","Loyal subclass", "Casual subclass"),
       lty=c(1,3,3,3),pch=c(NA,1,0,8),
       lwd=c(1,1.75,1.33,1.33),cex=1.33, box.lty=0, bg="transparent")

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.475
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.025
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.075  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.425
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)

count.max<-max(c(log(nn.01,10),
                 log(nn,10),
                 log(nn.89,10)),
               na.rm=T)
count.min<-min(c(log(nn.01,10),
                 log(nn,10),
                 log(nn.89,10)),
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



plot(log(nn.01,10),type="l"
     , ylim=c(min(at.y),max(at.y)), xlim=c(1,rn.max), 
     axes=F,ann=F,lty=3)
lines(log(nn,10),lty=3,lwd=2)
lines(log(nn.89,10),lty=3)

mod <- rn.max%/%16
Z.1 <- seq(rn.max)%%mod==1
lst01.count <- log(nn.01,10);lst.count <- log(nn,10);
lst89.count <- log(nn.89,10);
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
# setwd(oldwd)
par(oldpar, new=F)
