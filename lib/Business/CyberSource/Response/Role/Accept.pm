package Business::CyberSource::Response::Role::Accept;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::MerchantReferenceCode
);

1;

# ABSTRACT: role for handling accepted transactions
