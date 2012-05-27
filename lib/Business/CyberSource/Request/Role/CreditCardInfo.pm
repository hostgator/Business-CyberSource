package Business::CyberSource::Request::Role::CreditCardInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::SetOnce 0.200001;
use MooseX::RemoteHelper;

use MooseX::Types::Moose      qw( Int HashRef );
use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode CreditCard);

use Moose::Util::TypeConstraints;

use Carp qw( cluck );
use Module::Runtime qw( use_module );

around BUILDARGS => sub {
	my $orig  = shift;
	my $class = shift;

	my $args = $class->$orig( @_ );

	unless ( defined $args->{card}
			&& blessed $args->{card}
			&& $args->{card}->isa('Business::CyberSource::CreditCard')
		) {

		my $deprecation_notice = 'please pass a '
			. 'Business::CyberSource::CreditCard to card '
			. 'in the constructor'
			;

		unless ( $args->{credit_card}
				&& $args->{cc_exp_month}
				&& $args->{cc_exp_year}
			) {
			confess $deprecation_notice;
		}
		else {
			our @CARP_NOT = ( __PACKAGE__ , 'Class::MOP::Method::Wrapped');
			cluck 'DEPRECATED: using credit_card, cc_exp_month, and '
				. 'cc_exp_year are deprecated. '
				. $deprecation_notice
				;
		}

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
	isa         => CreditCard,
	remote_name => 'card',
	required    => 1,
	is          => 'ro',
	coerce      => 1,
	handles     => {
		credit_card   => 'account_number',
		cvn           => 'security_code',
		full_name     => 'holder',
		has_cvn       => 'has_cvn',
		has_full_name => 'has_full_name',
		cc_exp_month  => sub { shift->card->expiration->month },
		cc_exp_year   => sub { shift->card->expiration->year  },
	},
);

1;

# ABSTRACT: credit card info role
