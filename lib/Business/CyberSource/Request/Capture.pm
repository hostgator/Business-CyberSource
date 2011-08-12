package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;
use namespace::autoclean;
with 'Business::CyberSource::Request';

use SOAP::Lite +trace => [ 'debug' ] ;

sub submit {
	my $self = shift;
	return 1;
}

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has total => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

sub _build_sdbo {
	my $self = shift;
	return 1;
}


__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Capture Request Object

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Capture Request Object

=head1 VERSION

version v0.1.0

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

