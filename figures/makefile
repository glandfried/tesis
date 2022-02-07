all: tex julia R

tex:
	pdflatex agricultura.tex
	pdfcrop --margins '0 0 0 0' agricultura.pdf agricultura.pdf

julia:
	julia main.jl

R:
	Rscript main.R

