
PACKNAME = TestPack
PACKDIR  = $(PACKNAME)
SRCDIR   = pack
MCDIR    = $(HOME)/.minecraft
MCJAR    = $(MCDIR)/bin/minecraft.jar
DIRS     = $(SRCDIR)/gui $(SRCDIR)/terrain.png.d $(SRCDIR)/gui/items.png.d

.PHONY: all
all: $(PACKNAME).zip

$(PACKNAME).zip: $(PACKDIR)
	cd $< && zip -r $@ *
	mv $</$@ $@

$(PACKDIR): $(SRCDIR) $(SRCDIR)/pack.txt $(SRCDIR)/terrain.png $(SRCDIR)/gui/items.png
	cp -R $< $@
	rm -rf $(PACKDIR)/terrain.png.in   $(PACKDIR)/terrain.png.d \
	       $(PACKDIR)/gui/items.png.in $(PACKDIR)/gui/items.png.d

$(SRCDIR): $(DIRS)

$(DIRS):
	mkdir -p $@

$(SRCDIR)/terrain.png: $(SRCDIR)/terrain.png.in
	./maketiles $@

$(SRCDIR)/terrain.png.in: $(MCJAR)
	jar -xvf $< terrain.png
	mv terrain.png $@

$(SRCDIR)/gui/items.png: $(SRCDIR)/gui/items.png.in
	./maketiles $@

$(SRCDIR)/gui/items.png.in: $(MCJAR)
	jar -xvf $< gui/items.png
	mv gui/items.png $@
	rmdir gui

$(SRCDIR)/pack.txt:
	[ ! -f $@ ] && echo "$(PACKNAME)" >$@

.PHONY: install
install: all
	cp $(PACKNAME).zip $(MCDIR)/texturepacks

.PHONY: clean
clean:
	rm -rf $(PACKDIR) $(PACKNAME).zip \
	       $(SRCDIR)/terrain.png.in   $(SRCDIR)/terrain.png \
	       $(SRCDIR)/gui/items.png.in $(SRCDIR)/gui/items.png

.PHONY: uninstall
uninstall:
	rm -rf $(MCDIR)/texturepacks/$(PACKNAME).zip

example:
	mkdir example
	cd example && jar xvf $(MCJAR) && rm -rf *.class META-INF/ achievement/ com/ paulscode/ lang/ net/

