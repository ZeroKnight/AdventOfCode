#!/usr/bin/env perl

# Advent of Code Day 3
# http://adventofcode.com/day/3

use strict;
use warnings;
use v5.10; # state

my %homes = ('0,0' => 1);   # Starting home gets gifts
my $directions = do { local $/ = undef; open my $fh, '<', './input'; <$fh> };

# Follow our orders, deliver presents
foreach my $order (split //, $directions) {
    state $sx = 0; state $sy = 0;   # Santa Coords
    state $rx = 0; state $ry = 0;   # Robo Santa Coords
    state $count = 0; ++$count;

    my ($x, $y) = $count % 2 ? (\$sx, \$sy) : (\$rx, \$ry);
    if ($order eq '^') {
        ++$homes{"$$x," . ++$$y};
    } elsif ($order eq '>') {
        ++$homes{++$$x . ",$$y"};
    } elsif ($order eq 'v') {
        ++$homes{"$$x," . --$$y};
    } elsif ($order eq '<') {
        ++$homes{--$$x . ",$$y"};
    }
}

print "The two Santas stopped at " . scalar(keys %homes) . " unique homes.\n";

