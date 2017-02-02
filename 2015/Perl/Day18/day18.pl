#!/usr/bin/env perl

# Advent of Code Day 18
# http://adventofcode.com/day/18

use strict;
use warnings;
use v5.10; # state

my @lightgrid = ();

# Initialize lightgrid
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
foreach my $row (<$fh>) {
    state $n = -1;
    chomp($row);
    $lightgrid[++$n] = [ split(//, $row =~ tr/.#/01/r) ];
}
close $fh;

# Part 2
$lightgrid[0][0]   = 1;
$lightgrid[0][99]  = 1;
$lightgrid[99][0]  = 1;
$lightgrid[99][99] = 1;

# Commence Game of...Lights
for (1..100) {
    local $| = 1;
    #print_grid();
    print "\rStep $_...";

    my @next = ();
    for (my $row = 0; $row < 100; ++$row) {
        for (my $col = 0; $col < 100; ++$col) {
            my $n = neighbors($row, $col);
            if ($lightgrid[$row][$col]) {
                # Stay on if we have exactly 2 or 3 neighbors that are on
                $next[$row][$col] = ($n == 2 || $n == 3) ? 1 : 0;
            } else {
                # Turn on if we have exactly 3 neighbors that are on
                $next[$row][$col] = ($n == 3) ? 1 : 0;
            }
        }
    }

    # Part 2
    $next[0][0] = 1;
    $next[0][99] = 1;
    $next[99][0] = 1;
    $next[99][99] = 1;

    @lightgrid = @next;
}

my $total = 0;
for (my $row = 0; $row < 100; ++$row) {
    for (my $col = 0; $col < 100; ++$col) {
        ++$total if $lightgrid[$row][$col];
    }
}
print "\nAfter 100 steps, there are $total lights lit.\n";

sub neighbors {
    my ($row, $col) = @_;
    my $n = 0;

    #                  TL    T    TR   L    R   BL   B   BR
    COORD: foreach (qw/-1;-1 0;-1 1;-1 -1;0 1;0 -1;1 0;1 1;1/) {
        my @neighbor = ( $row + (split /;/)[1], $col + (split /;/)[0] );

        # No neighbors on edges of grid
        foreach (@neighbor) {
            next COORD if $_ < 0 or $_ > 99;
        }
        ++$n if $lightgrid[$neighbor[0]][$neighbor[1]];
    }
    return $n;
}

sub print_grid {
    print "[103F";
    foreach (@lightgrid) {
        my $row = join('', @$_) =~ tr/01/.#/r;
        print "$row\n";;
    }
}
