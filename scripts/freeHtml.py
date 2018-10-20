#!/usr/bin/env python3
import html
import sys
import re

def freeHtml(match):
    return html.unescape(match.group(1))

if len(sys.argv) != 2:
    print("Wrong usage")
    print("Use: freeHtml.py <htmlfile>")
    sys.exit(1)

document = open(sys.argv[1]).read()
document = re.sub(r"<code>(.*?)</code>", freeHtml, document)

with open(sys.argv[1], "w") as f:
    f.write(document)