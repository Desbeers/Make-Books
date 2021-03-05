#####################################################
#													#
# Pandoc Makefile									#
#													#
#####################################################

#############
#		 	#
# Options 	#
#		  	#
#############

PANDOC := pandoc
RM := rm
MKDIR := mkdir
LUALATEX := lualatex
KOBOGEN := kepubify
CONVERT := convert

PANDOC_OPTIONS := \
    --metadata-file=assets/make-book.md \
    --from native \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-metadata.lua" \
	--lua-filter "$(PANDOC_FILTERS)/desbeers-hashtags.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-dropcaps.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-linebreaks.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-chapterprecis.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-headers.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-matters.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-images.lua" \
    --lua-filter "$(PANDOC_FILTERS)/desbeers-quotes.lua" \
    --file-scope \
    --toc-depth=2
    
PANDOC_TEX := \
	--template="$(PANDOC_TEMPLATES)/desbeers-pdf.tex" \
	--variable documentclass=memoir \
	--top-level-division=chapter \
	--metadata=defaultpaper:$(PANDOC_PAPER) \
	--metadata=defaultfont:$(PANDOC_FONT) \
	--pdf-engine=$(LUALATEX) \
	--toc \
	--include-before-body=$(BUILD_DIR)/dedication.tex \
	+RTS -K100000000 -RTS \

# Coloured pages in the PDF output.
PANDOC_PDF := $(PANDOC_TEX) \
	--metadata=use-colours

# No coloured hyperlinks in the print output.
PANDOC_PRINT := $(PANDOC_TEX) \
	--metadata=hide-links

PANDOC_EPUB := \
    --template="$(PANDOC_TEMPLATES)/desbeers-epub.html" \
	--epub-embed-font="$(PANDOC_FONTS)/GreatVibes.ttf" \
	--css="$(PANDOC_CSS)/epub-css.css" \
	--css="$(PANDOC_CSS)/epub-greatvibes.css" \
	--epub-chapter-level=$(EPUB_CHAPTER_LEVEL) \
	+RTS -K100000000 -RTS \

# ePub optimised for Kobo
PANDOC_KOBO := $(PANDOC_EPUB) \

# Add the TOC and dedication to "normal" epubs; the Kobo e-reader
# does not need/like this.
PANDOC_EPUB+= \
	--toc \
	--include-before-body="$(BUILD_DIR)/dedication.epub" \

PANDOC_COLLECT := \

PANDOC_NATIVE := \
	--lua-filter "$(PANDOC_FILTERS)/desbeers-hashtags.lua" \
	--file-scope \
	--to=native \
	+RTS -K100000000 -RTS \

#############
#		 	#
# Prepare 	#
#		  	#
#############

# Add optional cover:
COVER := assets/cover-screen.jpg
ifneq ("$(wildcard $(COVER))","")
	PANDOC_EPUB+= --epub-cover-image=$(COVER)
	PANDOC_MOBI+= --epub-cover-image=$(COVER)
	PANDOC_PDF+= --metadata=have-cover
	PANDOC_KOBO+= --epub-cover-image=$(BUILD_DIR)/cover-screen-kobo.jpg
endif

# Add optional style:
CSS := assets/style.css
ifneq ("$(wildcard $(CSS))","")
	PANDOC_EPUB+= --css=$(CSS)
endif

# All the markdown source files:
SOURCES := $(wildcard *.md)

# Targets:
all: pdf epub

.PHONY: clean all md tex pdf print epub

#####################################################
#													#
# Only ment for internal use						#
#													#
#####################################################

# NATIVE Pandoc native Haskell

$(BUILD_DIR)/$(BUILD_TITLE).pandoc: $(SOURCES)
	$(call prepare)
	@$(PANDOC) $(PANDOC_NATIVE) --output $@ $^

# Collection

collect: $(BUILD_DIR)/$(BUILD_TITLE)-content.md $(BUILD_DIR)/$(BUILD_TITLE)-book.md
	$(call log,Collected $(EXPORT_TITLE).,targetEnd,✓)

$(BUILD_DIR)/$(BUILD_TITLE)-content.md: $(SOURCES)
	@$(PANDOC) $(PANDOC_COLLECT) --output $@ $^
	$(call log,Collecting $(EXPORT_TITLE)...,targetStart,❁)

$(BUILD_DIR)/$(BUILD_TITLE)-book.md: assets/make-book.md
	@echo "# $(EXPORT_TITLE) {.book}" > $(BUILD_DIR)/$(BUILD_TITLE)-book.md
	
# Dedication for LaTeX and ePub
	
$(BUILD_DIR)/dedication.tex: assets/dedication.md
	$(call prepare)
	@$(PANDOC) \
		--template="$(PANDOC_TEMPLATES)/desbeers-pdf-dedication.tex" \
		--lua-filter "$(PANDOC_FILTERS)/desbeers-linebreaks.lua" \
		--output $@ $^

	
