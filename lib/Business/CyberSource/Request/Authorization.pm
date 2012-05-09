package Business::CyberSource::Request::Authorization;
use strict;
use warnings;
use namespace::autoclean -also => [ qw( create ) ];

our $VERSION = '0.004007'; # VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Request::Role::BusinessRules
	Business::CyberSource::Request::Role::DCC
);

before serialize => sub {
	my $self = shift;
	$self->_request_data->{ccAuthService}{run} = 'true';
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Request object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization Request object

=head1 VERSION

version 0.004007

=head1 SYNOPSIS

	use Business::CyberSource::Request::Authorization;

	my $req = Business::CyberSource::Request::Authorization->new({
		reference_code => '42',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '100 somewhere st',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

	# or if you want to use items instead of just giving a total

	my $oreq = Business::CyberSource::Request::Authorization->new({
		reference_code => '42',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '100 somewhere st',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		currency       => 'USD',
		items          => [
			{
				unit_price => 1000.00,
				quantity   => 2,
			},
			{
				unit_price => 1000.00,
				quantity   => 1,
			},
		],
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

=head1 DESCRIPTION

Offline authorization means that when you submit an order using a credit card,
you will not know if the funds are available until you capture the order and
receive confirmation of payment. You typically will not ship the goods until
you receive this payment confirmation. For offline credit cards, it will take
typically five days longer to receive payment confirmation than for online
cards.

=head2 inherits

L<Business::CyberSource::Request>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::BillingInfo>

=item L<Business::CyberSource::Request::Role::PurchaseInfo>

=item L<Business::CyberSource::Request::Role::CreditCardInfo>

=item L<Business::CyberSource::Request::Role::BusinessRules>

=item L<Business::CyberSource::Request::Role::DCC>

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

