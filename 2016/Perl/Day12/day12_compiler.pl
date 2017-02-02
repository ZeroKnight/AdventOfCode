#!/usr/bin/env perl

# Advent of Code 2016: Day 12 - Compiler Approach
# http://adventofcode.com/2016/day/12

use v5.14;
use warnings;

my $C = 1;
chomp(my @input = <>);
my $fn = 'day12.p.cpp';
open my $fh, '>', $fn or die "Can't open $fn for writing: $!";

print $fh <<"END";
#include <iostream>

enum REGISTER { A=0, B, C, D };

int main()
{
  int registers[4] = { 0, 0, $C, 0 };

END

for (my $line = 1; $line <= @input; ++$line)
{
  my @arg = split(/ /, $input[$line-1]);
  if ($arg[0] eq 'inc')
  {
    say $fh "L$line: ++registers[".uc($arg[1]).'];';
  }
  elsif ($arg[0] eq 'dec')
  {
    say $fh "L$line: --registers[".uc($arg[1]).'];';
  }
  elsif ($arg[0] eq 'cpy')
  {
    say $fh "L$line: registers[".uc($arg[2]).'] = '.val($arg[1]).';';
  }
  elsif ($arg[0] eq 'jnz')
  {
    say $fh "L$line: if (".val($arg[1]).' != 0) goto L'.($line+$arg[2]).';';
  }
  else
  {
    die "Compilation error: Illegal instruction '@arg' on line $line\n";
  }
}

print $fh <<END;

  std::cout << registers[A] << std::endl;
  return 0;
}
END

sub val { $_[0] =~ /\d/ ? $_[0] : 'registers['.uc($_[0]).']' }
