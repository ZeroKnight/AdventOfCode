#!/usr/bin/env perl

# Advent of Code Day 15
# http://adventofcode.com/day/15

use strict;
use warnings;
use v5.14; # smartmatch

my %ingredients;
my %teaspoons;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
while (<$fh>) {
    my ($n) = /^(\w+):/;
    my ($c, $d, $f, $t, $a) = /(-?\d+)/g;
    $ingredients{$n} = {
        capacity   => $c,
        durability => $d,
        flavor     => $f,
        texture    => $t,
        calories   => $a
    }
}
close $fh;

my $best_score = 0;
my @best_ingredients;
my $cal_score = 0;
my @cal_ingredients;
for (my $i = 0; $i < 100; ++$i) {
    for (my $j = 0; $j < 100 - $i; ++$j) {
        for (my $k = 0; $k < 100 - $i - $j; ++$k) {
            my $h = 100 - $i - $j - $k;
            my ($c, $d, $f, $t, $a);
            $c += $i * $ingredients{Frosting}{capacity};
            $c += $j * $ingredients{Candy}{capacity};
            $c += $k * $ingredients{Butterscotch}{capacity};
            $c += $h * $ingredients{Sugar}{capacity};

            $d += $i * $ingredients{Frosting}{durability};
            $d += $j * $ingredients{Candy}{durability};
            $d += $k * $ingredients{Butterscotch}{durability};
            $d += $h * $ingredients{Sugar}{durability};

            $f += $i * $ingredients{Frosting}{flavor};
            $f += $j * $ingredients{Candy}{flavor};
            $f += $k * $ingredients{Butterscotch}{flavor};
            $f += $h * $ingredients{Sugar}{flavor};

            $t += $i * $ingredients{Frosting}{texture};
            $t += $j * $ingredients{Candy}{texture};
            $t += $k * $ingredients{Butterscotch}{texture};
            $t += $h * $ingredients{Sugar}{texture};

            $a += $i * $ingredients{Frosting}{calories};
            $a += $j * $ingredients{Candy}{calories};
            $a += $k * $ingredients{Butterscotch}{calories};
            $a += $h * $ingredients{Sugar}{calories};

            if ($c <= 0 || $d <= 0 || $f <= 0 || $t <= 0) {
                next;
            }
            my $score = $c * $d * $f * $t;
            if ($score > $best_score) {
                $best_score = $score;
                $teaspoons{best} = {
                    Frosting     => $i,
                    Candy        => $j,
                    Butterscotch => $k,
                    Sugar        => $h
                }
            }
            if ($a == 500) {
                if ($score > $cal_score) {
                    $cal_score = $score;
                    $teaspoons{cal} = {
                        Frosting     => $i,
                        Candy        => $j,
                        Butterscotch => $k,
                        Sugar        => $h
                    }
                }
            }
        }
    }
}

print "The best cookie has a score of $best_score, and consists of:\n";
while (my ($k, $v) = each %{$teaspoons{best}}) {
    print "${v}tsp $k\n"
}

print "\n";

print "The best 500-calorie cookie has a score of $cal_score, and consists of:\n";
while (my ($k, $v) = each %{$teaspoons{cal}}) {
    print "${v}tsp $k\n"
}

