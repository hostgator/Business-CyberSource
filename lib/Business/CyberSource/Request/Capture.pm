package Business::CyberSource::Request::Capture;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose;
use namespace::autoclean;
with 'Business::CyberSource::Request';

use Business::CyberSource::Response::Capture;

use SOAP::Lite; # +trace => [ 'debug' ] ;

sub submit {
	my $self = shift;

	my $req = SOAP::Lite->new(
		readable   => 1,
		autotype   => 0,
		proxy      => 'https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor',
		default_ns => 'urn:schemas-cybersource-com:transaction-data-1.61',
	);

	my $ret = $req->requestMessage( $self->_sdbo->to_soap_data );

	if ( $ret->fault ) {
		my ( $faultstring ) = $ret->faultstring =~ /\s([[:print:]]*)\s/xms;
		croak 'SOAP Fault: ' . $ret->faultcode . " " . $faultstring ;
	}

	$ret->match('//Body/replyMessage');

	my $res
		= Business::CyberSource::Response::Capture->new({
			reference_code => $ret->valueof('merchantReferenceCode'  ),
			request_id     => $ret->valueof('requestID'              ),
			decision       => $ret->valueof('decision'               ),
			reason_code    => $ret->valueof('reasonCode'             ),
			currency       => $ret->valueof('purchaseTotals/currency'),
			amount         => $ret->valueof('ccCaptureReply/amount'  ),
			reconciliation_id   => $ret->valueof('ccCaptureReply/reconciliationID'),
			capture_reason_code => $ret->valueof('ccCaptureReply/reasonCode'),
		})
		;

	return $res;
}

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

sub _build_sdbo {
	my $self = shift;

	my $sb = $self->_build_sdbo_header;

	$sb->add_elem(
		name  => 'merchantReferenceCode',
		value => $self->reference_code,
	);

	my $purchase_totals = $sb->add_elem(
		name => 'purchaseTotals',
	);

	$sb->add_elem(
		name   => 'currency',
		parent => $purchase_totals,
		value  => $self->currency,
	);


	$sb->add_elem(
		name   => 'grandTotalAmount',
		value  => $self->total,
		parent => $purchase_totals,
	);

	my $capture_service = $sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccCaptureService',
	);

	$sb->add_elem(
		name   => 'authRequestID',
		value  => $self->request_id,
		parent => $capture_service,
	);

	return $sb;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Capture Request Object

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Capture - CyberSource Capture Request Object

=head1 VERSION

version v0.1.0

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

