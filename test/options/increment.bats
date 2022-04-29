#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'semver -i major: should increment the major version' {
    [[ $(semver -i major <<< '1.2.3') = '2.0.0' ]]
}

@test 'semver -i minor: should increment the minor version' {
    [[ $(semver -i minor <<< '1.2.3') = '1.3.0' ]]
}

@test 'semver -i patch: should increment the patch version' {
    [[ $(semver -i patch <<< '1.2.3') = '1.2.4' ]]
}

@test 'semver -i patch: should increment a build modifier correctly' {
    # TODO: is this the correct behaviour?
    [[ $(semver -i patch <<< '1.2.3-alpha.1') = '1.2.3' ]]
}

@test 'semver -i: should reject unknown version component arguments' {
    run semver -i foobar <<< '1.2.3'

    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Error: unrecognised value for -i|--increment option. Allowed values are 'major', 'minor', or 'patch'." ]]
}

@test 'semver -i: should increment all matched versions' {
    input=$(cat <<EOF
1.0.0
2.0.0
EOF
)

    expected=$(cat <<EOF
2.0.0
3.0.0
EOF
)

    [[ "$(semver -i major <<< "$input")" = "$expected" ]]
}

@test "semver -i: should alias to --increment" {
    [[ "$(semver --increment major <<< "1.0.0")" = "2.0.0" ]]
}