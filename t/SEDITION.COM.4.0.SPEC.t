#!/usr/bin/env perl
use Test::More;
use Test::Fatal;
use warnings;
use strict;
# use Test::WWW::Mechanize::Catalyst;
require Catalyst::Test;
use HTTP::Request::Common;

$ENV{SEDCAT_CONFIG_LOCAL_SUFFIX} = "test";

#---------------------------------------------------------------------
# Sanity, basics.
{

    Catalyst::Test->import("SedCat");
    ok( get("/"), "GET /" );
}

#---------------------------------------------------------------------
# Sanity, basics.
{
    ok( my $res = request("/session"), "GET /session" );
    ok( $res->is_success, "Success" );
#    use HTTP::Request::Common;
#           my $response = request POST '/foo', [
#               bar => 'baz',
#               something => 'else'
#           ];

}


done_testing();

__DATA__
