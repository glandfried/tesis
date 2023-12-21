oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"), width = 8, height = 5  )
setwd(this.dir)
###############################



modelo <- "model{
  s[1] ~ dbeta(2, 8)
  s[2] ~ dbeta(2, 8)
  x[1] ~ dbeta(2, 8)
  x[2] ~ dbeta(2, 8)
  for(c in 1:Comunidades){
    p[c] ~ dbeta(1, 1)
    q[1,c] <- p[c]*(1-s[1])*(1-s[2]) + (1-p[c])*   x[1]*    x[2]
    q[2,c] <- p[c]*(1-s[1])*   s[2]  + (1-p[c])*   x[1]* (1-x[2])
    q[3,c] <- p[c]*   s[1] *(1-s[2]) + (1-p[c])*(1-x[1])*   x[2]
    q[4,c] <- p[c]*   s[1] *   s[2]  + (1-p[c])*(1-x[1])*(1-x[2])
    r[1:4, c] ~ dmulti(q[1:4, c], N[c])
  }
  #data# r, N, Comunidades
  #monitor# p, s, x
  #inits# p, s, x
}"

P = c(0.15, 0.3, 0.5) # TRUE VALUES
S = c(0.9, 0.6)
X = c(0.95, 0.9)

q = matrix(0,nrow=4,ncol=2)
for (c in seq(length(P))){
  q[1,c] <- P[c]*(1-S[1])*(1-S[2]) + (1-P[c])*   X[1] *   X[2]
  q[2,c] <- P[c]*(1-S[1])*   S[2]  + (1-P[c])*   X[1] *(1-X[2])
  q[3,c] <- P[c]*   S[1] *(1-S[2]) + (1-P[c])*(1-X[1])*   X[2]
  q[4,c] <- P[c]*   S[1] *   S[2]  + (1-P[c])*(1-X[1])*(1-X[2])
}

r <- matrix(nrow=4, ncol=length(P)) # DATA (simulated)
r[,1] <- rmultinom(1,size=4000,prob=q[,1] )
r[,2] <- rmultinom(1,size=4000,prob=q[,2] )
N <- apply(r, MARGIN=2, FUN=sum);
Comunidades = 2

library("runjags") # JAGS: Just Another Gibbs Sampler
s <- list(chain1=c(0.5,0.99), chain2=c(0.99,0.5)) # INITS
x <- list(chain1=c(0.5,0.99), chain2=c(0.99,0.5))
p <- list(chain1=c(0.1, 0.5, 0.9), chain2=c(0.9, 0.4, 0.1))
results <- run.jags(modelo, n.chains=2)
print(results)
s = results$summary[[2]][c(3,4),c(1,2,3)]
x = results$summary[[2]][c(5,6),c(1,2,3)]

plot_estimates <- function(real,estimates,ylim,xlim,name, max=NA, min=NA){

    grilla = seq(ylim[1],ylim[2],by=0.05)

    if (is.na(max)){
        max = rep(-10, length(real))
        min = rep(-10, length(real))
    }

    plot(0,0,col=rgb(1,1,1,0),  ylim=ylim, xlim=xlim, axes=F, xlab="", ylab="")
    for (is in seq(length(real))){
        points(is, real[is], pch=19)
        text(is, ylim[2],paste0(name,toString(is)), cex=1.5, col=rgb(0,0,0,0.6))
        segments(x0=is, x1=is, y0=estimates[is,1], y1=estimates[is,3],lwd=1)
        segments(x0=is-0.05, x1=is+0.05, y0=estimates[is,2], y1=estimates[is,2])

        segments(x0=is-0.1, x1=is+0.1, y0=max[is], y1=max[is], lty=2)
        segments(x0=is-0.1, x1=is+0.1, y0=min[is], y1=min[is], lty=2)
    }

    abline(v=3.5)
    axis(side=2, at= grilla ,labels=NA,cex.axis=0.6,tck=0.015)
    #axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
    #axis(lwd=0,side=1, cex.axis=1.5,line=-0.45)
    axis(lwd=0,side=2,at= grilla, cex.axis=1.5,line=-0.45)
    abline(h=grilla, col=rgb(0,0,0,0.1))
}



plot_estimates(real=S,estimates=s,ylim=c(0.5,1), xlim=c(0.75, length(S)+0.25), name="s")
plot_estimates(real=X,estimates=x,ylim=c(0.5,1), xlim=c(0.75, length(S)+0.25), name="x")
plot_estimates(real=Cov,estimates=cov,ylim=c(-0.1,0.2), xlim=c(0.75, length(S)+0.25), name="cov", min=min_cov, max=max_cov )
plot_estimates(real=S,estimates=s_indep,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="s")
plot_estimates(real=X,estimates=x_indep,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="x")


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################
