package Business::CyberSource::Helper::BusinessRules;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;

with 'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::RemoteHelper;
use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose                   qw( ArrayRef    );
use MooseX::Types::Common::String 0.001005 qw( NumericCode );
use MooseX::Types::CyberSource             qw( AVSResult   );

my $true_false
	= sub {
		my ( $attr, $instance ) = @_;
		return $attr->get_value( $instance ) ? 'true' : 'false';
	};

has ignore_avs_result => (
	isa         => 'Bool',
	remote_name => 'ignoreAVSResult',
	predicate   => 'has_ignore_avs_result',
	traits      => ['SetOnce'],
	is          => 'rw',
	serializer  => $true_false, 
);

has ignore_cv_result => (
	isa         => 'Bool',
	remote_name => 'ignoreCVResult',
	predicate   => 'has_ignore_cv_result',
	traits      => ['SetOnce'],
	is          => 'rw',
	serializer  => $true_false, 
);

has ignore_dav_result => (
	isa         => 'Bool',
	remote_name => 'ignoreDAVResult',
	predicate   => 'has_ignore_dav_result',
	traits      => ['SetOnce'],
	is          => 'rw',
	serializer  => $true_false, 
);

has ignore_export_result => (
	isa         => 'Bool',
	remote_name => 'ignoreExportResult',
	predicate   => 'has_ignore_export_result',
	traits      => ['SetOnce'],
	is          => 'rw',
	serializer  => $true_false, 
);

has ignore_validate_result => (
	isa         => 'Bool',
	remote_name => 'ignoreValidateResult',
	predicate   => 'has_ignore_validate_result',
	traits      => ['SetOnce'],
	is          => 'rw',
	serializer  => $true_false, 
);

has decline_avs_flags => (
	isa         => ArrayRef[AVSResult],
	remote_name => 'declineAVSFlags',
	predicate   => 'has_decline_avs_flags',
	is          => 'rw',
	traits      => ['Array'],
	serializer => sub {
		my ( $attr, $instance ) = @_;
		return join ' ', @{ $attr->get_value( $instance ) };
	},
);

has score_threshold => (
	isa         => NumericCode,
	remote_name => 'scoreThreshold',
	predicate   => 'has_score_threshold',
	traits      => ['SetOnce'],
	is          => 'rw',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Business Rules

=attr ignore_avs_result

=attr ignore_cv_result

=attr ignore_dav_result

=attr ignore_export_result

=attr ignore_validate_result

=attr decline_avs_flags

=attr score_threshold
