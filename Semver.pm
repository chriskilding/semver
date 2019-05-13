package Semver;

use strict;
use warnings;

use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT_OK = qw($gt $eq $lt $regex compare $get);

use Scalar::Util qw(looks_like_number);
use List::Util qw(max);

# Regex from semver.org: https://github.com/semver/semver/pull/460
our $regex = '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$';
my $precedence_regex_head = '^([0-9a-zA-Z-]*)';
my $precedence_regex_tail = '\.(0|[1-9a-zA-Z-][0-9a-zA-Z-]*)';

my $gt = 1;
my $eq = 0;
my $lt = -1;

sub Semver::get {
    my ($str) = @_;

    my @matches = $str =~ $regex;

    if ((defined $matches[0]) && (defined $matches[1]) && (defined $matches[2])) {
        return @matches;
    } else {
        exit 1
    }
}

sub _get_prerelease_identifiers {
    my ($prerelease) = @_;

    my @prerelease_identifiers_first = $prerelease =~ /$precedence_regex_head/;
    my @prerelease_identifiers_rest = $prerelease =~ /$precedence_regex_tail/g;

    push(@prerelease_identifiers_first, @prerelease_identifiers_rest);

    return @prerelease_identifiers_first;
}

sub _compare_prerelease_identifier {
    my ($a, $b) = @_;

    if ((defined $a) && (defined $b)) {
        if (looks_like_number($a) && looks_like_number($b)) {
            if ($a > $b) {
                return $gt;
            } elsif ($a < $b) {
                return $lt;
            }
        } elsif (!looks_like_number($a) && looks_like_number($b)) {
            return $gt;
        } else {
            my $a_cmp_b = $a cmp $b;

            if ($a_cmp_b eq 1) {
                return $gt;
            } elsif ($a_cmp_b eq -1) {
                return $lt;
            }
        }
        return $eq;
    } elsif ((defined $a) && (!defined $b)) {
        return $gt;
    } elsif ((!defined $a) && (defined $b)) {
        return $lt;
    }
}

sub _compare_prerelease {
    my ($a, $b) = @_;

    if ((!defined $a) && (defined $b)) {
        return $gt;
    } elsif ((defined $a) && (!defined $b)) {
        return $lt;
    } elsif ((defined $a) && (defined $b)) {
        my @a_identifiers = _get_prerelease_identifiers($a);
        my @b_identifiers = _get_prerelease_identifiers($b);

        for (my $i = 0; $i < max(scalar(@a_identifiers), scalar(@b_identifiers)); $i++) {
            my $a_identifier = $a_identifiers[$i];
            my $b_identifier = $b_identifiers[$i];

            my $a_cmp_b = _compare_prerelease_identifier($a_identifier, $b_identifier);

            if ($a_cmp_b eq 1) {
                return $gt;
            } elsif ($a_cmp_b eq -1) {
                return $lt;
            }
        }

        return $eq;
    } else {
        return $eq;
    }
}

sub compare {
    my ($a, $b) = @_;

    my @a_matches = Semver::get($a);

    my $a_major = $a_matches[0];
    my $a_minor = $a_matches[1];
    my $a_patch = $a_matches[2];
    my $a_prerelease = $a_matches[3];

    my @b_matches = Semver::get($b);

    my $b_major = $b_matches[0];
    my $b_minor = $b_matches[1];
    my $b_patch = $b_matches[2];
    my $b_prerelease = $b_matches[3];

    if ($a_major > $b_major) {
        return $gt;
    } elsif (($a_major eq $b_major) && ($a_minor > $b_minor)) {
        return $gt;
    } elsif (($a_major eq $b_major) && ($a_minor eq $b_minor) && ($a_patch > $b_patch)) {
        return $gt;
    } elsif (($a_major eq $b_major) && ($a_minor eq $b_minor) && ($a_patch eq $b_patch)) {
        return _compare_prerelease($a_prerelease, $b_prerelease);
    } else {
        return $lt;
    }
}