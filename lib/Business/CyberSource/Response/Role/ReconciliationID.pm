package Business::CyberSource::Response::Role::ReconciliationID;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
);

1;

# ABSTRACT: Reconciliation Identifier

=attr reconciliation_id

=cut
