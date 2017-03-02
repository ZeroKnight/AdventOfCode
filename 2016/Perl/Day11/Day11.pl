# Advent of Code 2016: Day 11
# http://adventofcode.com/2016/day/11

package Day11;

use v5.14;
use warnings;
use bigint;
use feature 'bitwise';
no warnings qw(experimental::bitwise portable);

use Advent::IO;
use Array::Heap::PriorityQueue::Numeric;

### Bitstring State
#
# Each pair of bytes represents a floor; the first byte being chips on the first
# floor, the second being generators on the first floor, etc. Each bit in the
# bytes represents an element type; from least to most significant bit:
#
# (P)lutonium, Pr(o)methium, (R)uthenium, (S)trontium, (T)hulium, (D)ilithium, (E)lerium
#
# The ele(v)ator position is the final bit in the 'generator' byte for the
# corresponding floor

# Floor constants
my $FLOOR_1    = 0x8000;
my $FLOOR_2    = 0x80000000;
my $FLOOR_3    = 0x800000000000;
my $FLOOR_4    = 0x8000000000000000;
my $FLOORMASK  = 0x8000800080008000;

sub solve
{
  my ($day, $part2) = @_;
  my $state = 0b00000000_00000000_00000110_00000110_00000000_00001001_10011001_00010000;
  #            |vEDTSROP4 EDTSROP|vEDTSROP3 EDTSROP|vEDTSROP2 EDTSROP|vEDTSROP1 EDTSROP|
  my $goal  = 0b10011111_00011111_00000000_00000000_00000000_00000000_00000000_00000000;
  if ($part2)
  {
    $state |= 0b01100000_01100000;
    $goal  |= 0b01100000_01100000;
  }
  # say A_star($state, $goal);
  say bfs($state, $goal);
}

sub bfs
{
  my ($start, $goal) = @_;
  my $s = { state => $start, pairs => pairs($start) };
  my @frontier = ($s);
  my %visited = ($s->{pairs} => 0);

  say '';
  while (@frontier)
  {
    local $| = 1;
    my $current = pop @frontier;

    print "\r$visited{$current->{pairs}}: $current->{pairs}";

    if ($current->{state} == $goal)
    {
      return $visited{$current->{pairs}};
    }
    foreach my $move (moves($current->{state}))
    {
      my $new_cost = $visited{$current->{pairs}} + 1;
      my $move_pairs = pairs($move);
      if (!exists $visited{$move_pairs} or $new_cost < $visited{$move_pairs})
      {
        unshift @frontier, { state => $move, pairs => $move_pairs };
        $visited{$move_pairs} = $new_cost;
      }
    }
  }
  return -1;
}

sub A_star
{
  my ($start, $goal) = @_;
  my $frontier = Array::Heap::PriorityQueue::Numeric->new();
  $frontier->add($start, 0);
  my %cost_so_far = ($start => 0);
  my %closed_set;

  while ($frontier->size)
  {
    my $current = $frontier->get;
    if ($current == $goal)
    {
      return $cost_so_far{$goal};
    }
    $closed_set{$current} = 1;

    my $floor = $current & $FLOORMASK;
    foreach my $move (moves($floor, $current))
    {
        # Initialize state of next move
        # my $next = move_if_valid($move, $new_floor, $current);
        # next unless defined $next;

        # Don't revisit an evaluated state
        # my $next_hash = zhash($next);
        # next if grep { $_ eq $next_hash } @closed_set;

        # my $new_cost = $cost_so_far{$current_hash} + 1;
        # if (!exists($cost_so_far{$next_hash}) or
        #     $new_cost < $cost_so_far{$next_hash})
        # {
        #   $cost_so_far{$next_hash} = $new_cost;
        #   my $priority = $new_cost - heuristic($next, $dir, ref($move) ? 2 : 1);
        #   $frontier->add($next, $priority);
        # }
    }
  }
}

