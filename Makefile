STYLES_SOURCE ?= styles.sass
STYLES_DEST = styles.css

HTML_SOURCE ?= _template.html
HTML_DEST = template.html
HTML_INLINE_DEST = inline.template.html
HTML_REPLACE_STRING = <!-- #STYLES# -->

ifeq ($(OS),Windows_NT)
	OPEN = start
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OPEN = xdg-open
	else ifeq ($(UNAME_S),Darwin)
		OPEN = start
	endif
endif

all:	$(STYLES_DEST) $(HTML_DEST) inline.$(HTML_DEST)

clean:
	@echo Remove compiled files
	rm -f $(STYLES_DEST) $(STYLES_DEST).map $(HTML_DEST) inline.$(HTML_DEST)

$(STYLES_DEST):
	@echo Compile SASS to CSS
	sass styles.sass styles.css

$(HTML_DEST): $(STYLES_DEST)
	@echo Add CSS styles to HTML template
	sed -e "/$(HTML_REPLACE_STRING)/r $(STYLES_DEST)" -e "/$(HTML_REPLACE_STRING)/d" $(HTML_SOURCE) >$(HTML_DEST)
	echo "<!-- Compiled at $(shell date +%Y%m%d%H%M%S) on $(shell hostname) -->" >> $(HTML_DEST)

$(HTML_INLINE_DEST):	$(HTML_DEST)
	python cssinline.py -i $(HTML_DEST) -o $(HTML_INLINE_DEST)

show: $(HTML_INLINE_DEST)
	$(OPEN) $(HTML_INLINE_DEST)

dist: $(HTML_INLINE_DEST)
	zip -r9 mailer.$(VERSION).zip $(HTML_INLINE_DEST) images
