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
#####################################
par(mar=c(3.75,3.75,.75,.75))



beta <- 2000/7
s_1 <- 2000
s_2 <- 1750
dif_1_2 <-  s_1-s_2
D <- ( -1200+dif_1_2):(1200+dif_1_2)

dnormal <- dnorm(D,s_1-s_2,beta)
plot(D,dnormal, type="l",lwd=1, xlab=expression(P[1]-P[2]),axes = F,ann = F)

axis(side=2, labels=NA,cex.axis=0.6,tck=0.015)
axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
axis(lwd=0,side=1, at=0,las=0,cex.axis=1.33,line=-0.6)
axis(lwd=0,side=1, at=250,labels=expression( (s[i]-s[j]) ),las=0,cex.axis=1.33,line=-0.3)
mtext(text ="Density" ,side =2 ,line=2,cex=1.75)
mtext(text =expression(d[i][j]) ,side =1 ,line=2.5,cex=1.75)
abline(v=250,lty=3)

segments(0,0,0,dnorm(0,s_1-s_2,beta))
base <- rep(0,length(D))
xx <- c(D[D>=0],rev(D[D>=0]))
yy <- c(base[D>=0],rev(dnormal[D>=0]) )
polygon(xx,yy,col=rgb(0,0,0,0.4))
xx <- c(D[D<=0],rev(D[D<=0]))
yy <- c(base[D<=0],rev(dnormal[D<=0]) )
polygon(xx,yy,col=rgb(0,0,0,0.1))
x2 <- -200
h <- dnormal[D==x2]/4
text(500,h, "Win i", col = 1, cex=1.33)
text(x2,h, "Win j", col = 1, cex=1.33)


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################
