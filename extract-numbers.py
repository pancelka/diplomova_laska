#!/usr/bin/env python3

import re

lines = open("text.tex").readlines()

opened = False
seminar = 0
task = 1

for i, l in enumerate(lines):
    if "\\section*{Seminár" in l:
        seminar = int(re.sub('[:\}\n]', '', l.split(" ")[1]))
        task = 1
        print("\n# Seminár {}".format(seminar))
    elif "\\begin{tcolorbox}" in l:
        x = l.replace("\\begin{tcolorbox}[breakable,notitle,boxrule=0pt,colback=light-gray,colframe=light-gray]", "")
        beg = x.find("[")
        end = x.find("]", beg) + 1
        print(x[beg:end])
    if "\\end{document}" in l:
        break