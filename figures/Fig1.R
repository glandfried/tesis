###########################################
# Header
oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"))
setwd(this.dir)
#setwd("~/gaming/materias/inferencia_bayesiana/trabajoFinal/imagenes")
#####################################
par(mar=c(3.75,3.75,.33,.33))

ls <- list()
ls[["ls1000"]] <- read.csv("data/learningskill_activos1024_.csv", header =T)
ls[["ls500"]] <- read.csv("data/learningskill_activos512_1024.csv", header =T)
ls[["ls200"]] <- read.csv("data/learningskill_activos256_512.csv", header =T)
ls[["ls100"]] <- read.csv("data/learningskill_activos128_256.csv", header =T)
ls[["ls70"]] <- read.csv("data/learningskill_activos64_128.csv", header =T)
ls[["ls40"]] <- read.csv("data/learningskill_activos32_64.csv", header =T)
ls[["ls20"]] <- read.csv("data/learningskill_activos16_32.csv", header =T)
ls[["ls10"]] <- read.csv("data/learningskill_activos8_16.csv", header =T)

#ls_all <- read.csv("../Datos/learningskill.csv", header =T)

grilla <- rev(2^seq(3,3+7))

ylim = c(min(log(ls[["ls10"]][,"avg"],10)),max(log(ls[["ls1000"]][,"avg"],10)))
xlim=c(0,3)
col = seq(0,0.8,length.out = 8)
colores <- matrix(NA,nrow = 8,ncol=1)
colores[1] = rgb(col[1],col[1],col[1])
plot(log(ls[["ls1000"]][,"rn"],10),log(ls[["ls1000"]][,"avg"],10),lwd=1,ylim=ylim,xlim=xlim,
     type="l",axes=F,ylab="",xlab="",col=colores[1])
c<-1
for (i in grilla[-1]){
  c<-c+1
  colores[c] = rgb(col[c],col[c],col[c])
  str <- paste0("ls",toString(i))
  lines(log(ls[[c]][,"rn"],10),log(ls[[c]][,"avg"],10),lwd=1,
        col=colores[c])
}

#lines(log(seq(1,1024),10),log(ls_all[,"avg"][1:1024],10),lwd=1, lty=3)

at.x <- log(outer(1:9, 10^(0:3)),10)
lab.x <- ifelse(at.x %% 1 == 0, at.x, NA)[1,]
lab.x <- lab.x[lab.x>=0& lab.x<=3]
labels.x <- sapply(lab.x,function(i)
  as.expression(bquote(10^ .(i)))
)
at.x <- c(at.x[-1,])[c(at.x[-1,])<=3 & c(at.x[-1,])>=0 ]

axis(lwd=0,lwd.ticks=1,side=1, at=at.x,labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=1, at=lab.x, labels=NA,cex.axis=0.6,tck=0.03,col=1)
axis(lwd=0,side=1, at=lab.x, labels=labels.x,las=1,cex.lab=0.6,tck=0.08,line=-0.5
     ,cex.axis=1.33)


lab.y<-axis(lwd=0,lwd.ticks=0,labels=NA, side=2,cex.axis=0.6,tck=0.03) 

labels.y <- round(10^lab.y,2)

axis(lwd=0,lwd.ticks=1,labels=NA, side=2,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=2, at=lab.y, labels=labels.y,cex.lab=0.6,tck=0.08,line=-0.5,cex.axis=1.33)

box()

mtext(side=1,"Games played", line=2,cex=2)
mtext(side=2,"Skill", line=2,cex=2)

legend(1.85,ylim[2] - (ylim[2]-ylim[1])*0.3,ncol=2,
       title = expression(Subpopulation~(2^n)),
       c("1024","512","256","128"
         ,"64","32","16","8"),
       lwd=c(8),col=colores, cex=1.25, box.lty=0, bg="transparent")


########
# ZOOM #
########




par(xpd=TRUE)

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.525
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.025
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.12  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.55
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)


