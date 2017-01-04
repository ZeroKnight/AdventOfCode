#!/usr/bin/env perl

# Advent of Code 2016: Day 3
# http://adventofcode.com/2016/day/3

use v5.14;
use warnings;

my $set = -1;
my @valid;
my @tris;

my @input = <>;

foreach my $line (@input)
{
  $set = ++$set % 3;
  @tris[$set] = [split /\s+/, $line =~ s/^\s+//r];

  if ($set == 2)
  {
    foreach (0..2)
    {
      ++$valid[0] if isTri($tris[$_][0], $tris[$_][1], $tris[$_][2]); # Part 1
      ++$valid[1] if isTri($tris[0][$_], $tris[1][$_], $tris[2][$_]); # Part 2
    }
  }
}

say "Part 1: $valid[0]";
say "Part 2: $valid[1]";

sub isTri
{
  my ($a, $b, $c) = @_;
  return 1 if ($a + $b > $c) && ($a + $c > $b) && ($b + $c > $a);
}
