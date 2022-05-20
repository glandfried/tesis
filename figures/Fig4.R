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


#library(remotes)
#install_version("maps", "3.3.0")

par(mar=c(3,3,.5,3.6))
require(fields)
#require(xtable)
#setwd("~/gaming/trabajos/conquerClub/SociosPorConveniencia/Imagenes")

ftot_perf <- read.csv("data/dosClases100.csv", header =T)

activity <- ftot_perf[,"team_times1"]>=4 
loyalty <- ftot_perf[,"max_times12"][activity]/ftot_perf[,"team_times1"][activity]
teamOriented <- ftot_perf[,"team_times1"][activity]/ftot_perf[,"times1"][activity]
skill <- ftot_perf[,"mean"][activity]
l.to <-(loyalty*teamOriented)[activity]

#xtable(lm(skill~loyalty*teamOriented))

#vif_model <- lm(teamOriented~loyalty)
#vif_model_summary <- summary(vif_model)
#1/(1-vif_model_summary$r.squared)
#cor(loyalty,teamOriented)
#cor.test(loyalty,teamOriented)

faithfulness <- matrix(NA, nrow=10, ncol=10)
colnames(faithfulness) = seq(0,9)
rownames(faithfulness) = seq(0,9)
faithfulnessSE <- matrix(NA, nrow=10, ncol=10)
colnames(faithfulnessSE) = seq(0,9)
rownames(faithfulnessSE) = seq(0,9)
faithfulnessLen <- matrix(NA, nrow=10, ncol=10)
colnames(faithfulnessLen) = seq(0,9)
rownames(faithfulnessLen) = seq(0,9)
for (l in seq(0,9)){
  for (t in seq(0,9)){
    tClass <- (teamOriented > t/10) & (teamOriented <= (t+1)/10)
    lClass <- (loyalty > l/10) & (loyalty <= (l+1)/10)
    faithfulness[l+1,t+1] = mean(skill[tClass & lClass],na.rm = T)
    faithfulnessLen[l+1,t+1] = sum(tClass & lClass) 
    faithfulnessSE[l+1,t+1] = sd(skill[tClass & lClass])/sqrt(faithfulnessLen[l+1,t+1])
  }
}

faithfulness[faithfulnessLen <=5] <- NA

skillMin <- min(faithfulness,na.rm=T)
skillMax <- max(faithfulness,na.rm=T)
image(seq(0.05,0.95,by=0.1),seq(0.05,0.95,by=0.1),faithfulness, col= rev(gray.colors(40)),axes=F, xlab="",ylab="")
#points(c(0.25,0.35,0.45,0.55,0.65,0.75), c(0.95,0.95,0.95,0.95,0.95,0.95), pch="X", cex=3,col=rgb(0,0,0,0.80))
image.plot(seq(0.05,0.95,by=0.1),seq(0.05,0.95,by=0.1),faithfulness, 
           col= rev(gray.colors(40)),legend.only = T,legend.line = 0,legend.mar = 3.5,
           legend.cex = 0.01, legend.width = 1, 
           axis.args = list(at = seq(27.5,31.5,by = 1),tck=-0.4,lwd=0,lwd.ticks=1),
           breaks =  seq(27,32,length = 41))
contour(seq(0.05,0.95,by=0.1),seq(0.05,0.95,by=0.1),faithfulness,add = T,labcex = 1, levels = seq(27.5,31.5))
mtext("Loyalty", side=1, line=1.5,cex = 1.75)
mtext("Team-oriented behavior", side=2, line=1.5,cex = 1.75)
box()
axis(lwd=0,lwd.ticks=1,side=2, at = seq(0.1,0.9,by=0.2),labels=NA,cex.axis=0.6,tck=0.02)
axis(lwd=0,side=2,cex.axis=1.33,at = seq(0.1,0.9,by=0.2),line=-0.66)
axis(lwd=0,lwd.ticks=1,side=1,labels=NA,cex.axis=0.6,tck=0.02,at = seq(0.1,0.9,by=0.2))
axis(lwd=0,side=1,las=1,cex.axis=1.33,line=-0.66,at = seq(0.1,0.9,by=0.2))
par(xpd=NA);text(1.05,0.98,"Skill",cex=1.33);par(xpd=F)

#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################



