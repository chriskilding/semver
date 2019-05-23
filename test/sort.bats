#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "sort: should handle a single version" {
    [[ "$(semver sort <<< "1.0.0")" = "1.0.0" ]]
}

@test "sort: should not handle an invalid version" {
    run semver sort <<< "rubbish"
    [[ "$status" -eq 1 ]]
}

@test "sort: should not handle invalid versions" {
    run semver sort <<EOF
rubbish
1.2.3
EOF
    [[ "$status" -eq 1 ]]
}

@test "sort: should handle empty input" {
    run printf '' | semver sort
    [[ "$status" -eq 0 ]] && [[ "$output" = "" ]]
}

@test "sort: should handle multiple versions" {
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

    [[ "$(semver sort <<< "$input")" = "$expected" ]]
}

@test "sort: should obey Semantic Version precedence rules" {
    input=$(cat <<EOF
1.0.0
1.0.0-SNAPSHOT
1.0.0-1
EOF
)

    expected=$(cat <<EOF
1.0.0-1
1.0.0-SNAPSHOT
1.0.0
EOF
)

    [[ "$(semver sort <<< "$input")" = "$expected" ]]
}

@test "sort: should apply lexicographic ordering when multiple versions are precedence-equal" {
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

    [[ "$(semver sort <<< "$input")" = "$expected" ]]
}

@test "sort: should reverse ordering with the -r (--reverse) flag" {
    input=$(cat <<EOF
1.0.0
2.0.0
1.0.0-SNAPSHOT
1.0.0+2008
EOF
)

    expected=$(cat <<EOF
2.0.0
1.0.0+2008
1.0.0
1.0.0-SNAPSHOT
EOF
)

    [[ "$(semver sort -r <<< "$input")" = "$expected" ]] && [[ "$(semver sort --reverse <<< "$input")" = "$expected" ]]
}

@test "sort: should fail with invalid flags" {
    run semver sort --foobar '1.0.0'
    [[ "$status" -eq 1 ]]
}