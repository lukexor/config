#!/usr/bin/perl
##==========================================================================##
# Changes the wallpaper background periodically
##==========================================================================##

use strict;
use warnings;
use Data::Dumper;

# Set to the directory you want to have searched for photos
my $searchPath = "$ENV{'HOME'}/media/pics/wallpapers/nature";

# Edit to the number of seconds between photo switches
my $switchTime = 3600;

my @photos = `find $searchPath -type f | grep -Pi '\.(jpg|jpeg|png|bmp|gif)'`;
chomp(@photos);
my $photo;

while(1)
{
    $photo = $photos[rand($#photos)];
    `gsettings set org.gnome.desktop.background picture-uri "file:///$photo"`;
    sleep($switchTime);
}
