#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use Try::Tiny;
use Data::Dumper;

main(@ARGV);

sub main
{
	my @files = @_;

	foreach my $file (@files) {
		my $tries       = 0;
		my $last_module = "";
		CHECK: while (1) {
			last CHECK if $tries >= 3;

			my $check = `perl -c $file 2>&1`;

			if ($check =~ m/syntax OK/) {
				print "$file syntax OK\n";
				last CHECK;
			} else {
				my @check_lines = split("\n", $check);

				foreach my $line (@check_lines) {
					if ($line =~ m/ locate\s+(.*?).pm /xms) {
						my $module = $1;
						$module =~ s/ \/ /::/xmsg;

						if ($module && $module ne $last_module) {
							$last_module = $module;
							print "Installing $module...\n";
							system("cpan $module >> /tmp/deps.log 2>&1") == 0
								or die "Failed to install $module";
							$tries = 0;
						} else {
							print
								"Failed to install $last_module. Please see /tmp/deps.log\n";
							last CHECK;
						}
					} elsif ($line =~ m/ syntax\sOK /xms) {
						print "$file syntax OK\n";
						last CHECK;
					}
				} ## end foreach my $line (@check_lines)
				$tries++;
			} ## end else [ if ($check =~ m/syntax OK/)]
		} ## end CHECK: while (1)
	} ## end foreach my $file (@files)

	return 1;
} ## end sub main
