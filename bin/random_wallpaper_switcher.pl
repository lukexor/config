#!/usr/bin/perl
##==========================================================================##
# Changes the wallpaper background periodically
##==========================================================================##

use strict;
use warnings;

# Set to the directory you want to have searched for photos
my $search_path = $ENV{'WALLPAPER_PATH'};

# Edit to the number of seconds between photo switches
my $interval = $ENV{'WALLPAPER_INTERVAL'};

my @paths = split(":", $search_path);
my @photos;
P: foreach my $path (@paths) {
	push @photos, `find $path -type f | grep -Pi '\.(jpg|jpeg|png|bmp|gif)'`;
}
chomp(@photos);
while(1)
{
	my $photo = $photos[rand($#photos)];
	if (-f $photo) {
		print "Switching to $photo\n";
		`gsettings set org.gnome.desktop.background picture-uri "file:///$photo"`;
		sleep($interval);
	}
	else {
		print "$photo does not exist\n";
	}
}
