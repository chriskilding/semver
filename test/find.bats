#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "find: should match nothing in empty directory" {
    dir="$(mktemp -d)"

    [[ $(semver find "$dir") = "" ]]
}

@test "find: should match all files with semvers in their names, like find(1) -name" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    touch "$dir/foo"
    mkdir "$dir/2.0.0"
    touch "$dir/2.0.0/3.0.0"
    touch "$dir/2.0.0/bar"

    expected=$(cat <<EOF
${dir}/1.0.0
${dir}/2.0.0
${dir}/2.0.0/3.0.0
EOF
)

    [[ $(semver find "$dir") = "$expected" ]]
}

@test "find: should loosely match semvers" {
    skip "Not working on CI for some reason"

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

@test "find: -type l should match all symlinks with semvers in their names" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    ln -s "$dir/1.0.0" "$dir/1.0.0-link"

    [[ $(semver find "$dir" -type l) = "$dir/1.0.0-link" ]]
}

@test "find: -type p should match all FIFO pipes with semvers in their names" {
    dir="$(mktemp -d)"
    mkfifo "$dir/1.0.0"
    touch "$dir/2.0.0"

    [[ $(semver find "$dir" -type p) = "$dir/1.0.0" ]]
}

@test "find: -depth should process directory entries before the directory itself" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"
    touch "$dir/2.0.0/3.0.0"
    touch "$dir/2.0.0/bar"

    expected=$(cat <<EOF
${dir}/1.0.0
${dir}/2.0.0/3.0.0
${dir}/2.0.0
EOF
)

    [[ $(semver find "$dir" -depth) = "$expected" ]]
}

@test "find: should combine primaries with an implicit AND operator" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"
    touch "$dir/2.0.0/3.0.0"
    mkdir "$dir/2.0.0/4.0.0"

    expected=$(cat <<EOF
${dir}/2.0.0/4.0.0
${dir}/2.0.0
EOF
)

    [[ $(semver find "$dir" -type d -depth) = "$expected" ]]
}

@test "find: should fail if path missing" {
    run semver find -type d
    [[ "$status" -eq 1 ]]
}

@test "find: should fail on invalid option" {
    run semver find -rubbish
    [[ "$status" -eq 1 ]]
}

@test "find: -h should print usage" {
    run semver find -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}