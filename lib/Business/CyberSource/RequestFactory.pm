package Business::CyberSource::RequestFactory;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004006'; # VERSION

use MooseX::AbstractFactory;
implementation_class_via sub { 'Business::CyberSource::Request::' . shift };

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: CyberSource Request Factory Module


__END__
=pod

=head1 NAME

Business::CyberSource::RequestFactory - CyberSource Request Factory Module

=head1 VERSION

version 0.004006

=head1 SYNOPSIS

	use Business::CyberSource::RequestFactory;

	my $factory = Business::CyberSource::RequestFactory->new;

	my $request_obj = $request_factory->create(
		'Authorization',
		{
			reference_code => '42',
			first_name     => 'Caleb',
			last_name      => 'Cushing',
			street         => 'somewhere',
			city           => 'Houston',
			state          => 'TX',
			zip            => '77064',
			country        => 'US',
			email          => 'xenoterracide@gmail.com',
			total          => 5.00,
			currency       => 'USD',
			credit_card    => '4111111111111111',
			cc_exp_month   => '09',
			cc_exp_year    => '2013',
		}
	);

=head1 DESCRIPTION

This module provides a generic factory interface to creating request objects.
It also allows us to not repeat ourselves when specifying attributes that are
common to all requests such as authentication, and server destination.

=head1 ATTRIBUTES

=head1 METHODS

=head2 new

=head2 create

	$factory->create( $implementation, { ... } )

Create a new request object. C<create> takes a request implementation and a hashref to pass to the
implementation's C<new> method. The implementation string accepts any
implementation whose package name is prefixed by
C<Business::CyberSource::Request::>.

	my $req = $factory->create(
			'Capture',
			{
				first_name => 'John',
				last_name  => 'Smith',
				...
			}
		);

=head1 SEE ALSO

=over

=item * L<MooseX::AbstractFactory>

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

