package Business::CyberSource::Request::Sale;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request::Authorization';

use MooseX::Types::CyberSource qw( Service );

has capture_service => (
	isa      => Service,
	remote_name => 'ccCaptureService',
	is          => 'ro',
	lazy        => 1,
	coerce      => 1,
	reader      => undef,
	init_arg    => undef,
	builder     => '_build_service',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Sale Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Sale;

	my $req
		= Business::CyberSource::Request::Sale->new({
			reference_code => 't601',
			bill_to => {
				first_name  => 'Caleb',
				last_name   => 'Cushing',
				street      => 'somewhere',
				city        => 'Houston',
				state       => 'TX',
				postal_code => '77064',
				country     => 'US',
				email       => 'xenoterracide@gmail.com',
			},
			purchase_totals => {
				total    => 3000.00,
				discount => 50.00, # optional
				duty     => 10.00, # optional
				currency => 'USD',
			},
			card => {
				account_number => '4111-1111-1111-1111',
				expiration     => {
					month => 9,
					year  => 2025,
				},
			},
		});

=head1 DESCRIPTION

A sale is a bundled authorization and capture. You can use a sale instead of a
separate authorization and capture if there is no delay between taking a
customer's order and shipping the goods. A sale is typically used for
electronic goods and for services that you can turn on immediately.

=head1 EXTENDS

L<Business::CyberSource::Request::Authorization>

=attr capture_service

Sale does both authorization and capture and so needs another service
attribute. It is built for you and cannot be modified.

=cut
