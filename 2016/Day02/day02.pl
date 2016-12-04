#!/usr/bin/env perl

# Advent of Code 2016: Day 2
# http://adventofcode.com/2016/day/2

use strict;
use warnings;

my $code;
my @pos = (1, 1);
my @pad = (
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
);

open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
while (my $line = <$fh>)
{
  chomp $line;
  foreach my $step (split(//, $line))
  {
    if ($step eq 'U')
    {
      $pos[0] = 0 if --$pos[0] == -1;
    }
    elsif ($step eq 'R')
    {
      $pos[1] = 2 if ++$pos[1] == 3;
    }
    elsif ($step eq 'D')
    {
      $pos[0] = 2 if ++$pos[0] == 3;
    }
    elsif ($step eq 'L')
    {
      $pos[1] = 0 if --$pos[1] == -1;
    }
    else
    {
      print "Invalid input: '$step'\n";
      exit 1
    }
  }
  $code .= $pad[$pos[0]][$pos[1]];
}

print "$code\n";

