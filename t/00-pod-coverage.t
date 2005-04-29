#!/usr/bin/perl

use strict;
use Test::More tests => 6;

eval "use Pod::Coverage";

plan skip_all => "Pod::Coverage required" if $@;

ok( Pod::Coverage->new( package => 'Graphics::ColorNames' ) );
ok( Pod::Coverage->new( package => 'Graphics::ColourNames' ) );
ok( Pod::Coverage->new( package => 'Graphics::ColorNames::X' ) );
ok( Pod::Coverage->new( package => 'Graphics::ColorNames::HTML' ) );
ok( Pod::Coverage->new( package => 'Graphics::ColorNames::Windows' ) );
ok( Pod::Coverage->new( package => 'Graphics::ColorNames::Netscape' ) );
