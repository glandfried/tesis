oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))



pdf(paste0(nombre,".pdf"))

par(mar=c(3.75,3.75,0.33,3.6))


a <- read.csv("data/skillProba3all.csv")
a <- a[a[,4]>24,]
min <- min(a[,1])
max <- max(a[,1])
l <- max-min+1
x <- min:max

proba <- matrix(NA, nrow=l,ncol=l)
colnames(proba) <- x
rownames(proba) <- x

i<-1
while (i < dim(a)[1] ){
  proba[toString(a[i,"dif1"]),toString(a[i,"dif2"])] <- a[i,"avg"]
  i <- i + 1
}
require(fields)
image(x,x,proba, col= rev(gray.colors(100)), xlab="", ylab="",axes=F)
image.plot(x,x,proba, col= rev(gray.colors(10)),legend.only = T,legend.line = 0,legend.mar = 3.2,
           legend.cex = 0.01, legend.width = 1)

contour(x,x,proba, add=T)
mtext("Skill difference", line=2, side=1,cex=1.75)
mtext("Skill difference", line=2, side=2,cex=1.75)
box()
axis(lwd=0,lwd.ticks=1,side=2,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,las=1,cex.axis=1.33,line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=1,las=1,cex.axis=1.33,line=-0.66)

abline(v=0,lty=2)
abline(h=0,lty=2)


dev.off()
setwd(oldwd)
par(oldpar, new=F)
