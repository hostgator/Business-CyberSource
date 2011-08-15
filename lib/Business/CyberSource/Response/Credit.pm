package Business::CyberSource::Response::Credit;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;
with 'Business::CyberSource::Response';

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: CyberSource Credit Response object

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Credit - CyberSource Credit Response object

=head1 VERSION

version v0.1.0

=head1 ATTRIBUTES

=head2 reconciliation_id

Reader: reconciliation_id

Type: Str

This attribute is required.

This documentation was automatically generated.

=head2 datetime

Reader: datetime

Type: Str

This attribute is required.

This documentation was automatically generated.

=head2 currency

Reader: currency

Type: Str

This attribute is required.

This documentation was automatically generated.

=head2 request_id

Reader: request_id

Type: Str

This attribute is required.

This documentation was automatically generated.

=head2 decision

Reader: decision

Type: Str

This attribute is required.

This documentation was automatically generated.

=head2 reason_code

Reader: reason_code

Type: Int

This attribute is required.

This documentation was automatically generated.

=head2 amount

Reader: amount

Type: Num

This attribute is required.

This documentation was automatically generated.

=head2 reference_code

Reader: reference_code

Type: Str

This attribute is required.

This documentation was automatically generated.

=head1 METHODS

=head2 reconciliation_id

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 reference_code

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 datetime

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 currency

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 request_id

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 decision

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 reason_code

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

=head2 amount

Method originates in Business::CyberSource::Response::Credit.

This documentation was automaticaly generated.

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

