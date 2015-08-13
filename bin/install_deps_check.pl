#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use Try::Tiny;
use Data::Dumper;

main(@ARGV);

sub main
{
    my $file = shift;

    my $tries = 0;
    CHECK: while (1) {
        last CHECK if $tries >= 3;

        my $check = `perl -c $file 2>&1`;

        if ( $check =~ m/syntax OK/ ) {
            print "$file syntax OK\n";
            last CHECK;
        }
        else {
            my @check_lines = split( "\n", $check );

            foreach my $line (@check_lines) {
                if ( $line =~ m/ locate\s+(.*?).pm /xms ) {
                    my $module = $1;
                    $module =~ s/ \/ /::/xmsg;

                    if ($module) {
                        print "Installing $module\n";
                        system("cpanm -n $module") == 0
                            or die "Failed to install $module";
                        $tries = 0;
                    }
                }
                elsif ( $line =~ m/ syntax\sOK /xms ) {
                    print "$file syntax OK\n";
                    last CHECK;
                }
            }
            $tries++;
        }
    }

    return 1;
}
