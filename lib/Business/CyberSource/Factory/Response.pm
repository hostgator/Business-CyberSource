package Business::CyberSource::Factory::Response;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use Try::Tiny;
use Module::Runtime  qw( use_module );
use Type::Params     qw( compile    );
use Types::Standard  qw( HashRef Optional );
use Type::Utils      qw( class_type role_type );

sub create { ## no critic ( RequireArgUnpacking )
	state $class     = class_type { class => __PACKAGE__ };
	state $traceable = role_type 'Business::CyberSource::Role::Traceable';
	state $check     = compile( $class, HashRef, Optional[$traceable]);
	my ( $self, $result , $request ) = $check->( @_ );

	$result->{http_trace}
		= $request->http_trace
		if $request && $request->has_http_trace;

	my $response
		= try {
			use_module('Business::CyberSource::Response')->new( $result );
		}
		catch {
			my %exception = (
				message       => 'BUG! please report: ' . $_,
				reason_code   => $result->{reasonCode},
				value         => $result->{reasonCode},
				decision      => $result->{decision},
				request_id    => $result->{requestID},
				request_token => $result->{requestToken},
				http_trace    => $result->{trace},
			);

			$exception{reason_text}
				= use_module('Business::CyberSource::Response')
				->_build_reason_text( $result->{reasonCode} )
				;

			die ## no critic ( ErrorHandling::RequireCarping )
				use_module('Business::CyberSource::Exception::Response')->new( %exception );
		};

	if ( blessed $response && $response->is_error ) {
		my %exception = (
			message       => 'message from CyberSource\'s API',
			reason_text   => $response->reason_text,
			reason_code   => $response->reason_code,
			value         => $response->reason_code,
			decision      => $response->decision,
			request_id    => $response->request_id,
			request_token => $response->request_token,
			is_error      => $response->is_error,
			is_accept     => $response->is_accept,
			is_reject     => $response->is_reject,
		);
		$exception{trace} = $response->trace if $response->has_trace;

		die ## no critic ( ErrorHandling::RequireCarping )
			use_module('Business::CyberSource::Exception::Response')->new( %exception );
	}

	return $response;
}

1;

# ABSTRACT: A Response Factory

=method create

	my $response = $factory->create( $answer->{result}, $request );

Pass the C<answer->{result}> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object. Passing a L<Business::CyberSource::Request> is now optional.

=cut
