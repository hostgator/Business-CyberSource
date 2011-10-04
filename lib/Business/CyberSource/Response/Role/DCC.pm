package Business::CyberSource::Response::Role::DCC;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.8'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Response::Role::Accept
);

use MooseX::Types::Moose qw( Num Bool Str Int );

has foreign_amount => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has dcc_supported => (
	required => 1,
	is       => 'ro',
	isa      => Bool
);

has exchange_rate => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has exchange_rate_timestamp => (
	required => 1,
	is       => 'ro',
	isa      => Str,
);

has valid_hours => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

has margin_rate_percentage => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

1;

# ABSTRACT: Role that provides attributes specific to responses for DCC

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::DCC - Role that provides attributes specific to responses for DCC

=head1 VERSION

version v0.3.8

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

