package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use MooseX::AbstractFactory;
use namespace::autoclean;

with qw(
	 Business::CyberSource::Request::Role::Credentials
);

has '+production' => ( required => 0 );
has '+username'   => ( required => 0 );
has '+password'   => ( required => 0 );

around 'create' => sub {
	my ( $orig, $self, $imp, $args ) = @_;

	if ( ref($args) eq 'HASH' ) {
		$args->{username} ||= $self->username;
		$args->{password} ||= $self->password;
		$args->{production} = $self->production unless defined $args->{production};
	}
	else {
		croak 'args not a hashref';
	}

	$self->$orig( $imp, $args );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource request factory

=head1 SYNOPSIS

	my $CYBS_ID = 'myMerchantID';
	my $CYBS_KEY = 'transaction key generated with cybersource';

	use Business::CyberSource::Request;

	my $request_factory
		= Business::CyberSource::Request->new({
			username       => $CYBS_ID,
			password       => $CYBS_KEY,
			production     => 0,
		})
		;

	my $request_obj = $request_factory->create(
		'Authorization',
		{
			reference_code => '42',
			first_name     => 'Caleb',
			last_name      => 'Cushing',
			street         => 'somewhere',
			city           => 'Houston',
			state          => 'TX',
			zip            => '77064',
			country        => 'US',
			email          => 'xenoterracide@gmail.com',
			total          => 5.00,
			currency       => 'USD',
			credit_card    => '4111-1111-1111-1111',
			cc_exp_month   => '09',
			cc_exp_year    => '2013',
		}
	);

=cut
