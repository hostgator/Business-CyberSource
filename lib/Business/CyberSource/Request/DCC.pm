package Business::CyberSource::Request::DCC;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

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

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.

=method new

Instantiates a DCC request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
