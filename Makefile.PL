
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Business::CyberSource",
  "AUTHOR" => "Caleb Cushing <xenoterracide\@gmail.com>",
  "BUILD_REQUIRES" => {
    "English" => 0,
    "Env" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::Exception" => 0,
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Business-CyberSource",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "Business::CyberSource",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Config" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "MooseX::AbstractFactory" => 0,
    "MooseX::Aliases" => 0,
    "MooseX::Traits" => 0,
    "MooseX::Types" => 0,
    "MooseX::Types::CreditCard" => "0.001001",
    "MooseX::Types::DateTime::W3C" => 0,
    "MooseX::Types::Email" => 0,
    "MooseX::Types::Locale::Country" => 0,
    "MooseX::Types::Locale::Currency" => 0,
    "MooseX::Types::Moose" => 0,
    "MooseX::Types::URI" => 0,
    "MooseX::Types::Varchar" => 0,
    "SOAP::Data::Builder" => 0,
    "SOAP::Lite" => "0.714",
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "v0.1.11",
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



