package Business::CyberSource::Request::Authorization;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Request::Role::BusinessRules
	Business::CyberSource::Request::Role::DCC
);

before serialize => sub {
	my $self = shift;
	$self->_request_data->{ccAuthService}{run} = 'true';
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Request object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization Request object

=head1 VERSION

version 0.005004

=head1 DESCRIPTION

Offline authorization means that when you submit an order using a credit card,
you will not know if the funds are available until you capture the order and
receive confirmation of payment. You typically will not ship the goods until
you receive this payment confirmation. For offline credit cards, it will take
typically five days longer to receive payment confirmation than for online
cards.

=head2 inherits

L<Business::CyberSource::Request>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::BillingInfo>

=item L<Business::CyberSource::Request::Role::PurchaseInfo>

=item L<Business::CyberSource::Request::Role::CreditCardInfo>

=item L<Business::CyberSource::Request::Role::BusinessRules>

=item L<Business::CyberSource::Request::Role::DCC>

=back

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

