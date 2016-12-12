#!/usr/bin/env perl

# Advent of Code 2016: Day 8
# http://adventofcode.com/2016/day/8

use strict;
use warnings;

my ($lcd_w, $lcd_h) = (50, 6);
my $px_on = "\e[32m█\e[0m";
my $px_off = ' ';
my @lcd_blank = (
  [ ($px_off) x $lcd_w ],
  [ ($px_off) x $lcd_w ],
  [ ($px_off) x $lcd_w ],
  [ ($px_off) x $lcd_w ],
  [ ($px_off) x $lcd_w ],
  [ ($px_off) x $lcd_w ]
);
my @lcd = map { [@$_] } @lcd_blank;

while (<>)
{
  chomp;
  if (/^rect/)
  {
    my ($w, $h) = /(\d+)x(\d+)/;
    rect($w, $h);
  }
  elsif (/^rotate/)
  {
    if (/row/)
    {
      my ($r, $n) = /y=(\d+) by (\d+)$/;
      rotate('row', $r, $n);
    }
    elsif (/column/)
    {
      my ($c, $n) = /x=(\d+) by (\d+)$/;
      rotate('column', $c, $n);
    }
  }
  draw_lcd();
}

print "There are ".pixel_count()." pixels lit\n";

sub rect
{
  my ($width, $height) = @_;
  for (my $i = 0; $i < $height; ++$i)
  {
    for (my $j = 0; $j < $width; ++$j)
    {
      $lcd[$i][$j] = $px_on;
    }
  }
}

sub rotate
{
  my ($axis, $num, $amt) = @_;
  my @update = map { [@$_] } @lcd_blank;
  if ($axis eq 'row')
  {
    for (my $i = 0; $i < $lcd_w; ++$i)
    {
      if ($lcd[$num][$i] eq $px_on)
      {
        $update[$num][($i + $amt) % $lcd_w] = $px_on;
      }
    }
    @{$lcd[$num]} = map { $_ } @{$update[$num]};
  }
  elsif ($axis eq 'column')
  {
    for (my $i = 0; $i < $lcd_h; ++$i)
    {
      if ($lcd[$i][$num] eq $px_on)
      {
        $update[($i + $amt) % $lcd_h][$num] = $px_on;
      }
    }
    for (my $i = 0; $i < $lcd_h; ++$i)
    {
      $lcd[$i][$num] = $update[$i][$num];
    }
  }
}

sub pixel_count
{
  my $count = 0;
  for (my $i = 0; $i < $lcd_h; ++$i)
  {
    for (my $j = 0; $j < $lcd_w; ++$j)
    {
      ++$count if $lcd[$i][$j] eq $px_on;
    }
  }
  return $count;
}

sub draw_lcd
{
  use feature 'say';
  local $" = '';

  # Clear screen
  print "\033[2J";
  print "\033[0;0H";

  # Draw
  say '┏' . '━' x ($lcd_w+3) . '┓';
  say '┃' . ' ' x ($lcd_w+3) . '┃';
  say "┃  @{$_} ┃" foreach (@lcd);
  say '┃' . ' ' x ($lcd_w+3) . '┃';
  say '┗' . '━' x ($lcd_w+3) . '┛';

  # Wait
  select(undef, undef, undef, 0.05);
}
