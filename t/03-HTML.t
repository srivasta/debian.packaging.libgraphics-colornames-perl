use Test;

BEGIN { plan tests => 7, todo => [ ] }

use strict;
use Carp;

use Graphics::ColorNames 0.20, qw( hex2tuple tuple2hex );
ok(1);

tie my %colors, 'Graphics::ColorNames', 'HTML';
ok(1);

ok(keys %colors, 17);

my $count = 0;
foreach my $name (keys %colors)
  {
    my @RGB = hex2tuple( $colors{$name} );
    $count++, if (tuple2hex(@RGB) eq $colors{$name} );
  }
ok($count, keys %colors);

ok(exists($colors{"fuchsia"}));
ok(exists($colors{"fuscia"}));
ok($colors{"fuscia"} eq $colors{"fuchsia"});