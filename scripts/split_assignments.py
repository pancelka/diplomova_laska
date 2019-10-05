#!/usr/bin/env python3

import re
import glob
import sys

def process(assignment):
    m = re.match(r"\\problem{(.*)}", assignment)
    if not m:
        return
    name = m.group(1)
    with open("problems/{}.tex".format(name), "w") as f:
        f.write("% Do not delete this line (pandoc magic!)\n\n")
        f.write(assignment)
    print(name)

assignment = ""
opened = False
for line in open(sys.argv[1]).readlines():
    if line.startswith('\problem'):
        assignment = line
        opened = True
    elif line == "}\n":
        assignment += line
        process(assignment)
        assignment = ""
        opened = False
    elif opened:
        assignment += line

