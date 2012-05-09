package Business::CyberSource::Request::Role::DCC;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

with qw(
	Business::CyberSource::Role::ForeignCurrency
);

use MooseX::Types::CyberSource qw( DCCIndicator );

has dcc_indicator => (
	required  => 0,
	predicate => 'has_dcc_indicator',
	is        => 'ro',
	isa       => DCCIndicator,
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
