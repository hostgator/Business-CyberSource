package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;
use Carp;

# VERSION

use Moose;
extends 'Business::CyberSource';
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Request::Role::BusinessRules
	Business::CyberSource::Request::Role::DCC
);

use Business::CyberSource::Response;
use MooseX::StrictConstructor;

sub submit {
	my $self = shift;

	$self->_request_data->{ccAuthService}{run} = 'true';

	my $r = $self->_build_request;

	my $res;
	if ( $r->{decision} eq 'ACCEPT' or $r->{decision} eq 'REJECT' ) {
		my @traits = qw(Business::CyberSource::Response::Role::Authorization);

		my $e = { };

		if ( $r->{decision} eq 'ACCEPT' ) {
			push( @traits, 'Business::CyberSource::Response::Role::Accept' );
			$e->{currency      } = $r->{purchaseTotals}{currency};
			$e->{amount        } = $r->{ccAuthReply}->{amount};
			$e->{datetime      } = $r->{ccAuthReply}{authorizedDateTime};
			$e->{reference_code} = $r->{merchantReferenceCode};
			$e->{request_specific_reason_code}
				= "$r->{ccAuthReply}->{reasonCode}";
		}

		if ( $r->{ccAuthReply} ) {

			$e->{auth_code}
				=  $r->{ccAuthReply}{authorizationCode }
				if $r->{ccAuthReply}{authorizationCode }
				;


			if ( $r->{ccAuthReply}{cvCode}
					&& $r->{ccAuthReply}{cvCodeRaw}
				) {
				$e->{cv_code}     = $r->{ccAuthReply}{cvCode};
				$e->{cv_code_raw} = $r->{ccAuthReply}{cvCodeRaw};
			}

			if ( $r->{ccAuthReply}{avsCode}
					&& $r->{ccAuthReply}{avsCodeRaw}
				) {
				$e->{avs_code}     = $r->{ccAuthReply}{avsCode};
				$e->{avs_code_raw} = $r->{ccAuthReply}{avsCodeRaw};
			}
			if ( $r->{ccAuthReply}{processorResponse} ) {
				$e->{processor_response}
					= $r->{ccAuthReply}{processorResponse}
					;
			}

			if ( $r->{ccAuthReply}->{authRecord} ) {
				$e->{auth_record} = $r->{ccAuthReply}->{authRecord};
			}
		}

		$res
			= Business::CyberSource::Response
			->with_traits( @traits )
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				request_token  => $r->{requestToken},
			%{$e},
			})
			;
	}
	else {
		croak 'decision defined, but not sane: ' . $r->{decision};
	}

	return $res;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Request object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Authorization;

	my $req = Business::CyberSource::Request::Authorization->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
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

	my $response = $req->submit;

	# or if you want to use items instead of just giving a total

	my $oreq = Business::CyberSource::Request::Authorization->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
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

	my $oresponse = $oreq->submit;

=head1 DESCRIPTION

Offline authorization means that when you submit an order using a credit card,
you will not know if the funds are available until you capture the order and
receive confirmation of payment. You typically will not ship the goods until
you receive this payment confirmation. For offline credit cards, it will take
typically five days longer to receive payment confirmation than for online
cards.

=method new

Instantiates a request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
