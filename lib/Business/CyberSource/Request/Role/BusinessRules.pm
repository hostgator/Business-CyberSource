package Business::CyberSource::Request::Role::BusinessRules;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose qw( Bool ArrayRef Int );
use MooseX::Types::Cybersource qw( AVSResult );

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
