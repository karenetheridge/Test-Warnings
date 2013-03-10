use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Warnings ':all';

is(1, 1, 'passing test');

subtest 'here is a subtest' => sub {
    pass('another passing test');
    # done_testing automatically called here - but no test is added
};

done_testing;

