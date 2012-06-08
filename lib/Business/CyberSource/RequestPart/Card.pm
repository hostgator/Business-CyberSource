package Business::CyberSource::RequestPart::Card;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';

use MooseX::Aliases;

use MooseX::Types::CyberSource qw( CvIndicator CardTypeCode ExpirationDate );
use MooseX::Types::CreditCard 0.001001 qw( CreditCard CardSecurityCode     );
use MooseX::Types::Common::String      qw( NonEmptySimpleStr               );

use Exception::Base (
	'Business::CyberSource::Card::Exception' => {
		has               => [qw( type )],
		string_attributes => [qw( type message )],
	},
	verbosity => 4,
	ignore_package => [ __PACKAGE__ ],
);

use Class::Load qw( load_class );

sub _build_type {
	my $self = shift;

	load_class('Business::CreditCard');
	my $ct = Business::CreditCard::cardtype( $self->account_number );

	Exception::Base->throw( message => $ct )
		if $ct =~ /not a credit card/ixms
		;

	$ct =~ s/[\s]card//xms;

	return uc $ct;
}

sub _build_expired {
	my $self = shift;
	load_class('DateTime');

	return $self->_compare_date_against_expiration( DateTime->now );
}

sub _compare_date_against_expiration { ## no critic (Subroutines::RequireFinalReturn)
	my ( $self, $date ) = @_;

	my $exp = $self->expiration->clone;
	# add 2 days so that we allow for a 24 hour period where
	# the card could be expired at UTC but not the issuer
	$exp->add( days => 1 );

	load_class('DateTime');
	my $cmp = DateTime->compare( $date, $exp );

	given ( $cmp ) {
		when ( -1 ) { # current date is before than the expiration date
			return 0;
		}
		when ( 0 ) { # expiration equal to current date
			return 0;
		}
		when ( 1 ) { # current date is past the expiration date
			return 1;
		}
	}
}
	
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

has account_number => (
	isa         => CreditCard,
	remote_name => 'accountNumber',
	alias       => [ qw( credit_card_number card_number ) ],
	required    => 1,
	is          => 'ro',
	coerce      => 1,
	trigger     => sub { shift->type },
);

has type => (
	isa       => 'Str',
	lazy      => 1,
	is        => 'ro',
	builder   => '_build_type',
);

has expiration => (
	isa      => ExpirationDate,
	required => 1,
	is       => 'ro',
	coerce   => 1,
);

has is_expired => (
	isa      => 'Bool',
	builder  => '_build_expired',
	lazy     => 1,
	is       => 'ro',
);

has security_code => (
	isa         => CardSecurityCode,
	remote_name => 'cvNumber',
	alias       => [ qw( cvn cvv cvv2 cvc2 cid ) ],
	predicate   => 'has_security_code',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
);

has holder => (
	isa         => NonEmptySimpleStr,
	remote_name => 'fullName',
	alias       => [ qw( name full_name card_holder ) ],
	predicate   => 'has_holder',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
);

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
