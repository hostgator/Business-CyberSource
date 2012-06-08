package Business::CyberSource::CreditCard;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Card';

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: A Credit Card Value Object

=head1 DESCRIPTION

Just a L<Business::CyberSource::RequestPart::Card>, use that instead.

=attr account_number

This is the Credit Card Number

=attr type

The card issuer, e.g. VISA, MasterCard. it is generated from the card number.

=attr expiration

	my $card = Business::CyberSource::CreditCard->new({
			account_number => '4111111111111111',
			expiration     => {
				year  => '2025',
				month => '04',
			},
		});

A DateTime object, you should construct it by passing a hashref with keys for
month, and year, it will actually contain the last day of that month/year.

=attr is_expired

Boolean, returns true if the card is older than
L<expiration date|/"expiration"> plus one day. This is done to compensate for
unknown issuer time zones as we can't be sure that all issuers shut cards of on
the first of every month UTC. In fact I have been told that some issuers will
allow renewed cards to be run with expired dates. Use this at your discretion.

=attr security_code

The 3 digit security number on the back of the card.

=attr holder

The full name of the card holder as printed on the card.

=cut
