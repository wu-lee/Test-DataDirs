package Test::DataDirs::Exporter;
use strict;
use warnings;
use Test::DataDirs;
use Carp;
our @CARP_NOT = 'Test::DataDirs';

sub import {
    my $package = shift;
    my $target = caller;

    my $dirs = Test::DataDirs->new(@_)->dirs;
    no strict 'refs';
    for my $name (keys %$dirs) {
        *{"${target}::$name"} = \$dirs->{$name};
    }
}

1;
