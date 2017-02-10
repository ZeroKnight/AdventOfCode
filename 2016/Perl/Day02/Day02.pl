# Advent of Code 2016: Day 2
# http://adventofcode.com/2016/day/2

package Day02;

use v5.14;
use warnings;

use Advent::IO;

# 1 2 3
# 4 5 6
# 7 8 9

my %fsm = (
  1 => { U => 1, R => 2, D => 4, L => 1 },
  2 => { U => 2, R => 3, D => 5, L => 1 },
  3 => { U => 3, R => 3, D => 6, L => 2 },
  4 => { U => 1, R => 5, D => 7, L => 4 },
  5 => { U => 2, R => 6, D => 8, L => 4 },
  6 => { U => 3, R => 6, D => 9, L => 5 },
  7 => { U => 4, R => 8, D => 7, L => 7 },
  8 => { U => 5, R => 9, D => 8, L => 7 },
  9 => { U => 6, R => 9, D => 9, L => 8 },
);

#     1
#   2 3 4
# 5 6 7 8 9
#   A B C
#     D

my %fsm2 = (
  1 => { U => 1,   R => 1,   D => 3,   L => 1 },
  2 => { U => 1,   R => 3,   D => 6,   L => 2 },
  3 => { U => 1,   R => 4,   D => 7,   L => 2 },
  4 => { U => 4,   R => 4,   D => 8,   L => 3 },
  5 => { U => 5,   R => 6,   D => 5,   L => 5 },
  6 => { U => 2,   R => 7,   D => 'A', L => 5 },
  7 => { U => 3,   R => 8,   D => 'B', L => 6 },
  8 => { U => 4,   R => 9,   D => 'C', L => 7 },
  9 => { U => 9,   R => 9,   D => 9,   L => 8 },
  A => { U => 6,   R => 'B', D => 'A', L => 'A' },
  B => { U => 7,   R => 'C', D => 'D', L => 'A' },
  C => { U => 8,   R => 'C', D => 'C', L => 'B' },
  D => { U => 'B', R => 'D', D => 'D', L => 'D' }
);


sub solve
{
  my ($day, $part2) = @_;
  my @code;
  my @state = (5, 5);
  foreach my $line (input($day))
  {
    foreach my $step (split //, $line)
    {
      $state[0] = $fsm{$state[0]}{$step};
      $state[1] = $fsm2{$state[1]}{$step};
    }
    $code[0] .= $state[0];
    $code[1] .= $state[1];
  }
  say $part2 ? $code[1] : $code[0];
}

1;
