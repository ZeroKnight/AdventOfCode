#!/usr/bin/env perl

# Advent of Code 2016: Day 9 (Part 1)
# http://adventofcode.com/2016/day/9

use v5.14;
use warnings;

chomp(my $data = <>);
my $dlength = 0;

for (my $i = 0; $i < length($data); ++$i)
{
  my $c = substr $data, $i, 1;
  if ($c eq '(')
  {
    $i = expand_at($i);
  }
  else { ++$dlength }
}

say "Decompressed length: $dlength";

sub expand_at
{
  my $start = shift;
  my $end = index($data, ')', $start);
  my ($nchars, $repeat) = substr($data, $start+1, $end-$start-1) =~ /(\d+)x(\d+)/;
  my $str = substr($data, $end+1, $nchars);
  my $expanded = $str x $repeat;

  $dlength += length($expanded);
  return $end + $nchars;
}
