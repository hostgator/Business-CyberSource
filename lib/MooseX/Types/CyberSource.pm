package MooseX::Types::CyberSource;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.2'; # VERSION

use MooseX::Types -declare => [ qw( Decision ) ];
use MooseX::Types::Common::String qw( NonEmptySimpleStr );
use MooseX::Types::Varchar qw( Varchar );

enum Decision, [ qw( ACCEPT REJECT ERROR REVIEW ) ];


subtype 'RequestID',
	as Varchar[29];

1;

# ABSTRACT: Moose Types specific to CyberSource


__END__
=pod

=head1 NAME

MooseX::Types::CyberSource - Moose Types specific to CyberSource

=head1 VERSION

version v0.2.2

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

