BIBFILE=bibliografia
SEMINARS_TEX := $(wildcard ./seminars/*.tex)
SEMINARS_HTML := $(patsubst ./seminars/%.tex,./build-web/seminars/%.html,$(SEMINARS_TEX))
MATHJAX_URL = https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML

all: diplomka web

clean:
	latexmk -c -outdir=build-pdf

cleanbib:
	bibtool -r bibstyle.rsc -r biblatex -i $(BIBFILE).bib >tmp.bib
	mv tmp.bib $(BIBFILE).bib

diplomka:
	latexmk -pdf -outdir=build-pdf main.tex

web: web-init $(SEMINARS_HTML)

web-init:
	mkdir -p build-web/seminars
	echo "" >build-web/index.html
	pandoc -v

build-web/seminars/%.html: seminars/%.tex force
	pandoc -s --mathjax=$(MATHJAX_URL) -f latex -t html -o $@ $<
	echo "<a href=\"${<:.tex=.html}\">$<</a><br/>" >>build-web/index.html

force: ;

.PHONY: all clean cleanbib diplomka web web-init
