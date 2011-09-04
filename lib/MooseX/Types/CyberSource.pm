package MooseX::Types::CyberSource;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use MooseX::Types -declare => [ qw( Decision ) ];

enum Decision, [ qw( ACCEPT REJECT ERROR REVIEW ) ];

1;

# ABSTRACT: Moose Types specific to CyberSource

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

=cut
