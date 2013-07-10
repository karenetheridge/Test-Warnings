use strict;
use warnings FATAL => 'all';

use Test::More 0.94;
use Test::Pod::Coverage 1.08;
use Pod::Coverage::TrustPod;

use Test::Pod::Coverage;

# copied from all_pod_coverage_ok, but omitting the plan
#all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });
subtest all_pod_coverage_ok => sub {
    my @modules = all_modules();
    for my $module ( @modules ) {
        my $thismsg = "Pod coverage on $module";
        pod_coverage_ok( $module, { coverage_class => 'Pod::Coverage::TrustPod' }, $thismsg );
    }
};

done_testing;
