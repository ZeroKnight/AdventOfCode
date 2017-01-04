#!/usr/bin/env perl

# Advent of Code 2016: Day 6
# http://adventofcode.com/2016/day/6

use v5.14;
use warnings;

my %columns;
my $message;
my $message2;
while (my $line = <>)
{
  chomp $line;
  my $n = 0;
  foreach (split //, $line)
  {
    ++$columns{$n}{$_};
    ++$n;
  }
}

foreach (0..(scalar keys %columns) - 1)
{
  $message .= (sort { $columns{$_}{$b} <=> $columns{$_}{$a} } keys %{$columns{$_}})[0];
  $message2 .= (sort { $columns{$_}{$a} <=> $columns{$_}{$b} } keys %{$columns{$_}})[0];
}

say "Part 1: $message";
say "Part 2: $message2";
