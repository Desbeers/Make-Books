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

# Coloured pages in the PDF output..
PANDOC_PDF := $(PANDOC_TEX) \
	--metadata=use-colours

# No coloured hyperlinks in the print output.
PANDOC_PRINT := $(PANDOC_TEX) \
	--metadata=hide-links

PANDOC_EPUB := \
    --template="$(PANDOC_TEMPLATES)/desbeers-epub.html" \
	--toc \
	--epub-embed-font="$(PANDOC_FONTS)/GreatVibes.ttf" \
	--css="$(PANDOC_CSS)/epub-css.css" \
	--css="$(PANDOC_CSS)/epub-greatvibes.css" \
	--include-before-body="$(BUILD_DIR)/dedication.epub" \
	+RTS -K100000000 -RTS \
	
PANDOC_HTML := \
	--toc \
	--css="$(PANDOC_CSS)/html-css.css" \
	--self-contained \
	--standalone \

PANDOC_DOCX := \
	--toc \
	
PANDOC_MD := \
	--lua-filter "$(PANDOC_FILTERS)/desbeers-hashtags.lua"

PANDOC_MD := \
	--lua-filter "$(PANDOC_FILTERS)/desbeers-hashtags.lua" \
	--file-scope

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
	PANDOC_PDF+= --metadata=have-cover
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

.PHONY: clean all md tex pdf print epub eproof html docx

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
	$(call log,✓ Collected $(EXPORT_TITLE).,done)

$(BUILD_DIR)/$(BUILD_TITLE)-content.md: $(SOURCES)
	@$(PANDOC) $(PANDOC_COLLECT) --output $@ $^
	$(call log,❁ Collecting $(EXPORT_TITLE)...,making)

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
# MD												#
#													#
#####################################################

md: $(BUILD_DIR)/$(BUILD_TITLE).md
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).md"
	$(call log,✓ Markdown file done.,done)

$(BUILD_DIR)/$(BUILD_TITLE).md: $(SOURCES)
	$(call prepare)
	$(call log,❁ Making markdown file...,making)
	@$(PANDOC) $(PANDOC_MD) --output $@ $^

#####################################################
#													#
# TEX												#
#													#
#####################################################

tex: $(BUILD_DIR)/$(BUILD_TITLE).tex
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).tex"
	$(call log,✓ LaTeX file done.,done)
	
$(BUILD_DIR)/$(BUILD_TITLE).tex: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.tex assets/make-book.md
	$(call prepare)
	$(call log,❁ Making LaTeX file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_TEX) --output $@ $<

#####################################################
#													#
# PDF												#
#													#
#####################################################

pdf: $(BUILD_DIR)/$(BUILD_TITLE).pdf
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).pdf"
	$(call log,✓ Your PDF file is done.,done)

$(BUILD_DIR)/$(BUILD_TITLE).pdf: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.tex assets/make-book.md
	$(call prepare)
	$(call log,❁ Making your PDF file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF) --output $@ $<

#####################################################
#													#
# PRINT pdf without cover							#
#													#
#####################################################

print: $(BUILD_DIR)/$(BUILD_TITLE)-print.pdf
	@cp $< "$(EXPORT_DIR)/PRINT $(EXPORT_TITLE).pdf"
	$(call log,✓ Your printable file done.,done)
	
$(BUILD_DIR)/$(BUILD_TITLE)-print.pdf: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.tex assets/make-book.md
	$(call prepare)
	$(call log,❁ Making your printable file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PRINT) --output $@ $<
	
#####################################################
#													#
# ePub												#
#													#
#####################################################

epub: $(BUILD_DIR)/$(BUILD_TITLE).epub
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).epub"
	$(call log,✓ Your ePub file is done.,done)

$(BUILD_DIR)/$(BUILD_TITLE).epub: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.epub assets/make-book.md
	$(call prepare)
	$(call log,❁ Making your ePub file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB) --output $@ $<

#####################################################
#													#
# ePub	proofreading								#
#													#
#####################################################

eproof: $(BUILD_DIR)/$(BUILD_TITLE)-proof.epub
	@rsync -r "$(BUILD_DIR)/tmp/PROOF $(EXPORT_TITLE).epub" "$(EXPORT_DIR)"
	$(call log,✓ ePub development file done.,done)

$(BUILD_DIR)/$(BUILD_TITLE)-proof.epub: $(BUILD_DIR)/$(BUILD_TITLE).pandoc $(BUILD_DIR)/dedication.epub assets/make-book.md
	$(call prepare)
	$(call log,❁ Making ePub development file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB) --output $@ $<

	@cp $@ $(BUILD_DIR)/$(BUILD_TITLE)-proof.zip

	@$(shell $(MKDIR) -p "$(BUILD_DIR)/tmp/PROOF $(EXPORT_TITLE).epub")

	@unzip -q -o -d "$(BUILD_DIR)/tmp/PROOF $(EXPORT_TITLE).epub" $(BUILD_DIR)/$(BUILD_TITLE)-proof.zip

#####################################################
#													#
# HTML												#
#													#
#####################################################

html: $(BUILD_DIR)/$(BUILD_TITLE).html
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).html"
	$(call log,✓ html file done.,done)
	
$(BUILD_DIR)/$(BUILD_TITLE).html: $(BUILD_DIR)/$(BUILD_TITLE).pandoc
	$(call prepare)
	$(call log,❁ Making html file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML) --output $@ $^

#####################################################
#													#
# DOCX												#
#													#
#####################################################

docx: $(BUILD_DIR)/$(BUILD_TITLE).docx
	@cp $< "$(EXPORT_DIR)/$(EXPORT_TITLE).docx"
	$(call log,✓ docx file done.,done)
	
$(BUILD_DIR)/$(BUILD_TITLE).docx: $(BUILD_DIR)/$(BUILD_TITLE).pandoc
	$(call prepare)
	$(call log,❁ Making docx file...,making)
	@$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_DOCX) --output $@ $^

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
	@echo '$(1)'
	@echo "log += \"<p class='make $(2)'>$(1)</p>\";" >> $(JSLOGFILE)
endef

clean:
	$(call log,✄ Cleaning up $(EXPORT_TITLE)...,clean)
	@if [ -d "$(SOURCE_DIR)" ]; then rm -Rf "$(SOURCE_DIR)"; fi
	@if [ -d "$(BUILD_DIR)" ]; then rm -Rf "$(BUILD_DIR)"; fi
	@if [ -d "$(EXPORT_DIR)" ]; then rm -Rf "$(EXPORT_DIR)"; fi
	
