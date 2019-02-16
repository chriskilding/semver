#!/usr/bin/env make

.PHONY: all lint test

all: test

lint:
	shellcheck semver

test: lint
	bats test