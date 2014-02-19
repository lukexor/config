#!/usr/bin/perl -w

use Cache::Memcached;
use Data::Dumper;

use strict;

#my $server = "localhost:11211";
#my $server = "localhost:11212";

my ($server, ) = @ARGV;

if (!defined($server)) {
    print "Usage: $0 <host:port>\n" ;
    exit(1);
}

memcached_dump($server);

sub memcached_dump
{
    my ($server, ) = @_;
    return undef if !$server;

    my $memd = new Cache::Memcached {
        'servers' => [$server],
        'debug' => 0
    };
    
    my $result = $memd->stats("items");
    my $items = $result->{hosts}->{$server}->{items};
    my @lines = split(/\r\n/, $items);
    
    my %buckets = ();
    for my $bucket (@lines) {
      $bucket =~ s/^.*:(.*):.*$/$1/ig;
      $buckets{$bucket} = 1;
    }
    
    my $hash_ref = {};
    for my $bucket (sort keys %buckets) {
         $result = $memd->stats("cachedump $bucket 100000");
         $items = $result->{hosts}->{$server}->{"cachedump $bucket 100000"};
         @lines = split(/\r\n/, $items);
    
         for my $ticket (@lines) {
            $ticket =~ s/^ITEM (.*) \[.*$/$1/ig;
            my $val = $memd->get($ticket);
            $hash_ref->{$ticket} = $val;
         }
    }
    $memd->disconnect_all;

    print join "\n", (sort keys %$hash_ref), "\n";
    for my $k (sort keys %$hash_ref) {
        print "*** $k ***\n  ", Dumper($hash_ref->{$k}), "\n";
    }
}
