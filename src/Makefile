
.so: %.scm
	csi -s rpn.system

rpn: rpn.so
	csc rpn.so

.PHONY: all build clean

all: build clean

build: rpn

clean:
	rm -f *.so
	rm -f *.import.scm
