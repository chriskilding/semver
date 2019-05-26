#!/usr/bin/env bats

dmajor() {
    awk -f semver.awk -e '{ print dmajor($0) }' <<< "$@"
}

dminor() {
    awk -f semver.awk -e '{ print dminor($0) }' <<< "$@"
}

dpatch() {
    awk -f semver.awk -e '{ print dpatch($0) }' <<< "$@"
}

imajor() {
    awk -f semver.awk -e '{ print imajor($0) }' <<< "$@"
}

iminor() {
    awk -f semver.awk -e '{ print iminor($0) }' <<< "$@"
}

ipatch() {
    awk -f semver.awk -e '{ print ipatch($0) }' <<< "$@"
}

# Increment

@test "awk: imajor 0.0.0 should be 1.0.0" {
    [[ $(imajor "0.0.0") = "1.0.0" ]]
}

@test "awk: iminor 0.0.0 should be 0.1.0" {
    [[ $(iminor "0.0.0") = "0.1.0" ]]
}

@test "awk: ipatch 0.0.0 should be 0.0.1" {
    [[ $(ipatch "0.0.0") = "0.0.1" ]]
}

@test "awk: imajor 1.0.0 should be 2.0.0" {
    [[ $(imajor "1.0.0") = "2.0.0" ]]
}

@test "awk: iminor 0.1.0 should be 0.2.0" {
    [[ $(iminor "0.1.0") = "0.2.0" ]]
}

@test "awk: ipatch 0.0.1 should be 0.0.2" {
    [[ $(ipatch "0.0.1") = "0.0.2" ]]
}

@test "awk: imajor 10.0.0 should be 11.0.0" {
    [[ $(imajor "10.0.0") = "11.0.0" ]]
}

@test "awk: iminor 0.10.0 should be 0.11.0" {
    [[ $(iminor "0.10.0") = "0.11.0" ]]
}

@test "awk: ipatch 0.0.10 should be 0.0.11" {
    [[ $(ipatch "0.0.10") = "0.0.11" ]]
}

@test "awk: imajor 1.2.3 should be 2.0.0" {
    [[ $(imajor "1.2.3") = "2.0.0" ]]
}

@test "awk: iminor 1.2.3 should be 1.3.0" {
    [[ $(iminor "1.2.3") = "1.3.0" ]]
}

@test "awk: ipatch 1.2.3 should be 1.2.4" {
    [[ $(ipatch "1.2.3") = "1.2.4" ]]
}

@test "awk: should tolerate prerelease" {
    [[ $(ipatch "1.2.3-alpha") = "1.2.4" ]]
}

@test "awk: should tolerate build" {
    [[ $(ipatch "1.2.3+2019") = "1.2.4" ]]
}

@test "awk: should tolerate prerelease and build" {
    [[ $(ipatch "1.2.3-alpha+2019") = "1.2.4" ]]
}

@test "awk: imajor -1.0.0 should fail" {
    run imajor "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: iminor 0.-1.0 should fail" {
    run iminor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: ipatch 0.0.-1 should fail" {
    run ipatch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

# Decrement

@test "awk: dmajor 1.0.0 should be 0.0.0" {
    [[ $(dmajor "1.0.0") = "0.0.0" ]]
}

@test "awk: dminor 0.1.0 should be 0.0.0" {
    [[ $(dminor "0.1.0") = "0.0.0" ]]
}

@test "awk: dpatch 0.0.1 should be 0.0.0" {
    [[ $(dpatch "0.0.1") = "0.0.0" ]]
}

@test "awk: dmajor 2.0.0 should be 1.0.0" {
    [[ $(dmajor "2.0.0") = "1.0.0" ]]
}

@test "awk: dminor 0.2.0 should be 0.1.0" {
    [[ $(dminor "0.2.0") = "0.1.0" ]]
}

@test "awk: dpatch 0.0.2 should be 0.0.1" {
    [[ $(dpatch "0.0.2") = "0.0.1" ]]
}

@test "awk: dmajor 11.0.0 should be 10.0.0" {
    [[ $(dmajor "11.0.0") = "10.0.0" ]]
}

@test "awk: dminor 0.11.0 should be 0.10.0" {
    [[ $(dminor "0.11.0") = "0.10.0" ]]
}

@test "awk: dpatch 0.0.11 should be 0.0.10" {
    [[ $(dpatch "0.0.11") = "0.0.10" ]]
}

@test "awk: dmajor 2.0.0-alpha should be 1.0.0" {
    [[ $(dmajor "2.0.0-alpha") = "1.0.0" ]]
}

@test "awk: dminor 0.2.0-alpha should be 0.1.0" {
    [[ $(dminor "0.2.0-alpha") = "0.1.0" ]]
}

@test "awk: dpatch 0.0.2-alpha should be 0.0.1" {
    [[ $(dpatch "0.0.2-alpha") = "0.0.1" ]]
}

@test "awk: dmajor 1.1.1 should be 0.0.0" {
    [[ $(dmajor "1.1.1") = "0.0.0" ]]
}

@test "awk: dminor 0.1.1 should be 0.0.0" {
    [[ $(dminor "0.1.1") = "0.0.0" ]]
}

@test "awk: dmajor 0.0.0 should fail" {
    run dmajor "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: dminor 0.0.0 should fail" {
    run dminor "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: dpatch 0.0.0 should fail" {
    run dpatch "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: dmajor -1.0.0 should fail" {
    run dmajor "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: dminor 0.-1.0 should fail" {
    run dminor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: dpatch 0.0.-1 should fail" {
    run dpatch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "awk: invalid version should fail" {
    run imajor ".0.0"
    [[ "$status" -eq 1 ]]
}

@test "awk: '' should fail" {
    run imajor ''
    [[ "$status" -eq 1 ]]
}