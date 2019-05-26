# semver.awk
#
# awk functions for Semantic Versioning

# PRIVATE
# Parse a Semantic Version into an array '_a'.
function _parse(version) {
    if (version == "") {
        exit 1;
    }

    split(version, _a, ".");

    split(_a[3], _b, "(-|+)");

    _a[3] = _b[1];

    if (_a[1] < 0 || _a[2] < 0 || _a[3] < 0) {
        exit 1;
    }
}

# Increment the major component of a Semantic Version.
function imajor(version)
{
    _parse(version);
    ++_a[1];
    return _a[1] "." 0 "." 0;
}

# Increment the minor component of a Semantic Version.
function iminor(version)
{
    _parse(version);
    ++_a[2];
    return _a[1] "." _a[2] "." 0;
}

# Increment the patch component of a Semantic Version.
function ipatch(version)
{
    _parse(version);
    ++_a[3];
    return _a[1] "." _a[2] "." _a[3];
}