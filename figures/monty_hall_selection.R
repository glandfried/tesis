###########################################
# Header
oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"), width = 8, height = 5  )
setwd(this.dir)
#setwd("~/gaming/materias/inferencia_bayesiana/trabajoFinal/imagenes")
#####################################

set.seed(0)
prior = 1/2
r1 = rbinom(n=32, size=1, prob=1/3)

predicciones_A = (1/3)*((1/2)^(1-r1) * (1/2)^r1)
predicciones_B = (1/2)*((1/3)^(1-r1) * (2/3)^r1)

evidencia_A = cumprod(predicciones_A )
evidencia_B = cumprod(predicciones_B )

p_datos = evidencia_A*prior + evidencia_B*prior
p_modelo_A = evidencia_A * prior / p_datos 

plot(c(0.5, p_modelo_A), ylim=c(0,1), type="l", axes = F,ann = F, lwd=3, col=rgb(0.6,0.2,0.4))
lines(1-c(0.5, p_modelo_A), lwd=3, col=rgb(0.2,0.6,0.4))

axis(side=2, labels=NA, cex.axis=0.6,tck=0.015)
axis(side=1, labels=NA, cex.axis=0.6,tck=0.015)
axis(lwd=0,side=1, las=0,cex.axis=1.5,line=-0.45)
axis(lwd=0,side=2, cex.axis=1.5,line=-0.45)

mtext(text ="P(Modelo | Datos, R)" ,side =2 ,line=2.25,cex=2)
mtext(text="Cantidad de datos" ,side =1 ,line=2.25,cex=2)

legend(18,0.66, col=c(rgb(0.6,0.2,0.4),rgb(0.2,0.6,0.4)), lwd=3, legend = c(expression("Modelo"~M[A]), expression("Modelo"~M[B])), bty = "n",cex = 1.75, ncol=1)


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################


