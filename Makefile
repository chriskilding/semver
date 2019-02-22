#!/usr/bin/env make

prefix := /usr/local

.PHONY: all test install

# Nothing to compile
all:

test:
	bats test

install:
	install semver $(DESTDIR)$(prefix)/bin
	install semver.1 $(DESTDIR)$(prefix)/share/man/man1
