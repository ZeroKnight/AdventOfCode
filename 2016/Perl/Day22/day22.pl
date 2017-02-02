#!/usr/bin/env perl

# Advent of Code 2016: Day 22
# http://adventofcode.com/2016/day/22

use v5.14;
use warnings;

use List::Util 'any';
use Array::Heap::PriorityQueue::Numeric;

my %nodes;
my @pairs;
my $empty;
my ($max_x, $max_y) = (0, 0);
while (<>)
{
  if (m|^/dev/grid/node-x(\d+)-y(\d+)|)
  {
    my ($size, $used, $avail) = (split /\s+/)[1..3];
    chop($size, $used, $avail); # Remove 'T'
    $nodes{"$1,$2"} = {
      size  => $size,
      used  => $used,
      avail => $avail
    };
    $max_x = $1 if $1 > $max_x;
    $max_y = $2 if $2 > $max_y;
    $empty = "$1,$2" if $used == 0;
  }
}
my $goal     = "$max_x,0";
my $adjacent = $max_x-1 . ',0';

# Part 1
foreach my $a (keys %nodes)
{
  foreach my $b (keys %nodes)
  {
    next if $a eq $b;
    next unless $nodes{$a}{used};
    if ($nodes{$a}{used} <= $nodes{$b}{avail})
    {
      push @pairs, "($a), ($b)";
    }
  }
}

say "Part 1: " . @pairs;
say "Part 2: " . p2();

# Automated "solve-by-hand"
sub p2
{
  my $moves;

  # A* to node adjacent to goal
  my $frontier = Array::Heap::PriorityQueue::Numeric->new();
  $frontier->add($empty, 0);
  my %cost_so_far = ($empty => 0);
  while ($frontier->size)
  {
    my $current = $frontier->get;
    if ($current eq $adjacent)
    {
      $moves = $cost_so_far{$current};
      last;
    }
    foreach my $node (neighbors($current))
    {
      my $new_cost = $cost_so_far{$current} + ($nodes{$node}{size} > 500 ? 99 : 1);
      if (!exists($cost_so_far{$node}) or $new_cost < $cost_so_far{$node})
      {
        $cost_so_far{$node} = $new_cost;
        $frontier->add($node, $new_cost + heuristic($node));
      }
    }
  }

  # Moving the goal node left requires 5 moves, 1 to swap with the empty node,
  # and 4 to reset the empty node back to the left of the goal node. Repeating
  # $max_x - 1 times will leave the goal node adjacent to the empty access node,
  # so add 1 final move.
  return $moves + (5 * ($max_x - 1) + 1);
}

sub neighbors
{
  my ($x, $y) = split /,/, shift;
  my $valid = sub {
    ($_[0] >= 0 && $_[0] <= $max_x) &&
    ($_[1] >= 0 && $_[1] <= $max_y) ?
      "$_[0],$_[1]" : ();
  };
  return (
    $valid->($x, $y+1),
    $valid->($x, $y-1),
    $valid->($x+1, $y),
    $valid->($x-1, $y),
  );
}

sub heuristic
{
  my ($cx, $cy) = split /,/, shift;
  my ($ax, $ay) = split /,/, $adjacent;
  return abs($cx - $ax) + abs($cy - $ay);
}
