package Business::CyberSource::Response::Role::ElectronicVerification;

use strict;
use warnings;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw(ElectronicVerificationResult);

has ev_email => (
    is           => 'ro',
    isa          => ElectronicVerificationResult,
    remote_name  => 'evEmail',
    predicate    => 'has_ev_email',
    required     => 0,
);

has ev_phone_number => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evPhoneNumber',
    predicate   => 'has_ev_phone_number',
    required    => 0,
);

has ev_postal_code => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evPostalCode',
    predicate   => 'has_ev_postal_code',
    required    => 0,
);

has ev_name => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evName',
    predicate   => 'has_ev_name',
    required    => 0,
);

has ev_street => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evStreet',
    predicate   => 'has_ev_street',
    required    => 0,
);

has ev_email_raw => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evEmailRaw',
    predicate   => 'has_ev_email_raw',
    required    => 0,
);

has ev_phone_number_raw => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evPhoneNumberRaw',
    predicate   => 'has_ev_phone_number_raw',
    required    => 0,
);

has ev_postal_code_raw => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evPostalCodeRaw',
    predicate   => 'has_ev_postal_code_raw',
    required    => 0,
);

has ev_name_raw => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evNameRaw',
    predicate   => 'has_ev_name_raw',
    required    => 0,
);

has ev_street_raw => (
    is          => 'ro',
    isa         => ElectronicVerificationResult,
    remote_name => 'evStreetRaw',
    predicate   => 'has_ev_street_raw',
    required    => 0,
);

1;

# ABSTRACT: Eletronic Verification Information

=head1 DESCRIPTION

When performing Authorization requests for American Express credit cards for some processors
CyberSource will respond with Electronic Verification Information.  This Role implements support
for them.

All attributes have values according to CyberSource's documentation available at
L<http://apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_SO_API/Credit_Cards_SO_API.pdf>

There are two types of attributes, B<raw> are values specified by your payment processor while
all other attributes are mapped by CyberSource from values specified by the payment processor.
It is strongly recommened that you avoid the raw values if possible to account for differences
in payment processors.

The possible values for the mapped fields include (shamelessly taken from CyberSource's Documentation):

=over 4

=item 'N'

No, the data does not match.

=item 'P'

The processor did not return verification information.

=item 'R'

The system is unavailable, so retry.

=item 'S'

The verification service is not available.

=item 'U'

Verification information is not available.

=item 'Y'

Yes, the data matches.

=item '2'

The processor returned an unrecognized value.

=back

=attr ev_email

=attr ev_phone_number

=attr ev_postal_code

=attr ev_name

=attr ev_street

=attr ev_email_raw

=attr ev_phone_number_raw

=attr ev_postal_code_raw

=attr ev_name_raw

=attr ev_street_raw

