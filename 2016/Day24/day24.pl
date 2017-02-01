#!/usr/bin/env perl

# Advent of Code 2016: Day 24
# http://adventofcode.com/2016/day/24

use v5.14;
use warnings;

use List::Util 'any';
use List::Permutor;
use Array::Heap::PriorityQueue::Numeric;

my @grid;
my %poi;
my %paths;
for (my $i = 0; my $line = <>; ++$i)
{
  chomp $line;
  my @chars = split //, $line;
  for (my $k = 0; $k < length $line; ++$k)
  {
    next if $i == 0; # First line is all '#'
    $poi{$chars[$k]} = "$k,$i" if $chars[$k] =~ /\d/;
  }
  @grid[$i] = [@chars];
}

my $p = new List::Permutor(grep { $_ != 0 } keys %poi);
while (my @set = $p->next)
{
  my $moves;
  my $from = $poi{0};
  foreach my $point (@set, 0)
  {
    $moves += A_star($from, $poi{$point});
    $from = $poi{$point};
  }
  my $s = join '', @set;
  $paths{$s} = $moves;
}

my $shortest = (sort { $paths{$a} <=> $paths{$b} } keys %paths)[0];
say "Shortest path: $shortest (Steps: $paths{$shortest})";

sub A_star
{
  my ($start, $goal) = @_;
  my $frontier = Array::Heap::PriorityQueue::Numeric->new();
  $frontier->add($start, 0);
  my %cost_so_far = ($start => 0);

  while ($frontier->size)
  {
    my $current = $frontier->get;
    if ($current eq $goal)
    {
      return $cost_so_far{$goal};
    }
    foreach my $next (neighbors($current))
    {
      my $new_cost = $cost_so_far{$current} + 1;
      if (!exists($cost_so_far{$next}) or $new_cost < $cost_so_far{$next})
      {
        $cost_so_far{$next} = $new_cost;
        $frontier->add($next, $new_cost + heuristic($next, $goal));
      }
    }
  }
  return -1;
}

sub neighbors
{
  my ($x, $y) = split /,/, shift;
  my $valid = sub {
    ($_[0] >= 0 && $_[0] <= @{$grid[0]}) &&
    ($_[1] >= 0 && $_[1] <= @grid) &&
    ($grid[$_[1]][$_[0]] ne '#') ? "$_[0],$_[1]" : ();
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
  my ($ax, $ay) = split /,/, shift;
  return abs($cx - $ax) + abs($cy - $ay);
}
