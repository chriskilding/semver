#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

should_lt() {
    [[ $(semver compare "$1" -lt "$2") -eq 0 ]] && [[ $(semver compare "$1" -gt "$2") -eq 1 ]]
}

should_eq() {
    [[ $(semver compare "$1" -eq "$2") -eq 0 ]] && [[ $(semver compare "$1" -ne "$2") -eq 1 ]]
}

should_gt() {
    [[ $(semver compare "$1" -gt "$2") -eq 0 ]] && [[ $(semver compare "$1" -lt "$2") -eq 1 ]]
}

@test 'compare: should support -eq operator' {
    [[ $(semver compare '1.0.0' -eq '1.0.0') -eq 0 ]]
}

@test 'compare: should support -ne operator' {
    [[ $(semver compare '1.0.0' -ne '2.0.0') -eq 0 ]]
}

@test 'compare: should support -ge operator' {
    [[ $(semver compare '2.0.0' -ge '1.0.0') -eq 0 ]]
}

@test 'compare: should support -gt operator' {
    [[ $(semver compare '2.0.0' -gt '1.0.0') -eq 0 ]]
}

@test 'compare: should support -le operator' {
    [[ $(semver compare '1.0.0' -le '2.0.0') -eq 0 ]]
}

@test 'compare: should support -lt operator' {
    [[ $(semver compare '1.0.0' -lt '2.0.0') -eq 0 ]]
}

##
## MAJOR.MINOR.PATCH
##

@test "compare: 1.2.3 should == 1.2.3" {
    should_eq "1.2.3" "1.2.3"
}

@test 'compare: 2.0.0 should > 1.0.0' {
    # MAJOR > MAJOR
    should_gt '2.0.0' '1.0.0'
}

@test 'compare: 2.1.0 should > 2.0.0' {
    # MAJOR == MAJOR && MINOR > MINOR
    should_gt '2.1.0' '2.0.0'
}

@test 'compare: 2.1.1 should > 2.1.0' {
    # MAJOR == MAJOR && MINOR == MINOR && PATCH > PATCH
    should_gt '2.1.1' '2.1.0'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE
##

@test "compare: 0.0.1-alpha should == 0.0.1-alpha" {
    should_eq "0.0.1-alpha" "0.0.1-alpha"
}

@test "compare: 0.0.1-alpha should < 0.0.1-beta" {
    should_lt "0.0.1-alpha" "0.0.1-beta"
}

@test 'compare: 1.0.0 should > 1.0.0-alpha' {
    should_gt '1.0.0' '1.0.0-alpha'
}

##
## MAJOR.MINOR.PATCH+BUILD
##

@test "compare: 0.0.1+1 should == 0.0.1+1" {
    should_eq "0.0.1+1" "0.0.1+1"
}

@test 'compare: 1.0.0+a should == 1.0.0+b' {
    should_eq '1.0.0+a' '1.0.0+b'
}

@test 'compare: 1.0.0 should == 1.0.0+a' {
    should_eq '1.0.0' '1.0.0+a'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE+BUILD
##

@test "compare: 0.0.1-alpha+1 should == 0.0.1-alpha+1" {
    should_eq "0.0.1-alpha+1" "0.0.1-alpha+1"
}

@test "compare: 0.0.1-alpha+1 should == 0.0.1-alpha+2" {
    should_eq "0.0.1-alpha+1" "0.0.1-alpha+2"
}

@test "compare: 0.0.1-beta+1 should > 0.0.1-alpha+1" {
    should_gt "0.0.1-beta+1" "0.0.1-alpha+1"
}

@test 'compare: 1.0.0-alpha+a should == 1.0.0-alpha+b' {
    should_eq '1.0.0-alpha+a' '1.0.0-alpha+b'
}

##
## I/O concerns
##

@test "compare: missing operand should fail" {
    run semver compare "1.0.0" -eq
    [[ "$status" -eq 1 ]]
}

@test "compare: invalid operand should fail" {
    run semver compare "1.0.0" -eq "foo"
    [[ "$status" -eq 1 ]]
}

@test "compare: invalid operator should fail" {
    run semver compare "1.0.0" -rubbish "1.0.0"
    [[ "$status" -eq 1 ]]
}