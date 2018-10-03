#!/usr/bin/env python3

lines = open("main.tex").readlines()
opened = False

for i, l in enumerate(lines):
    if "\\begin{tcolorbox}" in l:
        if opened:
            print("Corrupted at {}".format(i + 1))
        opened = True
    if "\\end{tcolorbox}" in l:
        opened = False