use Test;

BEGIN { plan tests => 7, todo => [ 5, 6, 7 ] }

use strict;
use Carp;

use Graphics::ColorNames 0.32, qw( hex2tuple tuple2hex );
ok(1);

tie my %colors, 'Graphics::ColorNames', 'Netscape';
ok(1);

ok(keys %colors, 100); #

my $count = 0;
foreach my $name (keys %colors)
  {
    my @RGB = hex2tuple( $colors{$name} );
    $count++, if (tuple2hex(@RGB) eq $colors{$name} );
  }
ok($count, keys %colors);

# Problem is with Netscape's color definitions

ok($colors{gold}      ne $colors{mediumblue});
ok($colors{lightblue} ne $colors{mediumblue});
ok($colors{lightblue} ne $colors{gold});
