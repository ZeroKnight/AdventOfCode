# Advent of Code 2016: Day 4
# http://adventofcode.com/2016/day/4

package Day04;

use v5.14;
use warnings;

use Advent::IO;
use List::Util qw/any sum/;

sub solve
{
  my ($day, $part2) = @_;
  my %real_rooms;
  my $target;

  ROOM: foreach my $line (input($day))
  {
    my %letters;
    my ($name, $sectorid, $checksum) = $line =~ /^([a-z-]+)-(\d+)\[(\w+)\]$/;
    foreach (split //, $name)
    {
      ++$letters{$_} unless /-/;
    }
    my @most_common = (sort { $letters{$b} <=> $letters{$a} }
                       sort keys %letters)[0..4];
    foreach my $c (split //, $checksum)
    {
      next ROOM unless any { $_ eq $c } @most_common;
    }
    $real_rooms{$name} = $sectorid;
  }

  if ($part2)
  {
    foreach my $room (keys %real_rooms)
    {
      if (rot($real_rooms{$room}, $room) =~ /.*north.*pole.*object.*/)
      {
        say $real_rooms{$room};
      }
    }
  }
  else
  {
    say sum(values %real_rooms);
  }
}

sub rot
{
  my ($shift, $str) = @_;
  my $digest;

  foreach my $c (split //, $str)
  {
    $digest .= $c eq '-' ? ' ' : chr(((ord($c) - 97 + $shift) % 26) + 97);
  }
  return $digest;
}

1;
