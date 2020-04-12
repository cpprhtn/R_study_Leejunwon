STYLESHEET = changes-html.xsl
HTML2TEXT = lynx -dump -nolist -width=70 -justify=0

all:: ../Changes.html ../Changes.txt

../Changes.html:: Changes.xml $(STYLESHEET)
	xsltproc -o ../Changes.html $(STYLESHEET) Changes.xml

../Changes.txt:: ../Changes.html
	$(HTML2TEXT) ../Changes.html > ../Changes.txt

lastchangeset:
	lastchangeset.rb Changes.xml
