package Business::CyberSource::Request::FollowOnCredit;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request::Credit';

sub BUILD { ## no critic ( Subroutines::RequireFinalReturn )
	my $self = shift;
	die ## no critic ( ErrorHandling::RequireCarping )
		use_module('Business::CyberSource::Exception::AttributeIsRequiredNotToBeSet')
		->new(
			attribute_name => 'request_id',
			class_name     => __PACKAGE__,
			message        => 'a Follow On Credit should set a request_id',
		) unless $self->service->has_request_id;
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::FollowOnCredit;

	my $credit = Business::CyberSource::Request::FollowOnCredit->new({
			reference_code => 'merchant reference code',
			purchase_totals => {
				total    => 5.00,
				currency => 'USD',
			},
			service => {
				request_id => 'capture request_id',
			},
		});

=head1 DESCRIPTION

Follow-On credit Data Transfer Object.

=head2 EXTENDS

L<Business::CyberSource::Request::Credit>

=cut
