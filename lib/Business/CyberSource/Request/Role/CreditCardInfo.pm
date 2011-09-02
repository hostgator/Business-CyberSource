package Business::CyberSource::Request::Role::CreditCardInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.0'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::Types::Moose      qw( Int        );
use MooseX::Types::Varchar    qw( Varchar    );
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode );

sub _cc_info {
	my $self = shift;

	my $cc = {
		accountNumber   => $self->credit_card,
		expirationMonth => $self->cc_exp_month,
		expirationYear  => $self->cc_exp_year,
	};

	if ( $self->cvn ) {
		$cc->{cvNumber   } = $self->cvn;
		$cc->{cvIndicator} = $self->cv_indicator;
	}

	return $cc;
}

has credit_card => (
	required => 1,
	is       => 'ro',
	isa      => CreditCard,
	coerce   => 1,
);

has card_type => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[3],
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
	isa      => Varchar[1],
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

1;

# ABSTRACT: credit card info role

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::CreditCardInfo - credit card info role

=head1 VERSION

version v0.2.0

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

