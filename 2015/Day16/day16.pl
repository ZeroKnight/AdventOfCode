#!/usr/bin/env perl

# Advent of Code Day 16
# http://adventofcode.com/day/16

use strict;
use warnings;

my %target = (
    children    => 3,
    cats        => 7,
    samoyeds    => 2,
    pomeranians => 3,
    akitas      => 0,
    vizslas     => 0,
    goldfish    => 5,
    trees       => 3,
    cars        => 2,
    perfumes    => 1
);

my %sue;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
while (<$fh>) {
    my $num = $1 if /^Sue (\d+):/;
    my %matches = /(\w+): (\d+),?/g;
    $sue{$num} = { %matches };
}
close $fh;

# Part 1
my $sender;
foreach my $n (keys %sue) {
    my $good = 1;
    foreach my $what (keys %{$sue{$n}}) {
        unless (int($sue{$n}{$what}) == int($target{$what})) {
            $good = 0;
            last;
        }
    }
    if ($good) {
        $sender = $n;
        last;
    }
}

# Part 2
my $real_sender;
foreach my $n (keys %sue) {
    my $good = 1;
    foreach my $what (keys %{$sue{$n}}) {
        if ($what eq 'cats' or $what eq 'trees') {
            unless (int($sue{$n}{$what}) > int($target{$what})) {
                $good = 0;
                last;
            }
        } elsif ($what eq 'pomeranians' or $what eq 'goldfish') {
            unless (int($sue{$n}{$what}) < int($target{$what})) {
                $good = 0;
                last;
            }
        } else {
            unless (int($sue{$n}{$what}) == int($target{$what})) {
                $good = 0;
                last;
            }
        }
    }
    if ($good) {
        $real_sender = $n;
        last;
    }
}

print "Aunt Sue #$sender sent us our gift.\n";
print "After further analysis, Aunt Sue #$real_sender actually sent us our gift.\n";

