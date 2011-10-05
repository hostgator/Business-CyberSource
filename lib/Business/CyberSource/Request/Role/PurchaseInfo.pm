package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Request::Role::Items
);

use MooseX::Types::Moose            qw( HashRef           );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );
use MooseX::Types::Varchar          qw( Varchar           );
use MooseX::Types::Locale::Currency qw( CurrencyCode      );

sub _purchase_info {
	my $self = shift;

	my $i = {
		currency => $self->currency,
	};

	$i->{grandTotalAmount} = $self->total if $self->has_total;;

	return $i;
}

has total => (
	required  => 0,
	predicate => 'has_total',
	is        => 'ro',
	isa       => PositiveOrZeroNum,
	trigger  => sub {
		my $self = shift;
		$self->_set_purchase_data(
			grandTotalAmount  => $self->total,
		);
	},
	documentation => 'Grand total for the order. You must include '
		. 'either this field or item_#_unitPrice in your request',
);

has _purchase_data => (
	required => 0,
	init_arg => undef,
	is       => 'rw',
	isa      => HashRef,
	traits   => [ 'Hash' ],
	handles  => {
		_set_purchase_data => 'set',
	},
	trigger   => sub {
		my $self = shift;
		$self->_set_request_data(
			purchaseTotals => $self->_purchase_data,
		);
	},
);

1;

# ABSTRACT: CyberSource Purchase Information Role
