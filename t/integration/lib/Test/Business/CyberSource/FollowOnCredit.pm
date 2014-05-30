package Test::Business::CyberSource::FollowOnCredit;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use MooseX::Params::Validate;

use Business::CyberSource::Client;
use Business::CyberSource::Request::FollowOnCredit;

use Exporter 'import';
our @EXPORT_OK = qw( attempt_follow_on_credit );

sub attempt_follow_on_credit {
    my (%args) = validated_hash(
        \@_,
        client         => { isa => 'Business::CyberSource::Client' },
        reference_code => { isa => 'Str' },
        decision       => { isa => 'Str' },
        reason_code    => { isa => 'Int' },
        total          => { isa => 'Math::Currency' },
        payment_request_id => { isa => 'Str' },
    );

    my $credit;
    lives_ok {
        $credit = Business::CyberSource::Request::FollowOnCredit->new({
            reference_code => $args{reference_code},
            service => {
                request_id => $args{payment_request_id},
            },
            purchase_totals => {
                currency => "USD",
                total    => $args{total}->as_float,
            },
        });
    } "Lives Through Credit Creation";

    my $response;
    lives_ok {
        $response = $args{client}->submit($credit);
    } "Lives through capture request";

    if( ok(defined $response, "Got a Well Formed Response") ) {
        cmp_ok($response->decision,    'eq', $args{decision}, "Correct decision");
        cmp_ok($response->reason_code, '==', $args{reason_code}, "Correct reason_code");
    }

    note("Follow On Credit Request ID: " . $response->request_id);

    return ($credit, $response);
};

1;
