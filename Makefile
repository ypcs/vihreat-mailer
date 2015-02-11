STYLES_SOURCE ?= styles.sass
STYLES_DEST = styles.css

HTML_SOURCE ?= _template.html
HTML_DEST = template.html
HTML_REPLACE_STRING = <!-- #STYLES# -->

all:	$(STYLES_DEST) $(HTML_DEST)

clean:
	@echo Remove compiled files
	rm -f $(STYLES_DEST) $(STYLES_DEST).map $(HTML_DEST)

$(STYLES_DEST):
	@echo Compile SASS to CSS
	sass styles.sass styles.css

$(HTML_DEST): $(STYLES_DEST)
	@echo Add CSS styles to HTML template
	sed -e "/$(HTML_REPLACE_STRING)/r $(STYLES_DEST)" -e "/$(HTML_REPLACE_STRING)/d" $(HTML_SOURCE) >$(HTML_DEST)
	echo "<!-- Compiled at $(shell date +%Y%m%d%H%M%S) on $(shell hostname) -->" >> $(HTML_DEST)
