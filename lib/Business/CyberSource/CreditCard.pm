package Business::CyberSource::CreditCard;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006001'; # VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Card';

use Carp qw( cluck );

around BUILDARGS => sub {
	my $orig = shift;
	my $self = shift;

	cluck 'DEPRECATED: just a thin wrapper around '
		. 'Business::CyberSource::RequestPart::Card use that instead'
		;

	return $self->$orig( @_ );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: A Credit Card Value Object


__END__
=pod

=head1 NAME

Business::CyberSource::CreditCard - A Credit Card Value Object

=head1 VERSION

version 0.006001

=head1 DESCRIPTION

Just a L<Business::CyberSource::RequestPart::Card>, use that instead.

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

