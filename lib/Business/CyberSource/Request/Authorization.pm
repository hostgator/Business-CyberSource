package Business::CyberSource::Request::Authorization;
use 5.008;
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
	};

	my $r = $self->_build_request( $payload );

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

=head1 DESCRIPTION

This allows you to create an authorization request.

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
