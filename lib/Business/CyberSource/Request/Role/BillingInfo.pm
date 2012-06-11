package Business::CyberSource::Request::Role::BillingInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Aliases;

use MooseX::Types::CyberSource qw( BillTo );

use Class::Load qw( load_class );

our @CARP_NOT = ( 'Class::MOP::Method::Wrapped', __PACKAGE__ );

my %bt_map = (
	first_name  => 1,
	last_name   => 1,
	city        => 1,
	state       => 1,
	postal_code => 1,
	country     => 1,
	email       => 1,
	street1     => 1,
	street2     => 1,
	street3     => 1,
	street4     => 1,
	street      => 1,
	ip          => 1,
);

around BUILDARGS => sub {
	my $orig = shift;
	my $self = shift;

	my $args = $self->$orig( @_ );

	return $args if defined $args->{bill_to};

	load_class('Carp');
	Carp::carp 'DEPRECATED: '
		. 'pass a Business::CyberSource::RequestPart::BillTo to bill_to '
		. 'or pass a constructor hashref to bill_to as it is coerced from '
		. 'hashref.'
		;

	my %map = (
		zip          => 'postal_code',
		street       => 'street1',
	);

	my %newargs = map {(( $map{$_} || $_ ), $args->{$_})} keys %$args;

	my %bill_to
		= map {
			defined $bt_map{$_} ? ( $_, delete $newargs{$_} ) : ()
		} keys %newargs;

	$newargs{bill_to}  = \%bill_to if keys %bill_to;

	return \%newargs;
};
before [ keys %bt_map ] => sub {
	load_class('Carp');
	Carp::carp 'DEPRECATED: '
		. 'call attribute methods ( ' . join( ' ', keys %bt_map ) . ' ) on '
		. 'Business::CyberSource::RequestPart::BillTo via bill_to directly'
		;
};

has bill_to => (
	isa         => BillTo,
	remote_name => 'billTo',
	alias       => ['billing_info'],
	is          => 'ro',
	required    => 1,
	coerce      => 1,
	handles     => {
		street => 'street1',
		%{ { map {( $_ => $_ )} keys %bt_map } },
	}
);

1;

# ABSTRACT: Role for requests that require "bill to" information

=attr bill_to

L<Business::Cybersource::RequestPart::BillTo>

=cut
