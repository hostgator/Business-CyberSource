package Business::CyberSource::Request::Role::BusinessRules;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.1'; # VERSION

use Moose::Role;
use MooseX::Types::Moose qw( Bool ArrayRef Int );
use MooseX::Types::CyberSource qw( AVSResult );

has ignore_avs_result => (
	predicate => 'has_ignore_avs_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
);

has ignore_cv_result => (
	predicate => 'has_ignore_cv_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
);

has ignore_dav_result => (
	predicate => 'has_ignore_dav_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
);

has ignore_export_result => (
	predicate => 'has_ignore_export_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
);

has ignore_validate_result => (
	predicate => 'has_ignore_validate_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
);

has decline_avs_flags => (
	predicate => 'has_decline_avs_flags',
	required  => 0,
	isa       => ArrayRef[AVSResult],
	traits    => ['Array'],
	handles   => {
		_stringify_decline_avs_flags => [ join => ' ' ],
	},
);

has score_threshold => (
	predicate => 'has_score_threshold',
	required  => 0,
	isa       => Int,
);
1;

# ABSTRACT: Business Rules Role

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BusinessRules - Business Rules Role

=head1 VERSION

version v0.3.1

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

