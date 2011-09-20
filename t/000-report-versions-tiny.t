use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

my $v = "\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.008';
    my $pv = ($^V || $]);
    $v .= "perl: $pv (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Business::CreditCard','any version') };
eval { $v .= pmver('Carp','any version') };
eval { $v .= pmver('Config','any version') };
eval { $v .= pmver('English','any version') };
eval { $v .= pmver('Env','any version') };
eval { $v .= pmver('ExtUtils::MakeMaker','6.30') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::ShareDir','any version') };
eval { $v .= pmver('File::ShareDir::Install','0.03') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('Locale::Country','any version') };
eval { $v .= pmver('Moose','any version') };
eval { $v .= pmver('Moose::Role','any version') };
eval { $v .= pmver('MooseX::AbstractFactory','any version') };
eval { $v .= pmver('MooseX::Aliases','any version') };
eval { $v .= pmver('MooseX::StrictConstructor','any version') };
eval { $v .= pmver('MooseX::Traits','any version') };
eval { $v .= pmver('MooseX::Types','any version') };
eval { $v .= pmver('MooseX::Types::Common::Numeric','0.001003') };
eval { $v .= pmver('MooseX::Types::Common::String','any version') };
eval { $v .= pmver('MooseX::Types::CreditCard','0.001001') };
eval { $v .= pmver('MooseX::Types::DateTime::W3C','any version') };
eval { $v .= pmver('MooseX::Types::Email','any version') };
eval { $v .= pmver('MooseX::Types::Locale::Country','any version') };
eval { $v .= pmver('MooseX::Types::Locale::Currency','any version') };
eval { $v .= pmver('MooseX::Types::Moose','any version') };
eval { $v .= pmver('MooseX::Types::NetAddr::IP','any version') };
eval { $v .= pmver('MooseX::Types::Path::Class','any version') };
eval { $v .= pmver('MooseX::Types::Structured','any version') };
eval { $v .= pmver('MooseX::Types::URI','any version') };
eval { $v .= pmver('MooseX::Types::Varchar','any version') };
eval { $v .= pmver('Path::Class','any version') };
eval { $v .= pmver('Test::Exception','any version') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('XML::Compile::SOAP11','any version') };
eval { $v .= pmver('XML::Compile::SOAP::WSS','0.12') };
eval { $v .= pmver('XML::Compile::Transport::SOAPHTTP','any version') };
eval { $v .= pmver('XML::Compile::WSDL11','any version') };
eval { $v .= pmver('namespace::autoclean','any version') };
eval { $v .= pmver('strict','any version') };
eval { $v .= pmver('warnings','any version') };



# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve you problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
