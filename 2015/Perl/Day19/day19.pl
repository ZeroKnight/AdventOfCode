#!/usr/bin/env perl

# Advent of Code Day 19
# http://adventofcode.com/day/19

use strict;
use warnings;

my @medicine;
my %conversions;
my %transformations;
open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
foreach my $line (<$fh>) {
    next unless chomp $line;
    if ($line =~ /(\w+) => (\w+)/) {
        push @{ $conversions{$1} }, $2;
    } else {
        @medicine = $line =~ /[A-Z][a-z]?/g;
    }
}
close $fh;

# Part 1
for (my $i = 0; $i < @medicine; ++$i) {
    my $mol = $medicine[$i];
    foreach my $conv (@{ $conversions{$mol} }) {
        my @xform = @medicine;
        $xform[$i] = $conv;
        ++$transformations{join('', @xform)};
    }
}

# Part 2
# https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/cy4etju
my ($RnAr, $Y);
foreach my $mol (@medicine) {
    ++$RnAr if $mol =~ /Rn|Ar/;
    ++$Y    if $mol eq 'Y';
}
my $p2 = @medicine - $RnAr - 2*$Y - 1;


print 'There are ' . (scalar keys %transformations) . " molecules that can be synthesized\n";
print "The medicine can be synthesized in $p2 steps.\n";

