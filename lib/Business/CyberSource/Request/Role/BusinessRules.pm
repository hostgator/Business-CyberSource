package Business::CyberSource::Request::Role::BusinessRules;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006005'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( BusinessRules );

#use List::MoreUtils qw( any );
use Class::Load qw( load_class );

our @CARP_NOT = ( 'Class::MOP::Method::Wrapped', __PACKAGE__ );

my %br_map = (
	ignore_avs_result      => 1,
	ignore_cv_result       => 1,
	ignore_dav_result      => 1,
	ignore_export_result   => 1,
	ignore_validate_result => 1,
	decline_avs_flags      => 1,
	score_threshold        => 1,
);

around BUILDARGS => sub {
	my $orig = shift;
	my $self = shift;

	my $args = $self->$orig( @_ );

	my %newargs = %{ $args };


	return $args if defined $args->{business_rules}
		#or any { defined $br_map{$_} } keys %br_map
		;

	my %business_rules
		= map {
			defined $br_map{$_} ? ( $_, delete $newargs{$_} ) : ()
		} keys %newargs;

	$newargs{business_rules} = \%business_rules if keys %business_rules;

	load_class 'Carp';
	Carp::carp 'DEPRECATED: '
		. 'pass a Business::CyberSource::RequestPart::BusinessRules to '
		. 'purchase_totals '
		. 'or pass a constructor hashref to bill_to as it is coerced from '
		. 'hashref.'
		if keys %business_rules
		;

	return \%newargs;
};

before [ keys %br_map ] => sub {
	load_class('Carp');
	Carp::carp 'DEPRECATED: '
		. 'call attribute methods ( ' . join( ' ', keys %br_map ) . ' ) on '
		. 'Business::CyberSource::RequestPart::BusinessRules via '
		. 'business_rules directly'
		;
};

has business_rules => (
	isa         => BusinessRules,
	remote_name => 'businessRules',
	traits      => ['SetOnce'],
	is          => 'rw',
	coerce      => 1,
	handles     => [ keys %br_map ],
);

1;

# ABSTRACT: Business Rules


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BusinessRules - Business Rules

=head1 VERSION

version 0.006005

=head1 ATTRIBUTES

=head2 business_rules

L<Business::CyberSource::RequestPart::BusinessRules>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

