package MooseX::Types::CyberSource;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.3'; # VERSION

use MooseX::Types -declare => [ qw( Decision CardTypeCode CvIndicator ) ];

enum Decision, [ qw( ACCEPT REJECT ERROR REVIEW ) ];

# can't find a standard on this, so I assume these are a cybersource thing
enum CardTypeCode, [ qw(
	001
	002
	003
	004
	005
	006
	007
	014
	021
	024
	031
	033
	034
	035
	036
	037
	039
	040
	042
	043
) ];

enum CvIndicator, [ qw( 0 1 2 9 ) ];

1;

# ABSTRACT: Moose Types specific to CyberSource


__END__
=pod

=head1 NAME

MooseX::Types::CyberSource - Moose Types specific to CyberSource

=head1 VERSION

version v0.2.3

=head1 SYNOPSIS

	{
		package My::CyberSource::Response;
		use Moose;
		use MooseX::Types::CyberSource qw( Decision );

		has decision => (
			is => 'ro',
			isa => Decision,
		);
		__PACKAGE__->meta->make_immutable;
	}

	my $response = My::CyberSource::Response->new({
		decison => 'ACCEPT'
	});

=head1 DESCRIPTION

This module provides CyberSource specific Moose Types.

=head1 TYPES

=over

=item * C<Decision>

	Base Type: C<enum>

	CyberSource Response Decision

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

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

