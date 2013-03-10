use strict;
use warnings FATAL => 'all';

use Test::Tester 0.108;
use Test::More tests => 23;     # avoid our done_testing hook
use Test::Deep;

END {
    final_tests();
}

use Test::Warnings ':all';

# we swap out our $tb for Test::Tester's, so we can also test the results
# of the END block...
Test::Warnings::_builder(my $capture = Test::Tester::capture());


# as in t/01-basic.t...
allow_warnings;
ok(allowing_warnings, 'warnings are now allowed');
warn 'this warning will not cause a failure';
had_no_warnings;            # TEST 1

allow_warnings(qr/Foobar is broken/);

cmp_deeply(
    [ allowing_warnings ],
    [
        qr/Foobar is broken/,
    ],
    'allowing_warnings() returns the regex(es) we permit',
);

warn 'blah blah Foobar is broken etc etc';
had_no_warnings;            # TEST 2

# this will cause a test failure
warn 'some other warning';
had_no_warnings;            # TEST 3

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
                actual_ok => 1,
                ok => 1,
                name => 'no (unexpected) warnings',
                type => '',
                diag => '',
                depth => undef, # not testable in END blocks
            },
            {   # TEST 3
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
        'all functionality ok',
    );
}

