package Business::CyberSource::Request::Sale;
use strict;
use warnings;
use namespace::autoclean;
use Carp;

# VERSION

use Moose;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Request::Role::BusinessRules
);

use Business::CyberSource::Response;
use MooseX::StrictConstructor;

sub submit {
	my $self = shift;
	my $payload = {
		billTo                => $self->_billing_info,
		card                  => $self->_cc_info,
		ccAuthService => {
			run => 'true',
		},
		ccCaptureService => {
			run => 'true',
		},
	};

	if ( keys $self->_business_rules ) {
		$payload->{businessRules} = $self->_business_rules;
	}

	my $r = $self->_build_request( $payload );

	my $res;
	if ( $r->{decision} eq 'ACCEPT' or $r->{decision} eq 'REJECT' ) {
		my @traits = qw(Business::CyberSource::Response::Role::Authorization);

		my $e = { };

		if ( $r->{decision} eq 'ACCEPT' ) {
			push( @traits, qw(
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::ReconciliationID
			));

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
		}

		if ( $r->{ccAuthReply}{processorResponse} ) {
			$e->{processor_response}
				= $r->{ccAuthReply}{processorResponse}
				;
		}

		if ( $r->{ccAuthReply}->{authRecord} ) {
			$e->{auth_record} = $r->{ccAuthReply}->{authRecord};
		}

		if ( $r->{ccCaptureReply}->{reconciliationID} ) {
			$e->{reconciliation_id} = $r->{ccCaptureReply}->{reconciliationID};
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

# ABSTRACT: Sale Request Object

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

=cut
