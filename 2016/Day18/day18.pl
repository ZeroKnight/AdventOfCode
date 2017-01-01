#!/usr/bin/env perl

# Advent of Code 2016: Day 18
# http://adventofcode.com/2016/day/18

use v5.14;
use strict;
use warnings;

chomp(my $input = <>);

my $nrows  = 400000;
my $ncols  = length $input;
my $nsafe = () = $input =~ /\./g;
my $current = $input;
foreach (1..$nrows-1)
{
  my $ref = $current;
  $current = '';
  for (my $col = 0; $col < $ncols; ++$col)
  {
    local $_ = lcr($ref, $col);
    if (/\Q^^./ or /\Q^../ or /\Q.^^/ or /\Q..^/)
    {
      $current .= '^';
    }
    else
    {
      $current .= '.';
      ++$nsafe;
    }
  }
}

say "There are $nsafe safe tiles";

sub lcr
{
  my ($line, $col) = @_;
  my $l = $col-1 < 0 ? '.' : substr($line, $col-1, 1);
  my $c = substr($line, $col, 1);
  my $r = $col+1 >= $ncols ? '.' : substr($line, $col+1, 1);
  return join '', $l, $c, $r;
}

