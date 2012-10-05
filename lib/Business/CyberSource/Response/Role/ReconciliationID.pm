package Business::CyberSource::Response::Role::ReconciliationID;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

has reconciliation_id => (
	isa         => 'Str',
	remote_name => 'reconciliationID',
	is          => 'ro',
	predicate   => 'has_reconciliation_id',
);

1;

# ABSTRACT: Reconciliation Identifier

=attr reconciliation_id

=cut
