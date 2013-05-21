package Business::CyberSource::Message;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Role::MerchantReferenceCode
);

has trace => (
	isa       => 'XML::Compile::SOAP::Trace',
	predicate => 'has_trace',
	traits    => [ 'SetOnce' ],
	is        => 'rw',
	writer    => '_trace',
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

=attr trace

A L<XML::Compile::SOAP::Trace> object which is populated only after the object
has been submitted to CyberSource by a L<Business::CyberSource::Client>.

=cut
