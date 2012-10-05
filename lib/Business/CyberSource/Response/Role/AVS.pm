package Business::CyberSource::Response::Role::AVS;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

1;

# ABSTRACT: AVS Role

=attr avs_code

AVS results

=attr avs_code_raw

AVS result code sent directly from the processor. Returned only if a value is
returned by the processor.

=cut
