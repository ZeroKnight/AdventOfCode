#!/usr/bin/env perl

# Advent of Code 2016: Day 22 - Grid Printer
# http://adventofcode.com/2016/day/22

use v5.14;
use warnings;

my @grid;
my $max_x;
while (<>)
{
  if (m|^/dev/grid/node-x(\d+)-y(\d+)\s+\d+T\s+(\d+)T|)
  {
    if ($3 > 99)
    {
      $grid[$2][$1] = '=';
    }
    elsif ($3 == 0)
    {
      $grid[$2][$1] = '_';
    }
    else
    {
      $grid[$2][$1] = '.';
    }
    $max_x = $1 if $1 > $max_x;
  }
}
$grid[0][$max_x] = 'G';

for (my $y = 0; $y < @grid; ++$y)
{
  for (my $x = 0; $x < @{$grid[$y]}; ++$x)
  {
    print "$grid[$y][$x] ";
  }
  print "\n";
}
