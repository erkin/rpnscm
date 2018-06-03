CSC = csc -O2

all: build

build: rpn

clean:
	rm -f *.import.scm
	rm -f *.so

.PHONY: all build clean

op:
	$(CSC) -s -J op.scm

docstring:
	$(CSC) -s -J docstring.scm

parse: op
	$(CSC) -s -J parse.scm

rpn: parse docstring
	$(CSC) -o rpn rpn.scm
