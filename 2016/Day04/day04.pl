#!/usr/bin/env perl

# Advent of Code 2016: Day 4
# http://adventofcode.com/2016/day/4

use strict;
use warnings;

use Carp::Assert;
use List::Util qw/sum/;

my %rooms;
my $target;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";

ROOM: while (my $line = <$fh>)
{
  chomp($line);
  my %letters = ();
  my ($name, $sectorid, $checksum) = $line =~ /^([a-z-]+)-(\d+)\[(\w+)\]$/;

  foreach (split //, $name)
  {
    ++$letters{$_} unless /-/;
  }

  my @most_common = sort keys %letters;
  @most_common = (sort { $letters{$b} <=> $letters{$a} } @most_common)[0..4];
  foreach my $c (split //, $checksum)
  {
    next ROOM unless (grep { $_ eq $c } @most_common);
  }
  $rooms{$name} = $sectorid;
}

# assert(rot(343, 'qzmt-zixmtkozy-ivhz') eq 'very encrypted name') if DEBUG;
foreach my $room (keys %rooms)
{
  if (rot($rooms{$room}, $room) =~ /.*north.*pole.*object.*/)
  {
    $target = $rooms{$room};
    last;
  }
}

print "Part 1: ".(scalar keys %rooms)." valid rooms whose sector ids sum to ".sum(values %rooms)."\n";
print "Part 2: Sector ID of 'North Pole Objects' room: $target\n";

sub rot
{
  my ($shift, $str) = @_;
  my $digest;

  foreach my $c (split //, $str)
  {
    if ($c eq '-')
    {
      $c = ' ';
    }
    else
    {
      $c = chr(((ord($c) - 97 + $shift) % 26) + 97);
    }
    $digest .= $c;
  }
  return $digest;
}
