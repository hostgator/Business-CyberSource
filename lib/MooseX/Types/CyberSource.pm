package MooseX::Types::CyberSource;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.4.0'; # VERSION

use MooseX::Types -declare => [ qw(
	AVSResult
	CardTypeCode
	CountryCode
	CvIndicator
	CvResults
	DCCIndicator
	Decision
	Item
) ];

use MooseX::Types::Common::Numeric qw( PositiveOrZeroNum );
use MooseX::Types::Moose qw( Int Num Str );
use MooseX::Types::Structured qw( Dict Optional );
use Locale::Country;
use MooseX::Types::Locale::Country qw( Alpha2Country Alpha3Country CountryName );

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
		unit_price   => PositiveOrZeroNum,
		quantity     => Int,
		product_code => Optional[Str],
		product_name => Optional[Str],
		product_sku  => Optional[Str],
		product_risk => Optional[Str],
		tax_amount   => Optional[PositiveOrZeroNum],
		tax_rate     => Optional[PositiveOrZeroNum],
		national_tax => Optional[PositiveOrZeroNum],
	];

enum CvResults, [ qw( D I M N P S U X 1 2 3 ) ];

enum AVSResult, [ qw( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 ) ];

subtype CountryCode,
	as Alpha2Country
	;

coerce CountryCode,
	from Alpha3Country,
	via {
		return uc country_code2code( $_ , LOCALE_CODE_ALPHA_3, LOCALE_CODE_ALPHA_2 );
	}
	;

coerce CountryCode,
	from CountryName,
	via {
		return uc country2code( $_, LOCALE_CODE_ALPHA_2 );
	}
	;

enum DCCIndicator, [ qw( 1 2 3 ) ];

1;

# ABSTRACT: Moose Types specific to CyberSource


__END__
=pod

=head1 NAME

MooseX::Types::CyberSource - Moose Types specific to CyberSource

=head1 VERSION

version v0.4.0

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

=begin Pod::Coverage

LOCALE_CODE_ALPHA_2

LOCALE_CODE_ALPHA_3

=end Pod::Coverage

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

=item * C<CvResults>

Base Type: C<enum>

Single character code that defines the result of having sent a CVN. See
L<CyberSource's Documentation on Card Verification Results
|http://www.cybersource.com/support_center/support_documentation/quick_references/view.php?page_id=421>
for more information.

=item * C<AVSResults>

Base Type: C<enum>

Single character code that defines the result of having sent a CVN. See
L<CyberSource's Documentation on AVS Results
|http://www.cybersource.com/support_center/support_documentation/quick_references/view.php?page_id=423>
for more information.

=item * C<DCCIndicator>

Base Type: C<enum>

Single character code that defines the DCC status

=over

=item * C<1>

Converted - DCC is being used.

=item * C<2>

Non-convertible - DCC cannot be used.

=item * C<3>

Declined - DCC could be used, but the customer declined it.

=back

=item * C<Item>

Base Type: C<Dict>

Here's the current list of valid keys and their types for the Dictionary

	unit_price   => PositiveOrZeroNum,
	quantity     => Int,
	product_code => Optional[Str],
	product_name => Optional[Str],
	product_sku  => Optional[Str],
	product_risk => Optional[Str],
	tax_amount   => Optional[PositiveOrZeroNum],
	tax_rate     => Optional[PositiveOrZeroNum],
	national_tax => Optional[PositiveOrZeroNum],

=back

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

