package Business::CyberSource::Response::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;
with 'Business::CyberSource::Response';

has request_token => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has auth_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

has avs_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has avs_code_raw => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);


has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has auth_record => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Response object

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Authorization - CyberSource Authorization Response object

=head1 VERSION

version v0.1.0

=head1 ATTRIBUTES

=head2 avs_code_raw

Reader: avs_code_raw

Type: Str

This attribute is required.

=head2 avs_code

Reader: avs_code

Type: Str

This attribute is required.

=head2 datetime

Reader: datetime

Type: Str

This attribute is required.

=head2 auth_code

Reader: auth_code

Type: Num

This attribute is required.

=head2 currency

Reader: currency

Type: Str

This attribute is required.

=head2 request_id

Reader: request_id

Type: Str

This attribute is required.

=head2 processor_response

Reader: processor_response

Type: Str

This attribute is required.

=head2 auth_record

Reader: auth_record

Type: Str

This attribute is required.

=head2 decision

Reader: decision

Type: Str

This attribute is required.

=head2 reason_code

Reader: reason_code

Type: Int

This attribute is required.

=head2 request_token

Reader: request_token

Type: Str

This attribute is required.

=head2 amount

Reader: amount

Type: Num

This attribute is required.

=head2 reference_code

Reader: reference_code

Type: Str

This attribute is required.

=head1 METHODS

=head2 avs_code_raw

Method originates in Business::CyberSource::Response::Authorization.

=head2 avs_code

Method originates in Business::CyberSource::Response::Authorization.

=head2 new

Method originates in Business::CyberSource::Response::Authorization.

=head2 reference_code

Method originates in Business::CyberSource::Response::Authorization.

=head2 datetime

Method originates in Business::CyberSource::Response::Authorization.

=head2 auth_code

Method originates in Business::CyberSource::Response::Authorization.

=head2 currency

Method originates in Business::CyberSource::Response::Authorization.

=head2 request_id

Method originates in Business::CyberSource::Response::Authorization.

=head2 processor_response

Method originates in Business::CyberSource::Response::Authorization.

=head2 auth_record

Method originates in Business::CyberSource::Response::Authorization.

=head2 decision

Method originates in Business::CyberSource::Response::Authorization.

=head2 reason_code

Method originates in Business::CyberSource::Response::Authorization.

=head2 request_token

Method originates in Business::CyberSource::Response::Authorization.

=head2 amount

Method originates in Business::CyberSource::Response::Authorization.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

