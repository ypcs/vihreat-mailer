S3_BUCKET ?=
S3_PREFIX ?=

JEKYLL_BIN ?= jekyll
SASS_BIN ?= sass

INLINE_TOOL = _tools/cssinline.py
PREMAILER = _tools/premailer.rb

STYLES_SOURCE ?= _assets/styles.sass
STYLES_DEST = _assets/styles.css

LAYOUT_DIR ?= _layouts
SITE_DIR = _site

SOURCE_FILES = $(wildcard _posts/*.txt)
SOURCES_FILES_MD = $(SOURCE_FILES:.txt=.md)

HTML_LAYOUT_SOURCE ?= $(LAYOUT_DIR)/_default.html
HTML_LAYOUT_DEST = $(LAYOUT_DIR)/default.html
HTML_REPLACE_STRING = <!-- #STYLES# -->
INK_REPLACE_STRING = <!-- #INK -->
INK_STYLES = _assets/ink.css

HTML_SOURCES = $(shell find _site/ -type f -name *.html)
HTML_INLINE_SOURCES = $(HTML_SOURCES:.html=.inline.html)

TIMESTAMP = $(shell date +%Y%m%d%H%M)

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

all:	build

depends:
	sudo gem install bundler
	bundler

clean:
	@echo Remove compiled files
	rm -f $(STYLES_DEST) $(STYLES_DEST).map $(HTML_DEST) inline.$(HTML_DEST)
	rm -rf $(SITE_DIR)

$(LAYOUT_DIR):
	mkdir -p $(LAYOUT_DIR)

$(STYLES_DEST):
	@echo Compile SASS to CSS
	$(SASS_BIN) $(STYLES_SOURCE) $(STYLES_DEST)

$(HTML_LAYOUT_DEST): $(STYLES_DEST) $(LAYOUT_DIR)
	@echo Add CSS styles to HTML template
	sed -e "/$(INK_REPLACE_STRING)/r $(INK_STYLES)" -e "/$(INK_REPLACE_STRING)/d" $(HTML_LAYOUT_SOURCE) >$(HTML_LAYOUT_SOURCE).tmp
	sed -e "/$(HTML_REPLACE_STRING)/r $(STYLES_DEST)" -e "/$(HTML_REPLACE_STRING)/d" $(HTML_LAYOUT_SOURCE).tmp >$(HTML_LAYOUT_DEST)
	echo "<!-- Compiled at $(shell date +%Y%m%d%H%M%S) on $(shell hostname) -->" >> $(HTML_LAYOUT_DEST)

_posts/%.md: _posts/%.txt
	awk 'NR==1{sub(/^\xef\xbb\xbf/,"")}{print}' $< > $@
	rm -f $<

convert-txt-to-markdown: $(SOURCE_FILES)
	$(foreach var,$(SOURCE_FILES_MD), $(MAKE) $(var))

build: clean $(HTML_LAYOUT_DEST) convert-txt-to-markdown
	$(JEKYLL_BIN) build
	rm -f _site/index.html

_site/%.inline.html: _site/%.html
	ruby $(PREMAILER) $< $@ $@.txt
	python $(INLINE_TOOL) -i $@ -o $@.mail.html

	@echo
	@echo "HTML (original, no inline styles): $<"
	@echo "HTML (inline styles):              $@"
	@echo "Plain text:                        $@.txt"
	@echo "HTML (inline images):              $@.mail.html"

inline: build $(HTML_INLINE_SOURCES)

publish: build
	s3cmd sync _site/* s3://$(S3_BUCKET)/$(S3_PREFIX)/$(TIMESTAMP)/

zip:
	git archive --format=zip --output=../mailer_$(shell date +%Y%m%d%H%M%S).zip master
#$(HTML_INLINE_DEST):	$(HTML_DEST)
#	python cssinline.py -i $(HTML_DEST) -o $(HTML_INLINE_DEST)

#show: $(HTML_INLINE_DEST)
#	$(OPEN) $(HTML_INLINE_DEST)

#dist: $(HTML_INLINE_DEST)
#	zip -r9 mailer.$(VERSION).zip $(HTML_INLINE_DEST) images
