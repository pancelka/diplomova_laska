TITLE=main
BIBFILE=bibliografia
IMAGES=$(wildcard obrazky/*)
LOGOS=$(wildcard loga/*)

all: diplomka

clean:
	latexmk -c -outdir=build-pdf

cleanbib:
	bibtool -r bibstyle.rsc -r biblatex -i $(BIBFILE).bib >tmp.bib
	mv tmp.bib $(BIBFILE).bib

diplomka:
	latexmk -pdf -outdir=build-pdf main.tex

.PHONY: all clean cleanbib diplomka
