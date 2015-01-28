use strict;
use warnings;

use Test::More;

END {
    final_tests();
}

use Test::Warnings ':no_end_test';

warn 'this warning should not be caught';

pass 'a passing test to keep done_testing happy';

done_testing;

# this is run in the END block
sub final_tests
{
    # if there was anything else than 1 test run, then we will fail
    exit (Test::Builder->new->current_test <=> 1);
}
