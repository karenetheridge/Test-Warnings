use strict;
use warnings;
use Test::More;
use Test::Warnings ':all', -pattern => qr/\bOK\b/;

ok 1;
warn 'Maybe OK';

done_testing;
