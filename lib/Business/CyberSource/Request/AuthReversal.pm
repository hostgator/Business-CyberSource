package Business::CyberSource::Request::AuthReversal;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request';

use MooseX::Types::CyberSource qw( AuthReversalService );

has '+service' => (
	isa         => AuthReversalService,
	remote_name => 'ccAuthReversalService',
	lazy_build  => 0,
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Reverse Authorization request object

=head1 SYNOPSIS

	use Business::CyberSource::Request::AuthReversal;

	my $req = Business::CyberSource::Request::AuthReversal->new({
		reference_code => 'orignal authorization merchant reference code',
		service        => {
			request_id => 'request id returned by authorization',
		},
		purchase_totals {
			total          => 5.00, # same as original authorization amount
			currency       => 'USD', # same as original currency
		},
	});

=head1 DESCRIPTION

This allows you to reverse an authorization request.

=head1 EXTENDS

L<Business::CyberSource::Request>

=cut
