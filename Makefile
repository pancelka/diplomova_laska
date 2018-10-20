BIBFILE=bibliografia
SEMINARS_TEX := $(wildcard ./seminars/*.tex)
SEMINARS_HTML := $(patsubst ./seminars/%.tex,./build-web/seminars/%.html,$(SEMINARS_TEX))
IMAGES_PDF := $(wildcard ./images/*.pdf)
IMAGES_PNG := $(patsubst ./images/%.pdf,./build-web/images/%.png,$(IMAGES_PDF))
WEB_TEX := $(wildcard ./seminars/*.tex)
WEB_PDF_STUDENT := $(patsubst ./seminars/%.tex,./build-web/pdf/%-student.pdf,$(WEB_TEX))
WEB_PDF_TEACHER := $(patsubst ./seminars/%.tex,./build-web/pdf/%-teacher.pdf,$(WEB_TEX))
TEMPLATES_HTML := $(wildcard ./templates/*.html)
TEMPLATES_PDF := $(wildcard ./templates/*.tex)
MATHJAX_URL = https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML
TMP_TEX := tmp.tex

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

web: web-init $(IMAGES_PNG) $(WEB_PDF_STUDENT) $(WEB_PDF_TEACHER) $(SEMINARS_HTML)

web-init: build-web/index.html
	mkdir -p build-web/seminars build-web/images build-web/pdf build-web/images/
	cp -v templates/style.css templates/background.png build-web/
	cp -v images/*.png build-web/images/
	
	./scripts/getVersion.sh

build-web/index.html: $(TEMPLATES_HTML)
	mkdir -p build-web
	echo -e "<html>\n<head>\n<title>Matematický seminár pre talentovaných študentov</title>" > $@
	cat templates/header.html >> $@
	echo -e "</head>\n<body>\n<div class="main">" >> $@
	cat templates/index.html >> $@
	cat templates/after-body.html >> $@
	echo -e "</body>\n</html>" >> $@

build-web/images/%.png: images/%.pdf
	convert -verbose -density 500 -resize '1200' $< $@

build-web/seminars/%.html: seminars/%.tex $(TEMPLATES_HTML)
	pandoc -s --mathjax=$(MATHJAX_URL) --metadata-file=templates/metadata.yaml -H templates/header.html -B templates/before-body.html -A templates/after-body.html -f latex -t html -o $@ templates/latex-header-web.tex $<

build-web/pdf/%-teacher.pdf: seminars/%.tex $(TEMPLATES_PDF)
	cat templates/header-teacher.tex $< templates/footer.tex >$(TMP_TEX)
	latexmk -halt-on-error -pdf -outdir=build-web-pdf $(TMP_TEX)
	mv build-web-pdf/tmp.pdf $@
	rm -rf build-web-pdf $(TMP_TEX)

build-web/pdf/%-student.pdf: seminars/%.tex $(TEMPLATES_PDF)
	cat templates/header-student.tex $< templates/footer.tex >$(TMP_TEX)
	latexmk -halt-on-error -pdf -outdir=build-web-pdf $(TMP_TEX)
	mv build-web-pdf/tmp.pdf $@
	rm -rf build-web-pdf $(TMP_TEX)

.PHONY: all clean cleanbib diplomka web web-init

# Run all recipe lines as bash commands
.ONESHELL: