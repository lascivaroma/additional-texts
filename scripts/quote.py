import re

with open("eclogs.xml") as f:
	with open("out.xml", "w") as o:
		text = f.read().replace("\n", "¬")
		out = ""
		for no, line in enumerate(re.split(r"&quot;", text)):
			if no != 0:
				if no % 2 == 0:
					line = "</quote> " + line
				else:
					line = "<quote> " + line
			o.write(line.replace("¬","\n"))
