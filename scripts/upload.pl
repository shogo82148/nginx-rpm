#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use FindBin;

sub execute {
    my @arg = @_;
    my $cmd = join " ", @arg;
    print "executing: $cmd\n";
    my $ret = system(@arg);
    if ($ret != 0) {
        print STDERR "::warning::failed to execute $cmd";
    }
}

sub upload {
    my ($variant, $prefix) = @_;
    while (my $rpm = <$FindBin::Bin/../$variant.build/RPMS/x86_64/*.x86_64.rpm>) {
        my $package = "nginx";
        $package .= "-debuginfo" if $rpm =~ /debuginfo/;
        execute("aws", "s3", "cp", $rpm, "s3://shogo82148-rpm-temporary/$prefix/x86_64/$package/");
    }
    while (my $rpm = <$FindBin::Bin/../$variant.build/RPMS/aarch64/*.aarch64.rpm>) {
        my $package = "nginx";
        $package .= "-debuginfo" if $rpm =~ /debuginfo/;
        execute("aws", "s3", "cp", $rpm, "s3://shogo82148-rpm-temporary/$prefix/aarch64/$package/");
    }
}

upload "amazonlinux2", "amazonlinux/2";
