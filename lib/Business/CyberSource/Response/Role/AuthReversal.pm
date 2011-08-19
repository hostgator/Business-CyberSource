package Business::CyberSource::Response::Role::AuthReversal;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.3'; # VERSION
}
use Moose::Role;

has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has reversal_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

1;

# ABSTRACT: Role for Authorization Reversal responses

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::AuthReversal - Role for Authorization Reversal responses

=head1 VERSION

version v0.1.3

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

