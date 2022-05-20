args <- commandArgs(trailingOnly = TRUE)

if (length(args)>0){
  files <- args
}else{
  files <- list.files(pattern = "\\.R")
  files <- files[files != "main.R"]
}

for (f in files){
  source(f)
} 

#source('learningskill_curve2.R')
#source('learningskill_pteam89_ployal_hasta4team_longRun_detail_w.R')
