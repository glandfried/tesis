#######################################
## Latex requirements ################
##
# pdflatex
# \documentclass[10pt]{standalone}
# \usepackage[utf8]{inputenc}
# \usepackage{amsfonts}  
# \usepackage{tikz}
# \usetikzlibrary{shapes}
# \usetikzlibrary{fit}
# \usetikzlibrary{chains}
# \usetikzlibrary{arrows}
######################################

######################################
## R requirements ###################
# /usr/bin/Rscript
# require(tools)
# require(fields)
#################


all:
	pdflatex trueskill_factorGraph_2equiops.tex
	pdflatex trueskill_factorGraph_versionGeneral-en.tex
	/usr/bin/Rscript main.R
