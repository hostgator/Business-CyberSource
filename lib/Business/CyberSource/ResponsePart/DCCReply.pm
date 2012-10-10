package Business::CyberSource::ResponsePart::DCCReply;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
);

use MooseX::Types::CyberSource qw( DCCSupported );

has dcc_supported => (
	isa         => DCCSupported,
	remote_name => 'dccSupported',
	is          => 'ro',
	coerce      => 1,
	required    => 1,
	predicate   => 'has_dcc_supported',
);

has margin_rate_percentage => (
	isa         => 'Num',
	remote_name => 'marginRatePercentage',
	is          => 'ro',
	required    => 1,
	predicate   => 'has_margin_rate_percentage',
);

has valid_hours => (
	isa         => 'Int',
	remote_name => 'validHours',
	is          => 'ro',
	required    => 1,
	predicate   => 'has_valid_hours',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Reply section for DCC

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head2 WITH

=over

=item L<Business::CyberSource::Response::Role::ReasonCode>

=back

=attr dcc_supported

B<Type:> C<Bool>

=attr margin_rate_percentage

B<Type:> C<Num>

=attr valid_hours

B<Type:> C<Int>

=cut
