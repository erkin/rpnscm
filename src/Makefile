CSC = csc -D2 -O2

all: build clean

build: rpn

clean:
	rm -f *.import.scm
	rm -f *.o

.PHONY: all build clean

op: op.scm
	$(CSC) -c -J op.scm

docstring:
	$(CSC) -c -J docstring.scm

parse: op
	$(CSC) -c -J op.o parse.scm

rpn: parse docstring
	$(CSC) -c parse.o docstring.o rpn.scm
	$(CSC) rpn.o -o rpn
