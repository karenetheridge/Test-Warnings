use strict;
use warnings;

use Test::More;

BEGIN {
    $SIG{__WARN__} = 'does_not_exist';
}

use Test::Warnings qw(:all :no_end_test);

eval { warn 'hello this is a warning' };
is($@, '', 'non-existent sub in warning handler does not result in an exception');

SKIP: {
    skip 'PadWalker required for this test', 1
        if not eval 'require PadWalker';
    is(
        ${ PadWalker::closed_over(\&Test::Warnings::had_no_warnings)->{'$forbidden_warnings_found'} },
        1,
        'Test::Warnings saw the warning go by',
    );
}

done_testing;
