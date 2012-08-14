package Business::CyberSource::Factory::Response;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006002'; # VERSION

use Moose;
extends 'Business::CyberSource::Factory';

use Module::Runtime qw( use_module );

use Exception::Base (
	'Business::CyberSource::Exception' => {
		has => [ qw( answer ) ],
	},
	'Business::CyberSource::Response::Exception' => {
		isa => 'Business::CyberSource::Exception',
		has => [
			qw(decision reason_text reason_code request_id request_token trace)
		],
		string_attributes => [ qw( message decision reason_text ) ],
	},
	verbosity      => 4,
	ignore_package => [ __PACKAGE__, 'Business::CyberSource::Client' ],
);

sub create {
	my ( $self, $dto, $answer ) = @_;

	my $result = $answer->{result};

	my $decision = $self->_get_decision( $result );

	# the reply is a subsection of result named after the specic request, e.g
	# ccAuthReply
	my $reply = $self->_get_reply( $result );

	my @traits;
	my $e = { }; # response constructor args
	my $prefix      = 'Business::CyberSource::';
	my $req_prefix  = $prefix . 'Request::';
	my $res_prefix  = $prefix . 'Response::';
	my $role_prefix = $res_prefix . 'Role::';

	if ( $result->{decision} eq 'ACCEPT' ) {
		push( @traits, $role_prefix .'Accept' );

		my $ptotals = $result->{purchaseTotals};

		$e->{currency}       = $ptotals->{currency};
		$e->{reference_code} = $result->{merchantReferenceCode};
		$e->{amount}         = $reply->{amount} if $reply->{amount};
		$e->{request_specific_reason_code} = "$reply->{reasonCode}";

		my $datetime   = $self->_get_datetime( $reply );
		$e->{datetime} = $datetime if $datetime;

		if( $reply->{reconciliationID} ) {
			push( @traits, $role_prefix . 'ReconciliationID');
			$e->{reconciliation_id} = $reply->{reconciliationID};
		}

		if ( $dto->isa( $req_prefix . 'DCC') ) {
				push ( @traits, $role_prefix . 'DCC' );
				$e->{exchange_rate   } = $ptotals->{exchangeRate};
				$e->{foreign_currency} = $ptotals->{foreignCurrency};
				$e->{foreign_amount  } = $ptotals->{foreignAmount};
				$e->{valid_hours     } = $reply->{validHours};

				$e->{dcc_supported}
						=$reply->{dccSupported} eq 'TRUE' ? 1 : 0
						;

				$e->{exchange_rate_timestamp}
						= $ptotals->{exchangeRateTimeStamp}
						;

				$e->{margin_rate_percentage} = $reply->{marginRatePercentage};
		}
	}

	if ( defined $reply->{processorResponse} ) {
		push ( @traits, $role_prefix . 'ProcessorResponse' );
		$e->{processor_response} = $reply->{processorResponse};
	}

	if ( $dto->isa( $req_prefix . 'Authorization') ) {
		if ( $result->{ccAuthReply} ) {
			push( @traits, $role_prefix . 'Authorization' );

			$e->{auth_code}
				=  $reply->{authorizationCode}
				if $reply->{authorizationCode}
				;


			if ( $reply->{cvCode} && $reply->{cvCodeRaw}) {
				$e->{cv_code}     = $reply->{cvCode};
				$e->{cv_code_raw} = $reply->{cvCodeRaw};
			}

			if ( $reply->{avsCode} && $reply->{avsCodeRaw}) {
				$e->{avs_code}     = $reply->{avsCode};
				$e->{avs_code_raw} = $reply->{avsCodeRaw};
			}

			$e->{auth_record} = $reply->{authRecord} if $reply->{authRecord};
		}
	}

	my $response = use_module('Business::CyberSource::Response')
		->with_traits( @traits )
		->new({
			request_id     => $result->{requestID},
			decision       => $decision,
			# quote reason_code to stringify from BigInt
			reason_code    => "$result->{reasonCode}",
			request_token  => $result->{requestToken},
			%{$e},
		});

	$response->_trace( $dto->trace ) if $dto->has_trace;

	if ( $decision eq 'ERROR' ) {
		my %exception = (
			message       => 'message from CyberSource\'s API',
			decision      => $response->decision,
			reason_text   => $response->reason_text,
			reason_code   => $response->reason_code,
			value         => $response->reason_code,
			request_id    => $response->request_id,
			request_token => $response->request_token,
		);
		$exception{trace} = $response->trace if $response->has_trace;

		Business::CyberSource::Response::Exception->throw( %exception );
	}

	return $response;
}

sub _get_datetime {
	my ( $self, $reply ) = @_;

	my $datetime
		= $reply->{requestDateTime} ? $reply->{requestDateTime}
		:                             $reply->{authorizedDateTime}
		;

	return $datetime;
}

sub _get_reply {
	my ( $self, $result ) = @_;
	my $_;

	my $reply;
	foreach ( sort keys %{ $result } ) {
		if ( $_ =~ m/Reply/x ) {
			unless ( defined $reply ) {
				$reply = $result->{$_}
			}
			else {
				# sale's have 2 Reply sections, this merges them
				require  Hash::Merge;
				$reply = Hash::Merge::merge( $result->{$_}, $reply );
			}
		}
	}

	return $reply;
}

sub _get_decision {
	my ( $self, $result ) = @_;

	my $_;

	my ( $decision )
		= grep {
			$_ eq $result->{decision}
		}
		qw( ERROR ACCEPT REJECT )
		or Business::CyberSource::Exception->throw(
			message  => 'decision not defined or not handled',
			answer   => $result,
		)
		;

	return $decision;
}

1;

# ABSTRACT: A Response Factory


__END__
=pod

=head1 NAME

Business::CyberSource::Factory::Response - A Response Factory

=head1 VERSION

version 0.006002

=head1 METHODS

=head2 create

Pass the C<answer> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

