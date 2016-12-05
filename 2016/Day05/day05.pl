#!/usr/bin/env perl

# Advent of Code 2016: Day 5
# http://adventofcode.com/2016/day/5

use strict;
use warnings;

use Digest::MD5 qw/md5_hex/;

my $input = 'ojvtpuvg';
my $password = '';
my $index;

print "\e[?25l"; # Disable cursor
print "Hacking password for door ID '$input' ... ";
while (1)
{
  local $| = 1;

  my $hash = md5_hex($input.$index++);
  my $display = substr $hash, length($password), (8 - length($password));

  print "$display";
  if ($hash =~ /^00000/)
  {
    $password .= substr $hash, 5, 1;
    print "\b" x length($display) . substr($password, -1, 1);
    last if length($password) == 8;
  }
  else
  {
    print "\b" x length($display);
  }
}

print " [DONE]\n";
print "\e[?25h"; # Enable cursor
