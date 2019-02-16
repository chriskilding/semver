#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

should_allow() {
    run semver validate "$1"
    [[ "$status" -eq 0 ]]
}

should_reject() {
    run semver validate "$1"
    [[ "$status" -eq 1 ]]
}

##
## MAJOR.MINOR.PATCH
##

@test 'validate: 0.0.0 should pass' {
    should_allow '0.0.0'
}

@test 'validate: 0.0.1 should pass' {
    should_allow '0.0.1'
}

@test 'validate: 0.1.0 should pass' {
    should_allow '0.1.0'
}

@test 'validate: 1.0.0 should pass' {
    should_allow '1.0.0'
}

@test 'validate: 1.2.3 should pass' {
    should_allow '1.2.3'
}

@test 'validate: 2.0.0 should pass' {
    should_allow '2.0.0'
}

@test 'validate: 10.10.10 should pass' {
    should_allow '10.10.10'
}

@test 'validate: 10.20.30 should pass' {
    should_allow '10.20.30'
}

@test 'validate: 99999999999999999999999.999999999999999999.99999999999999999 should pass' {
    should_allow '99999999999999999999999.999999999999999999.99999999999999999'
}

@test 'validate: 1234567890.1234567890.1234567890 should pass' {
    should_allow '1234567890.1234567890.1234567890'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE
##

@test 'validate: 1.0.0-a should pass' {
    should_allow '1.0.0-a'
}

@test 'validate: 1.0.0-1 should pass' {
    should_allow '1.0.0-1'
}

@test 'validate: 1.0.0-a.1 should pass' {
    should_allow '1.0.0-a.1'
}

@test 'validate: 1.0.0-1.2.3 should pass' {
    should_allow '1.0.0-1.2.3'
}

@test 'validate: 1.0.0-a.1.b.2.c.3 should pass' {
    should_allow '1.0.0-a.1.b.2.c.3'
}

@test 'validate: 1.0.0-a.a should pass' {
    should_allow '1.0.0-a.a'
}

@test 'validate: 1.0.0-a-a should pass' {
    should_allow '1.0.0-a-a'
}

@test 'validate: 1.0.0-a1.a1 should pass' {
    should_allow '1.0.0-a1.a1'
}

@test 'validate: 1.0.0-A should pass' {
    should_allow '1.0.0-A'
}

@test 'validate: 1.0.0---a--- should pass' {
    should_allow '1.0.0---a---'
}

@test 'validate: 1.0.0-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789- should pass' {
    should_allow '1.0.0-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-'
}

##
## MAJOR.MINOR.PATCH+BUILD
##

@test 'validate: 1.0.0+a should pass' {
    should_allow '1.0.0+a'
}

@test 'validate: 1.0.0+1 should pass' {
    should_allow '1.0.0+1'
}

@test 'validate: 1.0.0+01 should pass' {
    should_allow '1.0.0+01'
}

@test 'validate: 1.0.0+a.1 should pass' {
    should_allow '1.0.0+a.1'
}

@test 'validate: 1.0.0+a-a should pass' {
    should_allow '1.0.0+a-a'
}

@test 'validate: 1.0.0+a-1 should pass' {
    should_allow '1.0.0+a-1'
}

@test 'validate: 1.0.0+a.1.b.2.c.3 should pass' {
    should_allow '1.0.0+a.1.b.2.c.3'
}

@test 'validate: 1.0.0+A should pass' {
    should_allow '1.0.0+A'
}

@test 'validate: 1.0.0+--a should pass' {
    should_allow '1.0.0+--a'
}

@test 'validate: 1.0.0+ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789- should pass' {
    should_allow '1.0.0+ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE+BUILD
##

@test 'validate: 1.0.0-a+a should pass' {
    should_allow '1.0.0-a+a'
}

@test 'validate: 1.0.0-1+a should pass' {
    should_allow '1.0.0-1+a'
}

@test 'validate: 1.0.0-a+1 should pass' {
    should_allow '1.0.0-a+1'
}

@test 'validate: 1.0.0-1+1 should pass' {
    should_allow '1.0.0-1+1'
}

@test 'validate: 1.0.0-a.1+a.1 should pass' {
    should_allow '1.0.0-a.1+a.1'
}

##
## Invalid: Prepending or appending characters to the semver
##

@test 'validate: v1.0.0 should fail' {
    should_reject 'v1.0.0'
}

@test 'validate: 1.0.0a should fail' {
    should_reject '1.0.0a'
}

@test 'validate: v1.0.0a should fail' {
    should_reject 'v1.0.0a'
}

@test 'validate: v1.0.0-a should fail' {
    should_reject 'v1.0.0-a'
}

@test 'validate: v1.0.0+a should fail' {
    should_reject 'v1.0.0+a'
}

@test 'validate: v1.0.0-a+a should fail' {
    should_reject 'v1.0.0-a+a'
}


##
## Invalid: Incorrect separator characters in MAJOR.MINOR.PATCH
##

@test 'validate: 1_0_0 should fail' {
    should_reject '1_0_0'
}

@test 'validate: 1-0-0 should fail' {
    should_reject '1-0-0'
}

@test 'validate: 1,0,0 should fail' {
    should_reject '1,0,0'
}

##
## Invalid: Less than 3 dotted identifiers
##

@test 'validate: a should fail' {
    should_reject 'a'
}

@test 'validate: a.a should fail' {
    should_reject 'a.a'
}

@test 'validate: a.0 should fail' {
    should_reject 'a.0'
}

@test 'validate: 1 should fail' {
    should_reject '1'
}

@test 'validate: 1. should fail' {
    should_reject '1.'
}

@test 'validate: .1 should fail' {
    should_reject '.1'
}

@test 'validate: 1-a should fail' {
    should_reject '1-a'
}

@test 'validate: 1+a should fail' {
    should_reject '1+a'
}

@test 'validate: 1.0 should fail' {
    should_reject '1.0'
}

@test 'validate: 1.0-a should fail' {
    should_reject '1.0-a'
}

@test 'validate: 1.0+a should fail' {
    should_reject '1.0+a'
}

##
## Invalid: More than 3 dotted identifiers
##

@test 'validate: 1.0.0.0 should fail' {
    should_reject '1.0.0.0'
}

@test 'validate: 1.0.0.a should fail' {
    should_reject '1.0.0.a'
}

##
## Invalid: Empty MAJOR, MINOR, or PATCH
##

@test 'validate: .0.0 should fail' {
    should_reject '.0.0'
}

@test 'validate: 0..0 should fail' {
    should_reject '0..0'
}

@test 'validate: 0.0. should fail' {
    should_reject '0.0.'
}

@test 'validate: 0.. should fail' {
    should_reject '0..'
}

@test 'validate: ..0 should fail' {
    should_reject '..0'
}

@test 'validate: .. should fail' {
    should_reject '..'
}

##
## Invalid: Numeric identifiers with leading zeroes
##

@test 'validate: 01.01.01 should fail' {
    should_reject '01.01.01'
}

@test 'validate: 01.1.1 should fail' {
    should_reject '01.1.1'
}

@test 'validate: 1.01.1 should fail' {
    should_reject '1.01.1'
}

@test 'validate: 1.1.01 should fail' {
    should_reject '1.1.01'
}

@test 'validate: 1.0.0-01 should fail' {
    skip 'TODO check - this might be allowed by the spec as it is not a dotted numeric identifier'

    should_reject '1.0.0-01'
}

##
## Invalid: More than one BUILD
##

@test 'validate: 1.0.0+a+a should fail' {
    should_reject '1.0.0+a+a'
}

##
## Invalid: PRERELEASE or BUILD on their own
##

@test 'validate: +a should fail' {
    should_reject '+a'
}

@test 'validate: -a should fail' {
    should_reject '-a'
}

@test 'validate: -a+a should fail' {
    should_reject '-a+a'
}

##
## Invalid: PRERELEASE or BUILD have no identifiers
##

@test 'validate: 1.0.0- should fail' {
    should_reject '1.0.0-'
}

@test 'validate: 1.0.0+ should fail' {
    should_reject '1.0.0+'
}

##
## Invalid: PRERELEASE or BUILD have empty identifiers
##

@test 'validate: 1.0.0-1. should fail' {
    should_reject '1.0.0-1.'
}

@test 'validate: 1.0.0-1..1 should fail' {
    should_reject '1.0.0-1..1'
}

@test 'validate: 1.0.0+1. should fail' {
    should_reject '1.0.0+1.'
}

@test 'validate: 1.0.0+1..1 should fail' {
    should_reject '1.0.0+1..1'
}

##
## Invalid: MAJOR, MINOR, or PATCH contain letters
##

@test 'validate: a.a.a should fail' {
    should_reject 'a.a.a'
}

@test 'validate: a.0.0 should fail' {
    should_reject 'a.0.0'
}

@test 'validate: 0.a.0 should fail' {
    should_reject '0.a.0'
}

@test 'validate: 0.0.a should fail' {
    should_reject '0.0.a'
}

##
## Invalid: Incorrect separator characters in PRERELEASE
##

@test 'validate: 1.0.0-a_a should fail' {
    should_reject '1.0.0-a_a'
}

@test 'validate: 1.0.0-a,a should fail' {
    should_reject '1.0.0-a,a'
}

##
## Invalid: Incorrect separator characters in BUILD
##

@test 'validate: 1.0.0+a_a should fail' {
    should_reject '1.0.0+a_a'
}

@test 'validate: 1.0.0+a,a should fail' {
    should_reject '1.0.0+a,a'
}

##
## I/O concerns
##

@test 'validate: should not tolerate missing operand' {
    should_reject ''
}

@test 'validate: should not tolerate whitespace' {
    should_reject ' 0.0.0' && should_reject '0.0.0 '
}

