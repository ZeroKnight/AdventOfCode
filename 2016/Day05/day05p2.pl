#!/usr/bin/env perl

# Advent of Code 2016: Day 5 (Part 2)
# http://adventofcode.com/2016/day/5

use strict;
use warnings;

use Digest::MD5 qw/md5_hex/;

my $input = 'ojvtpuvg';
my @password = ();
my $index;

print "\e[?25l"; # Disable cursor
print "Hacking password for door ID '$input' ... ";
while (scalar @password < 8)
{
  local $| = 1;

  my $hash = md5_hex($input.$index++);
  # my $display = substr $hash, length($password), (8 - length($password));
  # print "$display";

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

  if ($hash =~ /^00000/)
  {
    my $pos = substr $hash, 5, 1;
    if ($pos =~ /\d/ and $pos < 8)
    {
      $password[$pos] = substr $hash, 6, 1 unless defined $password[$pos];
    }
  }
  print "\b" x 8;
}

print " [DONE]\n";
print "\e[?25h"; # Enable cursor
