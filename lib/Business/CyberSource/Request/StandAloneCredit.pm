package Business::CyberSource::Request::StandAloneCredit;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource';
extends 'Business::CyberSource::Request::Credit';
with qw(
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::StandAloneCredit;

	my $req = Business::CyberSource::Request::StandAloneCredit->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'merchant reference code',
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

	my $res = $req->submit;

=head1 DESCRIPTION

This object allows you to create a request for a standalone credit.

=method new

Instantiates a credit request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
