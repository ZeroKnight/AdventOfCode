# Advent of Code 2016: Day 11
# http://adventofcode.com/2016/day/11

package Day11;

use v5.14;
use warnings;

use Advent::IO;
use Clone 'clone';
use Array::Heap::PriorityQueue::Numeric;

my %state;
my %goal;
my %ztable;

sub solve
{
  my ($day, $part2) = @_;
  %state = (
    elevator => 0,
    floors => [
      $part2 ? [qw/TmG TmM PuG SrG ElG ElM DiG DiM/] : [qw/TmG TmM PuG SrG/],
      [qw/PuM SrM/],
      [qw/PmG PmM RuG RuM/],
      [],
    ],
    pairs => {
      Tm => [0,0], Pu => [0,1], Sr => [0,1], Pm => [2,2], Ru => [2,2],
    }
  );
  %goal = (
    elevator => 3,
    pairs => {
      Tm => [3,3], Pu => [3,3], Sr => [3,3], Pm => [3,3], Ru => [3,3],
      $part2 ? (El => [3,3], Di => [3,3]) : ()
    }
  );

  # Initialize a Zobrist Hash Table
  $ztable{elevator}[$_] = int(rand(2**64)) foreach (0..3);
  foreach my $elem (qw/Tm Pu Sr Pm Ru El Di/)
  {
    foreach my $chip (0..3)
    {
      foreach my $gen ($chip..3)
      {
        $ztable{pair}{"$elem:$chip,$gen"} = int(rand(2**64));
      }
    }
  }
  say A_star(\%state, zhash(\%goal));
}

sub zhash
{
  my $h = $ztable{elevator}[$_[0]->{elevator}];
  while (my ($elem, $pair) = each %{$_[0]->{pairs}})
  {
    my ($chip, $gen) = ($pair->[0], $pair->[1]);
    $h ^= $ztable{pair}{"$elem:$chip,$gen"};
  }
  return $h;
}

sub A_star
{
  my $goal = pop;
  my $frontier = Array::Heap::PriorityQueue::Numeric->new();
  $frontier->add($_[0], 0);
  my %cost_so_far = (zhash($_[0]) => 0);
  my @closed_set;

  while ($frontier->size)
  {
    my $current = $frontier->get;
    my $current_hash = zhash($current);
    if ($current_hash == $goal)
    {
      return $cost_so_far{$goal};
    }
    push @closed_set, $current_hash;

    my $floor = $current->{elevator};
    foreach my $move (combinations(@{$current->{floors}[$floor]}))
    {
      foreach my $dir (1, -1)
      {
        # Initialize state of next move
        my $new_floor = $floor + $dir;
        next unless 0 <= $new_floor && $new_floor <= 3;
        my $next = move_if_valid($move, $new_floor, $current);
        next unless defined $next;

        # Don't revisit an evaluated state
        my $next_hash = zhash($next);
        next if grep { $_ eq $next_hash } @closed_set;

        my $new_cost = $cost_so_far{$current_hash} + 1;
        if (!exists($cost_so_far{$next_hash}) or
            $new_cost < $cost_so_far{$next_hash})
        {
          $cost_so_far{$next_hash} = $new_cost;
          my $priority = $new_cost - heuristic($next, $dir, ref($move) ? 2 : 1);
          $frontier->add($next, $priority);
        }
      }
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

sub move_if_valid
{
  my @moving = ref $_[0] ? @{$_[0]} : ($_[0]);
  my $dest_floor = $_[1];
  my $current_floor = $_[2]->{elevator};
  my @current_pending = @{$_[2]->{floors}[$current_floor]};

  # First, make sure we're leaving the current floor in a valid state
  foreach my $item (@moving)
  {
    @current_pending = grep { $_ ne $item } @current_pending;
  }
  return undef unless valid_state(@current_pending);

  # Now see if our intended move is valid
  my @dest_pending = (@moving, @{$_[2]->{floors}[$dest_floor]});
  return undef unless valid_state(@dest_pending);

  # Make the move
  my $new;
  $new->{elevator}               = $dest_floor;
  $new->{floors}                 = clone($_[2]->{floors});
  $new->{floors}[$current_floor] = [@current_pending];
  $new->{floors}[$dest_floor]    = [@dest_pending];
  $new->{pairs}                  = get_pairs($new->{floors});

  return $new;
}


sub valid_state
{
  my $state = join ' ', @_;

  # No generators? No problem.
  return 1 if $state !~ /G\b/;

  # There is a generator on this floor; any chips on this floor MUST be paired
  # with a generator to be valid
  foreach my $chip ($state =~ /\b\w{2}M\b/g)
  {
    my $e = substr($chip, 0, 2);
    return 0 unless $state =~ /\b${e}G\b/;
  }
  return 1;
}

sub get_pairs
{
  my $pairs = {};
  for (my $floor = 0; $floor < 4; ++$floor)
  {
    foreach my $item (@{$_[0][$floor]})
    {
      my $e = substr $item, 0, -1;
      $pairs->{$e} = [] unless exists $pairs->{$e};
      push @{$pairs->{$e}}, $floor;
    }
  }
  return $pairs;
}

sub combinations
{
  my @p = @_;
  foreach my $n (0..$#_-1)
  {
    for (my $i = $n+1; $i < @_; ++$i)
    {
      push @p, [ $_[$n], $_[$i] ];
    }
  }
  return @p;
}

1;
