pdflatex:
	pdflatex -interaction=nonstopmode doc.tex

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
	pdftk A=doc.pdf cat A1-6 A19 output doc.draft.pdf

