#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

. ./semver.sh

@test "functions: ++major 0.0.0 should be 1.0.0" {
    [[ $(++major "0.0.0") = "1.0.0" ]]
}

@test "functions: ++minor 0.0.0 should be 0.1.0" {
    [[ $(++minor "0.0.0") = "0.1.0" ]]
}

@test "functions: ++patch 0.0.0 should be 0.0.1" {
    [[ $(++patch "0.0.0") = "0.0.1" ]]
}

@test "functions: ++major 1.0.0 should be 2.0.0" {
    [[ $(++major "1.0.0") = "2.0.0" ]]
}

@test "functions: ++minor 0.1.0 should be 0.2.0" {
    [[ $(++minor "0.1.0") = "0.2.0" ]]
}

@test "functions: ++patch 0.0.1 should be 0.0.2" {
    [[ $(++patch "0.0.1") = "0.0.2" ]]
}

@test "functions: ++major 10.0.0 should be 11.0.0" {
    [[ $(++major "10.0.0") = "11.0.0" ]]
}

@test "functions: ++minor 0.10.0 should be 0.11.0" {
    [[ $(++minor "0.10.0") = "0.11.0" ]]
}

@test "functions: ++patch 0.0.10 should be 0.0.11" {
    [[ $(++patch "0.0.10") = "0.0.11" ]]
}

@test "functions: ++major 1.2.3 should be 2.0.0" {
    [[ $(++major "1.2.3") = "2.0.0" ]]
}

@test "functions: ++minor 1.2.3 should be 1.3.0" {
    [[ $(++minor "1.2.3") = "1.3.0" ]]
}

@test "functions: ++patch 1.2.3 should be 1.2.4" {
    [[ $(++patch "1.2.3") = "1.2.4" ]]
}

@test "functions: ++major -1.0.0 should fail" {
    run ++major "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "functions: ++minor 0.-1.0 should fail" {
    run ++minor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "functions: ++patch 0.0.-1 should fail" {
    run ++patch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "functions: invalid version should fail" {
    run ++major ".0.0"
    [[ "$status" -eq 1 ]]
}

@test "functions: '' should fail" {
    run ++major ''
    [[ "$status" -eq 1 ]]
}

@test "functions: should tolerate whitespace" {
    [[ $(++major " 0.0.0 ") = "1.0.0" ]]
}