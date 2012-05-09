package Business::CyberSource::Request::Credit;
use strict;
use warnings;
use namespace::autoclean -also => [ qw( create ) ];

# VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::DCC
);

before serialize => sub {
	my $self = shift;

	$self->_request_data->{ccCreditService}{run} = 'true';
	$self->_request_data->{ccCreditService}{captureRequestID}
		= $self->request_id if $self->meta->has_attribute( 'request_id' );
};

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

=head1 DESCRIPTION

This object allows you to create a request for a credit. If you do not want to
apply traits (or are using the Request factory) then you can instantiate either the
L<Business::CyberSource::Request::StandAloneCredit> or the
L<Business::CyberSource::Request::FollowOnCredit>.

=head2 inherits

L<Business::CyberSource::Request>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::PurchaseInfo>

=item L<Business::CyberSource::Request::Role::DCC>

=back

=method with_traits

For standalone credit requests requests you need to apply C<BillingInfo> and
C<CreditCardInfo> roles. This is not necessary for follow on credits. Follow
on credits require that you specify a C<request_id> in order to work.

=cut
