#!/usr/bin/env perl

# Advent of Code Day 5
# http://adventofcode.com/day/5

use strict;
use warnings;

my @stringlist;
my @nicestrings;
open my $fh, '<', './input';
while (<$fh>) {
    chomp;
    push @stringlist, $_;
}

foreach my $str (@stringlist) {
    # Part 1
    #next unless $str =~ /(?:.*[aeiou].*){3,}/; # Round 1: 3 Vowels
    #next unless $str =~ /([a-z])\1/;           # Round 2: Letter twice in a row
    #next if     $str =~ /(?:ab|cd|pq|xy)/;     # Round 3: Bad substrings

    # Part 2
    next unless $str =~ /([a-z]{2}).*\1/;   # Round 1: Pairs (no overlaps)
    next unless $str =~ /([a-z])[a-z]\1/;   # Pair with middle (xyx)

    push @nicestrings, $str;
}

print 'There are ' . scalar(@nicestrings) . " nice strings.\n";

