
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "Perl interface to the CyberSource Simple Order SOAP API",
  "AUTHOR" => "Caleb Cushing <xenoterracide\@gmail.com>",
  "BUILD_REQUIRES" => {
    "Data::Dumper" => 0,
    "English" => 0,
    "Env" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::Exception" => 0,
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "Business-CyberSource",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "Business::CyberSource",
  "PREREQ_PM" => {
    "Business::CreditCard" => 0,
    "Carp" => 0,
    "Config" => 0,
    "File::ShareDir" => 0,
    "LWP::Protocol::https" => 0,
    "Locale::Country" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "MooseX::ABC" => 0,
    "MooseX::AbstractFactory" => 0,
    "MooseX::Aliases" => 0,
    "MooseX::SetOnce" => "0.200001",
    "MooseX::StrictConstructor" => 0,
    "MooseX::Traits" => 0,
    "MooseX::Types" => 0,
    "MooseX::Types::Common::Numeric" => "0.001003",
    "MooseX::Types::Common::String" => 0,
    "MooseX::Types::CreditCard" => "0.001001",
    "MooseX::Types::DateTime::W3C" => 0,
    "MooseX::Types::Email" => 0,
    "MooseX::Types::Locale::Country" => 0,
    "MooseX::Types::Locale::Currency" => 0,
    "MooseX::Types::Moose" => 0,
    "MooseX::Types::NetAddr::IP" => 0,
    "MooseX::Types::Path::Class" => 0,
    "MooseX::Types::Structured" => 0,
    "MooseX::Types::URI" => 0,
    "MooseX::Types::Varchar" => 0,
    "Path::Class" => 0,
    "XML::Compile::SOAP11" => 0,
    "XML::Compile::SOAP::WSS" => "0.12",
    "XML::Compile::Transport::SOAPHTTP" => 0,
    "XML::Compile::WSDL11" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "v0.4.1",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

package
MY;
use File::ShareDir::Install qw(postamble);


