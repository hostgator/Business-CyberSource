use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Class::Load 'load_class';

my $billto_c = load_class('Business::CyberSource::RequestPart::BillTo');

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

like $exception1, qr/postal_code is required for US or Canada/,
	'us/ca require a zip code';

my $exception2
	= exception { $billto_c->new({
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		country        => 'US',
		postal_code    => '77064',
		email          => 'xenoterracide@gmail.com',
	});
};

like $exception2, qr/state is required for US or Canada/,
	'us/ca require a state';

done_testing;
