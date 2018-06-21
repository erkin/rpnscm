CSC := csc -d2 -O0

TARGET := rpn

SRCDIR := src
BUILDDIR := build

all: build clean

build: $(TARGET)

clean:
	rm -f $(BUILDDIR)/*
	# csc doesn't have a flag to specify -J output
	rm -f *.import.scm

.PHONY: all build clean

$(BUILDDIR)/colour.o: $(SRCDIR)/colour.scm
	$(CSC) -c -J -o $(BUILDDIR)/colour.o $(SRCDIR)/colour.scm -unit rpn-colour

$(BUILDDIR)/op.o: $(SRCDIR)/op.scm $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/op.o $(SRCDIR)/op.scm -unit rpn-op -uses rpn-colour

$(BUILDDIR)/parse.o: $(SRCDIR)/parse.scm $(BUILDDIR)/op.o $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/parse.o $(SRCDIR)/parse.scm -unit rpn-parse -uses rpn-op -uses rpn-colour

$(BUILDDIR)/doc.o: $(SRCDIR)/doc.scm $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/doc.o $(SRCDIR)/doc.scm -unit rpn-doc -uses rpn-colour

$(TARGET): $(SRCDIR)/main.scm $(BUILDDIR)/op.o $(BUILDDIR)/parse.o $(BUILDDIR)/doc.o $(BUILDDIR)/colour.o
	$(CSC) -o $(TARGET) $(SRCDIR)/main.scm $(BUILDDIR)/op.o $(BUILDDIR)/parse.o $(BUILDDIR)/doc.o $(BUILDDIR)/colour.o -uses rpn-doc -uses rpn-parse -uses rpn-colour
