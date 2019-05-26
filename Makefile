#!/usr/bin/env make

prefix = /usr/local

.PHONY: all test install uninstall

# Nothing to compile
all:

test:
	bats test

install:
	mkdir -p $(DESTDIR)$(prefix)/bin $(DESTDIR)$(prefix)/share/awk $(DESTDIR)$(prefix)/share/man/man1 $(DESTDIR)$(prefix)/share/man/man3
	install semver $(DESTDIR)$(prefix)/bin
	install semver.awk $(DESTDIR)$(prefix)/share/awk
	install semver.1 $(DESTDIR)$(prefix)/share/man/man1
	install semver.3 $(DESTDIR)$(prefix)/share/man/man3

uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/semver
	-rm -f $(DESTDIR)$(prefix)/share/awk/semver.awk
	-rm -f $(DESTDIR)$(prefix)/share/man/man1/semver.1
	-rm -f $(DESTDIR)$(prefix)/share/man/man3/semver.3