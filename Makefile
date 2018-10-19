BIBFILE=bibliografia
SEMINARS_TEX := $(wildcard ./seminars/*.tex)
SEMINARS_HTML := $(patsubst ./seminars/%.tex,./build-web/seminars/%.html,$(SEMINARS_TEX))
IMAGES_PDF := $(wildcard ./images/*.pdf)
IMAGES_PNG := $(patsubst ./images/%.pdf,./build-web/images/%.png,$(IMAGES_PDF))
TEMPLATES := $(wildcard ./templates/*)
MATHJAX_URL = https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML

all: diplomka web

clean: diplomka-clean web-clean

diplomka-clean:
	latexmk -c -outdir=build-pdf

web-clean:
	rm -rf build-web

cleanbib:
	bibtool -r bibstyle.rsc -r biblatex -i $(BIBFILE).bib >tmp.bib
	mv tmp.bib $(BIBFILE).bib

diplomka:
	latexmk -halt-on-error -pdf -outdir=build-pdf main.tex

web: web-init $(IMAGES_PNG) $(SEMINARS_HTML)

web-init:
	mkdir -p build-web/seminars build-web/images
	cp -v templates/index.html templates/style.css templates/background.png build-web/
	cp -v images/*.png build-web/images/
	./scripts/getVersion.sh

build-web/images/%.png: images/%.pdf
	convert -verbose -density 500 -resize '1200' $< $@

build-web/seminars/%.html: seminars/%.tex $(TEMPLATES)
	pandoc -s --mathjax=$(MATHJAX_URL) --metadata-file=templates/metadata.yaml -H templates/html-header.html -B templates/html-before-body.html -A templates/html-after-body.html -f latex -t html -o $@ templates/latex-header.tex $<

.PHONY: all clean cleanbib diplomka web web-init

# Run all recipe lines as bash commands
.ONESHELL: