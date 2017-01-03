#!/usr/bin/env perl

# Advent of Code 2016: Day 19
# http://adventofcode.com/2016/day/19

# The Josephus Problem

use v5.14;
use strict;
use warnings;

my $input = shift // 3012210;
my ($p1, $p2);

# Part 1
#
# n = 2^a + l
# w(n) = 2l + 1
# After l moves, there is a power of 2 remaining people, and so the winner is
# who starts, hence 2l + 1
my $nearest_pow2 = 2 ** int(log($input) / log(2));
$p1 = ($input - $nearest_pow2) * 2 + 1;

# Part 2
my $nearest_pow3 = 3 ** int(log($input) / log(3));
if ($nearest_pow3 == $input)
{
  # Powers of 3 are winners
  $p2 = $nearest_pow3;
}
elsif ($input - $nearest_pow3 <= $nearest_pow3)
{
  # From 1, winners increase by 1 up to and including the previous power of 3
  $p2 = $input - $nearest_pow3;
}
else
{
  # Afterward, winners increase by 2, leading to the next power of 3
  # 3 * $nearest_pow3 is the next power of 3
  $p2 = $input * 2 - 3 * $nearest_pow3;
}

say "Part 1: $p1";
say "Part 2: $p2";

