package Business::CyberSource::Interface::Composite;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

sub serialize {
	my $self = shift;

	my %serialized;

	foreach my $attr ( $self->meta->get_all_attributes ) {
		if ( $attr->does('RemoteHelper')
				# check if we can get a value
				&& ( $attr->has_value( $self )
					|| $attr->has_default
					|| $attr->has_builder
				)
			) {
			if ( $attr->has_remote_name ) {
				my $value
					# if attr is an object and can serialize
					= ( blessed $attr->get_value( $self )
						&& $attr->get_value( $self )->can('serialize')
						)

					# then serialize
					? $attr->get_value( $self )->serialize

					# else run custom serializer
					: $attr->serialized( $self )
					;

				$serialized{ $attr->remote_name } = $value;
			}
		}
	}
	return \%serialized;
}

1;

# ABSTRACT: 
