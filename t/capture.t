use strict;
use warnings;
use Test::More;
use Test::Method;

use Module::Runtime qw( use_module );

my $capture = new_ok(
    use_module('Business::CyberSource::Request::Capture') => [
        {
            reference_code => 'not sending',
            service        => {
                request_id => 42,
            },
            purchase_totals => {
                total    => 2018.00,
                currency => 'USD',
            },
            invoice_header => {
                purchaser_vat_registration_number => 'ATU99999999',
                user_po                           => '123456',
                vat_invoice_reference_number      => '1234',
            },
        }
    ]
);

can_ok $capture, 'serialize';

my %expected = (
    merchantReferenceCode => 'not sending',
    purchaseTotals        => {
        grandTotalAmount => 2018.00,
        currency         => 'USD',
    },
    ccCaptureService => {
        authRequestID => 42,
        run           => 'true',
    },
    invoiceHeader => {
        purchaserVATRegistrationNumber => 'ATU99999999',
        userPO                         => '123456',
        vatInvoiceReferenceNumber      => '1234',
    },
);

method_ok $capture, serialize => [], \%expected;

done_testing;
