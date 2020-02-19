import lxml.etree as ET
import regex as re


def roman_int(user_choice):
    rn = [
        ('M', 1000),
        ('CM', 900),
        ('D', 500),
        ('CD', 400),
        ('C', 100),
        ('XC', 90),
        ('L', 50),
        ('XL', 40),
        ('X', 10),
        ('IX', 9),
        ('V', 5),
        ('IV', 4),
        ('I', 1)
    ]
    ix = 0
    result = 0
    while ix < len(user_choice):
        for k, v in rn:
            if user_choice.startswith(k, ix):
                result += v
                ix += len(k)
                break
        else:
            raise ValueError('Invalid Roman number.')
    return result

with open("./Anecdotum medicum.xml") as f:
    text = f.read()

text = text.replace("<br />", "\n<br />\n")

roman_numerals = re.compile(r"[\n\r]+(\[?[XCLIV]+\]?)\s")
page = re.compile(r"[\n\r]+Page ([XCLIV]+)\.?")

# Used this to check that the regexp is correct
if True == True:
    before = None
    before_string = None
    for x in roman_numerals.findall(text):
        equiv = roman_int(x.replace("[", "").replace("]", ""))
        if before != None:
            if equiv != before + 1:
                print(x, "did not match", before_string)
        before = equiv
        before_string = x


def replace_roman_number(match):
    txt = match.group().strip()
    integer = roman_int(txt.replace("[", "").replace("]", ""))

    return "\n<milestone n=\"{n}\">{txt}</milestone> ".format(txt=txt, n=integer)


def replace_page(match):
    txt = match.group(1).strip()
    p = roman_int(txt)

    return "\n<pb n=\"{n}\" />\n".format(n=p)


#text = re.compile(r"<a href='#n\d+'>\w+</a>")

names = re.compile(r"<a\s+name=\"(\d+)\"\s*>")

text = names.sub(r'<div name="\g<1>">', text)
text = text.replace("</a><div", "</div>\n<div")
text = roman_numerals.sub(replace_roman_number, text)
text = page.sub(replace_page, text)

gap = re.compile(r"(…\s*)+")
text = gap.sub("<gap reason=\"lost\" />", text)
text = text.replace("[", "<supplied reeason=\"lost\">").replace("]", "</supplied>")

endtext = []

_open = False
for line in re.split("\n+", text):
    line = line.strip()
    if line.startswith("<div"):
        if _open:
            endtext.append("</div>")
        _open = True
    elif line.startswith("</div>"):
        _open = False
    endtext.append(line)

text = "\n".join(endtext)

closing_a = re.compile(r"</font>\s*(</a>)?\s*<font\s+size=\"-?\d+\"\s*>\s*(<sup>)?<a\s+href=\"#n")


def close_a(match):
    got_a = match.group(1) or ""
    if got_a:  # We erase </a>
        got_a = ""
    got_sup = match.group(2) or ""
    return "</font>"+got_a+"<font size=\"3\">"+got_sup+"<a href=\"#n"


text = closing_a.sub(close_a, text)

# Remove trailing </a
text = text.replace('</a></font></font></p><center><font size="3"><font size="4"><div name="203">',
                    '</div></font></font></p><center><font size="3"><font size="4"><div name="203">')
text = text.replace('<img src="../../line.gif" width="250" height="1"/></a></font></font></center><font size="3"><font size="4"><div name="203">\n' 
                    '</a></font><div name="203"></a><p align="justify"><div name="203"><font size="4"></font>',
                    '<img src="../../line.gif" width="250" height="1"/></div></font></font></center><font size="3"><font size="4"><div name="203">\n'
                    '</div></font><div name="203"><p align="justify"><div name="203"><font size="4"></font><a>')
text = text.replace("""<br />
<br />
<br />
</p><center>
<img src="../../line.gif" width="250" height="1"/></center>""",
                    """
<br />
<br />
<br /></div>
</p><center>
<img src="../../line.gif" width="250" height="1"/></center>""")
text = text.replace("""<font size="-1"><sup>25</sup></font> merdas oricina
<br />
<br />
<br />
</a></p></font></font>""",
                    """
<font size="-1"><sup>25</sup></font> merdas oricina
<br />
<br />
<br />
</a></p></div></font></font>""")
with open("step01_output.xml", "w") as f:
    f.write(text)
