#!/usr/bin/env perl

# Advent of Code Day 12
# http://adventofcode.com/day/12

use strict;
use warnings;

use JSON::Tiny qw/decode_json/;

my $bytes = do { local $/; open my $fh, '<', './input'; <$fh> };
my $json = decode_json($bytes);

print "The sum of all numbers in the JSON document is " . sum_json($json) . "\n";

sub sum_json {
    my $elem = shift;
    my $sum = 0;

    if (ref $elem eq 'HASH') {
        return 0 if grep /red/, values %$elem;
        $sum += sum_json($_) foreach values %$elem;
        return $sum;
    } elsif (ref $elem eq 'ARRAY') {
        $sum += sum_json($_) foreach (@$elem);
        return $sum;
    } else {
        no warnings 'numeric';
        return $elem =~ /^-?\d+$/ ? $elem : 0;
    }
}

