###########################################
# Header
oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"),width = 8, height = 4.5)
setwd(this.dir)
#####################################

par(mar=c(4,4,1.5,1.5))

year_owid = c(-10000, -5000, -1000, 1000, 1500, 1800, 1900, 2010, 2020) - 2023
our_world_in_data = c(4.43*10^6, 19.08*10^6,110*10^6, 323.4*10^6, 503*10^6, 985*10^6, 1.63*10^9, 6.99*10^9, 7.84*10^9)

plot(year_owid, log(our_world_in_data,10), type="l")
abline(v=-log(500,10))
abline(v=-log(200,10))


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf"),paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################
