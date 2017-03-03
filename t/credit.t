use strict;
use warnings;
use Test::More;
use Test::Method;

use Module::Runtime 'use_module';
use FindBin; use lib "$FindBin::Bin/lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $dto
	= new_ok( use_module('Business::CyberSource::Request::Credit') => [{
		reference_code => 'notarealcode',
		bill_to =>
			$t->resolve( service => '/helper/bill_to' ),
		purchase_totals =>
			$t->resolve( service => '/helper/purchase_totals'),
		card =>
			$t->resolve( service => '/helper/card' ),
        invoice_header => $t->resolve( service => '/helper/invoice_header' ),
	}]);

my %expected = (
	billTo => {
		firstName   => 'Caleb',
		lastName    => 'Cushing',
		country     => 'US',
		ipAddress   => '192.168.100.2',
		street1     => '2104 E Anderson Ln',
		state       => 'TX',
		email       => 'xenoterracide@gmail.com',
		city        => 'Austin',
		postalCode => '78752',
	},
	card => {
		accountNumber   => '4111111111111111',
		cardType        => '001',
		cvIndicator     => 1,
		cvNumber        => 1111,
		expirationMonth => 5,
		expirationYear  => 2025,
		fullName        => 'Caleb Cushing',
	},
	ccCreditService => {
		run => 'true',
	},
	purchaseTotals => {
		currency         => 'USD',
		grandTotalAmount => 3000.00,
	},
	merchantReferenceCode => 'notarealcode',
    invoiceHeader => {
        purchaserVATRegistrationNumber => 'ATU99999999',
        userPO                         => '123456',
        vatInvoiceReferenceNumber      => '1234',
    },
);

method_ok $dto, serialize => [], \%expected;

done_testing;
