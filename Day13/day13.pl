#!/usr/bin/env perl

# Advent of Code Day 13
# http://adventofcode.com/day/13

use strict;
use warnings;
use List::Permutor;

my %guests;
my %permutations;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
chomp(my @lines = <$fh>);
close $fh;

foreach (@lines) {
    my ($a, $op, $h, $b) = (/^(\w+).+(gain|lose) (\d+).+?(\w+)\.$/);
    $guests{$a}{$b} = $op eq 'gain' ? int($h) : int(-$h);
}

# Part 2
foreach (keys %guests) {
    $guests{Me}{$_} = 0;
    $guests{$_}{Me} = 0;
}

# Make use of perl's -1 index to simulate a round table with an array
my $p = List::Permutor->new(keys %guests);
while (my @perm = $p->next()) {
    my $hdelta;
    for (my $i = 0; $i < @perm; ++$i) {
        my $l = $guests{$perm[$i]}{$perm[$i-1]};
        my $r = $guests{$perm[$i]}{$perm[$i == $#perm ? 0 : $i+1]};
        $hdelta += ($l + $r);
    }
    $permutations{$hdelta} = [@perm];
}

my $best = (reverse sort { $a <=> $b } keys %permutations)[0];
my @best_perm = (join ' -> ', @{$permutations{$best}});

print "The most optimal arrangement has a happinessΔ of $best\n";
print "The arrangement is: |<- @best_perm ->|\n";

