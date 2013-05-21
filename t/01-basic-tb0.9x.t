use strict;
use warnings FATAL => 'all';

# basic tests, using Test::Builder 0.98 or earlier.

use Test::Tester 0.108;
use Test::More;

plan skip_all => 'These tests are only for Test::Builder 0.9x'
    if Test::Builder->VERSION >= 1.005;

plan tests => 19;     # avoid our done_testing hook

# define our END block first, so it is run last (after TW's END)
END {
    final_tests()
        if Test::Builder->VERSION < 1.005;
}

use Test::Warnings ':all';

# we swap out our $tb for Test::Tester's, so we can also test the results
# of the END block... (although not all methods are supported!)
Test::Warnings::_builder(my $capture = Test::Tester::capture());

allow_warnings;
ok(allowing_warnings, 'warnings are now allowed');
warn 'this warning will not cause a failure';
had_no_warnings;                                        # TEST 1

allow_warnings(0);
ok(!allowing_warnings, 'warnings are not allowed again');
warn 'oh noes, something warned!';

allow_warnings(undef);
ok(!allowing_warnings, 'warnings are still not allowed');

had_no_warnings('no warnings, with a custom name');     # TEST 2

# now we "END"...

# this is run in the END block
sub final_tests
{
    my @tests = $capture->details;
    cmp_results(
        \@tests,
        [
            {   # TEST 1
                actual_ok => 1,
                ok => 1,
                name => 'no (unexpected) warnings',
                type => '',
                diag => '',
                depth => undef, # not testable in END blocks
            },
            {   # TEST 2
                actual_ok => 0,
                ok => 0,
                name => 'no warnings, with a custom name',
                type => '',
                diag => '',
                depth => undef, # not testable in END blocks
            },

            {   # END
                actual_ok => 0,
                ok => 0,
                name => 'no (unexpected) warnings (via END block)',
                type => '',
                diag => '',
                depth => undef, # not testable in END blocks
            },
        ],
        'all functionality ok, checking warnings via END block',
    );
}

