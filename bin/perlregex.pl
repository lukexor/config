#!/usr/bin/perl -s

my $regex = shift;
my $string = shift;

print "Regex: $regex\n";
if ($string =~ m/$regex/xms) {
    print "Matched: ";
    print $` if defined $`;
    print "{{$&}}";
    print $' if defined $';
    print "\n";
}
else
{
    print "No match!: '$regex' on '$string'\n";
}
