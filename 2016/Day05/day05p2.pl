#!/usr/bin/env perl

# Advent of Code 2016: Day 5 (Part 2)
# http://adventofcode.com/2016/day/5

use strict;
use warnings;

use Digest::MD5 qw/md5_hex/;

my $input = 'ojvtpuvg';
my @password = ();
my $index;
my $found = 0;

print "\e[?25l"; # Disable cursor
print "Hacking password for door ID '$input' ... ";
while (1)
{
  local $| = 1;

  my $hash = md5_hex($input.$index++);

  my $n = 0;
  foreach (split(//, substr($hash, 5, 8)))
  {
    if (defined $password[$n])
    {
      print "\e[33m$password[$n]\e[0m";
    }
    else
    {
      print;
    }
    ++$n;
  }
  last if $found == 8;

  if ($hash =~ /^00000/)
  {
    my $pos = substr $hash, 5, 1;
    if ($pos =~ /\d/ and $pos < 8)
    {
      if (!defined($password[$pos]))
      {
        $password[$pos] = substr($hash, 6, 1);
        ++$found;
      }
    }
  }
  print "\b" x 8;
}

print " [DONE]\n";
print "\e[?25h"; # Enable cursor
