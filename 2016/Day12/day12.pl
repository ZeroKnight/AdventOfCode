#!/usr/bin/env perl

# Advent of Code 2016: Day 12
# http://adventofcode.com/2016/day/12

use v5.14;
use strict;
use warnings;

my @input = <>;
chomp @input;
my %registers = ( a => 0, b => 0, c => 1, d => 0 );

for (my $line = 0; $line < @input; ++$line)
{
  my @arg = split(/ /, $input[$line]);
  if ($arg[0] eq 'inc')
  {
    ++$registers{$arg[1]};
  }
  elsif ($arg[0] eq 'dec')
  {
    --$registers{$arg[1]};
  }
  elsif ($arg[0] eq 'cpy')
  {
    $registers{$arg[2]} = val($arg[1]);
  }
  elsif ($arg[0] eq 'jnz')
  {
    if (val($arg[1]) != 0)
    {
      $line += $arg[2];
      die "FAULT: Negative line number\n" if $line < 0;
      redo;
    }
  }
  else
  {
    die "FAULT: Illegal instruction on line $line\n";
  }
}

say "Register 'a': $registers{a}";

sub val { $_[0] =~ /\d/ ? $_[0] : $registers{$_[0]} }
