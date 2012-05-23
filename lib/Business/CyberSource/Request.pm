package Business::CyberSource::Request;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Message';

with qw(
	Business::CyberSource::Request::Role::Credentials
	Business::CyberSource::Interface::Composite
);

use Module::Runtime qw( use_module );

use MooseX::SetOnce 0.200001;

use Carp qw( cluck );
our @CARP_NOT = ( 'Class::MOP::Method::Wrapped' );

before create => sub {
	cluck 'DEPRECATED: calling create and using Request object as a factory '
		. ' is deprecated. '
		. 'This class will be converted to an Abstract in the future. '
		. 'If you require a factory please use '
		. 'Business::CyberSource::RequestFactory directly instead'
		;
};

before [ qw( username password production ) ] => sub {
	cluck 'DEPRECATED: please do not set username, password, or production '
		. 'attributes on Request objects anymore, these instead should be set '
		. 'on Business::CyberSource::Client'
		;
};

sub create { ## no critic ( Subroutines::RequireArgUnpacking )
	my $self = shift;
	my $impl = shift;
	my ( $args ) = @_;

	confess 'Business::CyberSource::RequestFactory is now the factory'
		unless __PACKAGE__ eq ref $self;

	if ( ref($args) eq 'HASH' ) {
		$args->{username}   //= $self->username   if $self->has_username;
		$args->{password}   //= $self->password   if $self->has_password;
		$args->{production} //= $self->production if $self->has_production;
	}

	my $factory = use_module('Business::CyberSource::RequestFactory')->new;

	return $factory->create( $impl, @_ );
}

# the default is false, override in subclass
sub _build_skipable { return 0 }

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

=method new

=method serialize

returns a hashref suitable for passing to L<XML::Compile::SOAP>

=method create

B<DEPRECATED> consider using L<Business::CyberSource::RequestFactory> instead

( $implementation, { hashref for new } )

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

=attr foreign_amount

Reader: foreign_amount

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=attr comments

Reader: comments

Type: Str

=attr cvn

Reader: cvn

Type: MooseX::Types::CreditCard::CardSecurityCode

Additional documentation: Card Verification Numbers

=attr total

Reader: total

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

Additional documentation: Grand total for the order. You must include either this field or item_#_unitPrice in your request

=attr cc_exp_month

Reader: cc_exp_month

This attribute is required.

Additional documentation: Two-digit month that the credit card expires in. Format: MM.

=attr card_type

Reader: card_type

Type: MooseX::Types::CyberSource::CardTypeCode

Additional documentation: Type of card to authorize

=attr credit_card

Reader: credit_card

Type: MooseX::Types::CreditCard::CreditCard

Customer's credit card number

=attr reference_code

Reader: reference_code

Type: MooseX::Types::CyberSource::_VarcharFifty

=attr cv_indicator

Reader: cv_indicator

Type: MooseX::Types::CyberSource::CvIndicator

Flag that indicates whether a CVN code was sent

=attr currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

=attr exchange_rate

Reader: exchange_rate

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=attr exchange_rate_timestamp

Reader: exchange_rate_timestamp

Type: Str

=attr full_name

Reader: full_name

Type: MooseX::Types::CyberSource::_VarcharSixty

=attr cc_exp_year

Reader: cc_exp_year

Four-digit year that the credit card expires in. Format: YYYY.

=attr foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

=attr items

Reader: items

Type: ArrayRef[MooseX::Types::CyberSource::Item]

=attr is_skipable

Type: Bool

an optimization to see if we can skip sending the request and just construct a
response. This attribute is for use by L<Business::CyberSource::Client> only
and may change names later.

=for Pod::Coverage BUILD

=cut
