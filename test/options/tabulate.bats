#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'semver -t: should tabulate versions' {
    input=$(cat <<EOF
1.2.3
1.2.3-alpha
1.2.3+1
1.2.3-alpha+1
EOF
)

    expected=$(cat <<EOF
1,2,3
1,2,3,alpha
1,2,3,,1
1,2,3,alpha,1
EOF
)

    [[ $(semver -t <<< "$input" | tr '\t' ',') = "$expected" ]]
}

@test 'semver -t: should alias to --tabulate' {
    [[ $(semver --tabulate <<< '1.2.3-alpha+1' | tr '\t' ',') = '1,2,3,alpha,1' ]]
}

