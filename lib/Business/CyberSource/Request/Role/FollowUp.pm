package Business::CyberSource::Request::Role::FollowUp;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::RequestID
);

1;

# ABSTRACT: Role to apply to requests that are follow ups to a previous request

=head1 DESCRIPTION

=head2 composes

=over

=item L<Business::CyberSource::Role::RequestID>

=back
