use strict;
use warnings;

use Test::More;

sub IGNORE {
    die 'IGNORE sub called; this is wrong!';
}

BEGIN {
    $SIG{__WARN__} = 'IGNORE';
}

use Test::Warnings qw(:all :no_end_test);

warn 'this warning should not be caught';

SKIP: {
    skip 'PadWalker required for this test', 1
        if not eval 'require PadWalker';
    is(
        ${ PadWalker::closed_over(\&Test::Warnings::had_no_warnings)->{'$forbidden_warnings_found'} },
        1,
        'Test::Warnings saw the warning, and allowed it to go by',
    );
}

done_testing;
