#!/usr/bin/env python3

import re
import sys

document = ""
opened = False
for line in open(sys.argv[1]).readlines():
    if line.startswith("\\subsection*{Ciele}") or line.startswith("\\subsection*{Doplňujúce"):
        document += "\\teachernote{\n"
        opened = True
    elif line.startswith("\\subsection*{Úlohy a riešenia}"):
        document += "}\n"
        opened = False
    document += line

if opened:
    document += "}\n"

with open(sys.argv[1], "w") as f:
    f.write(document)
