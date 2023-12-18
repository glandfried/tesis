pdflatex:
	pdflatex -interaction=nonstopmode doc.tex

estebanizar:
	python3 ../../scripts/estebanizer.py -i doc.tex

all: img/resultados/centralidades/betweenness-centrality-150-partidas-hist.pdf
	make -C figures
	pdflatex -interaction=nonstopmode doc.tex

img/resultados/centralidades/betweenness-centrality-150-partidas-hist.pdf:
	make -C img
	
compile:
	pdflatex doc.tex
	bibtex doc.aux
	pdflatex doc.tex
	pdflatex doc.tex

pdfclean:
	- rm -f doc*.pdf

clean:
	- rm -f *.log
	- rm -f *.soc
	- rm -f *.toc
	- rm -f *.aux
	- rm -f *.out
	- rm -f doc.idx
	- rm -f *.bbl
	- rm -f *.bbg
	- rm -f *.dvi
	- rm -f *.blg
	- rm -f *.lof
	- rm -f *.nav
	- rm -f *.snm
	- rm -f *~

draft:
	pdftk doc.pdf cat 6-11 output doc.draft.pdf

