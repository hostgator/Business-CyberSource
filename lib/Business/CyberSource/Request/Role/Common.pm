package Business::CyberSource::Request::Role::Common;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

use Moose::Role;
use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::URI     qw( Uri     );
use MooseX::Types::Path::Class qw( File Dir );

with qw(
	Business::CyberSource::Request::Role::Credentials
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Role::MerchantReferenceCode
);

use Module::Runtime qw( use_module );
use Carp qw( cluck );

sub serialize {
	my $self = shift;
	return $self->_request_data;
}

before submit => sub {
	our @CARP_NOT = ( __PACKAGE__, 'Class::MOP::Method::Wrapped' );
	cluck 'DEPRECATED: using submit on a request object is deprecated. '
		. 'Please pass the object to Business::CyberSource::Client directly '
		. 'instead.'
		;
};

sub submit {
	my $self = shift;

	my $client = use_module('Business::CyberSource::Client')->new({
		username   => $self->username,
		password   => $self->password,
		production => $self->production,
	});

	return $client->run_transaction( $self );
}

sub BUILD { ## no critic qw( Subroutines::RequireFinalReturn )
	my $self = shift;

	if ( $self->does('Business::CyberSource::Request::Role::PurchaseInfo' ) ) {
		unless ( $self->has_items or $self->has_total ) {
			confess 'you must define either items or total';
		}
	}

	if ( $self->does('Business::CyberSource::Request::Role::BillingInfo' ) ) {
		if ( $self->country eq 'US' or $self->country eq 'CA' ) {
			confess 'zip code is required for US or Canada'
				unless $self->has_zip;
		}
	}
}

has comments => (
	isa      => Str,
	traits   => ['SetOnce'],
	is       => 'rw',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{comments} = $self->comments;
	},
);


has _request_data => (
	required => 1,
	init_arg => undef,
	is       => 'rw',
	isa      => HashRef,
	default => sub { { } },
);

1;

# ABSTRACT: Request Role


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Common - Request Role

=head1 VERSION

version 0.005004

=head1 METHODS

=head2 serialize

returns a hashref suitable for passing to L<XML::Compile::SOAP>

=head2 submit

B<DEPRECATED> now calls L<Business::CyberSource::Client>

=for Pod::Coverage BUILD

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

