#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "find: should only match the directory when there are no files" {
    dir="$(mktemp -d)"

    [[ $(semver find "$dir") = "${dir}" ]]
}

@test "find: should match all files when no primaries are given" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0" "$dir/a"
    mkdir "$dir/b"

    expected=$(cat <<EOF
${dir}
${dir}/1.0.0
${dir}/a
${dir}/b
EOF
)

    [[ $(semver find "$dir") = "$expected" ]]
}

@test "find: -name should match all files with semvers in their names, like find(1) -name" {
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

    [[ $(semver find "$dir" -name) = "$expected" ]]
}

@test "find: -path should match all files with semvers in their paths, like find(1) -path" {
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
${dir}/2.0.0/bar
EOF
)

    [[ $(semver find "$dir" -path) = "$expected" ]]
}

@test "find: -name and -path together should combine with an implicit AND" {
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

    [[ $(semver find "$dir" -name -path) = "$expected" ]]
}

@test "find: -name and -path should loosely match semvers" {
    skip "Unreliable in the CI environment"

    dir="$(mktemp -d)"
    touch "$dir/1.0.0" "$dir/foo-1.0.0"

    expected=$(cat <<EOF
${dir}/1.0.0
${dir}/foo-1.0.0
EOF
)

    [[ $(semver find "$dir" -name) = "$expected" ]] && [[ $(semver find "$dir" -path) = "$expected" ]]
}

@test "find: -type d should match directories" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"

    [[ $(semver find "$dir" -name -type d) = "$dir/2.0.0" ]]
}

@test "find: -type f should match regular files" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    mkdir "$dir/2.0.0"

    [[ $(semver find "$dir" -name -type f) = "$dir/1.0.0" ]]
}

@test "find: -type l should match symlinks" {
    dir="$(mktemp -d)"
    touch "$dir/1.0.0"
    ln -s "$dir/1.0.0" "$dir/1.0.0-link"

    [[ $(semver find "$dir" -name -type l) = "$dir/1.0.0-link" ]]
}

@test "find: -type p should match FIFO pipes" {
    dir="$(mktemp -d)"
    mkfifo "$dir/1.0.0"
    touch "$dir/2.0.0"

    [[ $(semver find "$dir" -name -type p) = "$dir/1.0.0" ]]
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

    [[ $(semver find "$dir" -name -depth) = "$expected" ]]
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

    [[ $(semver find "$dir" -name -type d -depth) = "$expected" ]]
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