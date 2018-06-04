CSC = csc -O2 -d2
SOURCEDIR = src
BULIDDIR = build
DESTDIR = bin

all: build clean

build: main

clean:
	rm -f *.c
	rm -f *.import.scm
	rm -f *.o
	rm -f *.so

.PHONY: all build clean

op:
	$(CSC) -c -J op.scm -unit rpn-op

parse: op
	$(CSC) -c -J parse.scm -unit rpn-parse -uses rpn-op

doc:
	$(CSC) -c -J doc.scm -unit rpn-doc

main: parse doc
	$(CSC) -o rpn main.scm op.o parse.o doc.o -uses rpn-doc -uses rpn-parse
