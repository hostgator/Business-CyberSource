package Business::CyberSource::ResponsePart::Reply;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
	Business::CyberSource::Response::Role::ReconciliationID
	Business::CyberSource::Response::Role::Amount
	Business::CyberSource::Response::Role::ProcessorResponse
	Business::CyberSource::Response::Role::RequestDateTime
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Generic Reply part of response

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head1 WITH

=over

=item L<Business::CyberSource::Response::Role::ReasonCode>

=item L<Business::CyberSource::Response::Role::ReconciliationID>

=item L<Business::CyberSource::Response::Role::Amount>

=item L<Business::CyberSource::Response::Role::ProcessorResponse>

=item L<Business::CyberSource::Response::Role::RequestDateTime>

=back

=attr amount

=attr reason_code

=attr reconciliation_id

=attr processor_response

=attr datetime

=cut
