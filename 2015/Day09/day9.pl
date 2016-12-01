#!/usr/bin/env perl

# Advent of Code Day 9
# http://adventofcode.com/day/9

use strict;
use warnings;

# I'd like to write my own, but I can't completely wrap my head around the
# algorithm and how it works... :(
use List::Permutor;

my %locations;
my %permutations;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
chomp(my @directions = <$fh>);
close $fh;

# Populate our location table
foreach (@directions) {
    my ($from, $to, $dist) = split / to | = /;
    $locations{$from}{$to} = $dist;
    $locations{$to}{$from} = $dist; # both ways apply, obviously
}

# Calculate each route permutation's distance
my $p = List::Permutor->new(keys %locations);
while (my @perm = $p->next()) {
    my $perm_distance;
    for (my $i = 0; $i < $#perm; ++$i) {
        $perm_distance += $locations{$perm[$i]}{$perm[$i+1]};
    }
    $permutations{$perm_distance} = [@perm];
}

my $shortest_dist = (sort keys %permutations)[0];
my @shortest_perm = join '->', @{$permutations{$shortest_dist}};
my $longest_dist = (reverse sort keys %permutations)[0];
my @longest_perm = join '->', @{$permutations{$longest_dist}};

print "The shortest route is @shortest_perm covering $shortest_dist total distance\n";
print "The longest route is @longest_perm covering $longest_dist total distance\n";

