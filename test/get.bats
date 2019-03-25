#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

join() {
    printf "$1\t$2\t$3\t$4\t$5"
}

@test 'get 1.0.0 should be [1,0,0,_,_]' {
    [[ $(semver get '1.0.0') = $(join '1' '0' '0') ]]
}

@test 'get 1.0.0-alpha should be [1,0,0,alpha,_]' {
    [[ $(semver get '1.0.0-alpha') = $(join '1' '0' '0' 'alpha') ]]
}

@test 'get 1.0.0+1 should be [1,0,0,_,1]' {
    [[ $(semver get '1.0.0+1') = $(join '1' '0' '0' '' '1') ]]
}

@test 'get 1.0.0-alpha+1 should be [1,0,0,alpha,1]' {
    [[ $(semver get '1.0.0-alpha+1') = $(join '1' '0' '0' 'alpha' '1') ]]
}

@test 'get -1.0.0 should fail' {
    run semver get '-1.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'get .0.0 should fail' {
    run semver get '.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'get 01.0.0 should fail' {
    run semver get '01.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'get a.0.0 should fail' {
    run semver get 'a.0.0'
    [[ "$status" -eq 1 ]]
}

@test "get '' should fail" {
    run semver get ''
    [[ "$status" -eq 1 ]]
}

@test 'get should not tolerate whitespace' {
    run semver get ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}