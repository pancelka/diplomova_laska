FROM haskell:8.2
MAINTAINER Jan Mrázek <email@honzamrazek.cz>

RUN apt-get update -y \
  && apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
    texlive \
    texlive-latex-extra \
    texlive-lang-czechslovak \
    biber \
    texlive-bibtex-extra pandoc \
    latexmk

RUN cabal update && cabal install pandoc