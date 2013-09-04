use strict;
use warnings;

use Test::More tests => 3;
use Test::Warnings ':all';

pass('yay!');
like(warning { warn "oh noes!" }, qr/^oh noes/, 'we warned');
