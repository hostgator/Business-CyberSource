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
			service security_code => '1111';
			service object => (
				class        => 'Business::CyberSource::CreditCard',
				lifecycle    => 'Singleton',
				dependencies => {
					account_number => depends_on('visa_test_number'),
					security_code  => depends_on('security_code'),
					holder         => depends_on('holder'),
				},
				parameters => {
					account_number => {
						isa => 'Str',
						default => '4111111111111111'
					},
					expiration => {
						isa => 'HashRef',
						default => {
							month => 5,
							year  => 2025,
						},
					},
				},
			);
		};

		container request => as {
			service reference_code => (
				block => sub { return 'test-' . time },
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
						currency       => depends_on('../currency'),
					},
					parameters => {
						card  => {
							isa => 'Business::CyberSource::CreditCard',
							optional => 1,
						},
						total => {
							isa => 'Num',
							default => 5.00,
						},
						ignore_cv_result => {
							isa      => 'Bool',
							optional => 1,
						},
						ignore_avs_result => {
							isa      => 'Bool',
							optional => 1,
						},
						decline_avs_flags => {
							isa      => 'ArrayRef',
							optional => 1,
						},
					},
				);
			};
		};
	};
}

has '+name' => ( default => sub { __PACKAGE__ }, );

__PACKAGE__->meta->make_immutable;
1;
