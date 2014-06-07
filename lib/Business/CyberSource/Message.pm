package Business::CyberSource::Message;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Role::Traceable
	Business::CyberSource::Role::MerchantReferenceCode
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Message Class;

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head1 WITH

=over

=item L<Business::CyberSource::Role::MerchantReferenceCode>

=back

