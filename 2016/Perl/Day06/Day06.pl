# Advent of Code 2016: Day 6
# http://adventofcode.com/2016/day/6

package Day06;

use v5.14;
use warnings;

use Advent::IO;

sub solve
{
  my ($day, $part2) = @_;
  my %columns;
  my $message;
  foreach my $line (input($day))
  {
    my $n = 0;
    ++$columns{$n++}{$_} foreach (split //, $line);
  }
  foreach (0..(scalar keys %columns) - 1)
  {
    if ($part2)
    {
      $message .= (sort { $columns{$_}{$a} <=> $columns{$_}{$b} }
                   keys %{$columns{$_}})[0];
    }
    else
    {
      $message .= (sort { $columns{$_}{$b} <=> $columns{$_}{$a} }
                   keys %{$columns{$_}})[0];
    }
  }
  say $message;
}

1;
