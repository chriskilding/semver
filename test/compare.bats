#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

should_equal() {
    run semver compare "$1" -eq "$2"
    status_eq="$status"
    run semver compare "$1" -ne "$2"
    status_ne="$status"
    [[ "$status_eq" -eq 0 ]] && [[ "$status_ne" -eq 1 ]]
}

should_not_equal() {
    run semver compare "$1" -eq "$2"
    status_eq="$status"
    run semver compare "$1" -ne "$2"
    status_ne="$status"
    [[ "$status_eq" -eq 1 ]] && [[ "$status_ne" -eq 0 ]]
}

##
## MAJOR.MINOR.PATCH
##

@test "compare: 1.2.3 should equal 1.2.3" {
    should_equal "1.2.3" "1.2.3"
}

@test "compare: 1.0.0 should not equal 2.0.0" {
    should_not_equal "1.0.0" "2.0.0"
}

@test "compare: 0.1.0 should not equal 0.2.0" {
    should_not_equal "0.1.0" "0.2.0"
}

@test "compare: 0.0.1 should not equal 0.0.2" {
    should_not_equal "0.0.1" "0.0.2"
}

##
## MAJOR.MINOR.PATCH-PRERELEASE
##

@test "compare: 0.0.1-alpha should equal 0.0.1-alpha" {
    should_equal "0.0.1-alpha" "0.0.1-alpha"
}

@test "compare: 0.0.1 should not equal 0.0.1-alpha" {
    should_not_equal "0.0.1" "0.0.1-alpha"
}

@test "compare: 0.0.1-alpha should not equal 0.0.1-beta" {
    should_not_equal "0.0.1-alpha" "0.0.1-beta"
}

@test "compare: 0.0.1-alpha.1 should not equal 0.0.1-alpha.2" {
    should_not_equal "0.0.1-alpha.1" "0.0.1-alpha.2"
}

##
## MAJOR.MINOR.PATCH+BUILD
##

@test "compare: 0.0.1+20080101 should equal 0.0.1+20080101" {
    should_equal "0.0.1+20080101" "0.0.1+20080101"
}

@test "compare: 0.0.1+20080101 should equal 0.0.1+20080102" {
    should_equal "0.0.1+20080101" "0.0.1+20080102"
}

##
## MAJOR.MINOR.PATCH-PRERELEASE+BUILD
##

@test "compare: 0.0.1-alpha+20080101 should equal 0.0.1-alpha+20080101" {
    should_equal "0.0.1-alpha+20080101" "0.0.1-alpha+20080101"
}

@test "compare: 0.0.1-alpha+20080101 should equal 0.0.1-alpha+20080102" {
    should_equal "0.0.1-alpha+20080101" "0.0.1-alpha+20080102"
}

@test "compare: 0.0.1-alpha+20080101 should not equal 0.0.1-beta+20080101" {
    should_not_equal "0.0.1-alpha+20080101" "0.0.1-beta+20080101"
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