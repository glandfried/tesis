oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
nombre <- "tasa-temporal"
pdf(paste0(nombre,".pdf"), width = 8, height = 6  )
setwd(this.dir)
###############################

p = 0.5
b = seq(0.0,1.0,by=0.001)# estrategias (a veces ambiente)
e = b
Q = c(1.2,3)

coop_fitness = function(p,b,Q,m,N){
    return( (m/N)*(1-b)*Q[1] + ((N-m)/N)*(b)*Q[2])
}
coop_temporal_average = function(p,b,Q, N){
    res = 1.0
    p_fitness = dbinom(seq(0,N),size=N,prob=p)
    for(m in seq(0,N)){#r=0
        res = res * coop_fitness(p,b,Q,m,N)^p_fitness[m+1]
    }
    return(res)
}


colores = rainbow(5)

       
r = rep(0,length(b))
for(j in seq(1,length(e))){r[j] = coop_temporal_average(p=0.5,b=e[j],Q=Q,N=1)}
plot(e,r, ylim=c(0,1.5), type="l", lwd=4, ,axes = F,ann = F, col=
colores[1] )
points(e[which.max(r)],r[which.max(r)],pch=19,cex=2,col=colores[1])
for(j in seq(1,length(e))){r[j] = coop_temporal_average(p=0.5,b=e[j],Q=Q,N=2)}
lines(e,r, lwd=4, col=colores[2])
points(e[which.max(r)],r[which.max(r)],pch=19,cex=2,col=colores[2])
for(j in seq(1,length(e))){r[j] = coop_temporal_average(p=0.5,b=e[j],Q=Q,N=3)}
lines(e,r, lwd=4, col=colores[3] )
points(e[which.max(r)],r[which.max(r)],pch=19,cex=2,col=colores[3] )
for(j in seq(1,length(e))){r[j] = coop_temporal_average(p=0.5,b=e[j],Q=Q,N=4)}
lines(e,r, lwd=4, col=colores[4] )
points(e[which.max(r)],r[which.max(r)],pch=19,cex=2,col=colores[4] )
for(j in seq(1,length(e))){r[j] = coop_temporal_average(p=0.5,b=e[j],Q=Q,N=5)}
lines(e,r, lwd=4, col=colores[5] )
points(e[which.max(r)],r[which.max(r)],pch=19,cex=2,col=colores[5] )
points(1,1.5,pch=19,cex=2,col="black")


axis(side=2, labels=NA,cex.axis=0.6,tck=0.015)
axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
axis(lwd=0,side=1,cex.axis=1.5,line=-0.3)
axis(lwd=0,side=2,cex.axis=1.5,line=-0.3)
axis(lwd=0,side=1, at=0.5, labels=0.5,cex.axis=1.33,line=-0.8,tck=0.015)
axis(side=1, at=0.5, labels=NA,cex.axis=1.33,line=0,tck=0.01)
mtext(text= "Apuesta b",side =1,line=2.33,cex=2)
mtext(text = "Tasa de crecimiento r" ,side =2,line=2,cex=2)
abline(v=0.5, lty=3)

legend(0,1.5,pch=19,
       legend = seq(1,5),
       col = c(colores[1],colores[2],colores[3],colores[4],colores[5]), bty = "n",cex = 1.5)


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
