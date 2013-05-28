#!perl

use strict;
use warnings;
use Test::More;
use Test::Deep;

use Log::Dis::Pleasure;

my $l = Log::Dis::Pleasure->new(
    { ident => 'pleasant', to_self => 1, to_screen => 0 } );

isa_ok( $l->_dispatcher, "Log::Dispatch" );

$l->mute();
$l->log("a message");
$l->unmute();
$l->log("another message");
$l->log_debug("debugging message");
$l->debug(1);
$l->log_debug("another debugging message");

cmp_deeply(
    $l->messages,
    [   superhashof( { level => 'info', message => "[$$] another message" } ),
        superhashof(
            { level => 'debug', message => "[$$] another debugging message" }
        ),
    ],
    'simple test'
);

my $p = $l->proxy( { proxy_prefix => "fix_me: " } );
$l->reset_messages();
$p->log("testing proxy");
cmp_deeply(
    $l->messages,
    [   superhashof(
            { level => 'info', message => "[$$] fix_me: testing proxy" }
        ),
    ],
    'simple test'
);

done_testing;
