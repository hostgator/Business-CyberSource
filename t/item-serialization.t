use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );

my $itemc = use_module('Business::CyberSource::RequestPart::Item');

{
	package Test;
		use Moose;
		with qw(
			MooseX::RemoteHelper::CompositeSerialization
			Business::CyberSource::Request::Role::Items
		);
		__PACKAGE__->meta->make_immutable;
}

my $item0
	= new_ok( $itemc => [{
		unit_price => 2.12,
	}]);

my $item1
	= new_ok( $itemc => [{
		unit_price => 1.00,
		quantity   => 2,
	}]);

my $test
	= new_ok( Test => [{
		items => [ $item0, $item1 ],
	}]);

can_ok $test, 'serialize';

my %expected_serialized = (
	item => [
		{
			id        => 0,
			unitPrice => 2.12,
			quantity  => 1,
		},
		{
			id        => 1,
			unitPrice => 1.00,
			quantity  => 2,
		},
	],
);

is_deeply( $test->serialize, \%expected_serialized, 'serialize' );

done_testing;
