#!/usr/bin/env perl

# Advent of Code 2016: Day 6
# http://adventofcode.com/2016/day/6

use strict;
use warnings;

my %columns;
my $message;
my $message2;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
while (my $line = <$fh>)
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

print "Part 1: $message\n";
print "Part 2: $message2\n";
