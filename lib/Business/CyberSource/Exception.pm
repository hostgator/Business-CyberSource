package Business::CyberSource::Exception;
use strict;
use warnings;

# VERSION

use Moose;
extends 'Moose::Exception';

has trace => (
    is        => 'ro',
    isa       => 'Maybe[XML::Compile::SOAP::Trace]',
    required  => 0,
    predicate => 'has_trace',
);

use overload '""' =>
    sub {
        my $self = shift;

        my $error;

        if($self->has_trace && defined $self->trace) {
            $error = "Date: " . $self->trace->date     . "\n"
                . "Request: "    . $self->trace->request->as_string  . "\n"
                . "Response: "   . $self->trace->response->as_string . "\n";

            if(defined $self->trace->error && length ($self->trace->error) ) {
                $error .= "Error: " . $self->trace->error . "\n";
            }
        }
        else {
            $error = "Error";
        }

        return $error,
    },
    fallback => 1,
;

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: base exception
