MAJOR=1
MINOR=2
CC=gcc
CFLAGS=-g -O2 -Wall -I. -DVERSION=\"$(MAJOR).$(MINOR)\"
OBJS=\
	cbtcommon/debug.o\
	cbtcommon/hash.o\
	cbtcommon/text_util.o\
	cvsps.o

cvsps: $(OBJS)
	gcc -o cvsps $(OBJS)

install:
	[ -d /usr/local/bin ] || mkdir -p /usr/local/bin
	[ -d /usr/local/man/man1 ] || mkdir -p /usr/local/man/man1
	install cvsps /usr/local/bin
	install -m 644 cvsps.1 /usr/local/man/man1

clean:
	rm -f cvsps *.o cbtcommon/*.o core

.PHONY: install clean
