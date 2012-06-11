use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $dto = new_ok( $dtc => [{
	reference_code => 'test-authorization-accept-' . time,
	first_name     => 'Caleb',
	last_name      => 'Cushing',
	street         => 'somewhere',
	city           => 'Houston',
	state          => 'TX',
	zip            => '77064',
	country        => 'US',
	email          => 'xenoterracide@gmail.com',
	total          => 3000.00,
	currency       => 'USD',
	credit_card    => '4111-1111-1111-1111',
	cc_exp_month   => '09',
	cc_exp_year    => '2025',
	ignore_avs_result => 1,
}]);

is $dto->first_name, 'Caleb', 'first_name';

done_testing;
