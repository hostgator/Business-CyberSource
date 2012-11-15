package Business::CyberSource::Role::Currency;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007007'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::Locale::Currency qw( CurrencyCode );

has currency => (
	isa         => CurrencyCode,
	remote_name => 'currency',
	is          => 'ro',
	required    => 1,
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency

__END__

=pod

=head1 NAME

Business::CyberSource::Role::Currency - Role to apply to requests and responses that require currency

=head1 VERSION

version 0.007007

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/hostgator/business-cybersource/issues or by email to
development@hostgator.com.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
