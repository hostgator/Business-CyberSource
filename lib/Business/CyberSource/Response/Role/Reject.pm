package Business::CyberSource::Response::Role::Reject;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose::Role;
use MooseX::Types::Varchar qw( Varchar );

has request_token => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[256],
);

1;

# ABSTRACT: role for handling rejected transactions

=head1 DESCRIPTION

This trait is applied if the decision is C<REJECT>

=head1 ATTRIBUTES

=head2 request_token

The field is an encoded string that contains no confidential information,
such as an account number or card verification number. The string can contain
up to 256 characters.

=cut
