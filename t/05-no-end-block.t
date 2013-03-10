use strict;
use warnings FATAL => 'all';

use Test::Tester 0.108;
use Test::More tests => 1;  # avoid our done_testing hook

END {
    final_tests();
}

use Test::Warnings ':no_end_test';

warn 'oh noes, something warned!';

# we swap out our $tb for Test::Tester's, so we can also test the results
# of the END block...
Test::Warnings::_builder(my $capture = Test::Tester::capture());

# this is run in the END block
sub final_tests
{
    my @tests = $capture->details;
    cmp_results(
        \@tests,
        [ ],
        'no tests were run!',
    );
}

