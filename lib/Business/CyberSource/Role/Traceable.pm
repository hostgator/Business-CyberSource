package Business::CyberSource::Role::Traceable;
use strict;
use warnings;

# VERSION

use Moose::Role;
use MooseX::SetOnce;

has http_trace => (
	isa       => 'XML::Compile::SOAP::Trace',
	predicate => 'has_http_trace',
	traits    => [ 'SetOnce' ],
	is        => 'rw',
	writer    => '_http_trace',
);

sub trace { $_[0]->http_trace } ## no critic ( RequireArgUnpacking RequireFinalReturn )
sub has_trace { $_[0]->has_http_trace } ## no critic ( RequireArgUnpacking RequireFinalReturn )

before [qw( trace has_trace ) ] => sub {
	my $self = shift;
	warnings::warnif('deprecated', # this is due to Moose::Exception conflict
		'`trace` is deprecated call `http_trace` instead'
	) unless $self->isa('Moose::Exception');
};

1;
# ABSTRACT: provides http_trace

=attr http_trace

A L<XML::Compile::SOAP::Trace> object which is populated only after the object
has been submitted to CyberSource by a L<Business::CyberSource::Client>.

=cut

=method trace

aliased to L</http_trace>

=method has_trace

aliased to L</has_http_trace>
