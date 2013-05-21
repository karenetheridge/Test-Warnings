use strict;
use warnings FATAL => 'all';

use Test::More;

pass 'here is a passing test, to keep plan happy';

use if $ENV{FOO} || $ENV{BAR}, 'Test::Warnings';

warn 'this is not a fatal warning, because Test::Warnings is not loaded';

done_testing;
