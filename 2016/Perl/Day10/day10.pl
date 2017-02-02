#!/usr/bin/env perl

# Advent of Code 2016: Day 10
# http://adventofcode.com/2016/day/10

use v5.14;
use warnings;

my %carriers;
my @instructions;

while (<>)
{
  chomp;
  if (/^value (\d+) goes to bot (\d+)$/)
  {
    if (!exists $carriers{bot}{$2})
    {
      $carriers{bot}{$2} = [$1];
    }
    else
    {
      $carriers{bot}{$2}[1] = $1;
    }
  }
  elsif (/gives/)
  {
    push @instructions, $_;
  }
}

while (@instructions)
{
  my ($index, $step) = each @instructions;
  next unless defined $index; # Reached end of array; loop again

  $step =~ /^bot (\d+).*?(bot|output) (\d+).*?(bot|output) (\d+)$/;
  my $from = $carriers{bot}{$1};

  # Bot should only proceed if it has 2 chips
  if (defined $from and @$from == 2)
  {
    @$from = sort { $a <=> $b } @$from;
    my @t1 = exists $carriers{$2}{$3} ? @{$carriers{$2}{$3}} : ();
    my @t2 = exists $carriers{$4}{$5} ? @{$carriers{$4}{$5}} : ();
    print "bot $1 (@$from): $from->[0] -> $2 $3 (@t1), $from->[1] -> $4 $5 (@t2)";

    # Hand off the chips
    next unless give(shift @$from, $2, $3);
    next unless give(shift @$from, $4, $5);

    # Remove this completed instruction
    splice @instructions, $index, 1;

    say " | Instr. left: ".@instructions;
  }
}

my $p2 = $carriers{output}{0} * $carriers{output}{1} * $carriers{output}{2};
say "Part 1: Grep it\nPart 2: $p2";

sub give
{
  my ($chip, $type, $to) = @_;

  if ($type eq 'bot')
  {
    $carriers{bot}{$to} = [] unless exists $carriers{bot}{$to};
    my $sz = @{ $carriers{bot}{$to} };
    return 0 if $sz >= 2;
    $carriers{bot}{$to}[$sz ? 1 : 0] = $chip;
  }
  elsif ($type eq 'output')
  {
    $carriers{output}{$to} = $chip;
  }

  return 1;
}
