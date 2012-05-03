package Business::CyberSource::Request::AuthReversal;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004004'; # VERSION

use Moose;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::FollowUp
);

before serialize => sub {
	my $self = shift;

	$self->_request_data->{ccAuthReversalService}{run} = 'true';
	$self->_request_data->{ccAuthReversalService}{authRequestID}
		= $self->request_id
		;
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Reverse Authorization request object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::AuthReversal - CyberSource Reverse Authorization request object

=head1 VERSION

version 0.004004

=head1 SYNOPSIS

	my $req = Business::CyberSource::Request::AuthReversal->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'orignal authorization merchant reference code',
		request_id     => 'request id returned in original authorization response',
		total          => 5.00, # same as original authorization amount
		currency       => 'USD', # same as original currency
	});

	my $res = $req->submit;

=head1 DESCRIPTION

This allows you to reverse an authorization request.

=head1 METHODS

=head2 new

Instantiates a authorization reversal request object, see
L<the attributes listed below|/ATTRIBUTES> for which ones are required and
which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

