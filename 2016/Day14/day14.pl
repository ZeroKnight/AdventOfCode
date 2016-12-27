#!/usr/bin/env perl

# Advent of Code 2016: Day 14
# http://adventofcode.com/2016/day/14

use v5.14;
use strict;
use warnings;

use Digest::MD5 'md5_hex';

my $salt  = 'cuanljph';
my $index = 0;
my $found = 0;
my @hashes;

for (; $found < 64; ++$index)
{
  my $hash = md5_hex($salt.$index);
  $hash = md5_hex($hash) for (1..2016); # Part 2
  if ($hash =~ /(.)\1\1/)
  {
    push @hashes, {
      hash  => $hash,
      index => $index,
      trip  => $1,
      after => 0
    };
  }
  foreach my $h (@hashes)
  {
    next if $h->{hash} eq $hash;
    next if ($h->{after} >= 1000);
    my $t = $h->{trip};
    if ($hash =~ /$t{5}/)
    {
      ++$found;
      say "[$found] Candidate hash $h->{hash} with index $h->{index} valid ($hash @ $index)";

      # A candidate could match more than once within 1000 indexes
      $h->{after} = 1000;
    }
    ++$h->{after};
  }
}

