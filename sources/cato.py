import requests
from bs4 import BeautifulSoup
import re

#step = [1, 2, 3]
step = [4]

if 1 in step:
    for letter in "ABCDEFGHIJKL":
        req = requests.get(
            "http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Cato/De_Agricultura/"+letter+"*.html"
        )
        req.encoding = 'ISO-8859-1'
        with open("cato/"+letter+".html", "w") as f:
             f.write(req.content.decode("utf-8"))

if 2 in step:
    full = []
    for letter in "ABCDEFGHIJKL":
        with open("cato/"+letter+".html") as f:
            content = f.read()
        html = BeautifulSoup(content, features="lxml")
        full.extend(html.select("p.justify"))

if 3 in step:
    with open("cato/full.html", "w") as f:
        f.write("<div>\n\t{}\n</div>".format(
            "\n\t".join([p.prettify() for p in full])
        ))

# 3bis Do transform.xsl from full.htl

# Simpler than XSL !
if 4 in step:
    with open("cato/cato_aftertransform.xml", "r") as f:
        content = f.read()
    milestone = re.compile(r'<milestone\s+unit="section"\s+n="\d+\.(\d+)"\s*/>')
    content = milestone.sub(r'</p> <p n="\g<1>">', content)
    empty_div = re.compile(r'</div>\s*<div\s+type="textpart"\s+subtype="chapter"\s+n=""\s*>')
    content = empty_div.sub(" ", content)
    empty_p = re.compile(r"<p>\s*</p>")
    content = empty_p.sub(" ", content)
    empty_p_with_pb = re.compile(r'</p>\s+<p>\s*<pb\s+n="(\d+)"\s*/>\s*</p>')
    content = empty_p_with_pb.sub(r'<pb n="\g<1>"/></p>', content)

    # Add n=1 to first elements
    bs = BeautifulSoup(content, "html.parser")
    for p in bs.select("p:first-child"):
        p["n"] = 1

    # For each div, check p without numbers, iterate over ps to find the previous and next p number
    for div in bs.select("div[type='textpart']"):
        ps = div.select("p")
        fake = {"n": -1, "type": False}
        for before, current, after in zip(ps + [fake, fake], ps[1:] + [fake, fake, fake], ps[2:] + [fake]):
            if current.get("n") is None and current != fake:
                bef, aft = int(before.get("n", -1)), int(after.get("n", -1))
                # If previous and after are not faked elements
                if before != fake and after != fake:
                    # If the number of previous and after are continuous, current is a prolongation of before
                    if bef == (aft - 1):
                        current["n"] = "prolongation"
                # Chose to treat it the same way but technically this is when this is the last p. Manually checked,
                # made sense
                elif before != fake:
                    current["n"] = "prolongation"

    # Replace URN
    bs.select("div")[0]["n"] = "urn:cts:latinLit:phi0022.phi001.thayer-lat1"
    # Reformat and remove prolongations
    content = bs.prettify()
    empty_div = re.compile(r'</p>\s*<p\s+n="prolongation"\s*>')
    content = empty_div.sub(" <lb /> ", content)

    with open("cato/template.xml") as f:
        template = f.read()
    with open("cato/cato_after_regex.xml", "w") as f:
        f.write(template.format(content))

