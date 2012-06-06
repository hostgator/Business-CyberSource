package Business::CyberSource::Request::Role::DCC;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

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


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::DCC - Role for DCC follow up requests

=head1 VERSION

version 0.005004

=head1 DESCRIPTION

=head2 composes

=over

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=head1 ATTRIBUTES

=head2 dcc_indicator

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

