use strict;
use warnings;

use Test::More;
plan skip_all => 'PadWalker required for this test'
    if not eval 'require PadWalker';

sub IGNORE {
    die 'IGNORE sub called; this is wrong!';
}

BEGIN {
    $SIG{__WARN__} = 'IGNORE';
}

use Test::Warnings qw(:all :no_end_test);

warn 'this warning should not be caught';

is(
    ${ PadWalker::closed_over(\&Test::Warnings::had_no_warnings)->{'$forbidden_warnings_found'} },
    1,
    'Test::Warnings allowed the warning to go by',
);

done_testing;
