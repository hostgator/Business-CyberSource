package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.1.5'; # VERSION

use MooseX::AbstractFactory;
use namespace::autoclean;

with qw(
	 Business::CyberSource::Request::Role::Credentials
);

has '+production' => ( required => 0 );
has '+username'   => ( required => 0 );
has '+password'   => ( required => 0 );

around 'create' => sub {
	my ( $orig, $self, $imp, $args ) = @_;

	if ( ref($args) eq 'HASH' ) {
		$args->{username}   = $self->username;
		$args->{password}   = $self->password;
		$args->{production} = $self->production;
	}
	else {
		croak 'args not a hashref';
	}

	$self->$orig( $imp, $args );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource request factory

__END__
=pod

=head1 NAME

Business::CyberSource::Request - CyberSource request factory

=head1 VERSION

version v0.1.5

=head1 ATTRIBUTES

=head2 password

Reader: password

Type: Str

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

=head2 username

Reader: username

Type: Str

Additional documentation: your merchantID

=head1 METHODS

=head2 password

Method originates in Business::CyberSource::Request.

=head2 production

Method originates in Business::CyberSource::Request.

=head2 new

Method originates in Business::CyberSource::Request.

=head2 create

Method originates in MooseX::AbstractFactory::Role.

=head2 username

Method originates in Business::CyberSource::Request.

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

