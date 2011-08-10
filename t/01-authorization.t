#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
use Data::Dumper;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username => $CYBS_ID,
		password => $CYBS_KEY,
		reference_code => '42',
	});

is( $req->username, $CYBS_ID,  'check username' );
is( $req->password, $CYBS_KEY, 'check key'      );
is( $req->client_version,
	$Business::CyberSource::VERSION,
	'check client_version exists'
);
is( $req->client_library, 'Business::CyberSource', 'check client_library' );
note( $req->client_version );
note( $req->client_library );
note( Dumper $req->client_env );

done_testing;
