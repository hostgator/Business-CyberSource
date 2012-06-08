package Business::CyberSource::Request;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Message';

with qw(
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::Items
	Business::CyberSource::Role::MerchantReferenceCode
);

use MooseX::ABC;

use MooseX::Types::CyberSource qw( Service );

use Class::Load qw( load_class );

before serialize => sub { ## no critic qw( Subroutines::RequireFinalReturn )
	my $self = shift;

	if ( $self->does('Business::CyberSource::Request::Role::PurchaseInfo' ) ) {
		unless ( $self->has_items or $self->has_total ) {
			confess 'you must define either items or total';
		}
	}
};


# the default is false, override in subclass
sub _build_skipable { return 0 }

sub _build_service {
	load_class('Business::CyberSource::RequestPart::Service');
	return Business::CyberSource::RequestPart::Service->new;
}

has comments => (
	remote_name => 'comments',
	isa         => 'Str',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has service => (
	isa        => Service,
	is         => 'ro',
	lazy_build => 1,
	required   => 1,
	coerce     => 1,
	reader     => undef,
);

has is_skipable => (
	isa     => 'Bool',
	builder => '_build_skipable',
	is      => 'ro',
	lazy    => 1,
);

has '+_trait_namespace' => (
	default => 'Business::CyberSource::Request::Role',
);

has '+trace' => (
	is        => 'rw',
	init_arg  => undef
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Request Class

=head1 DESCRIPTION

extends L<Business::CyberSource::Message>

Here are the provided Request subclasses.

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

=head1 EXTENDS

L<Business::CyberSource::Message>

=head1 WITH

=over

=item L<Business::CyberSource::Request::Role::PurchaseInfo>

=item L<Business::CyberSource::Request::Role::Items>

=item L<Business::CyberSource::Role::MerchantReferenceCode>

=back

=method serialize

returns a hashref suitable for passing to L<XML::Compile::SOAP>

=attr reference_code

Merchant-generated order reference or tracking number.  CyberSource recommends
that you send a unique value for each transaction so that you can perform
meaningful searches for the transaction.

=attr service

L<Business::CyberSource::RequestPart::Service>

=attr comments

Comment Field

=attr is_skipable

Type: Bool

an optimization to see if we can skip sending the request and just construct a
response. This attribute is for use by L<Business::CyberSource::Client> only
and may change names later.

=for Pod::Coverage BUILD

=cut
