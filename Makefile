CSC := chicken-csc -d2 -O0

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
	$(CSC) -c -J -o $(BUILDDIR)/colour.o $(SRCDIR)/colour.scm

$(BUILDDIR)/op.o: $(SRCDIR)/op.scm $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/op.o $(SRCDIR)/op.scm

$(BUILDDIR)/parse.o: $(SRCDIR)/parse.scm $(BUILDDIR)/op.o $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/parse.o $(SRCDIR)/parse.scm

$(BUILDDIR)/doc.o: $(SRCDIR)/doc.scm $(BUILDDIR)/colour.o
	$(CSC) -c -J -o $(BUILDDIR)/doc.o $(SRCDIR)/doc.scm

$(TARGET): $(SRCDIR)/main.scm $(BUILDDIR)/doc.o $(BUILDDIR)/parse.o $(BUILDDIR)/colour.o $(BUILDDIR)/op.o
	$(CSC) $^ -o $@
