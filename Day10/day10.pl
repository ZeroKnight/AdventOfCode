#!/usr/bin/env perl

# Advent of Code Day 10
# http://adventofcode.com/day/10

use strict;
use warnings;

my $input = '1113222113';
for (my ($j, $k) = (0, 4); $k <= 5; ++$k) {
    for (; $j < $k*10; ++$j) {
        local $| = 1;
        print "\rIteration " . ($j+1) . '...';

        my $next;
        for (my ($i, $count) = (0, 1); $i < length $input; ++$i) {
            my $num  = substr $input, $i, 1;
            my $peek = substr $input, $i+1, 1;
            if (!$peek or $peek != $num) {
                $next .= $count . $num;
                $count = 1;
            } else {
                ++$count;
            }
        }
        $input = $next;
    }
    print "\rAfter " . ($k*10) . " iterations, the sequence length is " .
          (length $input) . "\n";
}

