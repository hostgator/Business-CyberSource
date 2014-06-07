package Business::CyberSource::Exception::NotACreditCard;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Exception';

sub _build_message {
	return 'not a credit card';
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Card number is not a valid credit card
