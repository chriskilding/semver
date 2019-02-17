#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

should_eq() {
    run semver compare "$1" -eq "$2"
    [[ "$status" -eq 0 ]]
}

should_ne() {
    run semver compare "$1" -ne "$2"
    [[ "$status" -eq 0 ]]
}

should_gt() {
    run semver compare "$1" -gt "$2"
    [[ "$status" -eq 0 ]]
}

should_not_gt() {
    run semver compare "$1" -gt "$2"
    [[ "$status" -eq 1 ]]
}

##
## MAJOR.MINOR.PATCH
##

@test "compare: 1.2.3 should == 1.2.3" {
    should_eq "1.2.3" "1.2.3"
}

@test "compare: 1.0.0 should != 2.0.0" {
    should_ne "1.0.0" "2.0.0"
}

@test "compare: 0.1.0 should != 0.2.0" {
    should_ne "0.1.0" "0.2.0"
}

@test "compare: 0.0.1 should != 0.0.2" {
    should_ne "0.0.1" "0.0.2"
}

@test 'compare: 2.0.0 should > 1.0.0' {
    # MAJOR > MAJOR
    should_gt '2.0.0' '1.0.0'
}

@test 'compare: 1.0.0 should not > 2.0.0' {
    # MAJOR < MAJOR
    should_not_gt '1.0.0' '2.0.0'
}

@test 'compare: 2.1.0 should > 2.0.0' {
    # MAJOR == MAJOR && MINOR > MINOR
    should_gt '2.1.0' '2.0.0'
}

@test 'compare: 2.0.0 should not > 2.1.0' {
    # MAJOR == MAJOR && MINOR < MINOR
    should_not_gt '2.0.0' '2.1.0'
}

@test 'compare: 2.1.1 should > 2.1.0' {
    # MAJOR == MAJOR && MINOR == MINOR && PATCH > PATCH
    should_gt '2.1.1' '2.1.0'
}

@test 'compare: 2.1.0 should not > 2.1.1' {
    # MAJOR == MAJOR && MINOR == MINOR && PATCH < PATCH
    should_not_gt '2.1.0' '2.1.1'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE
##

@test "compare: 0.0.1-alpha should == 0.0.1-alpha" {
    should_eq "0.0.1-alpha" "0.0.1-alpha"
}

@test "compare: 0.0.1 should != 0.0.1-alpha" {
    should_ne "0.0.1" "0.0.1-alpha"
}

@test "compare: 0.0.1-alpha should != 0.0.1-beta" {
    should_ne "0.0.1-alpha" "0.0.1-beta"
}

@test "compare: 0.0.1-alpha.1 should != 0.0.1-alpha.2" {
    should_ne "0.0.1-alpha.1" "0.0.1-alpha.2"
}

@test 'compare: 1.0.0 should > 1.0.0-alpha' {
    should_gt '1.0.0' '1.0.0-alpha'
}

##
## MAJOR.MINOR.PATCH+BUILD
##

@test "compare: 0.0.1+20080101 should == 0.0.1+20080101" {
    should_eq "0.0.1+20080101" "0.0.1+20080101"
}

@test "compare: 0.0.1+20080101 should == 0.0.1+20080102" {
    should_eq "0.0.1+20080101" "0.0.1+20080102"
}

@test 'compare: 1.0.0+b should not > 1.0.0+a' {
    should_not_gt '1.0.0+b' '1.0.0+a'
}

@test 'compare: 1.0.0 should not > 1.0.0+a' {
    should_not_gt '1.0.0' '1.0.0+a'
}

@test 'compare: 1.0.0+a should not > 1.0.0' {
    should_not_gt '1.0.0+a' '1.0.0'
}

##
## MAJOR.MINOR.PATCH-PRERELEASE+BUILD
##

@test "compare: 0.0.1-alpha+20080101 should == 0.0.1-alpha+20080101" {
    should_eq "0.0.1-alpha+20080101" "0.0.1-alpha+20080101"
}

@test "compare: 0.0.1-alpha+20080101 should == 0.0.1-alpha+20080102" {
    should_eq "0.0.1-alpha+20080101" "0.0.1-alpha+20080102"
}

@test "compare: 0.0.1-alpha+20080101 should != 0.0.1-beta+20080101" {
    should_ne "0.0.1-alpha+20080101" "0.0.1-beta+20080101"
}

@test 'compare: 1.0.0-alpha+b should not > 1.0.0-alpha+a' {
    should_not_gt '1.0.0-alpha+b' '1.0.0-alpha+a'
}

##
## I/O concerns
##

@test "compare: missing operator should fail" {
    run semver compare "1.0.0" "1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "compare: invalid operator should fail" {
    run semver compare "1.0.0" -foobar "1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "compare: missing operand should fail" {
    run semver compare "1.0.0" -eq
    [[ "$status" -eq 1 ]]
}