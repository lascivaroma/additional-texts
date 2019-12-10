import re
import os
import lxml.etree as ET


here = os.path.dirname(__file__)

with open(os.path.join(here, "phi001.xml")) as f:
    xml = ET.parse(f)

milestone = re.compile(r"^\s+(M{0,4}(?:CM|CD|D?C{0,3})(?:XC|XL|L?X{0,3})(?:IX|IV|V?I{0,3}))\.")

for p in xml.xpath("//p"):
    if milestone.match(p.text):
        number, *_ = milestone.findall(p.text)
        p.text = milestone.sub("", p.text)
        p.addprevious(ET.fromstring('<milestone type="alt-chapter" n="{}" />'.format(number)))

unit = re.compile(r"^\s*(\d+)\.")

for p in xml.xpath("//p"):
    if unit.match(p.text):
        number, *_ = unit.findall(p.text)
        p.text = unit.sub("", p.text)
        p.getparent().set("n", number)

with open(os.path.join(here, "out.xml"), "w") as f:
    f.write(ET.tostring(xml, encoding='unicode'))
