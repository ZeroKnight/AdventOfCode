# Advent of Code 2016: Day 3
# http://adventofcode.com/2016/day/3

package Day03;

use v5.14;
use warnings;

use Advent::IO;

sub solve {
  my ($day, $part2) = @_;
  my $set = -1;
  my @valid;
  my @tris;

  foreach my $line (input($day))
  {
    $set = ++$set % 3;
    @tris[$set] = [split /\s+/, $line =~ s/^\s+//r];
    if ($set == 2)
    {
      foreach (0..2)
      {
        ++$valid[0] if isTri($tris[$_][0], $tris[$_][1], $tris[$_][2]); # Part 1
        ++$valid[1] if isTri($tris[0][$_], $tris[1][$_], $tris[2][$_]); # Part 2
      }
    }
  }
  say $part2 ? $valid[1] : $valid[0];
}

sub isTri
{
  my ($a, $b, $c) = @_;
  return 1 if ($a + $b > $c) && ($a + $c > $b) && ($b + $c > $a);
}

1;
