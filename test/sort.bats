#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "sort: should handle a single version" {
    [[ "$(semver sort <<< "1.0.0")" = "1.0.0" ]]
}

@test "sort: should not handle invalid versions" {
    run semver sort <<< "rubbish"
    [[ "$status" -eq 1 ]]
}

@test "sort: should handle empty input" {
    [[ "$(semver sort <<< "")" = "" ]]
}

@test "sort: should handle multiple versions" {
    input=$(cat <<EOF
2.3.4
1.2.3
4.5.6
EOF
)

    expected=$(cat <<EOF
1.2.3
2.3.4
4.5.6
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

@test "sort: should ensure natural ordering when versions are stringwise-unequal but precedence-equal" {
    input=$(cat <<EOF
1.0.0+1
1.0.0
1.0.0+3
1.0.0+2
EOF
)

    expected=$(cat <<EOF
1.0.0
1.0.0+1
1.0.0+2
1.0.0+3
EOF
)

    [[ "$(semver sort <<< "$input")" = "$expected" ]]
}