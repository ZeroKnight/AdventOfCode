# This module is part of Alex "ZeroKnight" George's Advent of Code Solutions
# written in Perl. Check out http://adventofcode.com for what this is about!
#
# Util: Various utility functions

package Advent::Util;

use v5.14;
use warnings;

our $VERSION = "0.001";
$VERSION = eval $VERSION;

use Exporter qw(import);
our @EXPORT    = qw();
our @EXPORT_OK = qw(manhattan);

use Carp;

# Return rectilinear (Manhattan) distance between two points, given as arrayrefs
sub manhattan
{
  my ($p1, $p2) = @_;
  unless (ref $p1 eq 'ARRAY' and ref $p2 eq 'ARRAY')
  {
    croak "Type of arguments to manhattan() must be arrayref";
  }
  return abs($p1->[0] - $p2->[0]) + abs($p1->[1] - $p2->[1]);
}

1;
