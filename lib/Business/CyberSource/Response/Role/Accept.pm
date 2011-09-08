package Business::CyberSource::Response::Role::Accept;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
);

use MooseX::Types::Moose         qw( Num );
use MooseX::Types::Varchar       qw( Varchar );
use MooseX::Types::DateTime::W3C qw( DateTimeW3C );


has amount => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has datetime => (
	required => 1,
	is       => 'ro',
	isa      => DateTimeW3C,
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

1;

# ABSTRACT: role for handling accepted transactions

=head1 DESCRIPTION

If the transaction has a C<decision> of approved then this Role is applied.

=head1 ATTRIBUTES

=head2 amount

Type: Num

Amount that was approved.

=head2 currency

Type: MooseX::Types::Locale::Currency

Currency code which was used to make the request

=head2 datetime

Type: MooseX::Types::DateTime::W3C::DateTimeW3C

Request timestamp (will probably become a DateTime object at some point)

=head2 reference_code

Type: MooseX::Types::Varchar::Varchar[50]

The merchant reference code originally sent

=cut
