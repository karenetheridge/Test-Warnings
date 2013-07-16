use strict;
use warnings FATAL => 'all';

use Test::More 0.94;
use Test::CleanNamespaces;

subtest all_namespaces_clean => sub { all_namespaces_clean() };

done_testing;
