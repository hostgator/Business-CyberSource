use strict;
use warnings;
use Test::More;

use Test::Moose;
use Module::Runtime qw( use_module );

my $br
	= new_ok( use_module('Business::CyberSource::RequestPart::BusinessRules') => [{
		ignore_avs_result => 1,
		ignore_cv_result  => 1,
		score_threshold   => 8,
		decline_avs_flags => [qw( Y N )],
	}]);

ok $br->ignore_avs_result,    '->ignore_avs_result';
ok $br->ignore_cv_result,     '->ignore_cv_result';
is $br->score_threshold,   8, '->score_threshold';

is_deeply $br->decline_avs_flags, [qw( Y N ) ], '->decline_avs_flags';

my %expected_serialized
	= (
		ignoreAVSResult => 'true',
		ignoreCVResult  => 'true',
		scoreThreshold  => 8,
		declineAVSFlags => 'Y N',
	);

is_deeply( $br->serialize, \%expected_serialized, 'serialized'          );

done_testing;
