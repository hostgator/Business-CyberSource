package Business::CyberSource::CreditCard;
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

=cut
