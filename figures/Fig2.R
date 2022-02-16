oldpar <- par(no.readonly = TRUE)

# No hace falta tanta generalidad.
# oldwd <- getwd()
# this.dir <- dirname(parent.frame(2)$ofile)
# nombre.R <-  sys.frame(1)$ofile
# require(tools)
# nombre <- print(file_path_sans_ext(nombre.R))
# pdf(paste0(nombre,".pdf"))
# setwd(this.dir)

# El nombre del archivo de salida est'a fijo.
nombre <- 'Fig2.pdf'
pdf(nombre)
par(mar=c(3.75,3.75,.33,.33))

lst89_summary <- read.csv("data/lst89_summary.csv")
lst45_summary <- read.csv("data/lst45_summary.csv")
lst01_summary <- read.csv("data/lst01_summary.csv")

lst89 <- lst89_summary[,"median"]
lst89.c <- lst89_summary[,"count"]
aa.89 <- lst89_summary[,"w_ic_i"]
bb.89 <- lst89_summary[,"w_ic_s"]

lst01 <- lst01_summary[,"median"]
lst01.c <- lst01_summary[,"count"]
aa.01 <- lst01_summary[,"w_ic_i"]
bb.01 <- lst01_summary[,"w_ic_s"]

lst45 <- lst45_summary[,"median"]
lst45.c <- lst45_summary[,"count"]
aa.45 <- lst45_summary[,"w_ic_i"]
bb.45 <- lst45_summary[,"w_ic_s"]

rn.max<-500

ls <- read.csv("data/learningskill.csv", header =T)
ls <- ls[1:rn.max,]

y.max <- max(bb.89)
y.min <- min(c(min(lst01, na.rm = T),min(lst45, na.rm = T), min(lst89, na.rm = T)
               ,min(ls[,2], na.rm = T)))



# example - output graph to jpeg file


plot(1, type="l",ylab="",col="white", ylim=c(y.min, y.max), xlim=c(1,rn.max)
     ,xlab="",axes=F)
mtext("Skill", side=2, line=2,cex = 2)
mtext("Games played", side=1, line=2,cex = 2)
#mtext("Population: all players. Subpopulation: players with all game finished", side=1, line=3, cex=0.85)

lines(lst89,lty=3)
lines(lst45,lty=3)
lines(lst01,lty=3)
lines(ls[,"avg"][1:rn.max],lwd=2)

box()
y.at =seq(ceiling(y.min), floor(y.max))
x.at = seq(0,500,by=100)
axis(lwd=0,lwd.ticks=1,side=2, at=y.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,lwd.ticks=1,side=1, at=x.at,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.25,line=-0.66)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(lwd=0,side=1, line=-0.66,cex.axis=1.25) 



mod <- rn.max%/%16
Z5.1 <- seq(rn.max)%%mod==1
lst01.points <- lst01;lst45.points <- lst45; lst89.points <- lst89
lst01.points[!Z5.1] <- NA;lst45.points[!Z5.1] <- NA;lst89.points[!Z5.1] <- NA

mod <- rn.max%/%6
Z5.1 <- seq(rn.max)%%mod==1
ls.points<-ls[,2][1:rn.max]
ls.points[!Z5.1] <- NA

#points(lsc.points, pch=15, cex=0.66)
#points(ls.points, pch=19, cex=0.66)
points(lst01.points,pch=4,lwd=1.33,cex=1.33)
points(lst45.points, pch=2,lwd=1.33,cex=1.33)
points(lst89.points,lwd=1.33,cex=1.33)


polygon(c(1:500 ,rev(1:500)),
          c(aa.01, rev(bb.01)), 
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)
polygon(c(1:500 ,rev(1:500)),
        c(aa.45, rev(bb.45)),
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)
polygon(c(1:500 ,rev(1:500)),
        c(aa.89, rev(bb.89)),
        col = rgb(0, 0, 0, 0.2),lty=2, border=F)
#polygon(c(ls[,1],rev(ls[,1])),
#        c(aa, rev(bb)), 
#        col = rgb(0, 0, 0, 0.33), border=F)
#polygon(c(lsc[,1] ,rev(lsc[,1] )),
#        c(aa.c, rev(bb.c)), 
#        col = rgb(0, 0, 0, 0.33),lty=2, border=F)





