#!/usr/bin/env python3

import re
import glob

unique_counter = 0
def seq():
    global unique_counter
    unique_counter += 1
    return unique_counter

def strip_intro_comment(text):
    pos = text.find("\\textbf{Úvodný komentár")
    if pos == -1:
        return "", text
    end = text.find("\\\\", pos)
    return text[:end], text[end+2:]

def extract_assignments(text):
    asgns = text.split("\\begin{tcolorbox}")
    ret = []
    for asgn in asgns[1:]:
        ul_pos = asgn.find("\\ul")
        code_start = asgn.find("[", ul_pos)
        if code_start == -1:
            code = "anonymous_" + str(seq())
            code_end = asgn.find("}", ul_pos)
        else:
            code_start += 1
            code_end = asgn.find("]", code_start)
            code = asgn[code_start:code_end]

        text, solution = tuple(asgn[code_end+1:].split("\\end{tcolorbox}"))
        ret.append({
            "code": code,
            "text": text.strip(),
            "solution": solution.strip()
        })

    return asgns[0], ret

def save_assignment(asgn):
    code = asgn["code"]
    code = re.sub(r"(, resp.*)|(resp.*)", "", code)
    code = code.replace(" ", "_")
    code = code.replace(",", "_")
    code = code.replace("+", "_and_")
    code = code.replace("~\\cite{", "")
    code = code.replace("}", "")
    filename = "problems/" + code + ".tex"
    with open(filename, "w") as f:
        f.write("\\problem{" + asgn["code"] + "}{}{\n")
        f.write(asgn["text"] + "\n}{\n")
        f.write(asgn["solution"] + "\n}\n")
    return filename

names = []

def process_section(text):
    document, content = strip_intro_comment(text)
    x, asgns = extract_assignments(content)
    document += x
    for asgn in asgns:
        name = save_assignment(asgn)
        names.append(name)
        document += "\\input{" + name + "}\n\n"
    return document

def save_seminar(name, text):
    with open(name, "w") as f:
        f.write(text)

school_work = re.compile(r"\\subsection\*{Úlohy a riešenia}\s*\n([\s\S]*)\n\\subsection\*{Domáca práca}", re.MULTILINE)
home_work = re.compile(r"\\subsection\*{Domáca práca}([\s\S]*)", re.MULTILINE)

def process_seminar(seminar):
    rest = None
    for match in school_work.finditer(seminar):
        intro = seminar[:match.start(1)]
        rest = seminar[match.end(1):]
        school = match.group(1)
    if rest == None:
        print("Skipping")
        return seminar
    for match in home_work.finditer(rest):
        home_intro = rest[:match.start(1)]
        home = match.group(1)
        endpos = home.find("\\subsection*{D")
        ending = ""
        if endpos != -1:
            home, ending = home[:endpos], home[endpos:]
    school = process_section(school)
    home = process_section(home)

    return "\n".join([intro, school, home_intro, home, ending])

for file in glob.glob("seminars/*.tex"):
    print("Processing " + file)
    document = open(file).read()
    document = process_seminar(document)
    save_seminar(file, document)

print("Generated names: " + ", ".join(names))
