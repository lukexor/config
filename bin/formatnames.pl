#!/usr/bin/perl

use strict;
use warnings;

use File::Copy 'mv';
use File::Basename;
use Cwd 'abs_path';
use Getopt::Long;
# use Data::Dumper;

my $check;
my $directories;
my $verbose;

GetOptions
(
    "c|check"   => \$check,
    "d|dir"     => \$directories,
    "v|verbose" => \$verbose,
);

my @args = @ARGV;


if (not defined $args[0])
{
    die <<"DIE"
Usage:  $0 <directory|filename>

        -c | --check    Print conversion, but don't rename files
        -d | --dir      Operate on directories
        -v | --verbose  Print verbose messages
DIE
}

my $count = 1;
print "About to rename all files under $args[0].\n\nDo you want to continue? (y/n) ";
my $ans = <STDIN>;
chomp $ans;
if ($ans =~ m/\A y /xmsi)
{
    foreach my $arg (@args)
    {
        process($arg);
    }
}
else
{
    print "Exiting...\n";
}

sub process
{
    my $oldname = shift;
    print "PROCESSING DIR $oldname\n" if $verbose;

    # Break apart into peices
    my $basename = basename $oldname;
    my $old_abs_path = abs_path $oldname;
    my $newname = strip($basename);
    my $new_abs_path = abs_path $newname;

    rename_file($old_abs_path, $new_abs_path);

    $new_abs_path = $old_abs_path if $check;

    if (-d $new_abs_path)
    {
        chdir $new_abs_path;
        # Open directory and get a list of files
        opendir my $dir_fh, $new_abs_path
            or die "Unable to open '$new_abs_path' to read directory contents: $!";
        # Get all files except ./ and ../
        my @files = grep { !/^\.{1,2}/ } readdir ($dir_fh);
        closedir $dir_fh;

        foreach my $file (@files)
        {
            my $basename = basename $file;
            my $old_abs_path = abs_path $file;
            # print "F-FILE: $file\n";
            # print "F-BASE: $basename\n";
            # print "F-ABS: $old_abs_path\n";
            if (-d $old_abs_path)
            {
                # Recurse directory
                process("$old_abs_path");
                chdir '../';
            }
            else
            {
                # Rename file
                my $newname = strip($basename);
                my $new_abs_path = abs_path $newname;

                rename_file($old_abs_path, $new_abs_path);
            }
        }
    }
}

sub rename_file
{
    my ($oldname, $newname) = @_;

    return if (-d $oldname && !$directories);

    if ($oldname eq $newname)
    {
        print "Skipping '$oldname' :: Names match.\n" if $verbose;
        $newname = $oldname;
    }
    elsif ($oldname =~ m/\A \. /xms)
    {
        print "Skipping '$oldname' :: Filename begins with a dot.\n" if $verbose;
        $newname = $oldname;
    }
    else
    {
        print "'$oldname'  --->  '$newname'\n";
        if (lc $oldname ne lc $newname && -e $newname)
        {
            print "$newname already exists!\n";
            print "Do you want to move it anyways?";
            my $ans = <STDIN>;
            chomp $ans;
            if ($ans !~ m/\A y /xmsi)
            {
                print "Skipping '$oldname' :: File already exists.\n";
                $newname = $oldname;
            }
        }
    }
    if (!$check && $newname ne $oldname) {
        mv $oldname, $newname
            or die "Unable to move '$oldname' to '$newname': $!";
    }
}

sub strip
{
    my $name = shift;

    return $name if (-d $name && !$directories);

    my $newname = lc $name;

    $newname =~ s#^[-_\.\s+]##g; # Remove any leading dashes, underscores, spaces or periods
    $newname =~ s#[-_\.\s+]\$##g; # Removing any trailing dashes, underscores, spaces or periods
    $newname =~ s#[-_<>:,\?\*\|\s]# #g; # Replace any dash, weird characters or spaces with space
    $newname =~ s#[!\?&"+'{}\(\)\[\]]##g; # Remove all double quotes and extra symbols
    $newname =~ s#\.{2,}#\.#g; # Replace 2 or more periods with a single period
    $newname =~ s#_\.#\.#g; # Replace an _. with just a period
    $newname =~ s#\_{2,}# #g; # Replace 2 or more underscores with a single space
    $newname =~ s#\.(?=.*\.)# #g; # Replace all but the last period with space

    # Titlecase
    my @words = split(" ", $newname);
    $_ = ucfirst $_ for @words;
    $newname = join(" ", @words);

    if ( length ($newname) > 100 && !$directories )
    {
        $newname = substr($newname, -100);
    }

    return $newname;
}
