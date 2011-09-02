package Business::CyberSource::Request::AuthReversal;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.2.1'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
);

use Business::CyberSource::Response;

sub submit {
	my $self = shift;

	my $payload = {
		ccAuthReversalService => {
			run => 'true',
			authRequestID => $self->request_id,
		},
	};

	my ( $answer, $trace ) = @{ $self->_build_request( $payload ) };

	$self->trace( $trace );

	if ( $answer->{Fault} ) {
		croak 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	my $r = $answer->{result};

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::AuthReversal
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccAuthReversalReply}->{requestDateTime},
				amount         => $r->{ccAuthReversalReply}->{amount},
				reversal_reason_code =>
					"$r->{ccAuthReversalReply}->{reasonCode}",
				processor_response =>
					$r->{ccAuthReversalReply}->{processorResponse},
			})
			;
	}
	elsif ( $r->{decision} eq 'REJECT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Reject
			})
			->new({
				decision      => $r->{decision},
				request_id    => $r->{requestID},
				reason_code   => "$r->{reasonCode}",
				request_token => $r->{requestToken},
			})
			;
	}
	else {
		croak 'decision defined, but not sane: ' . $r->{decision};
	}

	return $res;
}

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Reverse Authorization request object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::AuthReversal - CyberSource Reverse Authorization request object

=head1 VERSION

version v0.2.1

=head1 SYNOPSIS

	my $req = Business::CyberSource::Request::AuthReversal->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'orignal authorization merchant reference code',
		request_id     => 'request id returned in original authorization response',
		total          => 5.00, # same as original authorization amount
		currency       => 'USD', # same as original currency
	});

	my $res = $req->submit;

=head1 DESCRIPTION

This allows you to reverse an authorization request.

=head1 METHODS

=head2 new

Instantiates a authorization reversal request object, see
L<the attributes listed below|/ATTRIBUTES> for which ones are required and
which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 ATTRIBUTES

=head2 client_env

Reader: client_env

Type: Str

=head2 cybs_wsdl

Reader: cybs_wsdl

Type: MooseX::Types::Path::Class::File

=head2 trace

Reader: trace

Writer: trace

Type: XML::Compile::SOAP::Trace

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 request_id

Reader: request_id

Type: Str

This attribute is required.

=head2 cybs_api_version

Reader: cybs_api_version

Type: Str

=head2 total

Reader: total

Type: Num

=head2 username

Reader: username

Type: MooseX::Types::Varchar::Varchar[30]

This attribute is required.

Additional documentation: Your CyberSource merchant ID. Use the same merchantID for evaluation, testing, and production

=head2 cybs_xsd

Reader: cybs_xsd

Type: MooseX::Types::Path::Class::File

=head2 foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

=head2 client_name

Reader: client_name

Type: Str

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

=head2 client_version

Reader: client_version

Type: Str

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

