package Test::Business::CyberSource::Client;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use MooseX::Params::Validate;

use Business::CyberSource::Client;

use Exporter 'import';
our @EXPORT_OK = qw( create_client );

sub create_client {
    my (%args) = validated_hash(
        \@_,
    );

    if(    ! defined $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME}
        || ! defined $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD} ) {

        plan( skip_all => 'PERL_BUSINESS_CYBERSOURCE_USERNAME and '
            . 'PERL_BUSINESS_CYBERSOURCE_PASSWORD must be defined in '
            . 'order to run integration tests' );
        return;
    }

    my $client;
    lives_ok {
        $client = Business::CyberSource::Client->new({
            user => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
            pass => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
            test => 1,
        });
    } "Lives through client creation";

    return ($client);
};

1;
