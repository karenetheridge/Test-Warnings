use strict;
use warnings;

use Test::More tests => 1;

END {
    final_tests();
}

use Test::Warnings 'warning';       # should not add an END test
use Test::Warnings ':no_end_test';

warn 'this warning should not be caught';

like(warning { warn 'ohhai' }, qr/^ohhai/, 'warning() was imported');

# this is run in the END block
sub final_tests
{
    # if there was anything else than 1 test run, then we will fail
    exit (Test::Builder->new->current_test <=> 1);
}
