package Business::CyberSource::ResponsePart::AuthReply;
use strict;
use warnings;
use namespace::autoclean;
use Class::Load 0.20 qw( load_class );

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with 'Business::CyberSource::Response::Role::ReconciliationID';

use MooseX::Types -declare => [  qw( DateTimeFromW3C ) ];
use MooseX::Types::DateTime      qw( DateTime          );
use MooseX::Types::DateTime::W3C qw( DateTimeW3C       );
use MooseX::Types::CyberSource   qw(
	_VarcharSeven
	_VarcharTen
	AVSResult
	CvResults
);

subtype DateTimeFromW3C, as DateTime;

coerce DateTimeFromW3C,
	from DateTimeW3C,
	via {
		return load_class('DateTime::Format::W3CDTF')
			->new->parse_datetime( $_ );
	};

has auth_code => (
	isa         => _VarcharSeven,
	remote_name => 'authorizationCode',
	predicate   => 'has_auth_code',
	is          => 'rw',
);

has auth_record => (
	isa         => 'Str',
	remote_name => 'authRecord',
	predicate   => 'has_auth_record',
	is          => 'rw',
);

has amount => (
	isa         => 'Num',
	remote_name => 'amount',
	is          => 'rw',
);

has datetime => (
	isa         => DateTimeFromW3C,
	remote_name => 'authorizedDateTime',
	is          => 'rw',
	coerce      => 1,
);

has cv_code => (
	isa         => CvResults,
	remote_name => 'cvCode',
	predicate   => 'has_cv_code',
	is          => 'rw',
);

has cv_code_raw => (
	isa         => _VarcharTen,
	remote_name => 'cvCodeRaw',
	predicate   => 'has_cv_code_raw',
	is          => 'rw',
);

has avs_code => (
	isa         => AVSResult,
	remote_name => 'avsCode',
	predicate   => 'has_avs_code',
	is          => 'rw',
);

has avs_code_raw => (
	isa         => _VarcharTen,
	remote_name => 'avsCodeRaw',
	predicate   => 'has_avs_code_raw',
	is          => 'rw',
);

has processor_response => (
	isa         => _VarcharTen,
	remote_name => 'processorResponse',
	predicate   => 'has_processor_response',
	is          => 'rw',
);

has reason_code => (
	isa         => 'Int',
	remote_name => 'reasonCode',
	required    => 1,
	is          => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: PurchaseTotals part of response
