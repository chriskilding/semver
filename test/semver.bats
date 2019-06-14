#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "semver: should match a single version string" {
    [[ "$(semver <<< "1.0.0")" = "1.0.0" ]]
}

@test "semver: should match optional semver fields" {
    [[ "$(semver <<< "1.0.0-alpha+1")" = "1.0.0-alpha+1" ]]
}

@test "semver: should not match non-semver version strings" {
    [[ "$(semver <<< "1 1.23 1.2.3.4.5.6.7")" = "" ]]
}

@test "semver: should match a semver between other words and print the whole line" {
    [[ "$(semver <<< "the cow jumped 1.0.0 over the 2.0.0 moon")" = "$(printf "1.0.0\n2.0.0")" ]]
}

@test "semver: should not match semver strings inside other words" {
    [[ "$(semver <<< "v1.2.3 foo1.2.3bar 1.2.3bar")" = "" ]]
}

@test "semver: should print nothing and exit 1 on empty input" {
    run semver <<< ''
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver: should print nothing and exit 1 when no matches" {
    run semver <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver: should handle spaces between versions" {
    [[ "$(semver <<< "1.0.0 2.0.0")" = "$(printf "1.0.0\n2.0.0")" ]]
}

@test "semver: should handle tabs between versions" {
    [[ "$(printf "1.0.44\t1.0.68" | semver)" = "$(printf "1.0.44\n1.0.68")" ]]
}

@test "semver: should handle newlines between versions" {
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

    [[ "$(semver <<< "$input")" = "$expected" ]]
}

@test "semver: should handle slashes between versions (to read from find(1))" {
    expected=$(cat <<EOF
1.0.0
2.0.0
2.0.0
3.0.0
EOF
)

    actual=$(semver <<EOF
/dir/1.0.0
/dir/foo
/dir/2.0.0
/dir/2.0.0/3.0.0
/dir/2.0.0/bar
EOF
)

    [[ "$actual" = "$expected" ]]
}

# Quiet [-q]

@test "semver -q: should print nothing and exit 0 when there is a match" {
    run semver -q <<< '1.0.0'
    [[ -z "$output" ]] && [[ "$status" -eq 0 ]]
}

@test "semver -q: should print nothing and exit 1 when no matches" {
    run semver -q <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

# Sort [-s]

@test "semver -s: should handle empty input" {
    run printf '' | semver -s
    [[ "$status" -eq 0 ]] && [[ "$output" = "" ]]
}

@test "semver -s: should handle a single version" {
    [[ "$(semver -s <<< "1.0.0")" = "1.0.0" ]]
}

@test "semver -s: should handle multiple versions" {
    input=$(cat <<EOF
2.2.2
1.0.2
1.1.1
1.0.0
1.1.0
3.3.3
1.0.3
1.0.1
EOF
)

    expected=$(cat <<EOF
1.0.0
1.0.1
1.0.2
1.0.3
1.1.0
1.1.1
2.2.2
3.3.3
EOF
)

    [[ "$(semver -s <<< "$input")" = "$expected" ]]
}

@test "semver -s: should ignore invalid versions" {
    actual=$(semver -s <<EOF
rubbish
1.2.3
EOF
)
    [[ "$actual" = "1.2.3" ]]
}

@test "semver -s: should obey Semantic Version precedence rules" {
    input=$(cat <<EOF
1.0.0-alpha+1
1.0.0
1.0.0-alpha
1.0.0-alpha+2
1.0.0-1
EOF
)

    expected=$(cat <<EOF
1.0.0-1
1.0.0-alpha
1.0.0-alpha+1
1.0.0-alpha+2
1.0.0
EOF
)

    [[ "$(semver -s <<< "$input")" = "$expected" ]]
}

@test "semver -s: should apply lexicographic ordering when multiple versions are precedence-equal" {
    input=$(cat <<EOF
1.0.0+1
1.0.0
1.0.0+a.1
1.0.0+20080102
1.0.0+ab
1.0.0+20080101
1.0.0+a
1.0.0+12
1.0.0+2
EOF
)

    expected=$(cat <<EOF
1.0.0
1.0.0+1
1.0.0+12
1.0.0+2
1.0.0+20080101
1.0.0+20080102
1.0.0+a
1.0.0+a.1
1.0.0+ab
EOF
)

    [[ "$(semver -s <<< "$input")" = "$expected" ]]
}

# Tabulate [-t]

@test 'semver -t: 1.2.3 should be [1,2,3]' {
    [[ $(semver -t <<< '1.2.3') = $(printf "1\t2\t3") ]]
}

@test 'semver -t: 1.2.3-alpha should be [1,2,3,alpha]' {
    [[ $(semver -t <<< '1.2.3-alpha') = $(printf "1\t2\t3\talpha") ]]
}

@test 'semver -t: 1.2.3+1 should be [1,2,3,_,1]' {
    [[ $(semver -t <<< '1.2.3+1') = $(printf "1\t2\t3\t\t1") ]]
}

@test 'semver -t: 1.2.3-alpha+1 should be [1,2,3,alpha,1]' {
    [[ $(semver -t <<< '1.2.3-alpha+1') = $(printf "1\t2\t3\talpha\t1") ]]
}

# Bundling

@test "semver: should support option bundling (-s, -t)" {
    expected=$(cat <<EOF
1\t0\t0
2\t0\t0
EOF
)

    actual=$(semver -st <<EOF
1.0.0
2.0.0
EOF
)

    [[ "$actual" = "$expected" ]]
}

# Integrations

@test 'semver -t: should work with cut(1)' {
    [[ $(semver -t <<< '1.2.3-alpha+4' | cut -f 1) = '1' ]]
}