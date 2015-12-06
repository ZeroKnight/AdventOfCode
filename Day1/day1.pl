#!/usr/bin/env perl

# Advent of Code Day 1
# http://adventofcode.com/day/1

use strict;
use warnings;

my $fn = './input';
my $floor;
my $total_steps;
my @basement;

# Get our directions
open(my $fh, '<', $fn) or die "$0: can't open $fn for reading: $!";
my @directions = split(//, do { local $/; <$fh>; });
close $fh;

# Navigate
foreach my $step (@directions) {
    if ($step eq '(') {
        ++$floor;
    } elsif ($step eq ')') {
        --$floor;
    }
    ++$total_steps;

    # Make note of when we enter the basement
    push @basement, $total_steps if $floor == -1;
}

# Arrive at our destination
print "After $total_steps steps, we end up at Floor $floor.\n" .
      "We entered the basement for the first time at step $basement[0].\n";

