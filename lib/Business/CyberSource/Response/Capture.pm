package Business::CyberSource::Response::Capture;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;

has reconciliation_id => (
	is       => 'ro',
	isa      => 'Str',
);

has capture_reason_code => (
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

=head1 ATTRIBUTES

=head2 reconciliation_id

Reader: reconciliation_id

Type: Str

=head2 capture_reason_code

Reader: capture_reason_code

Type: Num

=head1 METHODS

=head2 reconciliation_id

Method originates in Business::CyberSource::Response::Capture.

=head2 new

Method originates in Business::CyberSource::Response::Capture.

=head2 capture_reason_code

Method originates in Business::CyberSource::Response::Capture.

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

