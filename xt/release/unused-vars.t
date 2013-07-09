#!perl

use Test::More 0.88;

eval "use Test::Vars";
plan skip_all => "Test::Vars required for testing unused vars"
  if $@;

subtest 'all_vars_ok' => sub { all_vars_ok() };

done_testing;
