all: tex julia

tex:
	pdflatex agricultura.tex
	pdfcrop --margins '0 0 0 0' agricultura.pdf agricultura.pdf

julia:
	julia ergodicity.jl
	julia cpr.jl
