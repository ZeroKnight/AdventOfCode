#!/usr/bin/env perl

# Advent of Code 2016: Day 15
# http://adventofcode.com/2016/day/15

use v5.14;
use warnings;

my $time = 0;
my @discs;

open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
while (<$fh>)
{
  chomp;
  /#(\d+) has (\d+).*?(\d+)\.$/;
  $discs[$1-1] = {
    npos => $2,
    init => $3
  };
}
$discs[6] = { npos => 11, init => 0 }; # Part 2

OUTER: while (1)
{
  my $start = $time++;
  for (my $i = 0; $i < @discs; ++$i)
  {
    next OUTER if (($discs[$i]{init} + ($start+$i+1)) % $discs[$i]{npos}) != 0;
  }
  say "The soonest time to get a capsule is time=$start";
  last;
}

