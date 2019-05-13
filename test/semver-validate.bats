#!/usr/bin/env bats

semver-validate() {
    ./semver-validate "$@"
}

should_allow() {
    run semver-validate "$1"
    [[ "$status" -eq 0 ]]
}

should_reject() {
    run semver-validate "$1"
    [[ "$status" -eq 1 ]]
}

##
## MAJOR.MINOR.PATCH
##

@test 'semver-validate: 0.0.0 should pass' {
    should_allow '0.0.0'
}

@test 'semver-validate: 0.0.1 should pass' {
    should_allow '0.0.1'
}

@test 'semver-validate: 0.1.0 should pass' {
    should_allow '0.1.0'
}

@test 'semver-validate: 1.0.0 should pass' {
    should_allow '1.0.0'
}

@test 'semver-validate: 1.2.3 should pass' {
    should_allow '1.2.3'
}

@test 'semver-validate: 2.0.0 should pass' {
    should_allow '2.0.0'
}

@test 'semver-validate: 10.10.10 should pass' {
    should_allow '10.10.10'
}

@test 'semver-validate: 10.20.30 should pass' {
    should_allow '10.20.30'
}

@test 'semver-validate: 99999999999999999999999.999999999999999999.99999999999999999 should pass' {
    should_allow '99999999999999999999999.999999999999999999.99999999999999999'
}

