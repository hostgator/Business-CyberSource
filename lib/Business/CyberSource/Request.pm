package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.2.1'; # VERSION

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
		$args->{username} ||= $self->username;
		$args->{password} ||= $self->password;
		$args->{production} = $self->production unless defined $args->{production};
	}
	else {
		croak 'args not a hashref';
	}

	$self->$orig( $imp, $args );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Request factory


__END__
=pod

=head1 NAME

Business::CyberSource::Request - CyberSource Request factory

=head1 VERSION

version v0.2.1

=head1 SYNOPSIS

	my $CYBS_ID = 'myMerchantID';
	my $CYBS_KEY = 'transaction key generated with cybersource';

	use Business::CyberSource::Request;

	my $request_factory
		= Business::CyberSource::Request->new({
			username       => $CYBS_ID,
			password       => $CYBS_KEY,
			production     => 0,
		})
		;

	my $request_obj = $request_factory->create(
		'Authorization',
		{
			reference_code => '42',
			first_name     => 'Caleb',
			last_name      => 'Cushing',
			street         => 'somewhere',
			city           => 'Houston',
			state          => 'TX',
			zip            => '77064',
			country        => 'US',
			email          => 'xenoterracide@gmail.com',
			total          => 5.00,
			currency       => 'USD',
			credit_card    => '4111111111111111',
			cc_exp_month   => '09',
			cc_exp_year    => '2013',
		}
	);

=head1 DESCRIPTION

This library provides a generic factory interface to creating request objects.
It also allows us to not repeat ourselves when specifying attributes that are
common to all requests such as authentication, and server destination.

=head1 METHODS

=head2 new([{ hashref }])

supports passing L<the attributes listed below|/ATTRIBUTES> as a hashref.

=head2 create( $implementation, { hashref for new } )

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

=item * L<Credit|Business::CyberSource::Request::Credit>

=item * L<DCC|Business::CyberSource::Request::DCC>

=back

=head1 ATTRIBUTES

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

Additional documentation: 0: test server. 1: production server

=head2 username

Reader: username

Type: MooseX::Types::Varchar::Varchar[30]

Additional documentation: Your CyberSource merchant ID. Use the same merchantID for evaluation, testing, and production

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

