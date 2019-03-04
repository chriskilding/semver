#!/usr/bin/env make

prefix = /usr/local

.PHONY: all test install uninstall

# Nothing to compile
all:

test:
	bats test

install:
	install semver $(DESTDIR)$(prefix)/bin
	install semver.1 $(DESTDIR)$(prefix)/share/man/man1

uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/semver
	-rm -f $(DESTDIR)$(prefix)/share/man/man1/semver.1
