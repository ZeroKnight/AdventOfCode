# Advent of Code 2016: Day 1
# http://adventofcode.com/2016/day/1

package Day01;

use v5.14;
use warnings;

use Advent::IO;
use Advent::Util qw(manhattan);

sub solve
{
  my ($day, $part2) = @_;

  my $heading = 0;
  my %dirmap = ( 0 => [0, 1], 1 => [1, 0], 2 => [0, -1], 3 => [-1, 0] );
  my %seen;
  my ($x, $y) = (0, 0);

  STEP: foreach my $step (input($day, ', '))
  {
    my $dir   = substr($step, 0, 1);
    my $count = substr($step, 1);
    $heading  = ($dir eq 'R' ? $heading+1 : $heading-1) % 4;
    if ($part2)
    {
      foreach (1..$count)
      {
        $x += $dirmap{$heading}[0];
        $y += $dirmap{$heading}[1];
        last STEP if ($seen{"$x,$y"}++)
      }
    }
    else
    {
      $x += ($dirmap{$heading}[0] * $count);
      $y += ($dirmap{$heading}[1] * $count);
    }
  }
  say manhattan([0,0], [$x,$y]), " ($x, $y)";
}

1;
