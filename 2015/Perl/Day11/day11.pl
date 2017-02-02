#!/usr/bin/env perl

# Advent of Code Day 11
# http://adventofcode.com/day/11

use strict;
use warnings;
use v5.10;

my $input = 'vzbxkghb';
my $lastpw = $input;
my $cycles;
my $found = 0;

while ($found < 2) {
    ++$cycles;
    ++$input; # Increment to our new password

    next if $input     =~ /[iol]/;                # Check for illegal characters
    next unless $input =~ /([a-z])\1.*([a-z])\2/; # Check for 2 pairs
    next unless has_straight($input);             # Check for 3-straight

    print "New password from '$lastpw' -> '$input' ($cycles cycles)\n";
    $lastpw = $input;
    $cycles = 0;
    ++$found;
}

sub has_straight {
    my $s = shift;
    for (my $i = 0; $i < (length $s) -2; ++$i) {
        my ($a, $b, $c) = (split //, (substr($s, $i, 3)));
        next unless ++$a eq $b;
        return 1 if ++$b eq $c;
    }
    return 0;
}
