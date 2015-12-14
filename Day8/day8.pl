#!/usr/bin/env perl

# Advent of Code Day 8
# http://adventofcode.com/day/8

use strict;
use warnings;

my $total_litchars;
my $total_memchars;
my $total_encchars;

open my $fh, '<', './input' or die "$0: can't open './input' for reading: $!";
chomp(my @list = <$fh>);
close $fh;

# Part 1
foreach my $string (@list) {
    $total_litchars += length $string;
    my @chars = split //, $string;
    for (my $c = 1; $c < (length $string) - 1; ++$c) {
        local $_ = $chars[$c];
        if (/\\/) {
            # Peek at escaped char
            if ($chars[$c + 1] eq 'x') {
                $c += 3;
            } else {
                ++$c;
            }
        }
        ++$total_memchars;
    }
}

# Part 2
foreach my $string (@list) {
    my @chars = split //, $string;
    my @encoded = ('"');

    for (my $c = 0; $c < length $string; ++$c) {
        local $_ = $chars[$c];
        if (/"/) {
            push @encoded, '\"';
        } elsif (/\\/) {
            push @encoded, '\\\\';
        } else {
            push @encoded, $_;
        }
    }
    push @encoded, '"';
    $total_encchars += length join '', @encoded;
}

print "The difference of literal chars and in-memory chars for the file is " .
      ($total_litchars - $total_memchars) . "\n";
print "The difference of literal chars and encoded chars for the file is " .
      ($total_encchars - $total_litchars) . "\n";

