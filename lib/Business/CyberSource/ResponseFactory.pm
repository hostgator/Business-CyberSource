package Business::CyberSource::ResponseFactory;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004006'; # VERSION

use Moose;
use MooseX::StrictConstructor;

use Module::Runtime qw( use_module );

sub create {
	my ( $self, $answer, $dto )  = @_;

	my $r = $answer->{result};

	my @traits;
	my $e = { };

	if ( $r->{decision} eq 'ACCEPT' or $r->{decision} eq 'REJECT' ) {
		my $prefix      = 'Business::CyberSource::';
		my $req_prefix  = $prefix . 'Request::';
		my $res_prefix  = $prefix . 'Response::';
		my $role_prefix = $res_prefix . 'Role::';

		if ( $r->{decision} eq 'ACCEPT' ) {
			push( @traits, $role_prefix .'Accept' );

			$e->{currency} = $r->{purchaseTotals}{currency};
			$e->{reference_code} = $r->{merchantReferenceCode};

			given ( $dto ) {
				when ( $_->isa( $req_prefix . 'Authorization') ) {
					$e->{amount        } = $r->{ccAuthReply}->{amount};
					$e->{datetime      } = $r->{ccAuthReply}{authorizedDateTime};
					$e->{request_specific_reason_code}
						= "$r->{ccAuthReply}->{reasonCode}";
					continue;
				}
				when ( $_->isa( $req_prefix . 'Capture')
					or $_->isa( $req_prefix . 'Sale' )
					) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $r->{ccCaptureReply}->{requestDateTime};
					$e->{amount}   = $r->{ccCaptureReply}->{amount};
					$e->{reconciliation_id}
						= $r->{ccCaptureReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$r->{ccCaptureReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'Credit') ) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $r->{ccCreditReply}->{requestDateTime};
					$e->{amount}   = $r->{ccCreditReply}->{amount};
					$e->{reconciliation_id} = $r->{ccCreditReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$r->{ccCreditReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'DCC') ) {
					push ( @traits, $role_prefix . 'DCC' );
					$e->{exchange_rate} = $r->{purchaseTotals}{exchangeRate};
					$e->{exchange_rate_timestamp}
						= $r->{purchaseTotals}{exchangeRateTimeStamp};
					$e->{foreign_currency}
						= $r->{purchaseTotals}{foreignCurrency};
					$e->{foreign_amount} = $r->{purchaseTotals}{foreignAmount};
					$e->{dcc_supported}
						= $r->{ccDCCReply}{dccSupported} eq 'TRUE' ? 1 : 0;
					$e->{valid_hours} = $r->{ccDCCReply}{validHours};
					$e->{margin_rate_percentage}
						= $r->{ccDCCReply}{marginRatePercentage};
					$e->{request_specific_reason_code}
						= "$r->{ccDCCReply}{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'AuthReversal' ) ) {
					push ( @traits, $role_prefix . 'ProcessorResponse' );

					$e->{datetime} = $r->{ccAuthReversalReply}->{requestDateTime};
					$e->{amount}   = $r->{ccAuthReversalReply}->{amount};

					$e->{request_specific_reason_code}
						= "$r->{ccAuthReversalReply}->{reasonCode}";
					$e->{processor_response}
						= $r->{ccAuthReversalReply}->{processorResponse};
				}
			}
		}

		if ( $dto->isa( $req_prefix . 'Authorization') ) {
				push( @traits, $role_prefix . 'Authorization' );
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
		}

	}
	else {
		confess 'decision defined, but not sane: ' . $r->{decision};
	}

	return use_module('Business::CyberSource::Response')
		->with_traits( @traits )
		->new({
			request_id     => $r->{requestID},
			decision       => $r->{decision},
			# quote reason_code to stringify from BigInt
			reason_code    => "$r->{reasonCode}",
			request_token  => $r->{requestToken},
			%{$e},
		});
}

1;

# ABSTRACT: A Response Factory


__END__
=pod

=head1 NAME

Business::CyberSource::ResponseFactory - A Response Factory

=head1 VERSION

version 0.004006

=head1 METHODS

=head2 create

Pass the C<answer> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object.

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

