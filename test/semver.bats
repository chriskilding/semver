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

@test "semver: should print nothing and exit 1 on empty input" {
    run semver <<< ''
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver: should print nothing and exit 1 when no matches" {
    run semver <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver: should read multiple lines" {
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

# Match modes [-l, -w]

@test "semver: should match strings that are semvers" {
    expected=$(cat <<EOF
1.0.0
2.0.0
3.0.0
4.0.0
5.0.0
EOF
)

    actual=$(semver <<EOF
1.0.0
the 2.0.0 jumped over the 3.0.0
foo-4.0.0.zip
 5.0.0
bar
EOF
)

    [[ "$actual" = "$expected" ]]
}

@test "semver -l: should match whole lines that are semvers" {
    expected=$(cat <<EOF
1.0.0
EOF
)

    actual=$(semver -l <<EOF
1.0.0
the 2.0.0 jumped over the 3.0.0
foo-4.0.0.zip
 5.0.0
bar
EOF
)

    [[ "$actual" = "$expected" ]]
}

@test "semver -w: should match whole words that are semvers" {
    expected=$(cat <<EOF
1.0.0
2.0.0
3.0.0
5.0.0
EOF
)

    actual=$(semver -w <<EOF
1.0.0
the 2.0.0 jumped over the 3.0.0
foo-4.0.0.zip
 5.0.0
bar
EOF
)

    # TODO roll the \t assertion into the main test data
    # [[ "$(printf "1.0.44\t1.0.68" | semver)" = "$(printf "1.0.44\n1.0.68")" ]]
    [[ "$actual" = "$expected" ]]
}

@test "semver: match modes should be mutually exclusive" {
    run semver -lw <<< 'abc'
    [[ "$status" -eq 1 ]]
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

@test 'semver -t: should work with cut(1)' {
    [[ $(semver -t <<< '1.2.3-alpha+4' | cut -f 1) = '1' ]]
}

# Bundling

@test "semver: should support option bundling (-s, -t)" {
    expected=$(printf "$(cat <<EOF
1\t0\t0
2\t0\t0
3\t0\t0
EOF
)")

    actual=$(semver -st <<EOF
2.0.0
3.0.0
1.0.0
EOF
)

    [[ "$actual" = "$expected" ]]
}