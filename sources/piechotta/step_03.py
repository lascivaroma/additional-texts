with open("step02_output.xml") as f:
    text = f.read().replace('<?xml version="1.0" encoding="UTF-8"?>', '')
    text = text.replace("</head>", "</head><p>")
    text = text.replace("</div>", "</p></div>")
    text = text.replace("div2", "div")

with open("template.xml") as f:
    template = f.read()

with open("../../data/dlt000006/001/dlt000006.001.csl-lat1.xml", "w") as f:
    f.write(template.format(text=text))
