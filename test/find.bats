#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "find: should match nothing in empty directory" {
    dir="$(mktemp -d)"

    [[ $(semver find "$dir") = "" ]]
}

@test "find: should match all pathnames containing semvers" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"

    expected=$(cat <<EOF
${dir}/1.0.0
${dir}/2.0.0
EOF
)

    [[ $(semver find "$dir") = "$expected" ]]
}

@test "find: should loosely match semvers" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0" "$dir/foo-1.0.0"

    expected=$(cat <<EOF
${dir}/1.0.0
${dir}/foo-1.0.0
EOF
)

    [[ $(semver find "$dir") = "$expected" ]]
}

@test "find: -type d should match all directories with semvers in their names" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"

    [[ $(semver find "$dir" -type d) = "$dir/2.0.0" ]]
}

@test "find: -type f should match all regular files with semvers in their names" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"

    [[ $(semver find "$dir" -type f) = "$dir/1.0.0" ]]
}

@test "find: -links should match all files with semvers in their names which have n links" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0" "$dir/2.0.0"
    ln "$dir/1.0.0" "$dir/link"

    [[ $(semver find "$dir" -links 2) = "$dir/1.0.0" ]]
}

@test "find: should fail if path missing" {
    run semver find -type d
    [[ "$status" -eq 1 ]]
}

@test "find: -h should print usage" {
    run semver find -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}