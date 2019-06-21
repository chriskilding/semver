#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "semver: should line-match a single semver" {
    [[ "$(semver <<< "1.0.0")" = "1.0.0" ]]
}

@test "semver: should line-match semvers" {
    expected=$(cat <<EOF
1.0.0
1.0.0-alpha+1
EOF
)

    actual=$(semver <<EOF
1.0.0
1.0.0-alpha+1
the 2.0.0 jumped over the 3.0.0
foo-4.0.0.zip
 5.0.0
bar
EOF
)

    [[ "$actual" = "$expected" ]]
}

@test "semver: should print nothing and exit 1 on empty input" {
    run semver <<< ''
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver: should print nothing and exit 1 when no matches" {
    run semver <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver: should support option bundling" {
    expected=$(printf "$(cat <<EOF
1\t0\t0
2\t0\t0
3\t0\t0
EOF
)")

    input=$(cat <<EOF
2.0.0
3.0.0
1.0.0
EOF
)

    [[ $(semver -st <<< "$input") = "$expected" ]]
}

@test "semver: invalid subcommand should print usage" {
    run semver foo
    [[ "$status" -eq 1 ]]
}

@test "semver: invalid option should print usage" {
    run semver -a <<< '1.0.0'
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Unknown option: a" ]]
}