#!perl

use strict;
use warnings;
use Test::More;

eval "require Test::Pod::Coverage; Test::Pod::Coverage->VERSION(1.08)";
plan skip_all => "Test::Pod::Coverage 1.08 required for testing POD coverage"
  if $@;

eval "use Pod::Coverage::TrustPod";
plan skip_all => "Pod::Coverage::TrustPod required for testing POD coverage"
  if $@;

use Test::Pod::Coverage tests => 2;

# copied from all_pod_coverage_ok, but omitting the plan
#all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });
subtest all_pod_coverage_ok => sub {
    my @modules = all_modules();
    for my $module ( @modules ) {
        my $thismsg = "Pod coverage on $module";
        pod_coverage_ok( $module, { coverage_class => 'Pod::Coverage::TrustPod' }, $thismsg );
    }
};

