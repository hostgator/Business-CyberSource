package Business::CyberSource::Exception::SOAPFault;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::RemoteHelper;
extends 'Business::CyberSource::Exception';

sub _build_message {
	my $self = shift;
	return $self->faultstring;
}

has $_ => (
	remote_name => $_,
	isa         => 'Str',
	is          => 'ro',
	required    => 1,
) foreach qw( faultstring faultcode );

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Card number is not a valid credit card
