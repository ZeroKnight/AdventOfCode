#!/usr/bin/env perl

# Advent of Code Day 4
# http://adventofcode.com/day/4

use strict;
use warnings;

use Digest::MD5 qw(md5_hex);

my $adventcoin;
my $secret = 'bgvyzdsv';
my $nonce  = 1;

while (1) {
    $adventcoin = md5_hex("${secret}${nonce}");
    last if substr($adventcoin, 0, 6) eq '000000';
    ++$nonce;
}

print "AdventCoin successfully mined: $adventcoin (Nonce: $nonce)\n";

