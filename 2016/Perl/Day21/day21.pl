#!/usr/bin/env perl

# Advent of Code 2016: Day 21
# http://adventofcode.com/2016/day/21

use v5.14;
use warnings;

my $p1 = 'abcdefgh';
my $p2 = 'fbgdceah';
my @instructions = (<>);

# Part 1
foreach (@instructions)
{
  chomp;
  if (/^move position (\d+) to position (\d+)$/)
  {
    my $c = substr($p1, $1, 1, '');
    substr($p1, $2, 0, $c);
  }
  elsif (/^reverse positions (\d+) through (\d+)$/)
  {
    my $str = substr($p1, $1, $2 - $1 + 1);
    $p1 =~ s/$str/reverse $str/e;
  }
  elsif (/^rotate (left|right|based on position of letter) (?:(\d+)|(\w))/)
  {
    my $shift = $2;
    if ($3)
    {
      $shift = index($p1, $3) + 1;
      ++$shift if index($p1, $3) >= 4;
    }
    my $dir = $1 =~ /based/ ? 'right' : $1;
    rotate($p1, $shift, $dir);
  }
  elsif (/^swap (letter|position) (\w+) with \1 (\w+)$/)
  {
    if ($1 eq 'letter')
    {
      eval "\$p1 =~ tr/$2$3/$3$2/";
    }
    else
    {
      my @chars = split //, $p1;
      @chars[$2,$3] = @chars[$3,$2];
      $p1 = join '', @chars;
    }
  }
}

# Part 2
foreach (reverse @instructions)
{
  if (/^move position (\d+) to position (\d+)$/)
  {
    my $c = substr($p2, $2, 1, '');
    substr($p2, $1, 0, $c);
  }
  elsif (/^reverse positions (\d+) through (\d+)$/)
  {
    my $str = substr($p2, $1, $2 - $1 + 1);
    $p2 =~ s/$str/reverse $str/e;
  }
  elsif (/^rotate (left|right|based on position of letter) (?:(\d+)|(\w))/)
  {
    my $shift = $2;
    if ($3)
    {
      my $index = index($p2, $3) || 8;
      $shift = ($index + ($index % 2 ? 1 : 10)) / 2;
    }
    my $dir = $1 =~ /based/ ? 'left' : $1 eq 'right' ? 'left' : 'right';
    rotate($p2, $shift, $dir);
  }
  elsif (/^swap (letter|position) (\w+) with \1 (\w+)$/)
  {
    if ($1 eq 'letter')
    {
      eval "\$p2 =~ tr/$2$3/$3$2/";
    }
    else
    {
      my @chars = split //, $p2;
      @chars[$2,$3] = @chars[$3,$2];
      $p2 = join '', @chars;
    }
  }
}

say "Part 1: $p1";
say "Part 2: $p2";

sub rotate
{
  my ($str, $n, $dir) = (\shift, @_);
  return if $n == length $str;
  $dir //= 'right';
  my @result = split //, $$str;
  for (my $i = 0; $i < @result; ++$i)
  {
    my $shift = $dir eq 'left' ? $i + $n : $i - $n;
    $result[$i] = substr $$str, $shift % length($$str), 1;
  }
  $$str = join '', @result;
}

