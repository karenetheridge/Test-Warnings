package Test::Warning;
# ABSTRACT: ...

use strict;
use warnings;

use Exporter 'import';
use Test::Builder;
use Class::Method::Modifiers;

our @EXPORT_OK = qw(allow_warnings allowing_warnings had_no_warnings);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

my $warnings_allowed;
my $forbidden_warnings_found;
my $done_testing_called;

# for testing this module only!
my $tb;
sub _builder(;$)
{
    if (not @_)
    {
        $tb ||= Test::Builder->new;
        return $tb;
    }

    $tb = shift;
}

$SIG{__WARN__} = sub {
    my $msg = shift;
    warn $msg;
    $forbidden_warnings_found++ if not $warnings_allowed;
};

# monkeypatch Test::Builder::done_testing:
# check for any forbidden warnings, and record that we have done so
# so we do not check again via END
Class::Method::Modifiers::install_modifier('Test::Builder',
    before => done_testing => sub {
        # only do this at the end of all tests, not at the end of a subtest
        if (not _builder()->parent)
        {
            local $Test::Builder::Level = $Test::Builder::Level + 3;
            had_no_warnings('no (unexpected) warnings (via done_testing)');
            $done_testing_called = 1;
        }
    },
);

END {
    if (not $done_testing_called)
    {
        local $Test::Builder::Level = $Test::Builder::Level + 1;
        had_no_warnings('no (unexpected) warnings (via END block)');
    }
}

# setter
sub allow_warnings(;$)
{
    $warnings_allowed = defined $_[0] ? $_[0] : 1;
}

# getter
sub allowing_warnings() { $warnings_allowed }

# call at any time to assert no (unexpected) warnings so far
sub had_no_warnings(;$)
{
    _builder()->ok(!$forbidden_warnings_found, shift || 'no (unexpected) warnings');
}

1;
__END__

=pod

=head1 SYNOPSIS

...

=head1 METHODS

=over

=item * C<foo>

=back

...

=head1 SUPPORT

Bugs may be submitted through L<https://rt.cpan.org/Public/Dist/Display.html?Name= >.
I am also usually active on irc, as 'ether' at L<irc://irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

...

=head1 SEE ALSO

...

=cut
