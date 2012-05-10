package Business::CyberSource::Request::FollowOnCredit;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request::Credit';
with qw(
	Business::CyberSource::Request::Role::FollowUp
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::FollowOnCredit;

	my $credit = Business::CyberSource::Request::FollowOnCredit->new({
			reference_code => 'merchant reference code',
			total          => 5.00,
			currency       => 'USD',
			request_id     => 'capture request_id',
		});

=head1 DESCRIPTION

Follow-On credit Data Transfer Object.

=head2 inherits

L<Business::CyberSource::Request::Credit>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::FollowUp>

=back

=cut
