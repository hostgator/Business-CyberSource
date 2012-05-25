package Business::CyberSource::Helper::Card;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::RemoteHelper;

extends 'Business::CyberSource::CreditCard';
with    'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode );
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode );
use MooseX::Types::Common::String qw( NonEmptySimpleStr );

use Exception::Base (
	'Business::CyberSource::Card::Exception' => {
		has               => [qw( type )],
		string_attributes => [qw( type message )],
	},
	verbosity => 4,
	ignore_package => [ __PACKAGE__ ],
);

	
sub _build_card_type_code {
	my $self = shift;

	my $code
		= $self->type =~ /visa             /ixms ? '001'
		: $self->type =~ /mastercard       /ixms ? '002'
		: $self->type =~ /discover         /ixms ? '004'
		: $self->type =~ /jcb              /ixms ? '007'
		: $self->type =~ /enroute          /ixms ? '014'
		: $self->type =~ /laser            /ixms ? '035'
		: $self->type =~ /american\ express/ixms ? '003'
		:                                  undef
		;
	
	Business::CyberSource::Card::Exception->throw(
		message => 'card type code was unable to be detected please define it'
			. ' manually'
			,
		type => $self->type,
	)
	unless $code;

	return $code;
}

has card_type_code => (
	isa         => CardTypeCode,
	remote_name => 'cardType',
	lazy        => 1,
	is          => 'ro',
	builder     => '_build_card_type_code',
);

has cv_indicator => (
	isa         => CvIndicator,
	remote_name => 'cvIndicator',
	lazy        => 1,
	predicate   => 'has_cv_indicator',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
	default     => sub { $_[0]->has_security_code ? 1 : 0 },
);

# recreate completely, remote_name doesn't work otherwise
has account_number => (
	isa         => CreditCard,
	remote_name => 'accountNumber',
	required    => 1,
	is          => 'ro',
	coerce      => 1,
);

has security_code => (
	isa         => CardSecurityCode,
	remote_name => 'cvNumber',
	predicate   => 'has_security_code',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
);

has holder => (
	isa         => NonEmptySimpleStr,
	remote_name => 'fullName',
	predicate   => 'has_holder',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
);

has _expiration_month => (
	remote_name => 'expirationMonth',
	isa         => 'Int',
	is          => 'ro',
	lazy        => 1,
	reader      => undef,
	writer      => undef,
	init_arg    => undef,
	default     => sub { $_[0]->expiration->month },
);

has _expiration_year => (
	remote_name => 'expirationYear',
	isa         => 'Int',
	is          => 'ro',
	lazy        => 1,
	reader      => undef,
	writer      => undef,
	init_arg    => undef,
	default     => sub { $_[0]->expiration->year },
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Credit Card Helper Class
