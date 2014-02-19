#!/usr/bin/perl

package Logger;

use strict;
use warnings;
use Data::Dumper;
use Carp;
$Data::Dumper::Indent   = 3;
$Data::Dumper::Deepcopy = 1;

sub log {
    my $HOME_DIR = "$ENV{'HOME'}";
    if (!$HOME_DIR) {
        $HOME_DIR = -d '/home/lpetherbridge' ? '/home/lpetherbridge' : '/';
    }
    my $LOG_DIR = "$HOME_DIR/tmp";
    chomp(my $date = `TZ='America / Los_Angeles' date '+%D %r'`);

    mkdir $LOG_DIR if !-d $LOG_DIR;

    open my $LOG, '>>', "$LOG_DIR/log.txt"
        or croak "Unable to open '$LOG_DIR/log.txt': $!";

    print $LOG "BEGIN $date ----------------------------------- {\n";
    my $i     = 1;
    my $count = scalar(@_);

    if ($count > 1) {
        for (@_) {
            print $LOG "\n{ $i of $count\n\n\t", Dumper($_), "\n}\n";
            $i += 1;
        }
    }
    else {
        print $LOG "\n\t", Dumper(@_), "\n";
    }
    print $LOG "\n} END  $date ------------------------------------\n\n";

    close $LOG
        or croak "Unable to close '$LOG_DIR/log.txt': $!";
}

sub Log {
    Logger::log(@_);

    if ($@) {
        return 0;
    }
    else {
        return 1;
    }
}

1;
