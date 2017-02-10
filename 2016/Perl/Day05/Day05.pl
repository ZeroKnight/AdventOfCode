# Advent of Code 2016: Day 5
# http://adventofcode.com/2016/day/5

package Day05;

use v5.14;
use warnings;

use Advent::IO;
use Digest::MD5 qw/md5_hex/;

sub solve
{
  my ($day, $part2) = @_;
  my @password = ();
  my $input = input($day);
  my $index = 0;
  my $found = 0;

  while ($found < 8)
  {
    my $hash = md5_hex($input.$index++);
    if ($part2)
    {
      if ($hash =~ /^00000([0-7])(\S)/)
      {
        unless (defined $password[$1])
        {
          $password[$1] = $2;
          ++$found;
        }
      }
    }
    else
    {
      if ($hash =~ /^00000(\S)/)
      {
        push @password, $1;
        ++$found;
      }
    }
  }
  say @password;
}

1;
