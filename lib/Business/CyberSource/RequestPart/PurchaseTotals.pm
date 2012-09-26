package Business::CyberSource::RequestPart::PurchaseTotals;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006008'; # VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with    'MooseX::RemoteHelper::CompositeSerialization';

with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
);

use MooseX::Types::Common::Numeric qw( PositiveOrZeroNum );


has total => (
	isa         => PositiveOrZeroNum,
	remote_name => 'grandTotalAmount',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
	predicate   => 'has_total',

);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Purchase Totals

__END__

=pod

=head1 NAME

Business::CyberSource::RequestPart::PurchaseTotals - Purchase Totals

=head1 VERSION

version 0.006008

=head1 ATTRIBUTES

=head2 total

Grand total for the order. You must include either this field or
L<Item unit price|Business::CyberSource::RequestPart::Item/"unit_price"> in your
request.

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head1 WITH

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by HostGator.com.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
