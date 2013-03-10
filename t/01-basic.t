use strict;
use warnings FATAL => 'all';

use Test::Tester 0.108;
use Test::More tests => 19;     # avoid our done_testing hook

END {
    final_tests();
}

use Test::Warnings ':all';

# we swap out our $tb for Test::Tester's, so we can also test the results
# of the END block...
Test::Warnings::_builder(my $capture = Test::Tester::capture());

is(1, 1, 'passing test');

allow_warnings;
ok(allowing_warnings, 'warnings are now allowed');
warn 'this warning will not cause a failure';
had_no_warnings;            # TEST 1

allow_warnings(0);
ok(!allowing_warnings, 'warnings are not allowed again');
warn 'oh noes, something warned!';

had_no_warnings;            # TEST 2

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
                name => 'no (unexpected) warnings',
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

