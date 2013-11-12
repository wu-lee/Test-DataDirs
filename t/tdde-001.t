#!/usr/bin/perl 
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";

my $bin = $Bin;

sub pkgvar {
    my $name = shift;
    my $caller = caller;
    no strict 'refs';
    
    return ${ *{"${caller}::$name"} };
}

{
    package A;
    use Test::More;

    # Simplest usage, with not parameters, should export
    # $data_dir and $temp_dir, check for $data_dir and create $temp_dir
    use Test::DataDirs::Exporter;

    is $data_dir, "$bin/data/tdde-001", "\$data_dir is set correctly";
    ok -d $data_dir, "$data_dir exists and is a directory";
    
    is $temp_dir, "$bin/temp/tdde-001", "\$temp_dir is set correctly";
    ok -d $temp_dir, "$temp_dir exists and is a directory";
}

{
    package B;
    use Test::More;

    # More prescriptive case, where variable names are mapped to
    # directories.  Should export variables $ip, $op, $oo and $ee to
    # map to directories 'hip', 'hop' below temp/tdde-001/' and
    # 'mee'. 'moo' below data/tdde-001/.
    use Test::DataDirs::Exporter (
        temp => [ip => 'hip', op => 'hop'],
        data => [oo => 'moo', ee => 'mee'],
    );

    is $data_dir, "$bin/data/tdde-001", "\$data_dir is set correctly";
    ok -d $data_dir, "$data_dir exists and is a directory";
    
    is $temp_dir, "$bin/temp/tdde-001", "\$temp_dir is set correctly";
    ok -d $temp_dir, "$temp_dir exists and is a directory";

    for (qw(oo ee)) {
        is ::pkgvar($_), "$bin/data/tdde-001/m$_", "\$$_ is set correctly";
        ok -d ::pkgvar($_), ::pkgvar($_ )." exists and is a directory";
    }

    for (qw(ip op)) {
        is ::pkgvar($_), "$bin/temp/tdde-001/h$_", "\$$_ is set correctly";
        ok -d ::pkgvar($_), ::pkgvar($_)." exists and is a directory";
    }
}

{
    package C;
    use Test::More;

    # Most prescriptive case, as above but s/tdde-001/zoon/
    use Test::DataDirs::Exporter (
        base => 'zoon',
        temp => [ip => 'hip', op => 'hop'],
        data => [oo => 'moo', ee => 'mee'],
    );

    is $data_dir, "$bin/data/zoon", "\$data_dir is set correctly";
    ok -d $data_dir, "$data_dir exists and is a directory";
    
    is $temp_dir, "$bin/temp/zoon", "\$temp_dir is set correctly";
    ok -d $temp_dir, "$temp_dir exists and is a directory";

    for (qw(oo ee)) {
        is ::pkgvar($_), "$bin/data/zoon/m$_", "\$$_ is set correctly";
        ok -d ::pkgvar($_), ::pkgvar($_ )." exists and is a directory";
    }

    for (qw(ip op)) {
        is ::pkgvar($_), "$bin/temp/zoon/h$_", "\$$_ is set correctly";
        ok -d ::pkgvar($_), ::pkgvar($_)." exists and is a directory";
    }
}


done_testing;
