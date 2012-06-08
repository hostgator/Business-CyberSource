use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Module::Runtime qw( use_module );

my $billto_c = use_module('Business::CyberSource::RequestPart::BillTo');

my $exception0
	= exception { $billto_c->new({
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'blerg',
		email          => 'xenoterracide@gmail.com',
	})
};

like $exception0, qr/Attribute \(country\)/, 'country invalid';

my $exception1
	= exception { $billto_c->new({
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
	});
};

like $exception1, qr/postal code is required for US or Canada/, 'us/ca require a zip code';

done_testing;
