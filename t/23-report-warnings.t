use strict;
use warnings;

use Test::More 0.88;
use Test::Warnings qw/ :report_warnings /;

# TODO test without Test::Output
use Test::Output qw/ stderr_like /;

stderr_like sub {
    say STDERR "foo";
    warn "warning 1";
    warn "warning 2";
}, qr{foo}, 'test';

done_testing;

