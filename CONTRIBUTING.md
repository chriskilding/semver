# Contributing

## General contributions

We welcome code contributions, bug fixes, and other general improvements.

Contributions that change the surface API of the program will necessarily undergo more deliberation than smaller internal changes to the implementation.

Rules:

1. Write [Bats](https://github.com/bats-core/bats-core) tests for your change.
2. Run `make test` before submitting.

## Validation suite contributions

We welcome new additions to the semver.org suite of exemplar valid and invalid semantic version strings.

Your new example must:
 
- Demonstrate a **single property** of a version string
- Be **generalisable** for a class of input

Good:

- `1.0.0+a+a`
  - Property: "A semver must have only one BUILD"
  - Generalisable: For the class of all valid semvers
- `1.0.0+`
  - Property: "BUILD must have an identifier"
  - Generalisable: For the class of all valid semvers with a BUILD

Bad:

- `1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788`
  - Property: ??? (unclear)
  - Generalisable: ??? (unclear)

