#!/usr/bin/env perl

# Advent of Code 2016: Day 16
# http://adventofcode.com/2016/day/16

use v5.14;
use warnings;

my $input = '11110010111001001';
my $p1_len = 272;
my $p2_len = 35651584;
my $checksum1 = $input;
my $checksum2 = $input;

$checksum1 = dragon($checksum1) while length($checksum1) <= $p1_len;
say 'Part 1 Checksum: '.checksum(substr $checksum1, 0, $p1_len);

$checksum2 = dragon($checksum2) while length($checksum2) <= $p2_len;
say 'Part 2 Checksum: '.checksum(substr $checksum2, 0, $p2_len);

sub dragon
{
  my $a = shift;
  my $b = (scalar reverse $a) =~ tr/01/10/r;
  return "${a}0$b";
}

sub checksum
{
  my $input = shift;
  my $digest;
  do
  {
    $digest .= substr($input, 0, 2, '') =~ /(?:00|11)/ ? 1 : 0;
  } while (length $input);
  unless (length($digest) % 2)
  {
    return checksum($digest);
  }
  else { return $digest }
}

