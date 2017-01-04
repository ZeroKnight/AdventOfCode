#!/usr/bin/env perl

# Advent of Code 2016: Day 17
# http://adventofcode.com/2016/day/17

use v5.14;
use warnings;

use Digest::MD5 'md5_hex';

my $input = 'pgflpeqp';
my $init = [$input, [0,0]];

my ($shortest, $longest) = bfs($init);
say "The shortest path to the vault with passcode '$input' is: $shortest";
say "The longest path to the vault with passcode '$input' is: $longest steps";

sub bfs
{
  my $start = shift;
  my @frontier = ($start);
  my ($shortest, $longest);

  while (@frontier)
  {
    my $current = pop @frontier;
    if (compare_coords($current->[1], [3,3]))
    {
      my $path = $current->[0] =~ s/$input//r;
      $shortest //= $path;
      $longest = length($path);
      next;
    }
    foreach my $next (get_moves($current))
    {
      next if is_wall($next->[1]);
      unshift @frontier, $next;
    }
  }
  return $shortest, $longest;
}

sub get_moves
{
  my $state = shift;
  my @moves;
  my @locks = (split //, md5_hex($state->[0]))[0..3];
  if ($locks[0] =~ /[bcdef]/)
  {
    push @moves, ["$state->[0]U", [$state->[1][0], $state->[1][1]-1]];
  }
  if ($locks[1] =~ /[bcdef]/)
  {
    push @moves, ["$state->[0]D", [$state->[1][0], $state->[1][1]+1]];
  }
  if ($locks[2] =~ /[bcdef]/)
  {
    push @moves, ["$state->[0]L", [$state->[1][0]-1, $state->[1][1]]];
  }
  if ($locks[3] =~ /[bcdef]/)
  {
    push @moves, ["$state->[0]R", [$state->[1][0]+1, $state->[1][1]]];
  }
  return @moves;
}

sub is_wall
{
  my $coord = shift;
  if ($coord->[0] < 0 or $coord->[0] > 3 or
      $coord->[1] < 0 or $coord->[1] > 3)
  {
    return 1;
  }
}

sub compare_coords
{
  my ($coord1, $coord2) = @_;
  if ($coord1->[0] == $coord2->[0] and
      $coord1->[1] == $coord2->[1])
  {
    return 1;
  }
}
