#!/usr/bin/env bats

semver-grep() {
    ./semver-grep "$@"
}

@test "semver-grep: -h should print usage" {
    run semver-grep -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}

@test "semver-grep: should match a single version strings" {
    [[ "$(semver-grep <<< "1.0.0")" = "1.0.0" ]]
}

@test "semver-grep: should match optional semver fields" {
    [[ "$(semver-grep <<< "1.0.0-alpha+1")" = "1.0.0-alpha+1" ]]
}

@test "semver-grep: should not match non-semver version strings" {
    [[ "$(semver-grep <<< "1 1.23 1.2.3.4.5.6.7")" = "" ]]
}

@test "semver-grep: should not match arbitrary A-Z strings" {
    [[ "$(semver-grep <<< "latest snapshot")" = "" ]]
}

@test "semver-grep: should not match semver strings inside other words" {
    [[ "$(semver-grep <<< "v1.2.3 foo1.2.3bar 1.2.3bar")" = "" ]]
}

@test "semver-grep: should handle empty input" {
    [[ "$(semver-grep <<< "")" = "" ]]
}

@test "semver-grep: should handle spaces between versions" {
    [[ "$(semver-grep <<< "1.0.0 2.0.0")" = "$(printf "1.0.0\n2.0.0")" ]]
}

@test "semver-grep: should handle tabs between versions" {
    [[ "$(printf "1.0.44\t1.0.68" | semver-grep)" = "$(printf "1.0.44\n1.0.68")" ]]
}

@test "semver-grep: should handle newlines between versions" {
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

    [[ "$(semver-grep <<< "$input")" = "$expected" ]]
}