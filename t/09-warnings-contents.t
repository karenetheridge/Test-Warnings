use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Warnings ':all';
use Test::Deep;

{
    my @lines;
    my @warnings = warnings {
        warn 'testing 1 2 3';   push @lines, __LINE__;
        warn 'another warning'; push @lines, __LINE__;
    };

    my $file = __FILE__;
    cmp_deeply(
        \@warnings,
        [
            "testing 1 2 3 at $file line $lines[0].\n",
            "another warning at $file line $lines[1].\n",
        ],
        'successfully captured all warnings',
    );
}

{
    my @warnings = warnings {
        note 'no warning here';
        note 'nor here';
    };

    cmp_deeply(
        \@warnings,
        [ ],
        'successfully captured all warnings (none!)',
    );
}

done_testing;
