#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'printf: 0.0.0 should be [0,0,0,_,_]' {
    [[ $(semver printf "%major %minor %patch" '0.0.0') = "0 0 0" ]]
}

@test 'printf: 0.1.0 should be [0,1,0,_,_]' {
    [[ $(semver printf "%major %minor %patch" '0.1.0') = "0 1 0" ]]
}

@test 'printf: 0.0.1 should be [0,0,1,_,_]' {
    [[ $(semver printf "%major %minor %patch" '0.0.1') = "0 0 1" ]]
}

@test 'printf: 1.0.0 should be [1,0,0,_,_]' {
    [[ $(semver printf "%major %minor %patch" '1.0.0') = "1 0 0" ]]
}

@test 'printf: 10.0.0 should be [10,0,0,_,_]' {
    [[ $(semver printf "%major %minor %patch" '10.0.0') = "10 0 0" ]]
}

@test 'printf: 0.10.0 should be [0,10,0,_,_]' {
    [[ $(semver printf "%major %minor %patch" '0.10.0') = "0 10 0" ]]
}

@test 'printf: 0.0.10 should be [0,0,10,_,_]' {
    [[ $(semver printf "%major %minor %patch" '0.0.10') = "0 0 10" ]]
}

@test 'printf: 1.0.0-1 should be [1,0,0,1,_]' {
    [[ $(semver printf "%major %minor %patch %prerelease" '1.0.0-1') = "1 0 0 1" ]]
}

@test 'printf: 1.0.0-a should be [1,0,0,a,_]' {
    [[ $(semver printf "%major %minor %patch %prerelease" '1.0.0-a') = "1 0 0 a" ]]
}

@test 'printf: 1.0.0-a-1 should be [1,0,0,a-1,_]' {
    [[ $(semver printf "%major %minor %patch %prerelease" '1.0.0-a-1') = "1 0 0 a-1" ]]
}

@test 'printf: 1.0.0-1.2.3 should be [1,0,0,1.2.3,_]' {
    [[ $(semver printf "%major %minor %patch %prerelease" '1.0.0-1.2.3') = "1 0 0 1.2.3" ]]
}

@test 'printf: 1.0.0+1 should be [1,0,0,_,1]' {
    [[ $(semver printf "%major %minor %patch %build" '1.0.0+1') = "1 0 0 1" ]]
}

@test 'printf: 1.0.0+a should be [1,0,0,_,a]' {
    [[ $(semver printf "%major %minor %patch %build" '1.0.0+a') = "1 0 0 a" ]]
}

@test 'printf: 1.0.0+1.2.3 should be [1,0,0,_,1.2.3]' {
    [[ $(semver printf "%major %minor %patch %build" '1.0.0+1.2.3') = "1 0 0 1.2.3" ]]
}

@test 'printf: 1.0.0-a+1 should be [1,0,0,a,1]' {
    [[ $(semver printf "%major %minor %patch %prerelease %build" '1.0.0-a+1') = "1 0 0 a 1" ]]
}

# Individual format specifiers

@test 'printf %major: 1.0.0 should be 1' {
    [[ $(semver printf '%major' '1.0.0') = '1' ]]
}

@test 'printf %minor: 0.1.0 should be 1' {
    [[ $(semver printf '%minor' '0.1.0') = '1' ]]
}

@test 'printf %patch: 0.0.1 should be 1' {
    [[ $(semver printf '%patch' '0.0.1') = '1' ]]
}

@test 'printf %prerelease: 0.0.0-a should be a' {
    [[ $(semver printf '%prerelease' '0.0.0-a') = 'a' ]]
}

@test 'printf %build: 0.0.0+a should be a' {
    [[ $(semver printf '%build' '0.0.0+a') = 'a' ]]
}

# Allowable blanks

@test "printf %prerelease: 0.0.0 should be ''" {
    [[ -z "$(semver printf '%prerelease' '0.0.0')" ]]
}

