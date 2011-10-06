package Business::CyberSource::Request::Role::CreditCardInfo;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

our $VERSION = 'v0.3.9'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::Types::Moose      qw( Int HashRef );
use MooseX::Types::Varchar    qw( Varchar    );
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode );
use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode );

use Business::CreditCard qw( cardtype );

has full_name => (
	required  => 0,
	predicate => 'has_full_name',
	isa       => Varchar[60], # length is a guess by other max's
	documentation => 'full name on credit card',
);

has credit_card => (
	required => 1,
	alias    => 'account_number',
	is       => 'ro',
	isa      => CreditCard,
	coerce   => 1,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{accountNumber} = $self->credit_card;
		$self->_request_data->{card}{cardType}      = $self->card_type;
	},
	documentation => 'Customer\'s credit card number',
);

has card_type => (
	required  => 0,
	lazy      => 1,
	predicate => 'has_card_type',
	is        => 'ro',
	isa       => CardTypeCode,
	builder   => '_build_card_type',
	documentation => 'Type of card to authorize',
);

has cc_exp_month => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[2],
	alias    => [ qw( exp_month expiration_month ) ],
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{expirationMonth} = $self->cc_exp_month;
	},
	documentation => 'Two-digit month that the credit card expires '
		. 'in. Format: MM.',
);

has cc_exp_year => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[4],
	alias    => [ qw( exp_year expiration_year ) ],
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{expirationYear} = $self->cc_exp_year;
	},
	documentation => 'Four-digit year that the credit card expires in. '
		. 'Format: YYYY.',
);

has cv_indicator => (
	required => 0,
	init_arg => undef,
	lazy     => 1,
	is       => 'ro',
	isa      => CvIndicator,
	default  => sub {
		my $self = shift;
		if ( $self->has_cvn ) {
			return 1;
		} else {
			return 0;
		}
	},
	documentation => 'Flag that indicates whether a CVN code was sent'
);

has cvn => (
	required  => 0,
	alias     => [ qw( cvv cvv2  cvc2 cid ) ],
	predicate => 'has_cvn',
	is        => 'ro',
	isa       => CardSecurityCode,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{card}{cvNumber} = $self->cvn;
		$self->_request_data->{card}{cvIndicator} = $self->cv_indicator;
	},
	documentation => 'Card Verification Numbers',
);

sub _build_card_type {
	my $self = shift;

	my $ct = cardtype( $self->credit_card );

	my $code
		= $ct =~ /visa             /ixms ? '001'
		: $ct =~ /mastercard       /ixms ? '002'
		: $ct =~ /discover         /ixms ? '004'
		: $ct =~ /jcb              /ixms ? '007'
		: $ct =~ /enroute          /ixms ? '014'
		: $ct =~ /laser            /ixms ? '035'
		: $ct =~ /american\ express/ixms ? '003'
		:                                  undef
		;

	croak $ct . ' card_type was unable to be detected please define it manually'
		unless $code;

	return $code;
}

1;

# ABSTRACT: credit card info role

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::CreditCardInfo - credit card info role

=head1 VERSION

version v0.3.9

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

