use strict;
use warnings;
use Test::More;
use Test::Moose;
use Module::Runtime qw( use_module );

my $billto
	= new_ok( use_module('Business::CyberSource::Helper::BillingInfo') => [{
		first_name  => 'Caleb',
		last_name   => 'Cushing',
		street1     => '8100 Cameron Road',
		street2     => 'Suite B-100',
		city        => 'Austin',
		state       => 'TX',
		postal_code => '78753',
		country     => 'US',
		email       => 'xenoterracide@gmail.com',
		ip_address  => '192.168.100.2',
	}]);

isa_ok ( $billto->ip_address, 'NetAddr::IP'                                 );
does_ok( $billto,             'MooseX::RemoteHelper::CompositeSerialization');
can_ok ( $billto,             'serialize'                                   );

is( $billto->first_name,      'Caleb',                   '->first_name'     );
is( $billto->last_name,       'Cushing',                 '->last_name'      );
is( $billto->street1,         '8100 Cameron Road',       '->street1'        );
is( $billto->street2,         'Suite B-100',             '->street2'        );
is( $billto->city,            'Austin',                  '->city'           );
is( $billto->state,           'TX',                      '->state'          );
is( $billto->country,         'US',                      '->country'        );
is( $billto->email,           'xenoterracide@gmail.com', '->email'          );
is( $billto->postal_code,     '78753',                   '->postal_code'    );
is( $billto->ip_address->addr,'192.168.100.2',           '->ip_address'     );

is( ref $billto->serialize,   'HASH',                    'serialize type'   );

my %expected_serialized
	= (
		firstName  => 'Caleb',
		lastName   => 'Cushing',
		country    => 'US',
		ipAddress  => '192.168.100.2',
		street1    => '8100 Cameron Road',
		street2    => 'Suite B-100',
		city       => 'Austin',
		state      => 'TX',
		postalCode => '78753',
		email      => 'xenoterracide@gmail.com',
	);

is_deeply( $billto->serialize, \%expected_serialized, 'serialized'          );

done_testing;
