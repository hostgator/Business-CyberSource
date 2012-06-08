package Business::CyberSource::Request::Role::DCC;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::SetOnce 0.200001;
use MooseX::Aliases;

with qw(
	Business::CyberSource::Role::ForeignCurrency
);

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

=head2 composes

=over

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=attr dcc_indicator

=cut
