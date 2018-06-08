CSC = csc -O2 -d2

TARGET = rpn

SOURCEDIR = src
BUILDDIR = build

all: build clean

build: $(TARGET)

clean:
	rm -f $(BUILDDIR)/*
	# csc doesn't have a flag to specify -J output
	rm -f *.import.scm

.PHONY: all build clean

$(BUILDDIR)/colour.o: $(SOURCEDIR)/colour.scm
	$(CSC) -c -J -o $(BUILDDIR)/colour.o $(SOURCEDIR)/colour.scm -unit rpn-colour

$(BUILDDIR)/op.o: $(SOURCEDIR)/op.scm $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/op.o $(SOURCEDIR)/op.scm -unit rpn-op -uses rpn-colour

$(BUILDDIR)/parse.o: $(SOURCEDIR)/parse.scm $(BUILDDIR)/op.o $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/parse.o $(SOURCEDIR)/parse.scm -unit rpn-parse -uses rpn-op -uses rpn-colour

$(BUILDDIR)/doc.o: $(SOURCEDIR)/doc.scm $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/doc.o $(SOURCEDIR)/doc.scm -unit rpn-doc -uses rpn-colour

$(TARGET): $(SOURCEDIR)/main.scm $(BUILDDIR)/op.o $(BUILDDIR)/parse.o $(BUILDDIR)/doc.o $(BUILDDIR)/colour.o
	$(CSC) -o $(TARGET) $(SOURCEDIR)/main.scm $(BUILDDIR)/op.o $(BUILDDIR)/parse.o $(BUILDDIR)/doc.o $(BUILDDIR)/colour.o -uses rpn-doc -uses rpn-parse -uses rpn-colour
