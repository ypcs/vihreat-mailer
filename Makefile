STYLES_SOURCE ?= styles.sass
STYLES_DEST = styles.css

LAYOUT_DIR ?= _layouts
SITE_DIR = _site

HTML_LAYOUT_SOURCE ?= $(LAYOUT_DIR)/_default.html
HTML_LAYOUT_DEST = $(LAYOUT_DIR)/default.html
HTML_REPLACE_STRING = <!-- #STYLES# -->

HTML_SOURCES = $(wildcard *.html)

ifeq ($(OS),Windows_NT)
	OPEN = start
	DEPS = N/A
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OPEN = xdg-open
		DEPS = apt-get install jekyll ruby-sass make
	else ifeq ($(UNAME_S),Darwin)
		OPEN = start
		DEPS = brew install jekyll (TODO)
	endif
endif

all:	$(STYLES_DEST) $(HTML_DEST)	#$(HTML_INLINE_DEST)

help:
	@echo To install dependencies, run
	@echo "     $(DEPS)"

clean:
	@echo Remove compiled files
	rm -f $(STYLES_DEST) $(STYLES_DEST).map $(HTML_DEST) inline.$(HTML_DEST)

$(LAYOUT_DIR):
	mkdir -p $(LAYOUT_DIR)

$(STYLES_DEST):
	@echo Compile SASS to CSS
	sass styles.sass styles.css

$(HTML_LAYOUT_DEST): $(STYLES_DEST) $(LAYOUT_DIR)
	@echo Add CSS styles to HTML template
	sed -e "/$(HTML_REPLACE_STRING)/r $(STYLES_DEST)" -e "/$(HTML_REPLACE_STRING)/d" $(HTML_LAYOUT_SOURCE) >$(HTML_LAYOUT_DEST)
	echo "<!-- Compiled at $(shell date +%Y%m%d%H%M%S) on $(shell hostname) -->" >> $(HTML_LAYOUT_DEST)

inline-template: clean $(HTML_LAYOUT_DEST)
	python cssinline.py -i $(HTML_LAYOUT_DEST) -o $(HTML_LAYOUT_DEST)

build: clean $(HTML_LAYOUT_DEST) inline-template
	jekyll build

_site/%.inline.html: _site/%.html
	python cssinline.py -i $< -o $@

publish-%:
	echo $(HTML_SOURCES)

#$(HTML_INLINE_DEST):	$(HTML_DEST)
#	python cssinline.py -i $(HTML_DEST) -o $(HTML_INLINE_DEST)

#show: $(HTML_INLINE_DEST)
#	$(OPEN) $(HTML_INLINE_DEST)

#dist: $(HTML_INLINE_DEST)
#	zip -r9 mailer.$(VERSION).zip $(HTML_INLINE_DEST) images
