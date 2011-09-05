package Business::CyberSource::Request::Role::CreditCardInfo;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

our $VERSION = 'v0.2.3'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::Types::Moose      qw( Int        );
use MooseX::Types::Varchar    qw( Varchar    );
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode );
use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode );

use Business::CreditCard;

sub _cc_info {
	my $self = shift;

	my $i = {
		accountNumber   => $self->credit_card,
		expirationMonth => $self->cc_exp_month,
		expirationYear  => $self->cc_exp_year,
		cardType        => $self->card_type,
	};

	if ( $self->cvn ) {
		$i->{cvNumber   } = $self->cvn;
		$i->{cvIndicator} = $self->cv_indicator;
	}

	return $i;
}

has credit_card => (
	required => 1,
	is       => 'ro',
	isa      => CreditCard,
	coerce   => 1,
);

has card_type => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => CardTypeCode,
	builder  => '_build_card_type',
);

has cc_exp_month => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

has cc_exp_year => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

has cv_indicator => (
	required => 0,
	init_arg => undef,
	lazy     => 1,
	is       => 'ro',
	isa      => CvIndicator,
	default  => sub {
		my $self = shift;
		if ( $self->cvn ) {
			return 1;
		} else {
			return 0;
		}
	},
	documentation => 'Flag that indicates whether a CVN code was sent'
);

has cvn => (
	required => 0,
	alias    => [ qw( cvv cvv2  cvc2 cid ) ],
	is       => 'ro',
	isa      => CardSecurityCode,
);

sub _build_card_type {
	my $self = shift;

	my $ct = Business::CreditCard->cardtype( $self->credit_card );

	my $code
		= $ct =~ /visa            /ixms ? '001'
		: $ct =~ /mastercard      /ixms ? '002'
		: $ct =~ /american express/ixms ? '003'
		: $ct =~ /discover        /ixms ? '004'
		: $ct =~ /jcb             /ixms ? '007'
		: $ct =~ /enroute         /ixms ? '014'
		: $ct =~ /laser           /ixms ? '035'
		:                                 undef
		;

	croak 'card_type was unable to be detected please define it manually'
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

version v0.2.3

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