$(BUILD_DIR)/dedication.epub: assets/dedication.md
	$(call prepare)
	@$(PANDOC) \
		--template="$(PANDOC_TEMPLATES)/desbeers-epub-dedication.html" \
		--metadata-file=assets/make-book.md \
		--write=html \
		--lua-filter "$(PANDOC_FILTERS)/desbeers-linebreaks.lua" \
		--output $@ $^

#####################################################
#													#
# TEX												#
#													#
#####################################################

tex: $(BUILD_DIR)/$(BUILD_TITLE).tex
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).tex"
	$(call log,LaTeX file done.,targetEnd,✓)
	
$(BUILD_DIR)/$(BUILD_TITLE).tex: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.tex assets/make-book.md
	$(call prepare)
	$(call log,Making LaTeX file...,targetStart,❁)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_TEX) --output $@ $<

#####################################################
#													#
# PDF												#
#													#
#####################################################

pdf: $(BUILD_DIR)/$(BUILD_TITLE).pdf
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).pdf"
	$(call log,Your PDF file is done.,targetEnd,✓)

$(BUILD_DIR)/$(BUILD_TITLE).pdf: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.tex assets/make-book.md
	$(call prepare)
	$(call log,Making your PDF file...,targetStart,❁)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF) --output $@ $<

#####################################################
#													#
# PRINT pdf without cover							#
#													#
#####################################################

print: $(BUILD_DIR)/$(BUILD_TITLE)-print.pdf
	@cp $< "$(EXPORT_DIR)/PRINT $(EXPORT_TITLE).pdf"
	$(call log,Your printable file done.,targetEnd,✓)
	
$(BUILD_DIR)/$(BUILD_TITLE)-print.pdf: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.tex assets/make-book.md
	$(call prepare)
	$(call log,Making your printable file...,targetStart,❁)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PRINT) --output $@ $<
	
#####################################################
#													#
# ePub												#
#													#
#####################################################

epub: $(BUILD_DIR)/$(BUILD_TITLE).epub
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).epub"
	$(call log,Your ePub file is done.,targetEnd,✓)

$(BUILD_DIR)/$(BUILD_TITLE).epub: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.epub assets/make-book.md
	$(call prepare)
	$(call log,Making your ePub file...,targetStart,❁)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB) --output $@ $<

#####################################################
#													#
# Kobo												#
#													#
#####################################################

kobo: $(BUILD_DIR)/KOBO_$(BUILD_TITLE).kepub.epub
	@cp $< "$(EXPORT_DIR)/KOBO_$(EXPORT_TITLE).kepub.epub"
	$(call log,Your Kobo book is done.,targetEnd,✓)

$(BUILD_DIR)/KOBO_$(BUILD_TITLE).kepub.epub: $(BUILD_DIR)/KOBO_$(BUILD_TITLE).epub	
	@$(KOBOGEN) -i -o $(BUILD_DIR) $(BUILD_DIR)/KOBO_$(BUILD_TITLE).epub >/dev/null

$(BUILD_DIR)/KOBO_$(BUILD_TITLE).epub: $(BUILD_DIR)/$(BUILD_TITLE).pandoc assets/make-book.md
	$(call prepare)
	$(call log,Making your Kobo book...,targetStart,❁)
ifneq ("$(wildcard $(COVER))","")
	@$(CONVERT) assets/cover-screen.jpg -resize 544x816\! -colorspace Gray $(BUILD_DIR)/cover-screen-kobo.jpg
	
	@$ magick composite -gravity center  $(BUILD_DIR)/cover-screen-kobo.jpg "$(PANDOC_TEMPLATES)/cover-kobo.jpg"  $(BUILD_DIR)/cover-screen-kobo.jpg
	
endif
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_KOBO) --output $@ $<

#####################
#					#
# REMAINING STUFF	#
#					#
#####################

define prepare
	$(shell $(MKDIR) -p "$(BUILD_DIR)") \
	$(shell $(MKDIR) -p "$(EXPORT_DIR)")
endef

define log
	@sleep 0.5
	@if [[ $(GUI) == "mac" ]]; then echo "$(2):$(1)"; fi
	@if [[ $(GUI) == "cmd" ]]; then echo "$(3) $(1)"; fi
endef

clean:
	$(call log,Cleaning up '$(EXPORT_TITLE)'...,targetClean,✄)
	@if [ -d "$(SOURCE_DIR)" ]; then rm -Rf "$(SOURCE_DIR)"; fi
	@if [ -d "$(BUILD_DIR)" ]; then rm -Rf "$(BUILD_DIR)"; fi
	@if [ -d "$(EXPORT_DIR)" ]; then rm -Rf "$(EXPORT_DIR)"; fi
	
