package Business::CyberSource::Request::Role::DCC;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::SetOnce 0.200001;

with qw(
	Business::CyberSource::Role::ForeignCurrency
);

use MooseX::Types::CyberSource qw( DCCIndicator );

has dcc_indicator => (
	isa       => DCCIndicator,
	traits    => [ 'SetOnce' ],
	is        => 'rw',
	predicate => 'has_dcc_indicator',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{dcc}{dccIndicator} = $self->dcc_indicator;
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
