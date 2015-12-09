#!/usr/bin/env perl

# Advent of Code Day 6
# http://adventofcode.com/day/6

use strict;
use warnings;
use v5.10; # state

my %lightgrid;
my @instructions;
open my $fh, '<', './input' or die "$0: can't open input for reading: $!";
while (<$fh>) {
    chomp;
    push @instructions, $_;
}
close $fh;

foreach (@instructions) {
    local $| = 1;
    state $count = 1;
    my @bound1 = ($1, $2) if (/(\d{1,3}),(\d{1,3}) through/);
    my @bound2 = ($1, $2) if (/(\d{1,3}),(\d{1,3})$/);

    print "\rProcessing instruction $count of " . scalar @instructions . ' ...';

    if (/^turn on/) {
        for (my $x = $bound1[0]; $x <= $bound2[0]; ++$x) {
            for (my $y = $bound1[1]; $y <= $bound2[1]; ++$y) {
                $lightgrid{$x}{$y}{p1} = 1;
                $lightgrid{$x}{$y}{p2}++;
            }
        }
    } elsif (/^turn off/) {
        for (my $x = $bound1[0]; $x <= $bound2[0]; ++$x) {
            for (my $y = $bound1[1]; $y <= $bound2[1]; ++$y) {
                $lightgrid{$x}{$y}{p1} = 0;
                $lightgrid{$x}{$y}{p2} = max(($lightgrid{$x}{$y}{p2} // 0) - 1, 0);
            }
        }
    } elsif (/^toggle/) {
        for (my $x = $bound1[0]; $x <= $bound2[0]; ++$x) {
            for (my $y = $bound1[1]; $y <= $bound2[1]; ++$y) {
                $lightgrid{$x}{$y}{p1} = !$lightgrid{$x}{$y};
                $lightgrid{$x}{$y}{p2} += 2;
            }
        }
    }
    ++$count;
}

print " done\n";

# Get our puzzle answers
my ($numlit, $total_brightness);
foreach my $x (keys %lightgrid) {
    foreach my $y (keys %{$lightgrid{$x}}) {
        ++$numlit if $lightgrid{$x}{$y}{p1};
        $total_brightness += $lightgrid{$x}{$y}{p2};
    }
}

print "There are $numlit lights lit with a total brightness of $total_brightness.\n";

sub max { return $_[ ($_[0] > $_[1] ? 0 : 1) ] }

