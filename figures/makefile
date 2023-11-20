all: R julia agricultura.pdf pdf/ergodicity_individual_trayectories_longrun.pdf trueskillDimorphismMaxMin_ProbWin.pdf

agricultura.pdf:
	pdflatex agricultura.tex
	pdfcrop --margins '0 0 0 0' agricultura.pdf agricultura.pdf

R:
	Rscript main.R
	make -C Img_sup

pdf/ergodicity_individual_trayectories_longrun.pdf:
	julia main.jl
	
trueskillDimorphismMaxMin_ProbWin.pdf:
	make -C Img_sup



