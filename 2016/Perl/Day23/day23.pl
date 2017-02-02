#!/usr/bin/env perl

# Advent of Code 2016: Day 23
# http://adventofcode.com/2016/day/23

use v5.14;
use warnings;

chomp(my @input = <>);
my %registers = (a => 12);

for (my $line = 0; $line < @input; ++$line)
{
  my @arg = getargs($input[$line]);
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
    next if $arg[2] =~ /\d+/;
    $registers{$arg[2]} = val($arg[1]);
  }
  elsif ($arg[0] eq 'jnz')
  {
    my $delta = val($arg[2]);

    # Optimization: Addition Loop ~> Multiplication
    if ($delta == -5 and $input[$line-5] =~ /^cpy/ and
        $input[$line-1] eq "dec $arg[1]" and
        $input[$line-2] =~ /jnz (\w) -2/ and
        $input[$line-3] eq "dec $1")
    {
      my $r = (getargs($input[$line-4]))[1];
      $registers{$r} = $registers{$r} + val($arg[1]) * val((getargs($input[$line-5]))[1]);
      $registers{$1} = 0;
      $registers{$arg[1]} = 0;
      next;
    }

    # Normal behavior
    if (val($arg[1]) != 0)
    {
      $line += $delta;
      die "FAULT: Jump to line outside program\n" if badjump($line);
      redo;
    }
  }
  elsif ($arg[0] eq 'tgl')
  {
    my $tgl = $line + val($arg[1]);
    my $instr = $input[$tgl];
    next if badjump($tgl);
    if ($instr =~ /inc/)
    {
      $input[$tgl] =~ s/inc/dec/;
    }
    elsif ($instr =~ /(dec|tgl)/)
    {
      $input[$tgl] =~ s/$1/inc/;
    }
    elsif ($instr =~ /jnz/)
    {
      $input[$tgl] =~ s/jnz/cpy/;
    }
    elsif ($instr =~ /cpy/)
    {
      $input[$tgl] =~ s/cpy/jnz/;
    }
  }
  else
  {
    die 'FAULT: Illegal instruction on line ' . $line+1 . "\n";
  }
}

say "Register 'a': $registers{a}";

sub getargs { return (split / /, $_[0]) };

sub val { $_[0] =~ /\d+/ ? $_[0] : $registers{$_[0]} }

sub badjump { $_[0] < 0 or $_[0] >= @input }

