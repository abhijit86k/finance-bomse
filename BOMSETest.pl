#!/usr/bin/perl -w
use strict;
use Test;
use Data::Dumper;
BEGIN {plan tests => 26};

use Finance::Quote;

# Test BSERO functions.

my $q      = Finance::Quote->new();
my @stocks = ("SUZLON.BO", "RECLTD.NS", "AMZN");


my %quotes = $q->fetch("bomse", @stocks);
ok(%quotes);

foreach my $stock (@stocks) {

	my $name = $quotes{$stock, "name"};
	print "#Testing $stock: $name\n";

	#my $regexp = $regexps{$stock};
	#ok($name =~ /$regexp/i);
	ok($quotes{$stock, "exchange"} eq 'Temporarily using Bucharest Stock Exchange');
	ok($quotes{$stock, "method"} eq 'bomse');
	ok($quotes{$stock, "last"} > 0);
	ok($quotes{$stock, "open"} =~ /^-?\d+\.\d+$/);
	ok($quotes{$stock, "p_change"} =~ /^-?\d+\.\d+$/);
	ok($quotes{$stock, "success"});
	ok($quotes{$stock, "volume"} >= 0);
}


# Check that a bogus stock returns no-success.
%quotes = $q->fetch("tsx", "BOGUS");
ok(! $quotes{"BOGUS","success"});
