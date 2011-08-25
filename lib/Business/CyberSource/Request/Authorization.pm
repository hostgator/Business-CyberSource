package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}

use SOAP::Lite; # +trace => [ 'debug' ] ;
use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

use Business::CyberSource::Response;

sub submit {
	my $self = shift;

	my $ret = $self->_build_soap_request;

	my $decision    = $ret->valueof('decision'  );
	my $request_id  = $ret->valueof('requestID' );
	my $reason_code = $ret->valueof('reasonCode');

	croak 'no decision from CyberSource' unless $decision;

	my $res;
	if ( $decision eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Authorization
			})
			->new({
				request_id     => $request_id,
				decision       => $decision,
				reason_code    => $reason_code,
				reference_code => $ret->valueof('merchantReferenceCode'  ),
				request_token  => $ret->valueof('requestToken'           ),
				currency       => $ret->valueof('purchaseTotals/currency'),
				amount         => $ret->valueof('ccAuthReply/amount'     ),
				avs_code_raw   => $ret->valueof('ccAuthReply/avsCodeRaw' ),
				avs_code       => $ret->valueof('ccAuthReply/avsCode'    ),
				datetime       => $ret->valueof('ccAuthReply/authorizedDateTime'),
				auth_record    => $ret->valueof('ccAuthReply/authRecord'        ),
				auth_code      => $ret->valueof('ccAuthReply/authorizationCode' ),
				processor_response => $ret->valueof('ccAuthReply/processorResponse'),
			})
			;
	}
	elsif ( $decision eq 'REJECT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Reject
			})
			->new({
				decision      => $decision,
				request_id    => $request_id,
				reason_code   => $reason_code,
				request_token => $ret->valueof('requestToken'),
			})
			;
	}
	else {
		croak 'decision defined, but not sane: ' . $decision;
	}

	return $res;
}

sub _build_sdbo {
	my $self = shift;

	my $sb = $self->_build_sdbo_header;

	$sb = $self->_build_bill_to_info    ( $sb );
	$sb = $self->_build_purchase_info   ( $sb );
	$sb = $self->_build_credit_card_info( $sb );

	$sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccAuthService',
		value      => ' ', # hack to prevent cs side unparseable xml
	);

	return $sb;
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
