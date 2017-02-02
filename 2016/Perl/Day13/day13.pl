#!/usr/bin/env perl

# Advent of Code 2016: Day 13
# http://adventofcode.com/2016/day/13

use v5.14;
use warnings;

use Term::ANSIColor;
use Array::Heap::PriorityQueue::Numeric;

my $magic = 1350;
my ($maxw, $maxh) = (49,49);
my @office;
my $p1 = '31,39';
my $p2 = '50';

foreach my $x (0..$maxw)
{
  foreach my $y (0..$maxh)
  {
    $office[$x][$y] = get_ent($x, $y);
  }
}

die "Goal is a wall!\n" if is_wall(split /,/, $p1);

my $optimal = A_star('1,1', $p1);
my $n50 = bfs('1,1', $p2);
say "Fewest steps required to reach ($p1): $optimal";
say "Number of locations reachable in $p2 steps: $n50";

sub A_star
{
  my ($start, $goal) = @_;
  my $frontier = Array::Heap::PriorityQueue::Numeric->new();
  $frontier->add($start, 0);
  my %cost_so_far = ($start => 0);
  my %came_from = ($start => 0);

  while ($frontier->size)
  {
    my $current = $frontier->get;
    if ($current eq $goal)
    {
      draw_path($current, \%came_from);
      return $cost_so_far{$current};
    }

    foreach my $next (neighbors($current))
    {
      # Check validity of coord
      my ($x, $y) = split /,/, $next;
      next if ($x < 0 or $x > $maxw) or ($y < 0 or $y > $maxh);
      next if is_wall($x, $y);

      my $new_cost = $cost_so_far{$current} + 1;
      if (!exists($cost_so_far{$next}) or $new_cost < $cost_so_far{$next})
      {
        $cost_so_far{$next} = $new_cost;
        my $priority = $new_cost + heuristic($next, $goal);
        $frontier->add($next, $priority);
        $came_from{$next} = $current;
      }
    }
  }
}

sub bfs
{
  my ($start, $max_steps) = @_;
  my @frontier = ($start);
  my %cost_so_far = ($start => 0);

  while (@frontier)
  {
    my $current = pop @frontier;
    foreach my $next (neighbors($current))
    {
      # Check validity of coord
      my ($x, $y) = split /,/, $next;
      next if ($x < 0 or $x > $maxw) or ($y < 0 or $y > $maxh);
      next if is_wall($x, $y);

      unless (grep { $_ eq $next } keys %cost_so_far)
      {
        unshift @frontier, $next;
        $cost_so_far{$next} = $cost_so_far{$current} + 1;
      }
    }
  }
  my @nodes_in_50;
  while (my ($k, $v) = each %cost_so_far)
  {
    push @nodes_in_50, $k if $v <= $max_steps;
  }
  draw_visited(@nodes_in_50);
  return scalar @nodes_in_50;
}

sub heuristic
{
  my ($cx, $cy) = split /,/, shift;
  my ($gx, $gy) = split /,/, shift;
  return abs($cx - $gx) + abs($cy - $gy);
}

sub get_ent
{
  my ($x, $y) = @_;
  my $expr = sprintf '%b', $x*$x + 3*$x + 2*$x*$y + $y + $y*$y + $magic;
  return ($expr =~ tr/1//) % 2 ? '█' : ' ';
}

sub neighbors
{
  my ($x, $y) = split /,/, shift;
  return (
    "$x," . ($y+1),
    ($x+1)  . ",$y",
    "$x," . ($y-1),
    ($x-1) .  ",$y"
  );
}

sub is_wall { $office[$_[0]][$_[1]] eq '█' }

sub draw_path
{
  my $current = shift;
  my $came_from = shift;
  my @o = map { [@$_] } @office;
  my @path;

  my ($x, $y) = split /,/, $current;
  $o[$x][$y] = colored('%', 'red');

  # Assemble our optimal path
  while ($came_from->{$current} != 0)
  {
    $current = $came_from->{$current};
    push @path, $current;
  }

  # Mark starting point
  ($x, $y) = split /,/, pop @path;
  $o[$x][$y] = colored('@', 'yellow');

  @path = reverse @path;
  foreach my $node (@path)
  {
    ($x, $y) = split /,/, $node;
    $o[$x][$y] = colored('o', 'magenta');

    # Clear screen and draw
    print "\033[2J";
    print "\033[0;0H";
    do { local $" = ''; say "@$_" foreach @o };

    # Wait
    select(undef, undef, undef, 0.05);
  }
}

sub draw_visited
{
  my @visited = @_;
  my @o = map { [@$_] } @office;

  foreach my $node (@visited)
  {
    my ($x, $y) = split /,/, $node;
    $o[$x][$y] = colored('o', 'magenta');
  }

  # Mark starting point
  $o[1][1] = colored('@', 'yellow');

  # Clear screen and draw
  print "\033[2J";
  print "\033[0;0H";
  do { local $" = ''; say "@$_" foreach @o };
}

