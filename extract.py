#!/usr/bin/env python3

import re

lines = open("text.tex").readlines()

opened = False

for i, l in enumerate(lines):
    if "\\section*{Seminár" in l:
        print(l)
    elif "\\begin{tcolorbox}" in l:
        print("\\noindent ", end='')
        x = l.replace("\\begin{tcolorbox}[breakable,notitle,boxrule=0pt,colback=light-gray,colframe=light-gray]", "")
        beg = x.find("[")
        end = x.find("]", beg) + 1
        x = x[:beg] + x[end:]
        print(x, end='')
        opened = True
    elif "\\end{tcolorbox}" in l:
        opened = False
        print("\n\n")
    elif opened:
        print(l, end='')
    if "\\end{document}" in l:
        break