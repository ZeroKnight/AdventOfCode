#!/usr/bin/env perl

# Advent of Code Day 20
# http://adventofcode.com/day/20

use strict;
use warnings;

my $input = 34000000;
my @part1 = (0);
my @part2 = (0);

# What I came up with -- Slow as fuck
#for (my $i = 1; $street[-1] < $input; ++$i) {
#    foreach my $elf (1..$i) {
#        $street[$i-1] += 10 * $elf if $i % $elf == 0;
#    }
#}

# Shamefully stolen from r/adventofcode since I can't grasp these shortcuts
for (my $i = 1; $i <= ($input / 10); $i++) {
    for (my $j = $i; $j <= ($input / 10); $j += $i) {
        if ($j < $i * 50) {
            $part2[$j-1] += $i * 11;
        }
        $part1[$j-1] += $i * 10;
    }
}

for (my $i = 0; $i < @part1; ++$i) {
    if ($part1[$i] >= $input) {
        print "The first house to have $input presents is house " . ($i+1) . "\n";
        last;
    }
}

for (my $i = 0; $i < @part2; ++$i) {
    if ($part2[$i] >= $input) {
        print "Part 2: The first house to have $input presents is house " . ($i+1) . "\n";
        last;
    }
}