@test 'semver-validate: 1234567890.1234567890.1234567890 should pass' {
    should_allow '1234567890.1234567890.1234567890'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE
##

@test 'semver-validate: 1.0.0-a should pass' {
    should_allow '1.0.0-a'
}

@test 'semver-validate: 1.0.0-1 should pass' {
    should_allow '1.0.0-1'
}

@test 'semver-validate: 1.0.0-a.1 should pass' {
    should_allow '1.0.0-a.1'
}

@test 'semver-validate: 1.0.0-1.2.3 should pass' {
    should_allow '1.0.0-1.2.3'
}

@test 'semver-validate: 1.0.0-a.1.b.2.c.3 should pass' {
    should_allow '1.0.0-a.1.b.2.c.3'
}

@test 'semver-validate: 1.0.0-a.a should pass' {
    should_allow '1.0.0-a.a'
}

@test 'semver-validate: 1.0.0-a-a should pass' {
    should_allow '1.0.0-a-a'
}

@test 'semver-validate: 1.0.0-a1.a1 should pass' {
    should_allow '1.0.0-a1.a1'
}

@test 'semver-validate: 1.0.0-A should pass' {
    should_allow '1.0.0-A'
}

@test 'semver-validate: 1.0.0---a--- should pass' {
    should_allow '1.0.0---a---'
}

@test 'semver-validate: 1.0.0-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789- should pass' {
    should_allow '1.0.0-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-'
}

##
## MAJOR.MINOR.PATCH+BUILD
##

@test 'semver-validate: 1.0.0+a should pass' {
    should_allow '1.0.0+a'
}

@test 'semver-validate: 1.0.0+1 should pass' {
    should_allow '1.0.0+1'
}

@test 'semver-validate: 1.0.0+01 should pass' {
    should_allow '1.0.0+01'
}

@test 'semver-validate: 1.0.0+a.1 should pass' {
    should_allow '1.0.0+a.1'
}

@test 'semver-validate: 1.0.0+a-a should pass' {
    should_allow '1.0.0+a-a'
}

@test 'semver-validate: 1.0.0+a-1 should pass' {
    should_allow '1.0.0+a-1'
}

@test 'semver-validate: 1.0.0+a.1.b.2.c.3 should pass' {
    should_allow '1.0.0+a.1.b.2.c.3'
}

@test 'semver-validate: 1.0.0+A should pass' {
    should_allow '1.0.0+A'
}

@test 'semver-validate: 1.0.0+--a should pass' {
    should_allow '1.0.0+--a'
}

@test 'semver-validate: 1.0.0+ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789- should pass' {
    should_allow '1.0.0+ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE+BUILD
##

@test 'semver-validate: 1.0.0-a+a should pass' {
    should_allow '1.0.0-a+a'
}

@test 'semver-validate: 1.0.0-1+a should pass' {
    should_allow '1.0.0-1+a'
}

@test 'semver-validate: 1.0.0-a+1 should pass' {
    should_allow '1.0.0-a+1'
}

@test 'semver-validate: 1.0.0-1+1 should pass' {
    should_allow '1.0.0-1+1'
}

@test 'semver-validate: 1.0.0-a.1+a.1 should pass' {
    should_allow '1.0.0-a.1+a.1'
}

##
## Invalid: Prepending or appending characters to the semver
##

@test 'semver-validate: v1.0.0 should fail' {
    should_reject 'v1.0.0'
}

@test 'semver-validate: 1.0.0a should fail' {
    should_reject '1.0.0a'
}

@test 'semver-validate: v1.0.0a should fail' {
    should_reject 'v1.0.0a'
}

@test 'semver-validate: v1.0.0-a should fail' {
    should_reject 'v1.0.0-a'
}

@test 'semver-validate: v1.0.0+a should fail' {
    should_reject 'v1.0.0+a'
}

@test 'semver-validate: v1.0.0-a+a should fail' {
    should_reject 'v1.0.0-a+a'
}


##
## Invalid: Incorrect separator characters in MAJOR.MINOR.PATCH
##

@test 'semver-validate: 1_0_0 should fail' {
    should_reject '1_0_0'
}

@test 'semver-validate: 1-0-0 should fail' {
    should_reject '1-0-0'
}

@test 'semver-validate: 1,0,0 should fail' {
    should_reject '1,0,0'
}

##
## Invalid: Less than 3 dotted identifiers
##

@test 'semver-validate: a should fail' {
    should_reject 'a'
}

@test 'semver-validate: a.a should fail' {
    should_reject 'a.a'
}

@test 'semver-validate: a.0 should fail' {
    should_reject 'a.0'
}

@test 'semver-validate: 1 should fail' {
    should_reject '1'
}

@test 'semver-validate: 1. should fail' {
    should_reject '1.'
}

@test 'semver-validate: .1 should fail' {
    should_reject '.1'
}

@test 'semver-validate: 1-a should fail' {
    should_reject '1-a'
}

@test 'semver-validate: 1+a should fail' {
    should_reject '1+a'
}

@test 'semver-validate: 1.0 should fail' {
    should_reject '1.0'
}

@test 'semver-validate: 1.0-a should fail' {
    should_reject '1.0-a'
}

@test 'semver-validate: 1.0+a should fail' {
    should_reject '1.0+a'
}

##
## Invalid: More than 3 dotted identifiers
##

@test 'semver-validate: 1.0.0.0 should fail' {
    should_reject '1.0.0.0'
}

@test 'semver-validate: 1.0.0.a should fail' {
    should_reject '1.0.0.a'
}

##
## Invalid: Empty MAJOR, MINOR, or PATCH
##

@test 'semver-validate: .0.0 should fail' {
    should_reject '.0.0'
}

@test 'semver-validate: 0..0 should fail' {
    should_reject '0..0'
}

@test 'semver-validate: 0.0. should fail' {
    should_reject '0.0.'
}

@test 'semver-validate: 0.. should fail' {
    should_reject '0..'
}

@test 'semver-validate: ..0 should fail' {
    should_reject '..0'
}

@test 'semver-validate: .. should fail' {
    should_reject '..'
}

##
## Invalid: Numeric identifiers with leading zeroes
##

@test 'semver-validate: 01.01.01 should fail' {
    should_reject '01.01.01'
}

@test 'semver-validate: 01.1.1 should fail' {
    should_reject '01.1.1'
}

@test 'semver-validate: 1.01.1 should fail' {
    should_reject '1.01.1'
}

@test 'semver-validate: 1.1.01 should fail' {
    should_reject '1.1.01'
}

@test 'semver-validate: 1.0.0-01 should fail' {
    should_reject '1.0.0-01'
}

##
## Invalid: More than one BUILD
##

@test 'semver-validate: 1.0.0+a+a should fail' {
    should_reject '1.0.0+a+a'
}

##
## Invalid: PRERELEASE or BUILD on their own
##

@test 'semver-validate: +a should fail' {
    should_reject '+a'
}

@test 'semver-validate: -a should fail' {
    should_reject '-a'
}

@test 'semver-validate: -a+a should fail' {
    should_reject '-a+a'
}

##
## Invalid: PRERELEASE or BUILD have no identifiers
##

@test 'semver-validate: 1.0.0- should fail' {
    should_reject '1.0.0-'
}

@test 'semver-validate: 1.0.0+ should fail' {
    should_reject '1.0.0+'
}

##
## Invalid: PRERELEASE or BUILD have empty identifiers
##

@test 'semver-validate: 1.0.0-1. should fail' {
    should_reject '1.0.0-1.'
}

@test 'semver-validate: 1.0.0-1..1 should fail' {
    should_reject '1.0.0-1..1'
}

@test 'semver-validate: 1.0.0+1. should fail' {
    should_reject '1.0.0+1.'
}

@test 'semver-validate: 1.0.0+1..1 should fail' {
    should_reject '1.0.0+1..1'
}

##
## Invalid: MAJOR, MINOR, or PATCH contain letters
##

@test 'semver-validate: a.a.a should fail' {
    should_reject 'a.a.a'
}

@test 'semver-validate: a.0.0 should fail' {
    should_reject 'a.0.0'
}

@test 'semver-validate: 0.a.0 should fail' {
    should_reject '0.a.0'
}

@test 'semver-validate: 0.0.a should fail' {
    should_reject '0.0.a'
}

##
## Invalid: Incorrect separator characters in PRERELEASE
##

@test 'semver-validate: 1.0.0-a_a should fail' {
    should_reject '1.0.0-a_a'
}

@test 'semver-validate: 1.0.0-a,a should fail' {
    should_reject '1.0.0-a,a'
}

##
## Invalid: Incorrect separator characters in BUILD
##

@test 'semver-validate: 1.0.0+a_a should fail' {
    should_reject '1.0.0+a_a'
}

@test 'semver-validate: 1.0.0+a,a should fail' {
    should_reject '1.0.0+a,a'
}

##
## I/O concerns
##

@test 'semver-validate: should not tolerate missing operand' {
    should_reject ''
}

@test 'semver-validate: should not tolerate whitespace' {
    should_reject ' 0.0.0' && should_reject '0.0.0 '
}

@test "semver-validate: -h should print usage" {
    run semver-validate -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}