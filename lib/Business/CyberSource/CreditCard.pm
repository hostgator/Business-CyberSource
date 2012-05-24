package Business::CyberSource::CreditCard;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

use Moose;

use MooseX::Aliases;
use MooseX::SetOnce 0.200001;

use MooseX::Types -declare => [qw( ExpirationDate )];
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode );
use MooseX::Types::Moose    qw( HashRef  );
use MooseX::Types::DateTime;
use MooseX::Types::Common::String qw( NonEmptySimpleStr );

use Business::CreditCard qw( cardtype );
use Module::Runtime qw( use_module );
use DateTime 0.74;


sub _build_type {
	my $self = shift;

	my $ct = cardtype( $self->account_number );

	confess $ct if $ct =~ /not a credit card/ixms;

	$ct =~ s/[\s]card//xms;

	return uc $ct;
}

sub _build_expired {
	my $self = shift;

	return $self->_compare_date_against_expiration( DateTime->now );
}

sub _compare_date_against_expiration { ## no critic (Subroutines::RequireFinalReturn)
	my ( $self, $date ) = @_;

	my $exp = $self->expiration->clone;
	# add 2 days so that we allow for a 24 hour period where
	# the card could be expired at UTC but not the issuer
	$exp->add( days => 1 );

	my $cmp = DateTime->compare( $date, $exp );

	given ( $cmp ) {
		when ( -1 ) { # current date is before than the expiration date
			return 0;
		}
		when ( 0 ) { # expiration equal to current date
			return 0;
		}
		when ( 1 ) { # current date is past the expiration date
			return 1;
		}
	}
}

subtype ExpirationDate, as MooseX::Types::DateTime::DateTime;
coerce ExpirationDate,
	from HashRef,
	via {
		return DateTime->last_day_of_month( %{ $_ } );
	};

has account_number => (
	isa      => CreditCard,
	alias    => [ qw( credit_card_number card_number ) ],
	required => 1,
	is       => 'ro',
	coerce   => 1,
	trigger  => sub { shift->type },
);

has type => (
	isa       => 'Str',
	lazy      => 1,
	is        => 'ro',
	builder   => '_build_type',
);

has expiration => (
	isa      => ExpirationDate,
	required => 1,
	is       => 'ro',
	coerce   => 1,
);

has is_expired => (
	isa      => 'Bool',
	builder  => '_build_expired',
	lazy     => 1,
	is       => 'ro',
);

has security_code => (
	isa       => CardSecurityCode,
	alias     => [ qw( cvn cvv cvv2 cvc2 cid ) ],
	predicate => 'has_security_code',
	traits    => [ 'SetOnce' ],
	is        => 'rw',
);

has holder => (
	isa       => NonEmptySimpleStr,
	alias     => [ qw( name full_name card_holder ) ],
	predicate => 'has_holder',
	traits    => [ 'SetOnce' ],
	is        => 'rw',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: A Credit Card Value Object


__END__
=pod

=head1 NAME

Business::CyberSource::CreditCard - A Credit Card Value Object

=head1 VERSION

version 0.005004

=head1 DESCRIPTION

This is a generic Credit Card object, it can be use outside of
L<Business::CyberSource> and will probably someday be split out of this
distribution and have a new namespace.

=head1 ATTRIBUTES

=head2 account_number

This is the Credit Card Number

=head2 type

The card issuer, e.g. VISA, MasterCard. it is generated from the card number.

=head2 expiration

	my $card = Business::CyberSource::CreditCard->new({
			account_number => '4111111111111111',
			expiration     => {
				year  => '2025',
				month => '04',
			},
		});

A DateTime object, you should construct it by passing a hashref with keys for
month, and year, it will actually contain the last day of that month/year.

=head2 is_expired

Boolean, returns true if the card is older than
L<expiration date|/"expiration"> plus one day. This is done to compensate for
unknown issuer time zones as we can't be sure that all issuers shut cards of on
the first of every month UTC. In fact I have been told that some issuers will
allow renewed cards to be run with expired dates. Use this at your discretion.

=head2 security_code

The 3 digit security number on the back of the card.

=head2 holder

The full name of the card holder as printed on the card.

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

