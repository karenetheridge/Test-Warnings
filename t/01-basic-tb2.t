use strict;
use warnings FATAL => 'all';

# basic tests, using Test::Builder 1.005/TB2.

use Test::More;

BEGIN {
    plan skip_all => 'These tests are only for Test::Builder 1.005+'
        if Test::Builder->VERSION < 1.005;
}

# define our END block first, so it is run last (after TW's and TB2::Module's END)
END {
    final_tests()
        if Test::Builder->VERSION >= 1.005;
}

plan tests => 6;     # avoid our done_testing hook

use TB2::Tester;
use Test::Warnings ':all';

# now recording TB events in a new coordinator
# (code taken from TB2::Tester::capture)
require TB2::TestState;
my $state = TB2::TestState->default;
my $our_ec = $state->push_coordinator;

$our_ec->clear_formatters;
$our_ec->history(TB2::History->new(store_events => 1));

my %lines;

allow_warnings;

ok(allowing_warnings, 'warnings are now allowed');          # test 1
warn 'this warning will not cause a failure';
had_no_warnings;                                            $lines{test2} = __LINE__;

allow_warnings(0);
ok(!allowing_warnings, 'warnings are not allowed again');   # test 3
warn 'oh noes, something warned!';

allow_warnings(undef);
ok(!allowing_warnings, 'warnings are still not allowed');   #test 4

had_no_warnings('no warnings, with a custom name');         $lines{test5} = __LINE__;

# now we "END"...

# this is run in the END block
sub final_tests
{
    $state->pop_coordinator;
    my $results = $our_ec->history->results;

    result_like shift @$results, {
            name => 'warnings are now allowed',
            is_pass => 1,
        },
        'allowing_warnings() returned true';

    result_like shift @$results, {
            name => 'no (unexpected) warnings',
            file => __FILE__,
            line => $lines{test2},
            is_pass => 1,
        },
        'test 2 - had_no_warnings() produced a passing test';

    result_like shift @$results, {
            name => 'warnings are not allowed again',
            is_pass => 1,
        },
        'allowing_warnings() returned false';

    result_like shift @$results, {
            name => 'warnings are still not allowed',
            is_pass => 1,
        },
        'allowing_warnings still returned false';

    result_like shift @$results, {
            name => 'no warnings, with a custom name',
            file => __FILE__,
            line => $lines{test5},
            is_pass => 0,
        },
        'test 5 - had_no_warnings() produced a failing test';

    result_like shift @$results, {
            name => 'no (unexpected) warnings (via END block)',
            file => __FILE__,
            line => 0,  # END block has no line number
            is_pass => 0,
        },
        'test 5 - had_no_warnings() produced a failing test';
}

