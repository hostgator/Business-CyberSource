package Business::CyberSource::Request::Sale;
use strict;
use warnings;
use namespace::autoclean -also => [ qw( create ) ];

# VERSION

use Moose;
extends 'Business::CyberSource::Request::Authorization';

before serialize => sub {
	my $self = shift;
	$self->_request_data->{ccCaptureService}{run} = 'true';
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Sale Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Sale;

	my $req
		= Business::CyberSource::Request::Sale->new({
			reference_code => 't601',
			first_name     => 'Caleb',
			last_name      => 'Cushing',
			street         => 'somewhere',
			city           => 'Houston',
			state          => 'TX',
			zip            => '77064',
			country        => 'US',
			email          => 'xenoterracide@gmail.com',
			total          => 3000.00,
			currency       => 'USD',
			credit_card    => '4111-1111-1111-1111',
			cc_exp_month   => '09',
			cc_exp_year    => '2025',
		});

=head1 DESCRIPTION

A sale is a bundled authorization and capture. You can use a sale instead of a
separate authorization and capture if there is no delay between taking a
customer's order and shipping the goods. A sale is typically used for
electronic goods and for services that you can turn on immediately.

=head2 inherits

L<Business::CyberSource::Request::Authorization>

=cut
