#!/usr/bin/perl

=head1 NAME

contacts_csv_to_txt - Converts a google.csv list of contacts to a plain text output

=head1 AUTHOR

Lucas Petherbridge <lukexor@gmail.com>

=cut

use strict;
use warnings;

use Carp;
use Data::Dumper;
use Text::CSV;

sub main {
    my ($csv_file) = @_;
    my $csv = Text::CSV->new()
        or croak "Cannot use CSV: " . Text::CSV->error_diag();

    if (!$csv_file) {
        croak "Must provide csv_file to parse!";
    }

    my $out_file = 'contacts.txt';

    my @csv_rows;
    open my $CSV_FILE, '<:encoding(utf8)', $csv_file
        or croak "Unable to open '$csv_file': $!";
    while ( my $row = $csv->getline($CSV_FILE) ) {
        my $row_hash = {
            'name' => $row->[0],
            'birthday' => $row->[14],
            'email1_type' => $row->[27],
            'email1_val' => $row->[28],
            'email2_type' => $row->[29],
            'email2_val' => $row->[30],
            'email3_type' => $row->[31],
            'email3_val' => $row->[32],
            'email4_type' => $row->[33],
            'email4_val' => $row->[34],
            'phone1_type' => $row->[38],
            'phone1_val' => $row->[39],
            'phone2_type' => $row->[40],
            'phone2_val' => $row->[41],
            'phone3_type' => $row->[42],
            'phone3_val' => $row->[43],
            'phone4_type' => $row->[44],
            'phone4_val' => $row->[45],
            'address1_type' => $row->[46],
            'address1_formatted' => $row->[47],
            'address2_type' => $row->[55],
            'address2_formatted' => $row->[56],
            'organization' => $row->[65],
            'job_title' => $row->[67],
            'notes' => $row->[25],
        };
        push @csv_rows, $row_hash;
    }
    close $CSV_FILE
        or croak "Unable to close '$csv_file': $!";

    foreach my $row (@csv_rows) {
        next if $row->{'name'} eq 'Name';
        my $phone_numbers = "";
        my $emails = "";
        my $addresses = "";
        for (my $i = 1; $i <= 4; $i++) {
            my $phone_type = "phone${i}_type";
            my $phone_val = "phone${i}_val";
            if ($row->{$phone_val}) {
                $phone_numbers .= "\n\t$row->{$phone_type}: $row->{$phone_val}";
            }
            my $email_type = "email${i}_type";
            my $email_val = "email${i}_val";
            if ($row->{$email_val}) {
                $emails .= "\n\t$row->{$email_type}: $row->{$email_val}";
            }
        }

        for (my $i = 0; $i <= 2; $i++) {
            my $addr_type = "address${i}_type";
            my $addr_val = "address${i}_formatted";
            if ($row->{$addr_val}) {
                $addresses .= "\n\t$row->{$addr_type}\n\t$row->{$addr_val}";
            }
        }

        my $entry = qq|
Name: $row->{'name'}
Birthday: $row->{'birthday'}
Phone Number(s): $phone_numbers
Email(s): $emails
Addresse(s): $addresses
Organization: $row->{'organization'}
Job Title: $row->{'job_title'}
Notes: $row->{'notes'}
- - - - -|;

        open my $TXT_OUT, '>>:encoding(utf8)', $out_file
            or croak "Unable to open file '$out_file': $!";
        print $TXT_OUT $entry;
        close $TXT_OUT
            or croak "Unable to close file '$out_file': $!";
    }

    return 1;
}

main(@ARGV);
