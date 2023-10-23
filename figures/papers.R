oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"), width = 8, height = 5  )
setwd(this.dir)
###############################


papers = read.csv("../static/papers.csv")

filtro <- papers[,"Año"] > 0

length(filtro )
sum(filtro)

hist.data <- hist(papers[filtro,"Año"], breaks = seq(1974-0.5, 2023 + 0.5, by=1) )
hist.data$counts = log10(hist.data$counts)
hist.data$counts[c(1,4,6)] <- NA

plot(hist.data$mids[-length(hist.data$mids)], hist.data$counts[-length(hist.data$mids)], pch=19, ,axes = F,ann = F, cex=1)

segments(x0=hist.data$mids[-length(hist.data$mids)], x1=hist.data$mids[-length(hist.data$mids)], y0=0, y1=hist.data$counts[-length(hist.data$mids)])

at.y <- log(outer(1:9, 10^(0:3)),10)
lab.y <- ifelse(at.y %% 1 == 0, at.y, NA)[1,]
labels.y <- sapply(lab.y,function(i)
  as.expression(bquote(10^ .(i)))
)

axis(lwd=1,lwd.ticks=1,side=2, at=at.y,labels=NA,cex.axis=0.6,tck=0.0133)
axis(lwd=0,lwd.ticks=1,side=2, at=lab.y, labels=NA,cex.axis=0.6,tck=0.03,col=1)
axis(lwd=0,side=2, at=lab.y, labels=labels.y,las=1,cex.lab=0.6,tck=0.08,line=-0.5
     ,cex.axis=1.5)


axis(side=1, labels=NA,at=seq(1975, 2020,by=5), cex.axis=0.6,tck=0.015)
axis(lwd=0,side=1,,at=seq(1975, 2020,by=5),cex.axis=1.5,line=-0.3)
mtext(text= "Año",side =1,line=2.5,cex=2)
mtext(text = "Cantidad de artículos" ,side =2,line=2.5,cex=2)


points(hist.data$mids[seq(1,16)], hist.data$counts[seq(1,16)], col=rev(rainbow(4))[1], pch=19,cex=1.1)

points(hist.data$mids[seq(17,24)], hist.data$counts[seq(17,24)], col=rev(rainbow(12))[5], pch=19,cex=1.1)

points(hist.data$mids[seq(25,39)], hist.data$counts[seq(25,39)], col=rev(rainbow(14))[9], pch=19,cex=1.1)


points(hist.data$mids[seq(40,48)], hist.data$counts[seq(40,48)], col=rev(rainbow(20))[19], pch=19,cex=1.1)


points(hist.data$mids[49], hist.data$counts[49], col="white", pch=19, cex=1.1)
points(hist.data$mids[49], hist.data$counts[49], cex=1.1)

legend(1975, log10(1600), legend=rev(c("1975-1989", "1990-1997", "1998-2012", "2013-20??")), pch=19,cex=1.75, col=c(rev(rainbow(20))[19], rev(rainbow(14))[9], rev(rainbow(12))[5], rev(rainbow(4))[1]), bty = "n" )

#######################################
# end
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
