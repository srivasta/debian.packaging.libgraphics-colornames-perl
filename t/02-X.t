use Test;

BEGIN { plan tests => 4, todo => [ ] }

use strict;
use Carp;

use Graphics::ColorNames 0.32, qw( hex2tuple tuple2hex );
ok(1);

tie my %colors, 'Graphics::ColorNames', 'X';
ok(1);

ok(keys %colors, 760); #

my $count = 0;
foreach my $name (keys %colors)
  {
    my @RGB = hex2tuple( $colors{$name} );
    $count++, if (tuple2hex(@RGB) eq $colors{$name} );
  }
ok($count, keys %colors);
