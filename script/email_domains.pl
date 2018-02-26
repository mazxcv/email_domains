#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use IO::File;

binmode(STDOUT,':utf8');


my $file = $ARGV[0] || undef;
my $fh = IO::File->new($file, '<:utf8') or exit;
my $domains = {};
my $invalid = 0;

while (<$fh>) {
	if (my ($name, $domain) = $_ =~ /^([\p{Alphabetic}\.\-\d]+)\@([\p{Alphabetic}\.\-\d]+)$/) {
		$domains->{$domain}++;
	} else {
		$invalid++;
	}
}

close $fh;

for (sort {$domains->{$b} <=> $domains->{$a}} keys %$domains) {
	print "$_: $domains->{$_}\n";
}
print "INVALID: $invalid\n" if $invalid;
