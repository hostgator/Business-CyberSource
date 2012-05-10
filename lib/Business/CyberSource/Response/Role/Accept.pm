package Business::CyberSource::Response::Role::Accept;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::MerchantReferenceCode
);

use MooseX::SetOnce 0.200001;

use MooseX::Types::DateTime::W3C qw( DateTimeW3C );


has amount => (
	isa      => 'Num',
	traits   => ['SetOnce'],
	is       => 'rw',
);

has datetime => (
	isa      => DateTimeW3C,
	is       => 'rw',
	traits   => ['SetOnce'],
);

has request_specific_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
);

1;

# ABSTRACT: role for handling accepted transactions

=head1 DESCRIPTION

If the transaction has a C<decision> of C<ACCEPT> then this Role is applied.

=head2 composes

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::MerchantReferenceCode>

=back

=attr amount

=attr datetime

=attr request_specific_reason_code

=cut
