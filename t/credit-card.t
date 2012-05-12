use strict;
use warnings;
use Test::More;
use Test::Fatal;
use Module::Runtime qw( use_module );
use DateTime;
use Data::Dumper::Concise;

my $card_c = use_module('Business::CyberSource::CreditCard');

my $card0
	= new_ok( $card_c => [{
		account_number => '4111111111111111',
		expiration     => {
			year  => '2025',
			month => '04',
		},
	}]);

is $card0->type, 'VISA', 'type visa';

isa_ok $card0->expiration, 'DateTime', 'expiration object';
is $card0->expiration->month, 4,       'expiration month';
is $card0->expiration->year,  2025,    'expiration year';
is $card0->expiration->day,   30,      'expiration day';
is $card0->is_expired,        0,       'card0 not expired';

my $dt0 = DateTime->new( year => 2025, month => 4, day => 30 );
my $dt1 = DateTime->new( year => 2025, month => 5, day => 1  );
my $dt2 = DateTime->new( year => 2025, month => 5, day => 2  );
my $dt3 = DateTime->new( year => 2025, month => 6, day => 1  );

is $card0->_compare_date_against_expiration( $dt0 ), 0, 'april not expired';
is $card0->_compare_date_against_expiration( $dt1 ), 0, 'may 1 not expired';
is $card0->_compare_date_against_expiration( $dt2 ), 1, 'may 2 expired';
is $card0->_compare_date_against_expiration( $dt3 ), 1, 'june expired';

my $card1
	= new_ok( $card_c => [{
		account_number => '4111111111111111',
		expiration     => {
			year  => '2012',
			month => '04',
		},
	}]);

is $card1->is_expired, 1, 'card1 expired';

done_testing;
