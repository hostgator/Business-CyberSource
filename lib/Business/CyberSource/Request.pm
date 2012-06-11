package Business::CyberSource::Request;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

BEGIN {
use Moose;
extends 'Business::CyberSource::Message';
}

with 'Business::CyberSource::Role::MerchantReferenceCode';

use MooseX::ABC;

use MooseX::Types::Moose       qw( ArrayRef );
use MooseX::Types::CyberSource qw( PurchaseTotals Service Items );

use Class::Load qw( load_class );

our @CARP_NOT = ( 'Class::MOP::Method::Wrapped', __PACKAGE__ );

my %pt_map = (
	currency         => 1,
	total            => 1,
	foreign_currency => 1,
	foreign_amount   => 1,
	exchange_rate    => 1,
	exchange_rate_timestamp => 1,
);
BEGIN {
%pt_map = (
	currency         => 1,
	total            => 1,
	foreign_currency => 1,
	foreign_amount   => 1,
	exchange_rate    => 1,
	exchange_rate_timestamp => 1,
);
}

around BUILDARGS => sub {
	my $orig = shift;
	my $self = shift;

	my $args = $self->$orig( @_ );

	return $args if defined $args->{purchase_totals};

	load_class 'Carp';
	Carp::cluck 'DEPRECATED: using a deprecated API';
	Carp::carp 'DEPRECATED: '
		. 'pass a Business::CyberSource::RequestPart::PurchaseTotals to '
		. 'purchase_totals '
		. 'or pass a constructor hashref to bill_to as it is coerced from '
		. 'hashref.'
		;

	my %newargs = %{ $args };

	my %purchase_totals
		= map {
			defined $pt_map{$_} ? ( $_, delete $newargs{$_} ) : ()
		} keys %newargs;

	$newargs{purchase_totals} = \%purchase_totals if keys %purchase_totals;

	return \%newargs;
};

before [ keys %pt_map ] => sub {
	load_class('Carp');
	Carp::carp 'DEPRECATED: '
		. 'call attribute methods ( ' . join( ' ', keys %pt_map ) . ' ) on '
		. 'Business::CyberSource::RequestPart::BillTo via bill_to directly'
		;
};

before serialize => sub { ## no critic qw( Subroutines::RequireFinalReturn )
	my $self = shift;

	if ( ! $self->has_total || ( ! $self->has_items && $self->items_is_empty ) ) {
		confess 'you must define either items or total';
	}
};

sub add_item {
	my ( $self, $args ) = @_;

	my $item;
	unless ( blessed $args
			&& $args->isa( 'Business::CyberSource::RequestPart::Item' )
		) {
		load_class 'Business::CyberSource::RequestPart::Item';
		$item = Business::CyberSource::RequestPart::Item->new( $args )
	}
	else {
		$item = $args;
	}
	$self->items( [ ] ) if ! $self->has_items;

	return $self->_push_item( $item );
}

# the default is false, override in subclass
sub _build_skipable { return 0 }

sub _build_service {
	load_class('Business::CyberSource::RequestPart::Service');
	return Business::CyberSource::RequestPart::Service->new;
}

has comments => (
	remote_name => 'comments',
	isa         => 'Str',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has service => (
	isa        => Service,
	is         => 'ro',
	lazy_build => 1,
	required   => 1,
	coerce     => 1,
	reader     => undef,
);

has is_skipable => (
	isa     => 'Bool',
	builder => '_build_skipable',
	is      => 'ro',
	lazy    => 1,
);

BEGIN {
has purchase_totals => (
	isa         => PurchaseTotals,
	remote_name => 'purchaseTotals',
	is          => 'ro',
	required    => 1,
	coerce      => 1,
	handles     => {
		has_total => 'has_total',
		%{ { map {( $_ => $_ )} keys %pt_map } }, ## no critic ( BuiltinFunctions::ProhibitVoidMap )
	},
);
}

has items => (
	isa         => Items,
	remote_name => 'item',
	predicate   => 'has_items',
	is          => 'rw',
	traits      => ['Array'],
	coerce      => 1,
	handles     => {
		items_is_empty => 'is_empty',
		next_item      => [ natatime => 1 ],
		list_items     => 'elements',
		_push_item     => 'push',
	},
	serializer => sub {
		my ( $attr, $instance ) = @_;

		my $items = $attr->get_value( $instance );

		my $i = 0;
		my @serialized
			= map { ## no critic ( BuiltinFunctions::ProhibitComplexMappings )
				my $item = $_->serialize;
				$item->{id} = $i;
				$i++;
				$item
			} @{ $items };

		return \@serialized;
	},
);

has '+_trait_namespace' => (
	default => 'Business::CyberSource::Request::Role',
);

has '+trace' => (
	is        => 'rw',
	init_arg  => undef
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Request Class

=head1 DESCRIPTION

extends L<Business::CyberSource::Message>

Here are the provided Request subclasses.

=over

=item * L<Authorization|Business::CyberSource::Request::Authorization>

=item * L<AuthReversal|Business::CyberSource::Request::AuthReversal>

=item * L<Capture|Business::CyberSource::Request::Capture>

=item * L<Follow-On Credit|Business::CyberSource::Request::FollowOnCredit>

=item * L<Stand Alone Credit|Business::CyberSource::Request::StandAloneCredit>

=item * L<DCC|Business::CyberSource::Request::DCC>

=item * L<Sale|Business::CyberSource::Request::Sale>

=back

I<note:> You can use the L<Business:CyberSource::Request::Credit> class but,
it requires traits to be applied depending on the type of request you need,
and thus does not currently work with the factory.

=head1 EXTENDS

L<Business::CyberSource::Message>

=head1 WITH

=over

=item L<Business::CyberSource::Role::MerchantReferenceCode>

=back

=method serialize

returns a hashref suitable for passing to L<XML::Compile::SOAP>

=method add_item

Add an L<Item|Business::CyberSource::RequestPart::Item> to L<items|/"items">.
Accepts an item object or a hashref to construct an item object.

an array of L<Items|MooseX::Types::CyberSource/"Items">

=attr reference_code

Merchant-generated order reference or tracking number.  CyberSource recommends
that you send a unique value for each transaction so that you can perform
meaningful searches for the transaction.

=attr service

L<Business::CyberSource::RequestPart::Service>

=attr purchase_totals

L<Business::CyberSource::RequestPart::PurchaseTotals>

=attr items

An array of L<Business::CyberSource::RequestPart::Item>

=attr comments

Comment Field

=attr is_skipable

Type: Bool

an optimization to see if we can skip sending the request and just construct a
response. This attribute is for use by L<Business::CyberSource::Client> only
and may change names later.

=for Pod::Coverage BUILD

=cut
