package Business::CyberSource::Response::Capture;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;
with 'Business::CyberSource::Response';

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has capture_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Capture Response Object

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Capture - CyberSource Capture Response Object

=head1 VERSION

version v0.1.0

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

