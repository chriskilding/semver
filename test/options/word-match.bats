#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'semver -w: should word-match semvers' {
    [[ $(semver -w <<< 'foo 1.0.0 bar') = '1.0.0' ]]
}

@test 'semver -w: should allow tab delimiters' {
    [[ "$(printf "foo\t1.0.68\tbar" | semver -w)" = '1.0.68' ]]
}

@test 'semver -w: should not allow semvers embedded in other words' {
    run semver -w <<< 'foo-4.0.0.zip'
    [[ "$status" -eq 1 ]]
}

@test 'semver -w: should match multiple semver words on a line' {
    [[ $(semver -w <<< '1.0.44 1.0.68') = "$(printf "1.0.44\n1.0.68")" ]]
}

@test 'semver -w: should alias to --word-match' {
    [[ $(semver --word-match <<< 'foo 1.0.0 bar') = '1.0.0' ]]
}