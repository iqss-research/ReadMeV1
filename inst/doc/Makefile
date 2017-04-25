# Set this value to false if you don't want to re-evaluate your Sweave (for testing)
REVAL=TRUE

# Replace <PROJECT>.pdf with the name of your project (must match .tex or .Rnw file,
# e.g. skel.tex would generate skel.pdf). Put multiple <PROJECT>.pdf separated by 
# spaces if you wish to generate more than just the single pdf
all:	readme.pdf

%.tex:	%.Rnw
	echo "Sweave(\"$<\", debug=TRUE, eval=$(REVAL))" | R --slave

%.pdf:	%.tex
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*
	pdflatex $*
