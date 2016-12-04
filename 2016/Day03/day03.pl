#!/usr/bin/env perl

# Advent of Code 2016: Day 3
# http://adventofcode.com/2016/day/3

use strict;
use warnings;

my $valid;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
while (my $line = <$fh>)
{
  my @tri = (split /\s+/, $line =~ s/^\s+//r);
  $tri[0] + $tri[1] > $tri[2] or next;
  $tri[0] + $tri[2] > $tri[1] or next;
  $tri[1] + $tri[2] > $tri[0] or next;
  ++$valid;
}

print "Part 1: $valid\n";

