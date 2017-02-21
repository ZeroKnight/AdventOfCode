# Advent of Code 2016: Day 7
# http://adventofcode.com/2016/day/7

package Day07;

use v5.14;
use warnings;

use Advent::IO;

sub solve
{
  my ($day, $part2) = @_;
  my @addrs = input($day);
  my @tls_ips;
  my @ssl_ips;

  if (!$part2)
  {
  foreach my $addr (@addrs)
  {
    my @chars = split //, $addr;
    my ($in_hypernet, $valid_tls) = (0, 0);
    for (my $i = 0; $i < length $addr; ++$i)
    {
      last if length($addr) - $i < 4;
      if ($chars[$i] eq '[')
      {
        $in_hypernet = 1;
        next;
      }
      elsif ($chars[$i] eq ']')
      {
        $in_hypernet = 0;
        next;
      }
      if (abba(@chars[$i..$i+3]))
      {
        if ($in_hypernet)
        {
          $valid_tls = 0;
          last;
        }
        else
        {
          $valid_tls = 1;
        }
      }
    }
    push @tls_ips, $addr if $valid_tls;
  }
  say scalar @tls_ips;
  } # Part 1

  else
  {
  my $valid_ssl = 0;
  ADDR: foreach my $addr (@addrs)
  {
    my %aba;
    my @chars = split //, $addr;
    my ($in_hypernet, $nSuper, $nHyper) = (0, 0, 0);

    # Look for ABAs
    for (my $i = 0; $i < length $addr; ++$i)
    {
      last if length($addr) - $i < 3;
      if ($chars[$i] eq '[')
      {
        $in_hypernet = 1;
        next;
      }
      elsif ($chars[$i] eq ']')
      {
        $in_hypernet = 0;
        next;
      }

      if (aba(@chars[$i..$i+2]))
      {
        if ($in_hypernet)
        {
          $aba{hyper}[$nHyper++] = [@chars[$i..$i+2]];
        }
        else
        {
          $aba{super}[$nSuper++] = [@chars[$i..$i+2]];
        }
      }
    }

    # Check for an ABA/BAB pair
    next unless exists $aba{super} and exists $aba{hyper};
    foreach my $h (@{$aba{hyper}})
    {
      foreach my $s (@{$aba{super}})
      {
        if ($$h[0] eq $$s[1] and
            $$h[1] eq $$s[0])
        {
          push @ssl_ips, $addr;
          next ADDR;
        }
      }
    }
  }
  say scalar @ssl_ips;
  } # Part 2
}

sub abba
{
  return 0 if grep { $_ =~ /[\[\]]/ } @_;
  if ($_[1] ne $_[0] and
      $_[1] eq $_[2] and
      $_[0] eq $_[3])
  {
    return 1;
  }
}

sub aba
{
  return 0 if grep { $_ =~ /[\[\]]/ } @_;
  if ($_[1] ne $_[0] and
      $_[0] eq $_[2])
  {
    return 1;
  }
}

1;
