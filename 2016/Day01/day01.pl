#!/usr/bin/env perl

# Advent of Code 2016: Day 1
# http://adventofcode.com/2016/day/1

use strict;
use warnings;

# Part 1
my $heading = 0;
my ($x, $y) = (0, 0);

# Part 2
my %city = ( 0 => { 0 => 1 } );
my $distanceHQ = 0;
my @hq;

open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
foreach my $step (split(/, /, do { local $/; <$fh>; }))
{
  my $count = substr($step, 1);
  if (substr($step, 0, 1) eq 'R')
  {
    $heading = ++$heading % 4
  }
  else
  {
    $heading = --$heading % 4
  }

  foreach (1..$count) {
    ++$y if $heading == 0;
    ++$x if $heading == 1;
    --$y if $heading == 2;
    --$x if $heading == 3;

    unless ($distanceHQ) {
      if (++$city{$x}{$y} == 2)
      {
        $distanceHQ = abs($x + $y);
        @hq = ($x, $y);
      }
    }
  }
}
my $distance = abs($x - $y);

print "Part 1: $distance\n";
print "Part 2: $distanceHQ ($hq[0], $hq[1])\n";
