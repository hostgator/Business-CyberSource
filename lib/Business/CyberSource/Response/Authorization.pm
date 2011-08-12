package Business::CyberSource::Response::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has decision => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
);

has request_token => (
#	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has amount => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

has auth_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

has avs_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has avs_code_raw => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has auth_datetime => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has auth_record => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Response object

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Authorization - CyberSource Authorization Response object

=head1 VERSION

version v0.1.0

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

