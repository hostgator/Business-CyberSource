#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username => $CYBS_ID,
		password => $CYBS_KEY,
	});

is ( $req->username, $CYBS_ID,  'check username' );
is ( $req->password, $CYBS_KEY, 'check key'      );

done_testing;
