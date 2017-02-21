# Advent of Code 2016: Day 10
# http://adventofcode.com/2016/day/10

package Day10;

use v5.14;
use warnings;

use Advent::IO;
use List::Util qw(product);

my %carriers;

sub solve
{
  my ($day, $part2) = @_;
  my @instructions;
  %carriers = ();

  # Initialize Bot states
  foreach (input($day))
  {
    if (/^value (\d+) goes to bot (\d+)$/)
    {
      if (!exists $carriers{bot}{$2})
      {
        $carriers{bot}{$2} = [$1];
      }
      else
      {
        $carriers{bot}{$2}[1] = $1;
      }
    }
    elsif (/gives/)
    {
      push @instructions, $_;
    }
  }

  # Get to work!
  while (@instructions)
  {
    my ($index, $step) = each @instructions;
    next unless defined $index; # Reached end of array; loop again

    $step =~ /^bot (\d+).*?(bot|output) (\d+).*?(bot|output) (\d+)$/;
    my $from = $carriers{bot}{$1};

    # Bot should only proceed if it has 2 chips
    if (defined $from and @$from == 2)
    {
      @$from = sort { $a <=> $b } @$from;
      unless ($part2)
      {
        if ($from->[0] == 17 and $from->[1] == 61)
        {
          say $1;
          return;
        }
      }

      # Hand off the chips
      next unless give(shift @$from, $2, $3);
      next unless give(shift @$from, $4, $5);

      # Remove this completed instruction
      splice @instructions, $index, 1;
    }
  }
  say product @{$carriers{output}}[0..2];
}

sub give
{
  my ($chip, $type, $to) = @_;
  if ($type eq 'bot')
  {
    $carriers{bot}{$to} = [] unless exists $carriers{bot}{$to};
    my $sz = @{ $carriers{bot}{$to} };
    return 0 if $sz >= 2;
    $carriers{bot}{$to}[$sz ? 1 : 0] = $chip;
  }
  elsif ($type eq 'output')
  {
    $carriers{output}[$to] = $chip;
  }
  return 1;
}

1;
