package Business::CyberSource::ResponsePart::AuthReply;
use strict;
use warnings;
use namespace::autoclean;
use Module::Runtime  qw( use_module );

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::AuthCode
	Business::CyberSource::Response::Role::ReconciliationID
	Business::CyberSource::Response::Role::ReasonCode
	Business::CyberSource::Response::Role::Amount
	Business::CyberSource::Response::Role::ProcessorResponse
);

use MooseX::Types::CyberSource   qw(
	_VarcharTen
	AVSResult
	CvResults
	DateTimeFromW3C
);


has auth_record => (
	isa         => 'Str',
	remote_name => 'authRecord',
	predicate   => 'has_auth_record',
	is          => 'ro',
);

has datetime => (
	isa         => DateTimeFromW3C,
	remote_name => 'authorizedDateTime',
	is          => 'ro',
	coerce      => 1,
	predicate   => 'has_datetime',
);

has cv_code => (
	isa         => CvResults,
	remote_name => 'cvCode',
	predicate   => 'has_cv_code',
	is          => 'ro',
);

has cv_code_raw => (
	isa         => _VarcharTen,
	remote_name => 'cvCodeRaw',
	predicate   => 'has_cv_code_raw',
	is          => 'ro',
);

has avs_code => (
	isa         => AVSResult,
	remote_name => 'avsCode',
	predicate   => 'has_avs_code',
	is          => 'ro',
);

has avs_code_raw => (
	isa         => _VarcharTen,
	remote_name => 'avsCodeRaw',
	predicate   => 'has_avs_code_raw',
	is          => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Reply section for Authorizations

=attr datetime

	$response->auth->datetime if $response->auth->has_datetime;

B<Type:> L<DateTime>

Time of authorization.

=attr avs_code

	$response->auth->avs_code if $response->auth->has_avs_code;

B<Type:> Varying character 1

=attr avs_code_raw

	$response->auth->avs_code_raw if $response->auth->has_avs_code_raw;

B<Type:> Varying character 10

=attr auth_record

	$response->auth->auth_record if $response->auth->has_auth_record;

B<Type:> String

=attr auth_code

	$response->auth->auth_code if $response->auth->has_auth_code;

B<Type:> Varying character 7

Authorization code. Returned only if a value is returned by the processor.

=attr cv_code

	$response->auth->cv_code if $response->auth->has_cv_code;

B<Type:> Single Char

=attr cv_code_raw

	$response->auth->cv_code_raw if $response->auth->has_cv_code_raw;

B<Type:> Varying character 10

=attr processor_response

	$response->auth->processor_response
		if $response->auth->has_processor_response;

Type: Varying character 10

=attr reconciliation_id

	$response->auth->reconciliation_id
		if $response->auth->has_reconciliation_id

Type: Int

=cut
