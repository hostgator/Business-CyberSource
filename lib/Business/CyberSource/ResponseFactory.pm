package Business::CyberSource::ResponseFactory;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::StrictConstructor;

use Module::Runtime qw( use_module );

sub create {
	my ( $self, $answer, $dto )  = @_;

	my $result = $answer->{result};

	my @traits;
	my $e = { };

	if ( $result->{decision} eq 'ACCEPT' or $result->{decision} eq 'REJECT' ) {
		my $prefix      = 'Business::CyberSource::';
		my $req_prefix  = $prefix . 'Request::';
		my $res_prefix  = $prefix . 'Response::';
		my $role_prefix = $res_prefix . 'Role::';

		if ( $result->{decision} eq 'ACCEPT' ) {
			push( @traits, $role_prefix .'Accept' );

			$e->{currency} = $result->{purchaseTotals}{currency};
			$e->{reference_code} = $result->{merchantReferenceCode};

			given ( $dto ) {
				when ( $_->isa( $req_prefix . 'Authorization') ) {
					$e->{amount        } = $result->{ccAuthReply}->{amount};
					$e->{datetime      } = $result->{ccAuthReply}{authorizedDateTime};
					$e->{request_specific_reason_code}
						= "$result->{ccAuthReply}->{reasonCode}";
					continue;
				}
				when ( $_->isa( $req_prefix . 'Capture')
					or $_->isa( $req_prefix . 'Sale' )
					) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $result->{ccCaptureReply}->{requestDateTime};
					$e->{amount}   = $result->{ccCaptureReply}->{amount};
					$e->{reconciliation_id}
						= $result->{ccCaptureReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$result->{ccCaptureReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'Credit') ) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $result->{ccCreditReply}->{requestDateTime};
					$e->{amount}   = $result->{ccCreditReply}->{amount};
					$e->{reconciliation_id} = $result->{ccCreditReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$result->{ccCreditReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'DCC') ) {
					push ( @traits, $role_prefix . 'DCC' );
					$e->{exchange_rate} = $result->{purchaseTotals}{exchangeRate};
					$e->{exchange_rate_timestamp}
						= $result->{purchaseTotals}{exchangeRateTimeStamp};
					$e->{foreign_currency}
						= $result->{purchaseTotals}{foreignCurrency};
					$e->{foreign_amount} = $result->{purchaseTotals}{foreignAmount};
					$e->{dcc_supported}
						= $result->{ccDCCReply}{dccSupported} eq 'TRUE' ? 1 : 0;
					$e->{valid_hours} = $result->{ccDCCReply}{validHours};
					$e->{margin_rate_percentage}
						= $result->{ccDCCReply}{marginRatePercentage};
					$e->{request_specific_reason_code}
						= "$result->{ccDCCReply}{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'AuthReversal' ) ) {
					push ( @traits, $role_prefix . 'ProcessorResponse' );

					$e->{datetime} = $result->{ccAuthReversalReply}->{requestDateTime};
					$e->{amount}   = $result->{ccAuthReversalReply}->{amount};

					$e->{request_specific_reason_code}
						= "$result->{ccAuthReversalReply}->{reasonCode}";
					$e->{processor_response}
						= $result->{ccAuthReversalReply}->{processorResponse};
				}
			}
		}

		if ( $dto->isa( $req_prefix . 'Authorization') ) {
				push( @traits, $role_prefix . 'Authorization' );
					if ( $result->{ccAuthReply} ) {

						$e->{auth_code}
							=  $result->{ccAuthReply}{authorizationCode }
							if $result->{ccAuthReply}{authorizationCode }
							;


						if ( $result->{ccAuthReply}{cvCode}
							&& $result->{ccAuthReply}{cvCodeRaw}
							) {
							$e->{cv_code}     = $result->{ccAuthReply}{cvCode};
							$e->{cv_code_raw} = $result->{ccAuthReply}{cvCodeRaw};
						}

						if ( $result->{ccAuthReply}{avsCode}
							&& $result->{ccAuthReply}{avsCodeRaw}
							) {
							$e->{avs_code}     = $result->{ccAuthReply}{avsCode};
							$e->{avs_code_raw} = $result->{ccAuthReply}{avsCodeRaw};
						}

						if ( $result->{ccAuthReply}{processorResponse} ) {
							$e->{processor_response}
								= $result->{ccAuthReply}{processorResponse}
								;
						}

						if ( $result->{ccAuthReply}->{authRecord} ) {
							$e->{auth_record} = $result->{ccAuthReply}->{authRecord};
						}
					}
		}

	}
	else {
		confess 'decision defined, but not sane: ' . $result->{decision};
	}

	return use_module('Business::CyberSource::Response')
		->with_traits( @traits )
		->new({
			request_id     => $result->{requestID},
			decision       => $result->{decision},
			# quote reason_code to stringify from BigInt
			reason_code    => "$result->{reasonCode}",
			request_token  => $result->{requestToken},
			trace          => $dto->trace,
			%{$e},
		});
}

1;

# ABSTRACT: A Response Factory

=method create

Pass the C<answer> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object.

=cut
