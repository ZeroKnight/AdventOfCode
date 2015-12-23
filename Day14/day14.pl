#!/usr/bin/env perl

# Advent of Code Day 14
# http://adventofcode.com/day/14

use strict;
use warnings;

my %reindeer;
my %score;
my @leaders;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
chomp(my @lines = <$fh>);
close $fh;

foreach (@lines) {
    my ($n, $s, $e, $r) = (/^(\w+).+?(\d+).+?(\d+).+?(\d+) seconds\.$/);
    $reindeer{$n} = {
        stat => { speed => $s, endurance => $e, rest => $r },
        stamina => $e,
        resting => 0
    };
    $score{points}{$n} = 0;
}

for (my $i = 1; $i <= 2503; ++$i) {
    foreach (keys %reindeer) {
        my $r = \$reindeer{$_};

        # Rest state
        if ($$r->{resting}) {
            if (--$$r->{resting} == 0) {
                $$r->{stamina} = $$r->{stat}{endurance};
            }
        } else { # Movement state
            $score{dist}{$_} += $$r->{stat}{speed};
            $$r->{resting} = $$r->{stat}{rest} if --$$r->{stamina} == 0;
        }
    }

    # Part 2 - Give points to leaders
    ++$score{points}{$_} foreach get_leaders('dist');
}

my $winner_p1 = (get_leaders('dist'))[0];
my $winner_p2 = (get_leaders('points'))[0];

print "The distance-winner is $winner_p1 with a score of " .
      $score{dist}{$winner_p1} . "\n";
print "The points-winner is $winner_p2 with a score of " .
      $score{points}{$winner_p2} . "\n";

sub get_leaders {
    my $category = shift;
    my @leaders;
    my $high = 0;

    foreach my $reindeer (keys %{$score{$category}}) {
        my $score = $score{$category}{$reindeer};
        if ($score > $high) {
            @leaders = ($reindeer);
            $high = $score;
        } elsif ($score == $high) {
            push @leaders, $reindeer;
        }
    }
    return @leaders;
}
