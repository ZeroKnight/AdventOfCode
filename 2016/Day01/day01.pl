#!/usr/bin/env perl

# Advent of Code 2016: Day 1
# http://adventofcode.com/2016/day/1

use strict;
use warnings;

my $heading = 0;
my @blocks = qw/0 0 0 0/; # North East South West

open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
foreach my $step (split(/, /, do { local $/; <$fh>; }))
{
  if (substr($step, 0, 1) eq 'R')
  {
    $heading = 0 if ++$heading == 4; # West to North
  }
  else
  {
    $heading = 3 if --$heading == -1; # North to West
  }
  $blocks[$heading] += substr($step, 1);
}

my $distance = abs($blocks[0] - $blocks[2]) + abs($blocks[1] - $blocks[3]);
print "$distance\n";
