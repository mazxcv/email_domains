#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More;
use Test::File;

subtest 'testing_mode_file' => sub {

	file_exists_ok 't/files/correct';
	file_not_exists_ok 't/files/nonexist';
	file_empty_ok  't/files/empty';
	file_not_empty_ok 't/files/correct';
	file_readable_ok 't/files/correct';
};

subtest 'testing_without_file' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl);
	ok !@t
};

subtest 'testing_with_empty_file' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl t/files/empty);
	ok !@t;
};

subtest 'testing_with_non_exist_file' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl t/files/nonexist);
	ok !@t;
};

subtest 'testing_with_dir' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl t/files/);
	ok !@t;
};

subtest 'testing_with_correct_file' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl t/files/correct);
	ok @t;

	my $first  = (grep {/eme\.t/} @t)[0];
	my $second = (grep {/mail\.ru/} @t)[0];
	ok $first;
	ok $second;
	like $first, qr/1/;
	like $second, qr/2/;
};

subtest 'testing_with_uncorrect_file' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl t/files/uncorrect);
	ok @t;
	my $first  = (grep {/INVALID/} @t)[0];
	ok $first;
	like $first, qr/2/;
};

subtest 'testing_with_uncorrect_file' => sub {

	my @t = split '\n', qx(carton exec ./script/email_domains.pl t/files/test);
	ok @t;
	my $invalid  = (grep {/INVALID/} @t)[0];
	ok $invalid;
	like $invalid, qr/2/;
	my $google = (grep {/google\.com/} @t)[0];
	ok $google;
	like $google, qr/3/;
};


done_testing();