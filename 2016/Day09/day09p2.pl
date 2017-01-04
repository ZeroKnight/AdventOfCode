#!/usr/bin/env perl

# Advent of Code 2016: Day 9 (Part 2)
# http://adventofcode.com/2016/day/9

use v5.14;
use warnings;

my $dlength = 0;

while (<>)
{
  chomp;
  $dlength += rexpand($_);
}
say "Decompressed length: $dlength";

sub rexpand
{
  my $compressed = shift;
  my $len = 0;

  while ($compressed =~ s/^(.*?) \( (\d+)x(\d+) \)//x)
  {
    my $repeat = $3;
    $len += (length $1) + rexpand(substr($compressed, 0, $2, '')) * $repeat;
  }
  return $len + length $compressed;
}
