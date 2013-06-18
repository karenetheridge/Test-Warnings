use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::CleanNamespaces;

                    # we would like to just do:
#all_namespaces_clean();
                    # ...but it also does: plan(@modules);
                    # which is not compatible with our adding a test via END

namespaces_clean(Test::CleanNamespaces->find_modules);

done_testing;
