use strict;
use warnings;
use Test::More;
use Test::Moose;
use Test::Fatal;

use Module::Runtime qw( use_module );
use DateTime;

my $card_c = use_module('Business::CyberSource::Helper::Card');

my @test_pairs = (
	[ qw( 4111111111111111 001 VISA       ) ],
	[ qw( 5555555555554444 002 MASTERCARD ) ],
	[ qw( 3566111111111113 007 JCB        ) ],
);

my $dt0 = DateTime->new( year => 2025, month => 4, day => 30 );
my $dt1 = DateTime->new( year => 2025, month => 5, day => 1  );
my $dt2 = DateTime->new( year => 2025, month => 5, day => 2  );
my $dt3 = DateTime->new( year => 2025, month => 6, day => 1  );

foreach ( @test_pairs ) {
	my ( $acct_num, $type_code, $type ) = @{ $_ };

	my $card
		= new_ok( $card_c => [{
			account_number => $acct_num,
			security_code  => '1111',
			expiration     => {
				year  => '2025',
				month => '04',
			},
	}]);

	does_ok $card, 'MooseX::RemoteHelper::CompositeSerialization';
	can_ok  $card, 'serialize';

	is $card->type          , $type,      'Type: '      . $type;
	is $card->card_type_code, $type_code, 'Type Code: ' . $type_code;
	is $card->security_code,  1111,       'security code';

	isa_ok $card->expiration, 'DateTime', 'expiration object';

	is $card->expiration->month, 4,       'expiration month';
	is $card->expiration->year,  2025,    'expiration year';
	is $card->expiration->day,   30,      'expiration day';
	is $card->is_expired,        0,       'card0 not expired';

	is $card->_compare_date_against_expiration( $dt0 ), 0, 'april not expired';
	is $card->_compare_date_against_expiration( $dt1 ), 0, 'may 1 not expired';
	is $card->_compare_date_against_expiration( $dt2 ), 1, 'may 2 expired';
	is $card->_compare_date_against_expiration( $dt3 ), 1, 'june expired';

	is ref $card->serialize, 'HASH', 'serialize returns hashref';

	my $expected_card = {
		accountNumber   => $acct_num,
		cardType        => $type_code,
		expirationMonth => 4,
		expirationYear  => 2025,
		cvIndicator     => 1,
		cvNumber        => 1111,
	};

	is_deeply $card->serialize, $expected_card, 'serialization';
}

done_testing;
