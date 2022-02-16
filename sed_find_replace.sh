#!/bin/bash
sed -i 's/\\proglang{/\\texttt{/g' doc.tex
sed -i 's/\\pkg{/\\texttt{/g' doc.tex
sed -i 's/\\citep{/\\cite{/g' doc.tex
sed -i 's/Imagenes\//figures\//g' doc.tex
sed -i 's/\\section\*/\\section/g' doc.tex
sed -i 's/\\subsection\*/\\subsection/g' doc.tex 
