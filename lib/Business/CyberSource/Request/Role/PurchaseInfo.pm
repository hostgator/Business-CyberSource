package Business::CyberSource::Request::Role::PurchaseInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( PurchaseTotals );

has purchase_totals => (
	isa         => PurchaseTotals,
	remote_name => 'purchaseTotals',
	is          => 'ro',
	required    => 1,
	coerce      => 1,
	handles     => {
		has_total => 'has_total',
	},
);

1;

# ABSTRACT: CyberSource Purchase Information Role

=attr purchase_totals

L<Business::CyberSource::Helper::PurchaseTotals>

=cut
