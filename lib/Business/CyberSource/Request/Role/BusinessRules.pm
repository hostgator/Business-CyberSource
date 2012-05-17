package Business::CyberSource::Request::Role::BusinessRules;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004009'; # VERSION

use Moose::Role;
use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose qw( Bool ArrayRef );
use MooseX::Types::Common::String 0.001005 qw( NumericCode );
use MooseX::Types::CyberSource qw( AVSResult );

has ignore_avs_result => (
	isa       => Bool,
	predicate => 'has_ignore_avs_result',
	traits    => ['SetOnce'],
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreAVSResult}
			= $self->ignore_avs_result ? 'true' : 'false'
			;
	},
);

has ignore_cv_result => (
	isa       => Bool,
	traits    => ['SetOnce'],
	is        => 'rw',
	predicate => 'has_ignore_cv_result',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreCVResult}
			= $self->ignore_cv_result ? 'true' : 'false'
			;
	},
);

has ignore_dav_result => (
	isa       => Bool,
	traits    => ['SetOnce'],
	is        => 'rw',
	predicate => 'has_ignore_dav_result',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreDAVResult}
			= $self->ignore_dav_result ? 'true' : 'false'
			;
	},
);

has ignore_export_result => (
	isa       => Bool,
	traits    => ['SetOnce'],
	is        => 'rw',
	predicate => 'has_ignore_export_result',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreExportResult}
			= $self->ignore_export_result ? 'true' : 'false'
			;
	},
);

has ignore_validate_result => (
	isa       => Bool,
	traits    => ['SetOnce'],
	is        => 'rw',
	predicate => 'has_ignore_validate_result',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreValidateResult}
			= $self->ignore_validate_result ? 'true' : 'false'
			;
	},
);

has decline_avs_flags => (
	isa       => ArrayRef[AVSResult],
	is        => 'rw',
	predicate => 'has_decline_avs_flags',
	traits    => ['Array'],
	handles   => {
		_stringify_decline_avs_flags => [ join => ' ' ],
	},
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{declineAVSFlags}
			= $self->_stringify_decline_avs_flags
			;
	},
);

has score_threshold => (
	isa       => NumericCode,
	traits    => ['SetOnce'],
	is        => 'rw',
	predicate => 'has_score_threshold',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{scoreThreshold}
			= $self->ignore_cv_result
			;
	},
);

1;

# ABSTRACT: Business Rules Role


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BusinessRules - Business Rules Role

=head1 VERSION

version 0.004009

=head1 ATTRIBUTES

=head2 ignore_avs_result

=head2 ignore_cv_result

=head2 ignore_dav_result

=head2 ignore_export_result

=head2 ignore_validate_result

=head2 decline_avs_flags

=head2 score_threshold

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

