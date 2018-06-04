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

$(BUILDDIR)/op.o: $(SOURCEDIR)/op.scm
	$(CSC) -c -J -o $(BUILDDIR)/op.o $(SOURCEDIR)/op.scm -unit rpn-op

$(BUILDDIR)/parse.o: $(SOURCEDIR)/parse.scm $(BUILDDIR)/op.o
	$(CSC) -c -J -o $(BUILDDIR)/parse.o $(SOURCEDIR)/parse.scm -unit rpn-parse -uses rpn-op

$(BUILDDIR)/doc.o: $(SOURCEDIR)/doc.scm
	$(CSC) -c -J -o $(BUILDDIR)/doc.o $(SOURCEDIR)/doc.scm -unit rpn-doc

$(TARGET): $(SOURCEDIR)/main.scm $(BUILDDIR)/op.o $(BUILDDIR)/parse.o $(BUILDDIR)/doc.o
	$(CSC) -o $(TARGET) $(SOURCEDIR)/main.scm $(BUILDDIR)/op.o $(BUILDDIR)/parse.o $(BUILDDIR)/doc.o -uses rpn-doc -uses rpn-parse
