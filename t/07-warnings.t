use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Warnings ':all';

is(warning { warn "Foo\n" }, "Foo\n", 'Warned Foo');
is_deeply([ warnings { warn "Foo\n"; warn "Bar\n" } ], [ "Foo\n", "Bar\n" ], 'Warned Foo and Bar');

done_testing;
