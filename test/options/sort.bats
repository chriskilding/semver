#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "semver -s: should sort a single version" {
    [[ "$(semver -s <<< "1.0.0")" = "1.0.0" ]]
}

@test "semver -s: should print nothing and exit 1 when no matches" {
    run semver -s <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test "semver -s: should sort versions" {
    input=$(cat <<EOF
1.0.0-alpha+1
1.0.0
1.0.0-alpha
1.0.0-alpha+2
1.0.0-1
2.2.2
1.0.2
1.1.1
1.1.0
3.3.3
1.0.3
1.0.1
EOF
)

    expected=$(cat <<EOF
1.0.0-1
1.0.0-alpha
1.0.0-alpha+1
1.0.0-alpha+2
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

@test "semver -s: should tolerate invalid versions" {
    input=$(semver -s <<EOF
rubbish
1.2.3
EOF
)

    expected="1.2.3"

    [[ $(semver -s <<< "$input") = "$expected" ]]
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

@test "semver -s: should alias to --sort" {
    [[ "$(semver --sort <<< "1.0.0")" = "1.0.0" ]]
}