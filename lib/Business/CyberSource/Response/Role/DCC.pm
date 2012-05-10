package Business::CyberSource::Response::Role::DCC;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Response::Role::Accept
);

has dcc_supported => (
	required => 1,
	is       => 'ro',
	isa      => 'Bool'
);

has valid_hours => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
);

has margin_rate_percentage => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

1;

# ABSTRACT: Role that provides attributes specific to responses for DCC

=attr dcc_supported

=attr valid_hours

=attr margin_rate_percentage
