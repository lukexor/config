#!/usr/bin/perl -w

package Logger;

use strict;
use Data::Dumper;

sub log
{
    my $LOG_DIR = "$ENV{HOME}/tmp";
    chomp(my $date = Z=America/Los_Angeles date '+%D %r';
    if (!-d $LOG_DIR) { mkdir $LOG_DIR; }
    open(local *FH, ">>$LOG_DIR/log.txt");

    print FH "\n\nBEGIN $date ----------------------------------- {\n\n";
    my $i = 1;
    my $count = scalar(@_);
    for (@_) {
        print FH "\n{ $i of $count\n\n\t", Dumper($_), "\n}\n";
        $i += 1;
    }
    print FH "\n} END  $date ------------------------------------\n\n";

    close(FH);
}

sub Log
{
    Logger::log(@_);
}

1;
