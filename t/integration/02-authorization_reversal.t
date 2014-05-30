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
use Test::Business::CyberSource::Sale qw(attempt_sale);
use Test::Business::CyberSource::AuthorizationReversal qw(attempt_authorization_reversal);

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
    'Visa'             => $VISA_NUMBER,
    'MasterCard'       => $MASTERCARD_NUMBER,
    'Discover'         => $DISCOVER_NUMBER,
};

for my $card_type ( keys $testing_hash ) {
    my $original_authorization_request_id;
    subtest "$card_type - Reverse an Auth" => sub {
        my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

        my ($authorization, $authorization_response) = attempt_authorization({
            client         => $client,
            reference_code => $reference_code,
            account_number => $testing_hash->{$card_type},
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
        });

        $original_authorization_request_id = $authorization_response->request_id;
        my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
            authorization_request_id => $authorization_response->request_id,
        });
    };

    subtest "$card_type - Reverse an Already Reversed Auth" => sub {
        my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");
        my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "REJECT",
            reason_code    => 243,
            authorization_request_id => $original_authorization_request_id,
        });
    };

    subtest "$card_type - Reverse a Capture" => sub {
        my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

        my ($authorization, $authorization_response) = attempt_authorization({
            client         => $client,
            reference_code => $reference_code,
            account_number => $testing_hash->{$card_type},
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
        });

        my ($capture, $capture_response) = attempt_capture({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
            authorization_request_id => $authorization_response->request_id,
        });

        my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "REJECT",
            reason_code    => 243,
            authorization_request_id => $capture_response->request_id,
        });
    };

    subtest "$card_type - Reverse an Already Captured Auth" => sub {
        my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

        my ($authorization, $authorization_response) = attempt_authorization({
            client         => $client,
            reference_code => $reference_code,
            account_number => $testing_hash->{$card_type},
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
        });

        my ($capture, $capture_response) = attempt_capture({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
            authorization_request_id => $authorization_response->request_id,
        });

        my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "REJECT",
            reason_code    => 243,
            authorization_request_id => $authorization_response->request_id,
        });
    };

    subtest "$card_type - Reverse a Sale" => sub {
        my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

        my ($sale, $response) = attempt_sale({
            client         => $client,
            reference_code => $reference_code,
            account_number => $testing_hash->{$card_type},
            total          => $PAYMENT_AMOUNT,
            decision       => "ACCEPT",
            reason_code    => 100,
        });

        my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "REJECT",
            reason_code    => 243,
            authorization_request_id => $response->request_id,
        });
    };

    subtest "$card_type - Reverse a Declined Authorization" => sub {
        my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

        my ($authorization, $authorization_response) = attempt_authorization({
            client         => $client,
            reference_code => $reference_code,
            account_number => $testing_hash->{$card_type},
            total          => $DECLINE_AMOUNT,
            decision       => "REJECT",
            reason_code    => 203,
        });

        $original_authorization_request_id = $authorization_response->request_id;
        my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
            client         => $client,
            reference_code => $reference_code,
            total          => $PAYMENT_AMOUNT,
            decision       => "REJECT",
            reason_code    => 102,
            authorization_request_id => $authorization_response->request_id,
        });
    };
}

subtest "American Express - Reverse an Auth" => sub {
    my $reference_code = "R" . random_string("nnCCnnCCnnCCnnCCnnCC");

    my ($authorization, $authorization_response) = attempt_authorization({
        client         => $client,
        reference_code => $reference_code,
        account_number => $AMEX_NUMBER,
        total          => $PAYMENT_AMOUNT,
        decision       => "ACCEPT",
        reason_code    => 100,
    });

    my ($authorization_reversal, $authorization_reversal_response) = attempt_authorization_reversal({
        client         => $client,
        reference_code => $reference_code,
        total          => $PAYMENT_AMOUNT,
        decision       => "REJECT",
        reason_code    => 231,
        authorization_request_id => $authorization_response->request_id,
    });
};

done_testing;
