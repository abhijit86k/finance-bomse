#!/usr/bin/perl -w 
use LWP::Simple;
use Finance::Quote;
use Data::Dumper;

print "Start of script\n";
my %info = ();
my $q = Finance::Quote->new;
%info = $q->fetch("asia", "amzn" );
print Dumper %info;

print "Exit\n\n";
