package Business::CyberSource::Role::MerchantReferenceCode;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( _VarcharFifty );

has reference_code => (
	isa         => _VarcharFifty,
	remote_name => 'merchantReferenceCode',
	required    => 1,
	is          => 'ro',
);

1;

# ABSTRACT: Generic implementation of MerchantReferenceCode
