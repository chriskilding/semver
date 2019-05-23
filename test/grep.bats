#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "grep: should match a single version string" {
    [[ "$(semver grep <<< "1.0.0")" = "1.0.0" ]]
}

@test "grep: should match optional semver fields" {
    [[ "$(semver grep -o <<< "1.0.0-alpha+1")" = "1.0.0-alpha+1" ]]
}

@test "grep: should not match non-semver version strings" {
    [[ "$(semver grep <<< "1 1.23 1.2.3.4.5.6.7")" = "" ]]
}

@test "grep: should not match arbitrary A-Z strings" {
    [[ "$(semver grep <<< "latest snapshot")" = "" ]]
}

@test "grep: should match a semver between other words and print the whole line" {
    [[ "$(semver grep <<< "the cow jumped 1.0.0 over the 2.0.0 moon")" = "the cow jumped 1.0.0 over the 2.0.0 moon" ]]
}

@test "grep -o: should match a semver between other words and print only the semver" {
    [[ "$(semver grep -o <<< "the cow jumped 1.0.0 over the 2.0.0 moon")" = "$(printf "1.0.0\n2.0.0")" ]]
}

@test "grep -c: should print a count of selected lines when there are matches" {
    [[ "$(semver grep -c <<< "the cow jumped 1.0.0 over the moon")" -eq 1 ]]
}

@test "grep -c: should print a count of selected lines (not a count of the semvers in those lines)" {
    [[ "$(semver grep -c <<< "the cow jumped 1.0.0 over the 2.0.0 moon")" -eq 1 ]]
}

@test "grep -co: should print a count of selected lines (not a count of the semvers in those lines)" {
    [[ "$(semver grep -co <<< "the cow jumped 1.0.0 over the 2.0.0 moon")" -eq 1 ]]
}

@test "grep: should not match semver strings inside other words" {
    [[ "$(semver grep <<< "v1.2.3 foo1.2.3bar 1.2.3bar")" = "" ]]
}

@test "grep: should print nothing and exit 1 on empty input" {
    run semver grep <<< ''
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "grep: should print nothing and exit 1 when no matches" {
    run semver grep <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "grep -c: should print 0 and exit 1 when no matches" {
    run semver grep -c <<< 'hello'
    [[ "$output" -eq 0 ]] && [[ "$status" -eq 1 ]]
}

@test "grep: should handle spaces between versions" {
    [[ "$(semver grep -o <<< "1.0.0 2.0.0")" = "$(printf "1.0.0\n2.0.0")" ]]
}

@test "grep: should handle tabs between versions" {
    [[ "$(printf "1.0.44\t1.0.68" | semver grep -o)" = "$(printf "1.0.44\n1.0.68")" ]]
}

@test "grep: should handle newlines between versions" {
    input=$(cat <<EOF
1.0.0
2.0.0
EOF
)

    expected=$(cat <<EOF
1.0.0
2.0.0
EOF
)

    [[ "$(semver grep <<< "$input")" = "$expected" ]]
}

@test "grep: invalid option should fail" {
    run semver grep --rubbish <<< "1.2.3"
    [[ "$status" -eq 1 ]]
}

@test "grep: -h should print usage" {
    run semver grep -h <<< "1.2.3"
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}