package Business::CyberSource::Response::Capture;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose;
with 'Business::CyberSource::Response';

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has capture_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

__PACKAGE__->meta->make_immutable;
1;
