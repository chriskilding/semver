#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

my_utility_function() {
    version=$1
    if [ "$version" = "0.0.1" ] || [ "$version" = "0.1.0" ] || [ "$version" = "1.0.0" ]; then
        echo ${version}
    else
        false
    fi
}

@test 'xargs: false should exit immediately' {
    run semver xargs false
    [[ "$output" = "" ]]
}

@test 'xargs: should support an unquoted utility function' {
    run semver xargs false {}
    # FIXME this does not work yet, xargs only sees the first argument ('false')
    [[ true == false ]]
}

@test 'xargs: should support an external utility function' {
    run semver xargs my_utility_function {}

    expected=$(cat <<EOF
0.0.1
0.1.0
1.0.0
EOF
)

    [[ "$output" = "$expected" ]]
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

@test 'xargs: should support --replace option' {
    run semver xargs 'if [ abc = "0.0.1" ] || [ abc = "0.1.0" ] || [ abc = "1.0.0" ]; then echo abc; else false; fi' --replace 'abc'

    expected=$(cat <<EOF
0.0.1
0.1.0
1.0.0
EOF
)

    [[ "$output" = "$expected" ]]
}

@test 'xargs: should support -r option' {
    run semver xargs 'if [ abc = "0.0.1" ] || [ abc = "0.1.0" ] || [ abc = "1.0.0" ]; then echo abc; else false; fi' -r 'abc'

    expected=$(cat <<EOF
0.0.1
0.1.0
1.0.0
EOF
)

    [[ "$output" = "$expected" ]]
}