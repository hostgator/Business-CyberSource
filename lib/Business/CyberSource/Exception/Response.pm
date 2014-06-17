package Business::CyberSource::Exception::Response;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use namespace::autoclean;
use MooseX::Aliases;
extends 'Business::CyberSource::Exception';
with 'Business::CyberSource::Role::Traceable' => {
	-excludes => [qw( trace )]
}, qw(
	Business::CyberSource::Response::Role::Base
);

sub _build_message {
	my $self = shift;
	return $self->decison . ' ' . $self->reason_text;
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: response thrown as an object because of ERROR state

=head1 SYNOPSIS

	use Try::Tiny;
	use Safe::Isa;

	try { ... }
	catch {
		if ( $_->$_does('Business::CyberSource::Response::Role::Base) )
			# log reason_text
		}
	};

=head1 DESCRIPTION

do not catch this object, should Moose provide an exception role at some
point, we will remove this class in favor of applying the role to
L<Business::CyberSource::Response> instead catch
L<Business::CyberSource::Response::Role::Base>
