package Business::CyberSource::Response::Role::Authorization;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::AVS
	Business::CyberSource::Response::Role::CVN
);

1;

# ABSTRACT: DEPRECATED NOOP will be removed
