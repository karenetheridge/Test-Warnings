use strict;
use warnings;

use Test::More;
use Test::Warnings ':all';

pass('yay!');
like(warning { warn "oh noes!" }, qr/^oh noes/, 'we warned');

done_testing;