@test "printf %build: 0.0.0 should be ''" {
    [[ -z "$(semver printf '%build' '0.0.0')" ]]
}

# Negative numbers

@test 'printf: -1.0.0 should fail' {
    run semver printf "%major %minor %patch" '-1.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.-1.0 should fail' {
    run semver printf "%major %minor %patch" '0.-1.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.0.-1 should fail' {
    run semver printf "%major %minor %patch" '0.0.-1'
    [[ "$status" -eq 1 ]]
}

# Numeric identifiers with preceding zeroes

@test 'printf: 01.0.0 should fail' {
    run semver printf "%major %minor %patch" '01.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.01.0 should fail' {
    run semver printf "%major %minor %patch" '0.01.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.0.01 should fail' {
    run semver printf "%major %minor %patch" '0.0.01'
    [[ "$status" -eq 1 ]]
}

# Non-numeric characters in numeric identifiers

@test 'printf: a.0.0 should fail' {
    run semver printf "%major %minor %patch" 'a.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.a.0 should fail' {
    run semver printf "%major %minor %patch" '0.a.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.0.a should fail' {
    run semver printf "%major %minor %patch" '0.0.a'
    [[ "$status" -eq 1 ]]
}

# Missing identifiers

@test 'printf: .0.0 should fail' {
    run semver printf "%major %minor %patch" '.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0..0 should fail' {
    run semver printf "%major %minor %patch" '0..0'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.0. should fail' {
    run semver printf "%major %minor %patch" '0.0.'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.0.0- should fail' {
    run semver printf "%major %minor %patch" '0.0.0-'
    [[ "$status" -eq 1 ]]
}

@test 'printf: 0.0.0+ should fail' {
    run semver printf "%major %minor %patch" '0.0.0+'
    [[ "$status" -eq 1 ]]
}

@test 'printf: should not tolerate missing arguments' {
    run semver printf ''
    [[ "$status" -eq 1 ]]
}

@test 'printf: should not tolerate empty version string' {
    run semver printf "%major %minor %patch" ''
    [[ "$status" -eq 1 ]]
}

@test 'printf: should not tolerate whitespace around version string' {
    run semver printf "%major %minor %patch" ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}

@test 'printf: should not tolerate invalid format specifiers' {
    run semver printf "hello %s" '0.0.1'
    [[ "$status" -eq 1 ]] && [[ "$output" = "Invalid format specifier detected (valid specifiers: %major, %minor, %patch, %prerelease, %build)" ]]
}

@test 'printf: \% should not escape the format specifier' {
    [[ "$(semver printf '\%patch' '0.0.1')" = '\1' ]]
}

@test 'printf: \a should write a <bell> character' {
    [[ "$(semver printf '\a' '0.0.1')" = "$(printf '\a')" ]]
}

@test 'printf: \b should write a <backspace> character' {
    [[ "$(semver printf '\b' '0.0.1')" = "$(printf '\b')" ]]
}

@test 'printf: \e should write an <escape> character' {
    [[ "$(semver printf '\e' '0.0.1')" = "$(printf '\e')" ]]
}

@test 'printf: \f should write a <form-feed> character' {
    [[ "$(semver printf '\f' '0.0.1')" = "$(printf '\f')" ]]
}

@test 'printf: \n should write a <new-line> character' {
    expected=$(cat <<EOF

EOF
)
    [[ "$(semver printf '\n' '0.0.1')" = ${expected} ]]
}

@test 'printf: \r should write a <carriage return> character' {
    [[ "$(semver printf '\r' '0.0.1')" = "$(printf '\r')" ]]
}

@test 'printf: \t should write a <tab> character' {
    [[ "$(semver printf '\t' '0.0.1')" = "$(printf '\t')" ]]
}

@test "printf: \' should write a <single quote> character" {
    [[ "$(semver printf "\'" '0.0.1')" = "'" ]]
}

@test 'printf: \\ should write a backslash character' {
    [[ "$(semver printf '\\' '0.0.1')" = '\' ]]
}