curve <- read.csv("data/learningskill_curve2.csv")

plot(log(grilla,10),curve[,1][curve[,3] %in% grilla],type="l",axes=F,ylab="",xlab="")
points(log(grilla,10),curve[,1][curve[,3] %in% grilla],pch=19,cex=0.5)
box()


at.y <- log(outer(1:9, 10^(1:3)),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
lab.y <- lab.y[lab.y>=1& lab.y<=3]
labels <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)
at.y <- c(at.y[-1,])[c(at.y[-1,])<=3 & c(at.y[-1,])>=1 ]

axis(lwd=0,lwd.ticks=1,side=1, at=at.y,labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=1, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03,col=1)
axis(lwd=0,side=1, at=lab.y, labels=labels,las=1,cex.lab=0.6,line=-0.75)


lab.y<-axis(lwd=0,lwd.ticks=0,labels=NA, side=2,cex.axis=0.6,tck=0.03) 

labels.y <- round(10^lab.y,2)

axis(lwd=0,lwd.ticks=1,labels=NA, side=2,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=2, at=lab.y, labels=labels.y,cex.lab=0.6,line=-0.75)



mtext(side=1,"Subpopulation", line=1.33,cex=1.25)
mtext(side=2,expression(Skill[0]), line=1.33,cex=1.25)

plotdim <- par("plt")
xleft    = plotdim[1] + (plotdim[2] - plotdim[1]) * 0.2
xright   = plotdim[2] - (plotdim[2] - plotdim[1]) * 0.45
ybottom  = plotdim[3] + (plotdim[4] - plotdim[3]) * 0.7  #
ytop     = plotdim[4] - (plotdim[4] - plotdim[3]) * 0.025
region <-c(xleft,xright,ybottom,ytop)
# add inset
par(fig = region, mar=c(0,0,0,0), new=TRUE)



curve <- read.csv("data/learningskill_curve2.csv")

#max( 25 * 1000^curve[,"alpha"][curve[,"rn"]>16])-min( 25* 1000^curve[,"alpha"][curve[,"rn"]>16])

min.a <- min(curve[,2])
max.a <- max(curve[,2])

#ylim <- c(min.a,max.a)
ylim <- c(0.01,0.021)

plot(log(grilla,10),curve[,2],type="l",axes=F,ylab="",xlab="",ylim=ylim)
points(log(grilla,10),curve[,2][curve[,3] %in% grilla],pch=19,cex=0.5)
box()

at.y <- log(outer(1:9, 10^(1:3)),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
lab.y <- lab.y[lab.y>=1& lab.y<=3]
labels <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)
at.y <- c(at.y[-1,])[c(at.y[-1,])<=3 & c(at.y[-1,])>=1 ]

axis(lwd=0,lwd.ticks=1,side=1, at=at.y,labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=1, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03,col=1)
axis(lwd=0,side=1, at=lab.y, labels=labels,las=1,cex.lab=0.6,line=-0.75)
axis(lwd=0,lwd.ticks=1,at=c(0.01,0.02),labels=NA, side=2,cex.axis=0.6,tck=0.03) 
axis(lwd=0,side=2, at=c(0.01,0.02),cex.lab=0.6,line=-0.75)

mtext(side=1,"Subpopulation", line=1.33,cex=1.25)
mtext(side=2,expression(alpha), line=1.33,cex=1.25)


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################

##########
# Rectas
#grow <- c()
#plot(log(grilla,10),curve[1,"Intercept"]+log(grilla,10)*curve[1,"alpha"],type="l")
#for (g in seq(2,dim(curve)[1])){
#  lines(log(grilla,10),curve[g,"Intercept"]+log(grilla,10)*curve[g,"alpha"],type="l")
#  c <- (10^(curve[g,"Intercept"]+3*curve[g,"alpha"]) - 10^(curve[g,"Intercept"]))
#  grow <-c(grow,c)
#}
#max(grow)-min(grow)
#############

