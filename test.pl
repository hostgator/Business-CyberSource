#!/usr/bin/perl

use 5.014;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Data::Dumper;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username => $CYBS_ID,
		password => $CYBS_KEY,
	});

say $req->username;

say $req->submit;
