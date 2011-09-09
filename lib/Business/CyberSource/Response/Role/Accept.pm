package Business::CyberSource::Response::Role::Accept;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.5'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
);

use MooseX::Types::Moose         qw( Num Int );
use MooseX::Types::Varchar       qw( Varchar );
use MooseX::Types::DateTime::W3C qw( DateTimeW3C );


has amount => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has datetime => (
	required => 1,
	is       => 'ro',
	isa      => DateTimeW3C,
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

has request_specific_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => Int,
	documentation => 'every sucessful request also has a reason code '
		. 'specific to its request type, e.g. for capture this is the '
		. 'ccCaptureReply_reasonCode',
);

1;

# ABSTRACT: role for handling accepted transactions


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Accept - role for handling accepted transactions

=head1 VERSION

version v0.2.5

=head1 DESCRIPTION

If the transaction has a C<decision> of approved then this Role is applied.

=head1 ATTRIBUTES

=head2 amount

Type: Num

Amount that was approved.

=head2 currency

Type: MooseX::Types::Locale::Currency

Currency code which was used to make the request

=head2 datetime

Type: MooseX::Types::DateTime::W3C::DateTimeW3C

Request timestamp (will probably become a DateTime object at some point)

=head2 reference_code

Type: MooseX::Types::Varchar::Varchar[50]

The merchant reference code originally sent

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

