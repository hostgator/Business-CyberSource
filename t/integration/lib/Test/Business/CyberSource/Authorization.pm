package Test::Business::CyberSource::Authorization;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use MooseX::Params::Validate;

use Business::CyberSource::Client;
use Business::CyberSource::Request::Authorization;

use Exporter 'import';
our @EXPORT_OK = qw( attempt_authorization );

sub attempt_authorization {
    my (%args) = validated_hash(
        \@_,
        client         => { isa => 'Business::CyberSource::Client' },
        reference_code => { isa => 'Str' },
        account_number => { isa => 'Str' },
        decision       => { isa => 'Str' },
        reason_code    => { isa => 'Int' },
        total          => { isa => 'Math::Currency' },
    );

    my $authorization;
    lives_ok {
        $authorization = Business::CyberSource::Request::Authorization->new({
            reference_code => $args{reference_code},
            bill_to => {
                first_name  => "Robert",
                last_name   => "Stone",
                street      => "123 Main St",
                city        => "Houston",
                state       => "TX",
                postal_code => "77088",
                country     => "US",
                email       => "drzigman\@cpan.org",
            },
            purchase_totals => {
                currency => "USD",
                total    => $args{total}->as_float,
            },
            card => {
                account_number => $args{account_number},
                expiration => {
                    month => DateTime->now->month,
                    year  => DateTime->now->year + 1,
                },
            },
            business_rules => {
                ignore_avs_result => 1
            },
        });
    } "Lives Through Authorization Creation";

    my $response;
    lives_ok {
        $response = $args{client}->submit($authorization);
    } "Lives through authorization request";

    if( ok(defined $response, "Got a Well Formed Response") ) {
        cmp_ok($response->decision,    'eq', $args{decision}, "Correct decision");
        cmp_ok($response->reason_code, '==', $args{reason_code}, "Correct reason_code");
    }

    note("Authorization Request ID: " . $response->request_id);

    return ($authorization, $response);
};

1;
