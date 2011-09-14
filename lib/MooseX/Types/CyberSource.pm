package MooseX::Types::CyberSource;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use MooseX::Types -declare => [ qw(
	Decision
	CardTypeCode
	CvIndicator
	Item
) ];

use MooseX::Types::Moose qw( Int Num Str );
use MooseX::Types::Structured qw( Dict Optional );

enum Decision, [ qw( ACCEPT REJECT ERROR REVIEW ) ];

# can't find a standard on this, so I assume these are a cybersource thing
enum CardTypeCode, [ qw(
	001
	002
	003
	004
	005
	006
	007
	014
	021
	024
	031
	033
	034
	035
	036
	037
	039
	040
	042
	043
) ];

enum CvIndicator, [ qw( 0 1 2 9 ) ];

subtype Item,
	as Dict[
		unit_price => Num,
		quantity   => Int,
	];

1;

# ABSTRACT: Moose Types specific to CyberSource

=head1 SYNOPSIS

	{
		package My::CyberSource::Response;
		use Moose;
		use MooseX::Types::CyberSource qw( Decision );

		has decision => (
			is => 'ro',
			isa => Decision,
		);
		__PACKAGE__->meta->make_immutable;
	}

	my $response = My::CyberSource::Response->new({
		decison => 'ACCEPT'
	});

=head1 DESCRIPTION

This module provides CyberSource specific Moose Types.

=head1 TYPES

=over

=item * C<Decision>

Base Type: C<enum>

CyberSource Response Decision

=item * C<CardTypeCode>

Base Type: C<enum>

Numeric codes that specify Card types. Codes denoted with an asterisk* are
automatically detected when using
L<Business::CyberSource::Request::Role::CreditCardInfo>

=over

=item * 001: Visa*

=item * 002: MasterCard, Eurocard*

=item * 003: American Express*

=item * 004: Discover*

=item * 005: Diners Club

=item * 006: Carte Blanche

=item * 007: JCB*

=item * 014: EnRoute*

=item * 021: JAL

=item * 024: Maestro (UK Domestic)

=item * 031: Delta

=item * 033: Visa Electron

=item * 034: Dankort

=item * 035: Laser*

=item * 036: Carte Bleue

=item * 037: Carta Si

=item * 039: Encoded account number

=item * 040: UATP

=item * 042: Maestro (International)

=item * 043: Santander card

=back

=back

=cut
