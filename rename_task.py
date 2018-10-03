#!/usr/bin/env python3

import re

lines = open("text.tex").readlines()
seminar = 0
task = 1

for i, l in enumerate(lines):
    if "\\section*{Seminár" in l:
        seminar = int(re.sub('[:\}\n]', '', l.split(" ")[1]))
        task = 1
    elif "\\ul" in l:
        l = l.replace("\\ul", "\\ul{{{}.{}}}".format(seminar, task))
        task += 1
    print(l, end='')