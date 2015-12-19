use strict;
use warnings;

use Test::More;
plan skip_all => 'PadWalker required for this test'
    if not eval 'require PadWalker';

my @warnings;
sub warning_capturer {
    note 'original warn handler captured a warning: ', $_[0];
    push @warnings, $_[0]
}

BEGIN {
    $SIG{__WARN__} = 'warning_capturer';
}

use Test::Warnings qw(:all :no_end_test);

warn 'hello this is a warning'; my $file = __FILE__; my $line = __LINE__;

is(@warnings, 1, 'got one warning propagated')
    &&
is(
    $warnings[0],
    "hello this is a warning at $file line $line.\n",
    '..and it is the warning we just issued, with original location intact',
)
    ||
diag 'warnings propagated to original handler: ', explain \@warnings;

is(
    ${ PadWalker::closed_over(\&Test::Warnings::had_no_warnings)->{'$forbidden_warnings_found'} },
    1,
    'Test::Warnings also saw the warning go by',
);

done_testing;
