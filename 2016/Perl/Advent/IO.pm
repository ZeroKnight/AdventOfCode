# This module is part of Alex "ZeroKnight" George's Advent of Code Solutions
# written in Perl. Check out http://adventofcode.com for what this is about!
#
# IO: Functions for common I/O patterns

package Advent::IO;

use v5.14;
use warnings;

our $VERSION = "0.001";
$VERSION = eval $VERSION;

use Exporter qw(import);
our @EXPORT    = qw(input);
our @EXPORT_OK = qw(input_fh);

use Carp;

# TODO: use Path::Tiny for input functions

# Open input file and slurp into a scalar or array. If $pattern is given,
# split() the list before returning it; useful for some single-line inputs.
sub input
{
  my ($day, $pattern) = @_;
  my $if = "../inputs/$day.txt";
  open my $fh, '<', $if or croak "Can't open input file '$if' for $day: '$!'";
  if (wantarray)
  {
    if (defined $pattern)
    {
      local $/;
      return split /$pattern/, <$fh>;
    }
    chomp(my @lines = <$fh>);
    return @lines;
  }
  else
  {
    local $/;
    return <$fh>;
  }
}

# Open input and return file handle
sub input_fh
{
  my $day = shift;
  my $if = "../inputs/$day.txt";
  open my $fh, '<', $if or croak "Can't open input file for $day: $if";
  return $fh;
}

1;
