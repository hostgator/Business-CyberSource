package Business::CyberSource::Response::Role::ReasonCode;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load qw( load );

our $VERSION = '0.007007'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::Common::String 0.001005 qw( NumericCode );

has reason_code => (
	isa         => NumericCode,
	remote_name => 'reasonCode',
	required    => 1,
	is          => 'ro',
	predicate   => 'has_reason_code',
);

sub has_request_specific_reason_code {
	my $self = shift;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call has_reason_code';

	return $self->has_reason_code
}

sub request_specific_reason_code {
	my $self = shift;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call reason_code';

	return $self->reason_code
}

1;
# ABSTRACT: Role for ReasonCode

__END__

=pod

=head1 NAME

Business::CyberSource::Response::Role::ReasonCode - Role for ReasonCode

=head1 VERSION

version 0.007007

=for Pod::Coverage request_specific_reason_code has_request_specific_reason_code

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
