package Business::CyberSource::ResponsePart::DCCReply;
use strict;
use warnings;
use Module::Load 'load';
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
);

use MooseX::Types::CyberSource qw( DCCSupported );

sub has_dcc_supported {
	my $self = shift;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call has_supported';

	return $self->has_supported;
}

sub dcc_supported {
	my $self = shift;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call supported';

	return $self->supported;
}

has supported => (
	isa         => DCCSupported,
	remote_name => 'dccSupported',
	is          => 'ro',
	coerce      => 1,
	required    => 1,
	predicate   => 'has_supported',
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

=attr supported

B<Type:> C<Bool>

=attr margin_rate_percentage

B<Type:> C<Num>

=attr valid_hours

B<Type:> C<Int>

=cut
