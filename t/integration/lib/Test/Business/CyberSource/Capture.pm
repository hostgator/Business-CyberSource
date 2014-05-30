package Test::Business::CyberSource::Capture;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use MooseX::Params::Validate;

use Business::CyberSource::Client;
use Business::CyberSource::Request::Capture;

use Exporter 'import';
our @EXPORT_OK = qw( attempt_capture );

sub attempt_capture {
    my (%args) = validated_hash(
        \@_,
        client         => { isa => 'Business::CyberSource::Client' },
        reference_code => { isa => 'Str' },
        decision       => { isa => 'Str' },
        reason_code    => { isa => 'Int' },
        total          => { isa => 'Math::Currency' },
        authorization_request_id => { isa => 'Str' },
    );

    my $capture;
    lives_ok {
        $capture = Business::CyberSource::Request::Capture->new({
            reference_code => $args{reference_code},
            service => {
                request_id => $args{authorization_request_id},
            },
            purchase_totals => {
                currency => "USD",
                total    => $args{total}->as_float,
            },
        });
    } "Lives Through Capture Creation";

    my $response;
    lives_ok {
        $response = $args{client}->submit($capture);
    } "Lives through capture request";

    if( ok(defined $response, "Got a Well Formed Response") ) {
        cmp_ok($response->decision,    'eq', $args{decision}, "Correct decision");
        cmp_ok($response->reason_code, '==', $args{reason_code}, "Correct reason_code");
    }

    note("Capture Request ID: " . $response->request_id);

    return ($capture, $response);
};

1;
