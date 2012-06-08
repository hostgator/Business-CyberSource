package Business::CyberSource::Request::Role::Common;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::SetOnce 0.200001;
use MooseX::RemoteHelper;

with qw(
	Business::CyberSource::Request::Role::Credentials
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::Items
	Business::CyberSource::Role::MerchantReferenceCode
);

use Module::Runtime qw( use_module );

before serialize => sub { ## no critic qw( Subroutines::RequireFinalReturn )
	my $self = shift;

	if ( $self->does('Business::CyberSource::Request::Role::PurchaseInfo' ) ) {
		unless ( $self->has_items or $self->has_total ) {
			confess 'you must define either items or total';
		}
	}
};

has comments => (
	remote_name => 'comments',
	isa         => 'Str',
	traits      => ['SetOnce'],
	is          => 'rw',
);

1;

# ABSTRACT: Request Role

=for Pod::Coverage BUILD

=method serialize

returns a hashref suitable for passing to L<XML::Compile::SOAP>

=method submit

B<DEPRECATED> now calls L<Business::CyberSource::Client>

=cut
