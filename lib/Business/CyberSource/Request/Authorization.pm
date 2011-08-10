package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}

use SOAP::Lite ( +trace => [ qw( debug ) ] );
use Moose;
use namespace::autoclean;
with 'Business::CyberSource::Request';

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'merchantReferenceCode',
			value  => $value,
		);
	},
);

has _bill_to => (
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => 'SOAP::Data::Builder::Element',
	default  => sub {
		my $self = shift;
		return $self->_sdbo->add_elem(
			name => 'billTo',
		);
	},
);

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'firstName',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'lastName',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'street1',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'city',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has state => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'state',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has country => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'country',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has zip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'postalCode',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'email',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has ip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'ipAddress',
			value  => $value,
			parent => $self->_bill_to,
		);
	},
);

has _item => (
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => 'SOAP::Data::Builder::Element',
	default  => sub {
		my $self = shift;
		return $self->_sdbo->add_elem(
			name => 'item',
		);
	},
);

has unit_price => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
	traits   => ['Number'],
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'unitPrice',
			value  => $value,
			parent => $self->_item,
		);
	},
);

has quantity => (
	required => 1,
	is       => 'ro',
	isa      => '',
	traits   => ['Number'],
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'quantity',
			value  => $value,
			parent => $self->_item,
		);
	},
);

has _totals => (
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => 'SOAP::Data::Builder::Element',
	default  => sub {
		my $self = shift;
		return $self->_sdbo->add_elem(
			name => 'purchaseTotals',
		);
	},
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'currency',
			value  => $value,
			parent => $self->_totals,
		);
	},
);

sub submit {
	my ( $self ) = shift;
	
	$self->_sdbo->add_elem(
		attributes => { run => 'true' },
		name       => 'ccAuthService',
		value      => ' ', # hack to prevent cs side unparseable xml
	);

	my $req = SOAP::Lite->new(
		readable   => 1,
		autotype   => 0,
		proxy      => 'https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor',
		default_ns => 'urn:schemas-cybersource-com:transaction-data-1.61',
	);

	my $ret = $req->requestMessage( $self->_sdbo->to_soap_data )->result;

	return 1;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization request object

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization request object

=head1 VERSION

version v0.1.0

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

