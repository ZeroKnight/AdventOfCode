#!/usr/bin/env perl

# Advent of Code 2016: Day 1
# http://adventofcode.com/2016/day/1

use strict;
use warnings;

# Part 1
my $heading = 0;
my @blocks = qw/0 0 0 0/; # North East South West

# Part 2
my %city = ( 0 => { 0 => 1 } );
my ($x, $y) = (0, 0);
my $foundHQ = 0;

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
  $blocks[$heading] += $count;

  unless ($foundHQ) {
    foreach (1..$count)
    {
      ++$y if $heading == 0;
      ++$x if $heading == 1;
      --$y if $heading == 2;
      --$x if $heading == 3;

      if (++$city{$x}{$y} == 2)
      {
        $foundHQ = 1;
        last;
      }
    }
  }
}

my $distance = abs($blocks[0] - $blocks[2]) + abs($blocks[1] - $blocks[3]);
my $distance2 = abs($x + $y);
print "Part 1: $distance\n";
print "Part 2: $distance2 ($x,$y)\n";
