package Business::CyberSource::Request;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004006'; # VERSION

use Moose;
extends 'Business::CyberSource::Message';

with qw(
	Business::CyberSource::Request::Role::Credentials
);

use Module::Runtime qw( use_module );

use MooseX::SetOnce 0.200001;

sub create {
	my $self = shift;
	my $impl = shift;
	my ( $args ) = @_;

	confess 'Business::CyberSource::RequestFactory is now the factory'
		unless __PACKAGE__ eq ref $self;

	if ( ref($args) eq 'HASH' ) {
		$args->{username}   //= $self->username   if $self->has_username;
		$args->{password}   //= $self->password   if $self->has_password;
		$args->{production} //= $self->production if $self->has_production;
	}

	my $factory = use_module('Business::CyberSource::RequestFactory')->new;

	return $factory->create( $impl, @_ );
}

has '+_trait_namespace' => (
	default => 'Business::CyberSource::Request::Role',
);

has '+trace' => (
	is        => 'rw',
	writer    => '_trace',
	traits    => [ 'SetOnce' ],
	init_arg  => undef
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Request Class


__END__
=pod

=head1 NAME

Business::CyberSource::Request - Abstract Request Class

=head1 VERSION

version 0.004006

=head1 DESCRIPTION

extends L<Business::CyberSource::Message>

=head1 ATTRIBUTES

=head2 trace

Reader: trace

Writer: _trace

Type: XML::Compile::SOAP::Trace

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

=head2 username

Reader: username

Type: __ANON__

=head2 production

Reader: production

Type: Bool

=head1 METHODS

=head2 new

=head2 create

B<DEPRECATED> consider using L<Business::CyberSource::RequestFactory> instead

( $implementation, { hashref for new } )

Create a new request object. C<create> takes a request implementation and a hashref to pass to the
implementation's C<new> method. The implementation string accepts any
implementation whose package name is prefixed by
C<Business::CyberSource::Request::>.

	my $req = $factory->create(
			'Capture',
			{
				first_name => 'John',
				last_name  => 'Smith',
				...
			}
		);

Please see the following C<Business::CyberSource::Request::> packages for
implementation and required attributes:

=over

=item * L<Authorization|Business::CyberSource::Request::Authorization>

=item * L<AuthReversal|Business::CyberSource::Request::AuthReversal>

=item * L<Capture|Business::CyberSource::Request::Capture>

=item * L<Follow-On Credit|Business::CyberSource::Request::FollowOnCredit>

=item * L<Stand Alone Credit|Business::CyberSource::Request::StandAloneCredit>

=item * L<DCC|Business::CyberSource::Request::DCC>

=item * L<Sale|Business::CyberSource::Request::Sale>

=back

I<note:> You can use the L<Business:CyberSource::Request::Credit> class but,
it requires traits to be applied depending on the type of request you need,
and thus does not currently work with the factory.

=head1 SEE ALSO

=over

=item * L<MooseX::AbstractFactory>

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

