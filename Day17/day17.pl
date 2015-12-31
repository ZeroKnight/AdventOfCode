#!/usr/bin/env perl

# Advent of Code Day 17
# http://adventofcode.com/day/17

use strict;
use warnings;
use Algorithm::Combinatorics qw/subsets combinations/;

my $total_liters = 150;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
chomp(my @containers = <$fh>);
close $fh;

my @valid_combos;
my $minimum = 0;
my $iter = subsets(\@containers);
while (my $combo = $iter->next()) {
    if (sum(@$combo) == $total_liters) {
        push @valid_combos, $combo;

        # Part 2
        if (!$minimum or @$combo < $minimum) {
            $minimum = scalar @$combo;
        }
    }
}

my @minimal_combos;
foreach my $c (@valid_combos) {
    push @minimal_combos, $c if @$c == $minimum;
}

print 'There are ' . scalar @valid_combos . " combinations.\n";
print 'There are ' . scalar @minimal_combos .
      " combinations with the least possible amount of containers.\n";

sub sum {
    my $sum = 0;
    $sum += $_ foreach @_;
    return $sum;
}