sub heuristic
{
  my $f4_items = @{$_[0]->{floors}[3]};
  my $f3_items = @{$_[0]->{floors}[2]};
  my $f2_items = @{$_[0]->{floors}[1]};
  my $dir = $_[1];
  my $nItems = $_[2];

  # Prefer moves that leave us with more items on higher floors
  my $score = $f4_items*5 + $f3_items*2 + $f2_items;

  # Prefer to Move 2 items UP instead of 1, and 1 item DOWN instead of 2
  # This shaves run time by ~77%
  if (($dir == 1 and $nItems == 2) or ($dir == -1 and $nItems == 1))
  {
    $score *= 2;
  }
  return $score;
}

sub moves
{
  my $state = shift;
  my $floor = get_floor($state);
  my @valid;
  foreach my $dir (1, -1)
  {
    # Check legality of direction
    next unless 0 <= $floor + $dir and $floor + $dir <= 3;
    ITEM1: foreach my $i (0..6, 8..14)
    {
      ITEM2: foreach my $j ($i+1 .. 14, -1)
      {
        my $shifti = $i + 16 * $floor;
        my $shiftj = $j + 16 * $floor;

        # Make sure the item(s) are on this floor
        next ITEM1 unless (1 << $shifti) & $state;
        next ITEM2 if $j != -1 and ((1 << $shiftj) & $state) == 0;

        # Move the item(s) and elevator to the new floor
        my $new_state = $state;
        $new_state |= (1 << $i + 16 * ($floor + $dir)); # New Item
        $new_state |= (1 << 15 + 16 * ($floor + $dir)); # New Floor
        $new_state ^= (1 << $shifti);                   # Old Item
        $new_state ^= (1 << 15 + 16 * $floor);          # Old Floor
        if ($j != -1)
        {
          $new_state |= (1 << $j + 16 * ($floor + $dir));
          $new_state ^= (1 << $shiftj);
        }

        # Check for any unpaired chips
        foreach my $f ($floor, $floor + $dir)
        {
          my ($chips, $generators) = floor_items($floor, $new_state);
          next unless $generators;              # No generators? No problem.
          my $unpaired = $chips & ~$generators; # Isolate unpaired chips
          next ITEM2 if $unpaired and $generators;
        }
        push @valid, $new_state;
      }
    }
  }
  return @valid;
}

# FIXME
# Starting on Floor 1, for the first 7 bits (each element), look for the
# paired generator on each floor until it's found. Add the floors of each
# item as a 2-tuple to a list of pairs. Repeat for each floor necessary,
# until all pending elements have had their pairs found.
sub pairs
{
  my $state = shift;
  my @pairs;
  foreach my $floor_chip (0..3)
  {
    foreach my $element (0..6)
    {
      # Chip exists on this floor
      if ((1 << $element + 16 * $floor_chip) & $state) 
      {
        foreach my $floor_gen (0..3)
        {
          # Found matching generator
          if ((1 << $element + 8 + $floor_gen * 16) & $state)
          {
            push @pairs, [$floor_chip, $floor_gen];
            # $pairs .= "[$floor_chip,$floor_gen]";
          }
        }
      }
    }
  }
  @pairs = sort {
    if ($a->[0] == $b->[0])
    {
      $a->[1] <=> $b->[1];
    }
    else
    {
      $a->[0] <=> $b->[0];
    }
  } @pairs;

  my $str;
  foreach my $i (@pairs)
  {
    $str .= "[$i->[0],$i->[1]]";
  }
  return $str;
}

sub floor_items
{
  my ($floor, $state) = @_;
  my $chips = $state >> ($floor * 16)     & 0x7F;
  my $gens  = $state >> ($floor * 16 + 8) & 0x7F;
  return ($chips, $gens);
}

sub get_floor
{
  my $state = shift;
  my $floor = $state & $FLOORMASK;
  return 0 if $floor == $FLOOR_1;
  return 1 if $floor == $FLOOR_2;
  return 2 if $floor == $FLOOR_3;
  return 3 if $floor == $FLOOR_4;
}

# sub compare_pairs {
#   my ($a, $b) = @_;
#   for (my $i = 0; $i < @$a; ++$i)
#   {
#     return 0 unless
#     $a->[$i][0] == $b->[$i][0] and
#     $a->[$i][1] == $b->[$i][1];
#   }
# }

sub pretty
{
  my $num = shift;
  return scalar reverse((scalar reverse sprintf("%b", $num)) =~ s/(\d{8})/$1_/gr);
}

1;
