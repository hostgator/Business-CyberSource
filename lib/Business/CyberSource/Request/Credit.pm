package Business::CyberSource::Request::Credit;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use Moose;
use namespace::autoclean;
with qw(
	MooseX::Traits
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
);

use Business::CyberSource::Response;
use MooseX::StrictConstructor;

has '+_trait_namespace' => (
	default => 'Business::CyberSource::Request::Role',
);

sub submit {
	my $self = shift;

	$self->_request_data->{ccCreditService}{run} = 'true';
	$self->_request_data->{ccCreditService}{captureRequestID}
		= $self->request_id if $self->meta->has_attribute( 'request_id' );

	my $r = $self->_build_request;

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::ReconciliationID
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				request_token  => $r->{requestToken},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccCreditReply}->{requestDateTime},
				amount         => $r->{ccCreditReply}->{amount},
				reconciliation_id  => $r->{ccCreditReply}->{reconciliationID},
				request_specific_reason_code =>
					"$r->{ccCreditReply}->{reasonCode}",
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

# ABSTRACT: CyberSource Credit Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Credit;

	my $req = Business::CyberSource::Request::Credit
		->with_traits(qw{
			BillingInfo
			CreditCardInfo
		})
		->new({
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

This object allows you to create a request for a credit. If you do not want to
apply traits (or are using the Request factory) then you can instantiate either the
L<Business::CyberSource::Request::StandAloneCredit> or the
L<Business::CyberSource::Request::FollowOnCredit>.

=method with_traits

For standalone credit requests requests you need to apply C<BillingInfo> and
C<CreditCardInfo> roles. This is not necessary for follow on credits. Follow
on credits require that you specify a C<request_id> in order to work.

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
