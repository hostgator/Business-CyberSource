package Business::CyberSource::RequestPart::BusinessRules;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';

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

Boolean that indicates whether to allow C<ccCaptureService> to run even when the
authorization receives an AVS decline. Used only when both C<ccAuthService> and
C<ccCaptureService> are requested at the same time.
Possible values:

=over

=item true

Ignore the results of AVS checking and run the C<ccCaptureService> service.

=item false (default on remote)

If the authorization receives an AVS decline, do not run the
C<ccCaptureService> service.

=back

If the value of this field is true, the list in the
businessRules_declineAVSFlags field is ignored.

=attr ignore_cv_result

Flag that indicates whether to allow C<ccCaptureService> to run if the value of
the reply field C<ccAuthReply_cvCode> is D or N. Used only when both
C<ccAuthService>
and C<ccCaptureService> are requested at the same time.
Possible values:

=over

=item true

If the value of C<ccAuthReply_cvCode> is D or N, allow C<ccCaptureService> to
run.

=item false (default on remote)

If the value of C<ccAuthReply_cvCode> is D or N, return a card
verification decline and do not allow C<ccCaptureService> to run.

=back

=attr ignore_dav_result

=attr ignore_export_result

=attr ignore_validate_result

=attr decline_avs_flags

ArrayRef of AVS flags that cause the request to be declined for AVS reasons.

B<Important> Make sure that you include the value N in the list if you want to
receive declines for the AVS code N.

=attr score_threshold
