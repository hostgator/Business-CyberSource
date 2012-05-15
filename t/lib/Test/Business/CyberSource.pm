package Test::Business::CyberSource;
use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	my $self = shift;
	return container $self => as {
		container client => as {
			service username   => "$ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME}";
			service password   => "$ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD}";
			service production => 0;
			service object     => (
				class        => 'Business::CyberSource::Client',
				lifecycle    => 'Singleton',
				dependencies => {
					username   => depends_on('username'),
					password   => depends_on('password'),
					production => depends_on('production'),
				},
			);
		};

		container credit_card => as {
			service holder     => 'Caleb Cushing';
			service expiration => (
				block => sub { return { month => 5, year => 2025 } },
			);
			service security_code => '1111';
			service visa_test_number => '4111-1111-1111-1111';
			service visa => (
				class        => 'Business::CyberSource::CreditCard',
				lifecycle    => 'Singleton',
				dependencies => {
					account_number => depends_on('visa_test_number'),
					expiration     => depends_on('expiration'),
					security_code  => depends_on('security_code'),
					holder         => depends_on('holder'),
				},
			);
		};

		container request => as {
			service reference_code => (
				lifecycle => 'Singleton',
				block     => sub { return 'test-' . time },
			);
			service first_name     => 'Caleb';
			service last_name      => 'Cushing';
			service street         => 'somewhere';
			service city           => 'Houston';
			service state          => 'TX';
			service postal_code    => '77064';
			service country        => 'USA';
			service email          => 'xenoterracide@gmail.com';
			service ip_address     => '192.168.100.2';
			service total          => 5.00;
			service currency       => 'USD';
			container authorization => as {
				service visa => (
					class => 'Business::CyberSource::Request::Authorization',
					dependencies => {
						card           => depends_on('/credit_card/visa'),
						reference_code => depends_on('../reference_code'),
						first_name     => depends_on('../first_name'),
						last_name      => depends_on('../last_name'),
						street         => depends_on('../street'),
						city           => depends_on('../city'),
						state          => depends_on('../state'),
						postal_code    => depends_on('../postal_code'),
						country        => depends_on('../country'),
						email          => depends_on('../email'),
						ip_address     => depends_on('../ip_address'),
						total          => depends_on('../total'),
						currency       => depends_on('../currency'),
					},
				);
			};
		};

		container response => as {
			container authorization => as {
				service visa => (
					block => sub {
						my $s = shift;

						return $s
							->param('client')
							->run_transaction( $s->param('auth') );
					},
					dependencies => {
						client => depends_on('/client/object'),
						auth   => depends_on('/request/authorization/visa'),
					},
				);
			};
		};
	};
}

has '+name' => ( default => sub { __PACKAGE__ }, );

__PACKAGE__->meta->make_immutable;
1;
