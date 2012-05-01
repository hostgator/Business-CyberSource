use strict;
use warnings;
use Test::More;
use Test::Exception;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username       => 'foobar',
		password       => 'test',
		reference_code => 't001',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		ip             => '192.168.100.2',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		production     => 0,
	});

is( $req->username, 'foobar',  'check username' );
is( $req->password, 'test'  ,  'check password' );

throws_ok { $req->submit } qr/SOAP Fault/, 'submit threw exception ok';
done_testing;
