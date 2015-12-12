#!/usr/bin/env perl

# Advent of Code Day 7
# http://adventofcode.com/day/7

use strict;
use warnings;
use v5.14; # smartmatch
no warnings 'experimental::smartmatch';

my %table;          # Wire connection table
my %table_cache;    # Memoization
my $target_wire = 'a';

my %operators = (
    LSHIFT => { arity => 2, eval => sub { return $_[0] << $_[1] & 0xFFFF } },
    RSHIFT => { arity => 2, eval => sub { return $_[0] >> $_[1] & 0xFFFF } },
    AND    => { arity => 2, eval => sub { return $_[0] &  $_[1] & 0xFFFF } },
    OR     => { arity => 2, eval => sub { return $_[0] |  $_[1] & 0xFFFF } },
    NOT    => { arity => 1, eval => sub { return ~$_[0] & 0xFFFF } }
);

my @instructions;
open my $fh, '<', './input' or die "$0: can't open input for reading: $!";
while (<$fh>) {
    chomp;
    push @instructions, $_;
}
close $fh;

# Map wires to their 'connections'
foreach (@instructions) {
    state $line = 1;
    my $opers = (join '|', (keys %operators));
    my $re = qr/
        ^(
          (?:\d+|[[:alpha:]]{1,2})
            (?:\s(?:RSHIFT|LSHIFT|AND|OR)\s(?:\d+|[[:alpha:]]{1,2}))? |
          NOT\s(?:\d+|[[:alpha:]]{1,2})
         )\s->\s([[:alpha:]]{1,2})$
    /x;

    die "Invalid instruction in input at line $line: '$_'\n" unless $_ =~ $re;

    $table{$2} = $1;

    ++$line;
}

# Part 1
my $target_signal = resolve($target_wire);
print "Wire '$target_wire' has signal $target_signal.\n";

# Part 2
$table{b} = $target_signal;
undef %table_cache;
$target_signal = resolve($target_wire);
print "After some tinkering, it now has signal $target_signal\n";

# Recursively resolve a wire's signal (memoized)
sub resolve {
    my $wire = shift;
    my @queue; # Operand queue
    my @stack; # Operator stack

    # Break down the statement
    foreach my $token (split / /, $table{$wire}) {
        if ($token ~~ [keys %operators]) {
            push @stack, $token;
        } elsif ($token =~ /[[:alpha:]]{1,2}/) {
            push @queue, $table_cache{$token} // resolve($token);
        } elsif ($token =~ /\d+/) {
            push @queue, $token;
        }
    }

    # Evaluate each operation
    foreach (@stack) {
        my $result;

        if ($operators{$_}{arity} == 2) {
            # Pop each operand off the queue and evaluate the operation
            $result = $operators{$_}{eval}(shift @queue, shift @queue);

            # Push the result back on to the front of the queue
            unshift @queue, $result;
        } else {
            $result = $operators{$_}{eval}(shift @queue);
            unshift @queue, $result;
        }
    }

    # Cache and return the result
    return $table_cache{$wire} = $queue[0];
}

