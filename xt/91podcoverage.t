use warnings;
use strict;

use Test::More;

use Pod::Coverage 0.19;
use Test::Pod::Coverage 1.04;

my @modules = sort { $a cmp $b } ( Test::Pod::Coverage::all_modules() );

# Since this is about checking documentation, a little documentation
# of what this is doing might be in order...
# The exceptions structure below is a hash keyed by the module
# name.  The value for each is a hash, which contains one or more
# (although currently more than one makes no sense) of the following
# things:-
#   skip   => a true value means this module is not checked
#   ignore => array ref containing list of methods which
#             do not need to be documented.
my $exceptions = {
    'SQL::Abstract' => { ignore => [qw(
      belch
      puke
      DETECT_AUTOGENERATED_STRINGIFICATION
    )]},
    'SQL::Abstract::Tree' => { ignore => [qw(BUILDARGS)] },
    'SQL::Abstract::Test' => { skip => 1 },
    'SQL::Abstract::Formatter' => { skip => 1 },
    'SQL::Abstract::Parts' => { skip => 1 },
    'DBIx::Class::Storage::Debug::PrettyPrint' => { skip => 1 },
};

foreach my $module (@modules) {
  SKIP:
    {
        skip "$module - No user visible methods",
          1
          if ( $exceptions->{$module}{skip} );

        # build parms up from ignore list
        my $parms = {};
        $parms->{trustme} =
          [ map { qr/^$_$/ } @{ $exceptions->{$module}{ignore} } ]
          if exists( $exceptions->{$module}{ignore} );

        # run the test with the potentially modified parm set
        pod_coverage_ok( $module, $parms, "$module POD coverage" );
    }
}

done_testing;
