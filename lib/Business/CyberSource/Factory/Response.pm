package Business::CyberSource::Factory::Response;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use Module::Runtime   qw( use_module       );
use Type::Params      qw( compile Invocant );
use Types::Standard   qw( HashRef Optional );
use Type::Utils 0.040 qw( role_type        );

sub create { ## no critic ( RequireArgUnpacking )
	state $traceable = role_type 'Business::CyberSource::Role::Traceable';
	state $check     = compile( Invocant, HashRef, Optional[$traceable]);
	my ( $self, $result , $request ) = $check->( @_ );

	$result->{http_trace}
		= $request->http_trace
		if $request && $request->has_http_trace;

	die ## no critic ( ErrorHandling::RequireCarping )
		use_module('Business::CyberSource::Exception::Response')
		->new( $result ) if $result->{decision} eq 'ERROR';

	return use_module('Business::CyberSource::Response')->new( $result );
}

1;

# ABSTRACT: A Response Factory

=method create

	my $response = $factory->create( $answer->{result}, $request );

Pass the C<answer->{result}> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object. Passing a L<Business::CyberSource::Request> is now optional.

=cut
