#!/usr/bin/env perl

# Advent of Code Day 21
# http://adventofcode.com/day/21

use strict;
use warnings;
use Storable qw/dclone/;

my %wins;
my %losses;
my %shop = (
    Weapon => {
        Dagger     => { Cost => 8,  Damage => 4, Armor => 0 },
        Shortsword => { Cost => 10, Damage => 5, Armor => 0 },
        Warhammer  => { Cost => 25, Damage => 6, Armor => 0 },
        Longsword  => { Cost => 40, Damage => 7, Armor => 0 },
        Greataxe   => { Cost => 74, Damage => 8, Armor => 0 },
    },
    Armor => {
        Leather    => { Cost => 13,  Damage => 0, Armor => 1 },
        Chainmail  => { Cost => 31,  Damage => 0, Armor => 2 },
        Splintmail => { Cost => 53,  Damage => 0, Armor => 3 },
        Bandedmail => { Cost => 75,  Damage => 0, Armor => 4 },
        Platemail  => { Cost => 102, Damage => 0, Armor => 5 },
        Tunic      => { Cost => 0,   Damage => 0, Armor => 0 }, # no armor
    },
    Ring => {
        Damage1  => { Cost => 25,  Damage => 1, Armor => 0 },
        Damage2  => { Cost => 50,  Damage => 2, Armor => 0 },
        Damage3  => { Cost => 100, Damage => 3, Armor => 0 },
        Defense1 => { Cost => 20,  Damage => 0, Armor => 1 },
        Defense2 => { Cost => 40,  Damage => 0, Armor => 2 },
        Defense3 => { Cost => 80,  Damage => 0, Armor => 3 },
        Ordinary => { Cost => 0,   Damage => 0, Armor => 0 }, # no ring
    },
);

my %boss = ( hp => 100, atk => 8, def => 2 );
my %player = (
    hp     => 100,
    Weapon => undef,
    Armor  => undef,
    Ring   => [ undef, undef ],
);

foreach my $w (keys %{ $shop{Weapon} }) {
    foreach my $a (keys %{ $shop{Armor} }) {
        foreach my $r (keys %{ $shop{Ring} }) {
            foreach my $r2 (keys %{ $shop{Ring} }) {
                next if $r ne 'Ordinary' and $r eq $r2;
                $player{Weapon} = dclone($shop{Weapon}{$w});
                $player{Armor}  = dclone($shop{Armor}{$a});
                $player{Ring}   = [
                    dclone($shop{Ring}{$r}), dclone($shop{Ring}{$r2})
                ];
                $player{Weapon}{Name} = $w;
                $player{Armor}{Name} = $a;
                $player{Ring}[0]{Name} = $r;
                $player{Ring}[1]{Name} = $r2;

                my @result = fight();
                if ($result[0]) {
                    $wins{$result[1]} = [ $w, $a, $r, $r2 eq 'Ordinary' ? '' : $r2 ];
                } else {
                    $losses{$result[1]} = [ $w, $a, $r, $r2 eq 'Ordinary' ? '' : $r2 ];
                }
            }
        }
    }
}

my $cheapest_cost = (sort { $a <=> $b } keys %wins)[0];
my $costliest_cost = (sort { $b <=> $a } keys %losses)[0];
my @cheapest_gear = @{ $wins{$cheapest_cost} };
my @costliest_gear = @{ $losses{$costliest_cost} };
print "The player can spend as little as $cheapest_cost gold and win.\nGear: @cheapest_gear\n";
print "\nThe player can spend as much as $costliest_cost gold and lose.\nGear: @costliest_gear\n";

sub fight {
    my ($atk, $def, $cost) = qw/0 0 0/;
    my $winner;
    foreach (keys %player) {
        next if $_ eq 'hp';
        if ($_ eq 'Ring') {
            foreach my $r (@{ $player{Ring} }) {
                $atk  += $r->{Damage};
                $def  += $r->{Armor};
                $cost += $r->{Cost};
            }
            next;
        }
        $atk  += $player{$_}{Damage};
        $def  += $player{$_}{Armor};
        $cost += $player{$_}{Cost};
    }

    my $pHP = $player{hp};
    my $bHP = $boss{hp};

    # Fight the boss
    while (1) {

        # Player goes first
        $bHP -= max(1, $atk - $boss{def});
        if ($bHP <= 0) {
            $winner = 1;
            last;
        }

        # Boss retaliates
        $pHP -= max(1, $boss{atk} - $def);
        if ($pHP <= 0) {
            $winner = 0;
            last;
        }
    }
    return ($winner, $cost);
}

sub max { return $_[ $_[0] > $_[1] ? 0 : 1 ] }
