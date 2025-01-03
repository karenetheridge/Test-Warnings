use strict;
use warnings;
package Test2::Warnings;
# vim: set ts=8 sts=2 sw=2 tw=100 et :
# ABSTRACT: Test for warnings and the lack of them
# KEYWORDS: testing tests warnings Test2

our $VERSION = '0.036';

use base qw(Exporter);
use Import::Into;
use Test::Warnings;

sub import {
  shift->export_to_level(1);
  Test::Warnings->import::into(1);
}

1;
__END__

=pod

=head1 SYNOPSIS

    use Test2::V0;
    use Test::Warnings;

    pass('yay!');
    done_testing;

emits TAP:

    ok 1 - yay!
    ok 2 - no (unexpected) warnings (via done_testing)
    1..2

and:

    use Test::More tests => 3;
    use Test::Warnings 0.005 ':all';

    pass('yay!');
    like(warning { warn "oh noes!" }, qr/^oh noes/, 'we warned');

emits TAP:

    ok 1 - yay!
    ok 2 - we warned
    ok 3 - no (unexpected) warnings (via END block)
    1..3

=head1 DESCRIPTION

See L<Test::Warnings> for full documentation.

For now, this is a simple wrapper around L<Test::Warnings>, but there is a plan to make this a full
port and eject all the old L<Test::Builder> compatibility and use the Test2 suite correctly.

=head1 CAVEATS

This module depends on L<Import::Into>, which is not a prerequisite of the distribution because it
aims to be core-only. When it is moved to its own distribution the prerequisite will be declared
normally.

=cut
