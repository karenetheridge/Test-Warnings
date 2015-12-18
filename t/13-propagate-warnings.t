use strict;
use warnings;

use Test::More;

my @warnings;
BEGIN {
    $SIG{__WARN__} = sub {
        note 'original warn handler captured a warning: ', $_[0];
        push @warnings, $_[0]
    };
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

done_testing;
