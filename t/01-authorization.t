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
		reference_code => '42',
	});

is ( $req->username, $CYBS_ID,  'check username' );
is ( $req->password, $CYBS_KEY, 'check key'      );
ok ( $req->client_version, 'check client_version exists' );
note( $req->client_verson );

done_testing;