par(xpd=TRUE)
legend(-20,32.1,
       c("All players"),
       lwd=c(2),cex=1.33,box.lty=0, bg="transparent")
text(135,31.3,"Team-oriented behavior:",cex = 1.33)
legend(-10,31.3,
       c("Strong", "Medium", "Weak"),
       lty=c(3,3,3),pch=c(1,2,4),
       cex=1.33,box.lty=0, bg="transparent")

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.325
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.025
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.075  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.375
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)

count.max<-max(c(log(lst01.c,10),
                 log(lst45.c,10),
                 log(lst89.c,10),
                 log(ls[,"count"],10)),
               na.rm=T)
count.min<-min(c(log(lst01.c,10),
                 log(lst45.c,10),
                 log(lst89.c,10),
                 log(ls[,"count"],10)),
               na.rm=T)
ys.min <- count.min
ys.max<- count.max

plot(log(lst01.c,10),type="l"
     , ylim=c(signif(count.min,2),signif(count.max,2) ), xlim=c(1,rn.max), 
     axes=F,ann=F,lty=3)
lines(log(lst45.c,10),lty=3)
lines(log(lst89.c,10),lty=3)
lines(log(ls[,"count"],10),lwd=2)



mod <- rn.max%/%16
Z.1 <- seq(rn.max)%%mod==1
lst01.count <- log(lst01.c,10);lst45.count <- log(lst45.c,10);
lst89.count <- log(lst89.c,10);
lst01.count[!Z.1] <- NA;lst45.count[!Z.1] <- NA;lst89.count[!Z.1] <- NA

points(lst01.count,pch=4,lwd=1.33,cex=1.33)
points(lst45.count, pch=2,lwd=1.33,cex=1.33)
points(lst89.count,lwd=1.33,cex=1.33)


at.y <- log(outer(1:9, 10^(floor(ys.min):ceiling(ys.max))),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
lab.y <- lab.y[lab.y>=signif(ys.min,2) & lab.y<=signif(ys.max,2)]
labels <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)

at.y <- c(at.y)[c(at.y)<=signif(ys.max,2) & c(at.y)>=signif(ys.min,2)]


axis(side=2, at=at.y, labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=2, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03)
axis(lwd=0,side=2, at=lab.y, labels=labels,las=1,cex.lab=0.6,tck=0.08,line=-0.9)
#axis(lwd=0,side=2, at=round(seq(ys.min,ys.max,length.out = 4),2),line=-0.5,cex.axis=0.6) 
axis(labels=NA, side=1,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=1, line=-0.9,cex.lab=0.6) 

mtext(side=2,"Population size", line=1.66,cex=1.33)


#######################################
# t-test for each point of experiencie
#f<-500
#count <- 0
#pvalues2 <- rep(NA,f)
#for (i in 1:f){
#  pvalue <- 2*pt(-abs((lst01[i,"avg"] - lst89[i,"avg"]) 
#                      * sqrt(lst89[i,"count"])/lst89[i,"stddev_pop"]), 
#                 lst89[i,"count"] - 1)
#  if (pvalue > 0.01 ){count <- count + 1} 
#  pvalues2[i]<-pvalue
#}
#count/f
#plot(pvalues2,type="l")
#############################################

#############################################
# Wilcoxon TEST

#lst89.500 <- read.csv("../Datos/learningskill_pteam89_hasta4team_skill500.csv", header =T)
#lst45.500 <- read.csv("../Datos/learningskill_pteam45_hasta4team_skill500.csv", header =T)
#lst01.500 <- read.csv("../Datos/learningskill_pteam10_hasta4team_skill500.csv", header =T)

#wilcox.test(lst45.500[[1]],lst01.500[[1]])
#wilcox.test(lst45.500[[1]],lst89.500[[1]])
#wilcox.test(lst89.500[[1]],lst01.500[[1]])[["p.value"]]

#ks.test(lst45.500[[1]], "pnorm", mean(lst45.500[[1]]), sd(lst45.500[[1]])) 
###########################

dev.off()
# setwd(oldwd)
par(oldpar, new=F)

