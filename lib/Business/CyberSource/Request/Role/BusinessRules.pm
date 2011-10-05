package Business::CyberSource::Request::Role::BusinessRules;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose qw( Bool ArrayRef Int );
use MooseX::Types::CyberSource qw( AVSResult );

has ignore_avs_result => (
	predicate => 'has_ignore_avs_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreAVSResult}
			= $self->ignore_avs_result ? 'true' : 'false'
			;
	},
);

has ignore_cv_result => (
	predicate => 'has_ignore_cv_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreCVResult}
			= $self->ignore_cv_result ? 'true' : 'false'
			;
	},
);

has ignore_dav_result => (
	predicate => 'has_ignore_dav_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreDAVResult}
			= $self->ignore_dav_result ? 'true' : 'false'
			;
	},
);

has ignore_export_result => (
	predicate => 'has_ignore_export_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreExportResult}
			= $self->ignore_export_result ? 'true' : 'false'
			;
	},
);

has ignore_validate_result => (
	predicate => 'has_ignore_validate_result',
	required  => 0,
	is        => 'ro',
	isa       => Bool,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{ignoreValidateResult}
			= $self->ignore_validate_result ? 'true' : 'false'
			;
	},
);

has decline_avs_flags => (
	predicate => 'has_decline_avs_flags',
	required  => 0,
	isa       => ArrayRef[AVSResult],
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
	predicate => 'has_score_threshold',
	required  => 0,
	isa       => Int,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{businessRules}{scoreThreshold}
			= $self->ignore_cv_result
			;
	},
);

1;

# ABSTRACT: Business Rules Role
