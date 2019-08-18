#!/usr/bin/env python3

import sys
import glob
import re;
import os

if len(sys.argv) != 2:
    print("Invalid usage: usage assingTags.py tags")
    sys.exit(1)

problems = {}
tags = set()
with open(sys.argv[1]) as f:
    for line in f.readlines():
        fields = list(map(lambda x: x.strip(), line.split(",")))
        t = list(filter(lambda x: len(x) > 0, fields[1:]))
        problems[fields[0]] = t
        for x in t:
            tags.add(x)

for file in glob.glob("problems/*.tex"):
    problem = os.path.splitext(os.path.basename(file))[0]
    if problem not in problems or len(problems[problem]) == 0:
        continue
    filecontent = open(file).read()
    newcontent = re.sub(r"(\\problem\{.*\})\{(.*)\}\{",
        "\\1{{{}}}{{".format(",".join(problems[problem])), filecontent)
    open(file,"w").write(newcontent)

tt = list(tags)
tt.sort()
for x in tt:
    print('<li><label><input type="checkbox" value="{}" checked></label>{}</li>'.format(x, x))
