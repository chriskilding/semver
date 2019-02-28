#!/usr/bin/env make

prefix := /usr/local

.PHONY: all test install

# Nothing to compile
all:

test:
	bats test

install:
	@mkdir -p $(DESTDIR)$(prefix)/bin
	install semver $(DESTDIR)$(prefix)/bin
	@mkdir -p $(DESTDIR)$(prefix)/share/man/man1
	install semver.1 $(DESTDIR)$(prefix)/share/man/man1
