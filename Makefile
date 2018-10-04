TITLE=main
BIBFILE=bibliografia
IMAGES=$(wildcard obrazky/*)
LOGOS=$(wildcard loga/*)

all: $(TITLE).pdf

clean:
	rm -f *.aux *.dvi *.log *.synctex.gz *.out *.nav *.toc *.snm *.run.xml *-blx.bib *.bbl *.blg *.bcf

cleanbib:
	bibtool -r bibstyle.rsc -r biblatex -i $(BIBFILE).bib >tmp.bib
	mv tmp.bib $(BIBFILE).bib

$(TITLE).pdf: $(TITLE).tex $(IMAGES)
	pdflatex $(TITLE)

remake: $(BIBFILE).bib $(TITLE).tex $(IMAGES)
	pdflatex $(TITLE)
	bibtex $(TITLE)
	pdflatex $(TITLE)
	pdflatex $(TITLE)

.PHONY: all clean cleanbib remake
