use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Warnings ':all';

is(1, 1, 'passing test');

my $had_no_warnings_called;

{
    no strict 'refs';
    my $orig = *{'Test::Warnings::had_no_warnings'}{CODE};
    no warnings 'redefine';
    *{'Test::Warnings::had_no_warnings'} = sub(;$) {
        $had_no_warnings_called++;
        $orig->(@_);
    };
}

subtest 'here is a subtest' => sub {
    pass('another passing test');
    # done_testing automatically called here - but no test is added
};

ok(!$had_no_warnings_called, 'had_no_warnings was not called via the subtest\'s done_testing');

done_testing;

# we are done testing, so we need to signal our status via exit codes.
exit($had_no_warnings_called ? 0 : 1);

