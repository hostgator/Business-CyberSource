package Business::CyberSource::Request::Role::DCC;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::SetOnce 0.200001;

with 'Business::CyberSource::Role::ForeignCurrency';

use MooseX::Types::CyberSource qw( DCCIndicator );

has dcc_indicator => (
	isa         => DCCIndicator,
	remote_name => 'dcc',
	predicate   => 'has_dcc_indicator',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
	serializer  => sub {
		my ( $attr, $instance ) = @_;
		return { dccIndicator => $attr->get_value( $instance ) };
	},
);

1;

# ABSTRACT: Role for DCC follow up requests

=head1 DESCRIPTION

=head1 WITH

=over

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=attr dcc_indicator

Flag that indicates whether DCC is being used for the transaction.

This field is required if you called the DCC service for the purchase.

Possible values:

=over

=item 1: Converted

DCC is being used.

=item 2: Nonconvertible

DCC cannot be used.

=item 3: Declined

DCC could be used, but the customer declined it.

=back

=cut
