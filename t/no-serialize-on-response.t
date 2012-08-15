use strict;
use warnings;
use Test::More;
use Class::Load qw( load_class );

my $res
	= new_ok( load_class('Business::CyberSource::Response') => [{
		request_id    => '42',
		decision      => 'ACCEPT',
		reason_code   => 100,
		request_token => 'gobbledygook',
	}]);

ok ! $res->can('serialize'), 'can not serialize';

done_testing;
