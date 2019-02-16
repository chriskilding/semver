#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "grep should match a single version strings" {
    [[ "$(semver grep <<< "1.0.0")" = "1.0.0" ]]
}

@test "grep should not match non-semver version strings" {
    [[ "$(semver grep <<< "1 1.23 1.2.3.4.5.6.7")" = "" ]]
}

@test "grep should not match arbitrary A-Z strings" {
    [[ "$(semver grep <<< "latest snapshot")" = "" ]]
}

@test "grep should not match semver strings inside other words" {
    [[ "$(semver grep <<< "v1.2.3 foo1.2.3bar 1.2.3bar")" = "" ]]
}

@test "grep should handle empty input" {
    [[ "$(semver grep <<< "")" = "" ]]
}

@test "grep should handle spaces between versions" {
    [[ "$(semver grep <<< "1.0.0 2.0.0")" = "$(printf "1.0.0\n2.0.0")" ]]
}

@test "grep should handle tabs between versions" {
    [[ "$(printf "1.0.44\t1.0.68" | semver grep)" = "$(printf "1.0.44\n1.0.68")" ]]
}

@test "grep should handle newlines between versions" {
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