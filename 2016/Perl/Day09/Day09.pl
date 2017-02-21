# Advent of Code 2016: Day 9
# http://adventofcode.com/2016/day/9

package Day09;

use v5.14;
use warnings;

use Advent::IO;

my $data;
my $dlength;

sub solve
{
  my ($day, $part2) = @_;
  $dlength = 0;
  $data = input($day);

  if ($part2)
  {
    $dlength += rexpand($data);
  }
  else
  {
    for (my $i = 0; $i < length $data; ++$i)
    {
      my $c = substr $data, $i, 1;
      if ($c eq '(')
      {
        $i = expand_at($i);
      }
      else { ++$dlength }
    }
  }
  say $dlength;
}

sub expand_at
{
  my $start = shift;
  my $end = index($data, ')', $start);
  my ($nchars, $repeat) = substr($data, $start+1, $end-$start-1) =~ /(\d+)x(\d+)/;
  my $str = substr($data, $end+1, $nchars);
  my $expanded = $str x $repeat;

  $dlength += length $expanded;
  return $end + $nchars;
}

sub rexpand
{
  my $compressed = shift;
  my $len = 0;
  while ($compressed =~ s/^(.*?) \( (\d+)x(\d+) \)//x)
  {
    my $repeat = $3;
    $len += (length $1) + rexpand(substr($compressed, 0, $2, '')) * $repeat;
  }
  return $len + length $compressed;
}

1;
