package Business::CyberSource::Response::Role::ReconciliationID;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose qw( Int );

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

1;

# ABSTRACT: Reconciliation Identifier
