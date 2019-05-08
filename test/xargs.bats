#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'xargs: false should exit immediately' {
    run semver xargs false
    [[ "$output" = "" ]]
}


@test 'xargs: should discover all available semvers given a utility function' {
    run semver xargs 'if [ {} = "0.0.1" ] || [ {} = "0.0.2" ] || [ {} = "0.1.0" ] || [ {} = "0.1.1" ] || [ {} = "1.0.0" ] || [ {} = "1.0.1" ]; then echo {}; else false; fi'

    expected=$(cat <<EOF
0.0.1
0.0.2
0.1.0
0.1.1
1.0.0
1.0.1
EOF
)

    [[ "$output" = "$expected" ]]
}