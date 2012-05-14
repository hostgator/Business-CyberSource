package Business::CyberSource::Request::Role::CreditCardInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose      qw( Int HashRef );
use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode CreditCard);

use Moose::Util::TypeConstraints;

use Module::Runtime qw( use_module );

around BUILDARGS => sub {
	my $orig  = shift;
	my $class = shift;

	my $args = $class->$orig( @_ );

	unless ( defined $args->{card}
		&& blessed $args->{card}
		&& $args->{card}->isa('Business::CyberSource::CreditCard')
		) {
			my %cc_args = (
				account_number => delete $args->{credit_card},
				expiration     => {
					month => delete $args->{cc_exp_month},
					year  => delete $args->{cc_exp_year},
				},
			);

			$cc_args{security_code}
				=  delete  $args->{cvn}
				if defined $args->{cvn}
				;

			$cc_args{holder}
				=  delete  $args->{full_name}
				if defined $args->{full_name}
				;

			$args->{card}
				= use_module('Business::CyberSource::CreditCard')
				->new( \%cc_args )
				;
	}

	return $args;
};

has card => (
	isa      => CreditCard,
	required => 1,
	is       => 'ro',
	coerce   => 1,
	handles  => {
		credit_card   => 'account_number',
		cvn           => 'security_code',
		full_name     => 'holder',
		has_cvn       => 'has_cvn',
		has_full_name => 'has_full_name',
		cc_exp_month  => sub { shift->card->expiration->month },
		cc_exp_year   => sub { shift->card->expiration->year  },
	},
	trigger  => sub {
		my $self = shift;

		my $card = $self->card;

		my %ccinfo = (
			accountNumber   => $card->account_number,
			cardType        => $self->card_type,
			expirationMonth => $card->expiration->month,
			expirationYear  => $card->expiration->year,
		);

		$ccinfo{cvIndicator}
			= $self->has_cv_indicator  ? $self->cv_indicator
			: $card->has_security_code ? 1
			:                            0
			;

		$ccinfo{cvNumber} = $card->security_code if $card->has_security_code;

		$ccinfo{fullName} = $card->holder if $card->has_holder;

		$self->_request_data->{card} = \%ccinfo;
	},
);

has card_type => (
	lazy      => 1,
	is        => 'ro',
	isa       => CardTypeCode,
	builder   => '_build_card_type',
);

has cv_indicator => (
	isa       => CvIndicator,
	predicate => 'has_cv_indicator',
	traits    => [ 'SetOnce' ],
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{card}{cvIndicator} = $self->cv_indicator;
	},
);

sub _build_card_type {
	my $self = shift;

	my $ct = $self->card->type;

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

	confess $ct . ' card_type was unable to be detected please define it manually'
		unless $code;

	return $code;
}

1;

# ABSTRACT: credit card info role

=attr card_type

Type of card to authorize, e.g. Visa, MasterCard

=attr credit_card

Customer's credit card number

=attr cvn

B<alias:> cvv cvv2  cvc2 cid

Card Verification Numbers

=attr full_name

Full Name on the Credit Card

=attr cc_exp_month

Two-digit month that the credit card expires in. Format: MM

=attr cc_exp_year

Four-digit year that the credit card expires in. Format: YYYY

=attr cv_indicator

Flag that indicates whether a CVN code was sent

=cut
