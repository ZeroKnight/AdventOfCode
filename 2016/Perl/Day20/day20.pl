#!/usr/bin/env perl

# Advent of Code 2016: Day 20
# http://adventofcode.com/2016/day/20

use v5.14;
use warnings;

my @allowed;
my @conflated;
my @ranges = sort { $a->[0] <=> $b->[0] } map { chomp; [split /-/] } <>;
my $check = 0;

# Conflate ranges to find holes
foreach (@ranges)
{
  my ($beg, $end) = @$_;
  if ($beg <= $check or $beg == $check + 1)
  {
    # Squash
    $check = $end unless $end <= $check;
  }
  else
  {
    # Found a hole, add the allowed IPs
    push @allowed, $_ for (($check+1)..($beg-1));
    $check = $end;
  }
}

say "Part 1: $allowed[0]";
say 'Part 2: '.@allowed;
