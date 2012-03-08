package Business::CyberSource::Request::DCC;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.004004'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Role::ForeignCurrency
);

use Business::CyberSource::Response;
use MooseX::StrictConstructor;

sub submit {
	my $self = shift;

	$self->_request_data->{ccDCCService}{run} = 'true';

	my $r = $self->_build_request;

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::DCC
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				request_token  => $r->{requestToken},
				reference_code => $r->{merchantReferenceCode},
				exchange_rate  => $r->{purchaseTotals}{exchangeRate},
				exchange_rate_timestamp =>
					$r->{purchaseTotals}{exchangeRateTimeStamp},
				currency       => $r->{purchaseTotals}{currency},
				foreign_currency => $r->{purchaseTotals}{foreignCurrency},
				foreign_amount   => $r->{purchaseTotals}{foreignAmount},
				dcc_supported =>
					$r->{ccDCCReply}{dccSupported} eq 'TRUE' ? 1 : 0,
				valid_hours => $r->{ccDCCReply}{validHours},
				margin_rate_percentage =>
					$r->{ccDCCReply}{marginRatePercentage},
				request_specific_reason_code => "$r->{ccDCCReply}{reasonCode}",
			})
			;
	}
	else {
		$res = $self->_handle_decision( $r );
	}

	return $res;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::DCC - CyberSource DCC Request Object

=head1 VERSION

version 0.004004

=head1 SYNOPSIS

	my $CYBS_ID = 'myMerchantID';
	my $CYBS_KEY = 'transaction key generated with cybersource';

	use Business::CyberSource::Request;

	my $factory
		= Business::CyberSource::Request->new({
			username       => $CYBS_ID,
			password       => $CYBS_KEY,
			production     => 0,
		});

	my $dcc_req = $factory->create( 'DCC',
		{
			reference_code => '1984',
			currency       => 'USD',
			credit_card    => '5100870000000004',
			cc_exp_month   => '04',
			cc_exp_year    => '2012',
			total          => '1.00',
			foreign_currency => 'EUR',
		});

	my $dcc_res = $dcc_req->submit;

	my $auth_req = $factory->create( 'Authorization',
		{
			reference_code   => '1984',
			first_name       => 'Caleb',
			last_name        => 'Cushing',
			street           => 'somewhere',
			city             => 'Houston',
			state            => 'TX',
			zip              => '77064',
			country          => 'US',
			email            => 'xenoterracide@gmail.com',
			credit_card      => '5100870000000004',
			total            => '1.00',
			currency         => 'USD',
		 	foreign_currency => 'EUR',
			foreign_amount   => $dcc_res->foreign_amount,
			exchange_rate    => $dcc_res->exchange_rate,
			cc_exp_month     => '04',
			cc_exp_year      => '2012',
			dcc_indicator    => 1,
			exchange_rate_timestamp => $dcc_res->exchange_rate_timestamp,
		});

	my $auth_res = $auth_req->submit;

	my $cap_req = $factory->create( 'Capture',
		{
			reference_code   => '1984',
			total            => '1.00',
			currency         => 'USD',
			foreign_currency => 'EUR',
			foreign_amount   => $dcc_res->foreign_amount,
			exchange_rate    => $dcc_res->exchange_rate,
			dcc_indicator    => 1,
			request_id       => $auth_res->request_id,
			exchange_rate_timestamp => $dcc_res->exchange_rate_timestamp,
		});

	my $cap_res = $cap_req->submit;

	my $cred_req = $factory->create( 'FollowOnCredit',
		{
			reference_code   => '1984',
			total            => '1.00',
			currency         => 'USD',
			foreign_currency => 'EUR',
			foreign_currency => $dcc_res->foreign_currency,
			foreign_amount   => $dcc_res->foreign_amount,
			exchange_rate    => $dcc_res->exchange_rate,
			dcc_indicator    => 1,
			request_id       => $cap_res->request_id,
			exchange_rate_timestamp => $dcc_res->exchange_rate_timestamp,
		});

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.

=head1 METHODS

=head2 new

Instantiates a DCC request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

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

