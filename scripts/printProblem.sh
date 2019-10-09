#!/usr/bin/env bash

printf "<div class=\"topProblemContainer\">"
pandoc --mathjax --metadata-file=templates/metadata.yaml -f latex -V biblio-title=Reference --bibliography=bibliografia.bib -t html templates/latex-header-web.tex --id-prefix=$(basename $1 .tex) $1
printf "</div>"