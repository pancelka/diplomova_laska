FROM haskell:8.2
MAINTAINER Jan Mrázek <email@honzamrazek.cz>

RUN apt update -y \
  && apt install -y -o Acquire::Retries=10 --no-install-recommends \
    texlive \
    texlive-latex-extra \
    texlive-lang-czechslovak \
    biber \
    texlive-bibtex-extra pandoc \
    latexmk \
    imagemagick

RUN cabal update && cabal install pandoc
