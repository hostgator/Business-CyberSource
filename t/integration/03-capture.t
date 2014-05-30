#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use Test::More;
use Test::Exception;
use String::Random qw(random_string);
use MooseX::Params::Validate;

use FindBin; use lib "$FindBin::Bin/lib";
use Test::Business::CyberSource::Client qw(create_client);
use Test::Business::CyberSource::Authorization qw(attempt_authorization);
use Test::Business::CyberSource::Capture qw(attempt_capture);

use Business::CyberSource::Client;

use DateTime;
use Math::Currency;
use Readonly;

Readonly my $AMEX_NUMBER        => "378282246310005";
Readonly my $VISA_NUMBER        => "4111111111111111";
Readonly my $MASTERCARD_NUMBER  => "5555555555554444";
Readonly my $DISCOVER_NUMBER    => "6011111111111117";

Readonly my $PAYMENT_AMOUNT => Math::Currency->new("100.00");
Readonly my $EXPIRED_AMOUNT => Math::Currency->new("3000.37");
Readonly my $DECLINE_AMOUNT => Math::Currency->new('3000.28');

my $client = create_client();

my $testing_hash = {
    'Visa' => [
        [ $VISA_NUMBER, $PAYMENT_AMOUNT, "ACCEPT", 100 ],
    ],
    'American Express' => [
        [ $AMEX_NUMBER, $PAYMENT_AMOUNT, "ACCEPT", 100 ],
    ],
    'MasterCard' => [
        [ $MASTERCARD_NUMBER, $PAYMENT_AMOUNT, "ACCEPT", 100 ],
    ],
    'Discover' => [
        [ $DISCOVER_NUMBER, $PAYMENT_AMOUNT, "ACCEPT", 100 ],
    ],
};

for my $card_type ( keys $testing_hash ) {
    for my $test (@{ $testing_hash->{$card_type} }) {

        my $original_auth_request_id;
        subtest "$card_type - Success" => sub {
            my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

            my ($authorization, $authorization_response) = attempt_authorization({
                client         => $client,
                reference_code => $reference_code,
                account_number => $test->[0],
                total          => $PAYMENT_AMOUNT,
                decision       => "ACCEPT",
                reason_code    => 100,
            });

            $original_auth_request_id = $authorization_response->request_id;
            my ($capture, $capture_response) = attempt_capture({
                client         => $client,
                reference_code => $reference_code,
                total          => $PAYMENT_AMOUNT,
                decision       => "ACCEPT",
                reason_code    => 100,
                authorization_request_id => $original_auth_request_id,
            });
        };

        subtest "$card_type - Double Capture the Same Auth" => sub {
            my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

            my ($capture, $capture_response) = attempt_capture({
                client         => $client,
                reference_code => $reference_code,
                total          => $PAYMENT_AMOUNT,
                decision       => "REJECT",
                reason_code    => 242,
                authorization_request_id => $original_auth_request_id,
            });
        };

        subtest "$card_type - Capture a Declined Auth" => sub {
            my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

            my ($authorization, $authorization_response) = attempt_authorization({
                client         => $client,
                reference_code => $reference_code,
                account_number => $test->[0],
                total          => $DECLINE_AMOUNT,
                decision       => "REJECT",
                reason_code    => 203,
            });

            my ($capture, $capture_response) = attempt_capture({
                client         => $client,
                reference_code => $reference_code,
                total          => $PAYMENT_AMOUNT,
                decision       => "REJECT",
                reason_code    => 102,
                authorization_request_id => $authorization_response->request_id,
            });
        };

        subtest "$card_type - Capture With No Auth" => sub {
            my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

            my ($capture, $capture_response) = attempt_capture({
                client         => $client,
                reference_code => $reference_code,
                total          => $PAYMENT_AMOUNT,
                decision       => "REJECT",
                reason_code    => 241,
                authorization_request_id => 0,
            });
        };
    }
}

done_testing;
