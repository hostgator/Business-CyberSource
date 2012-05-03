package Business::CyberSource::Request::Sale;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004004'; # VERSION

use Moose;
extends 'Business::CyberSource::Request::Authorization';

before serialize => sub {
	my $self = shift;
	$self->_request_data->{ccCaptureService}{run} = 'true';
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Sale Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Sale - Sale Request Object

=head1 VERSION

version 0.004004

=head1 SYNOPSIS

	use Business::CyberSource::Request::Sale;

	my $req
		= Business::CyberSource::Request::Sale->new({
			username       => 'merchantID',
			password       => 'transaction key',
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
			production     => 0,
		});

	my $res = $req->submit;

=head1 DESCRIPTION

A sale is a bundled authorization and capture. You can use a sale instead of a
separate authorization and capture if there is no delay between taking a
customer's order and shipping the goods. A sale is typically used for
electronic goods and for services that you can turn on immediately.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Response>

=back

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

