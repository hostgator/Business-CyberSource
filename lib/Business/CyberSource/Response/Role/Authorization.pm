package Business::CyberSource::Response::Role::Authorization;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::ProcessorResponse
	Business::CyberSource::Response::Role::AVS
	Business::CyberSource::Response::Role::CVN
);

use MooseX::SetOnce 0.200001;

use MooseX::Types::CyberSource qw( _VarcharSeven );

has auth_code => (
	isa       => _VarcharSeven,
	predicate => 'has_auth_code',
	traits    => ['SetOnce'],
	is        => 'rw',
);

has auth_record => (
	isa       => 'Str',
	predicate => 'has_auth_record',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: CyberSource Authorization Response only attributes

=head1 DESCRIPTION

If the transaction did Authorization then this role is applied

=head2 composes

=over

=item L<Business::CyberSource::Response::Role::ProcessorResponse>

=item L<Business::CyberSource::Response::Role::AVS>

=item L<Business::CyberSource::Response::Role::CVN>

=back

=attr auth_code

=attr auth_record

=cut
