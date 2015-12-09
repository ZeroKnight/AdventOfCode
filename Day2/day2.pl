#!/usr/bin/env perl

# Advent of Code Day 2
# http://adventofcode.com/day/2

use strict;
use warnings;

my $total_paper;
my $total_ribbon;
my @manifest;
open my $fh, '<', './input' or die "$0: can't open input for reading: $!";
while (<$fh>) {
    chomp;
    push @manifest, $_;
}

foreach my $present (@manifest) {
    $total_paper += area_paper(split /x/, $present);
    $total_ribbon += area_ribbon(split /x/, $present);
}

print "The elves will need to order exactly $total_paper square feet of " .
      "wrapping paper and $total_ribbon feet of ribbon to wrap all " .
      scalar(@manifest) . " presents.\n";

sub area_paper {
    my ($l, $w, $h) = @_;

    # Sort our dimensions
    my @dimensions = sort { $a <=> $b } @_;

    # Get the exact surface area minus the slack
    my $box_area = 2*$l*$w + 2*$w*$h + 2*$h*$l;

    # Find our smallest side's area
    my $small_area = $dimensions[0] * $dimensions[1];

    return $box_area + $small_area;
}

sub area_ribbon {
    my ($l, $w, $h) = @_;

    # Sort our dimensions
    my @dimensions = sort { $a <=> $b } @_;

    # Find length of the wrap
    my $wrap_length = $dimensions[0]*2 + $dimensions[1]*2;

    # Find length of the bow
    my $bow_length = $l*$w*$h;

    return $wrap_length + $bow_length;
}

