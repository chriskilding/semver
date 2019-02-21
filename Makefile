#!/usr/bin/env make

prefix := /usr/local

.PHONY: all lint test

all: test

lint:
	shellcheck semver

test: lint
	bats test

install:
	install semver $(DESTDIR)$(prefix)/bin
	install semver.1 $(DESTDIR)$(prefix)/share/man/man1
