package Business::CyberSource::Request::Role::CreditCardInfo;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005005'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;

use MooseX::Types::CyberSource qw( Card);

use Class::Load qw( load_class );

our @CARP_NOT = ( 'Class::MOP::Method::Wrapped', __PACKAGE__ );

my %map = (
	cc_exp_month => 'month',
	cc_exp_year  => 'year',
	exp_month    => 'month',
	exp_year     => 'year',
	cvn          => 'security_code',
	csc          => 'security_code',
	cvv2         => 'security_code',
	cvc2         => 'security_code',
	cid          => 'security_code',
	credit_card  => 'account_number',
	card_type    => 'card_type_code',
);

around BUILDARGS => sub {
	my $orig = shift;
	my $self = shift;

	my $args = $self->$orig( @_ );

	return $args if defined $args->{card};

	load_class 'Carp';
	Carp::carp 'DEPRECATED: '
		. 'pass a Business::CyberSource::RequestPart::CreditCardInfo to '
		. 'purchase_totals '
		. 'or pass a constructor hashref to bill_to as it is coerced from '
		. 'hashref.'
		;

	my %newargs = map {(( $map{$_} || $_ ), $args->{$_})} keys %$args;

	my %cc_map = (
		account_number => 1,
		security_code  => 1,
	);

	my %ccexp_map = (
		month => 1,
		year  => 1,
	);

	my %card
		= map {
			defined $cc_map{$_} ? ( $_, delete $newargs{$_} ) : ()
		} keys %newargs;

	my %expiration
		= map {
			defined $ccexp_map{$_} ? ( $_, delete $newargs{$_} ) : ()
		} keys %newargs;

	$newargs{card           }  = \%card       if keys %card;
	$newargs{card}{expiration} = \%expiration if keys %expiration;

	return \%newargs;
};

before [ keys %map ] => sub {
	load_class('Carp');
	Carp::carp 'DEPRECATED: '
		. 'call attribute methods ( ' . join( ' ', keys %map ) . ' ) on '
		. 'Business::CyberSource::RequestPart::BillTo via bill_to directly'
		;
};

has card => (
	isa         => Card,
	remote_name => 'card',
	required    => 1,
	is          => 'ro',
	coerce      => 1,
	handles     => \%map,
);

1;

# ABSTRACT: credit card info role


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::CreditCardInfo - credit card info role

=head1 VERSION

version 0.005005

=head1 ATTRIBUTES

=head2 card

L<Business::CyberSource::RequestPart::Card>

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

