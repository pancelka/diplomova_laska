FROM haskell:8.2
MAINTAINER Jan Mrázek <email@honzamrazek.cz>

RUN cabal update && cabal install -j8 pandoc pandoc-citeproc

RUN apt-get update -y \
  && apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
    texlive \
    texlive-latex-extra \
    texlive-extra-utils \
    texlive-lang-czechslovak \
    biber \
    texlive-bibtex-extra pandoc \
    latexmk \
    imagemagick \
    ghostscript \
    python3
