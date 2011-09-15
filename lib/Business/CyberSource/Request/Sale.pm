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

		$res
			= Business::CyberSource::Response
			->with_traits( @traits )
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				request_token  => $r->{requestToken},
				auth_record    => $r->{ccAuthReply}->{authRecord},
				processor_response =>
					$r->{ccAuthReply}->{processorResponse},
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
