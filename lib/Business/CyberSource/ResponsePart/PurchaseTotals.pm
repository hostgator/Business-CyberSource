package Business::CyberSource::ResponsePart::PurchaseTotals;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006010'; # VERSION

use Moose;
extends 'MessagePart';
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
);

__PACKAGE__->make->meta_immutable;
1;
# ABSTRACT: PurchaseTotals part of response

__END__

=pod

=head1 NAME

Business::CyberSource::ResponsePart::PurchaseTotals - PurchaseTotals part of response

=head1 VERSION

version 0.006010

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
