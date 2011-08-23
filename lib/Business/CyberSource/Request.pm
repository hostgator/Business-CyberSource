package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose;
use namespace::autoclean;

with qw(
	Business::CyberSource::Request::Role::Credentials
);

use MooseX::AbstractFactory;

1;

# ABSTRACT: CyberSource request factory
