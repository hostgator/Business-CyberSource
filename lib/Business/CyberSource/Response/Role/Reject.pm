package Business::CyberSource::Response::Role::Reject;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;
use MooseX::Types::Varchar qw( Varchar );

has request_token => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[256],
);

1;

# ABSTRACT: role for handling rejected transactions
