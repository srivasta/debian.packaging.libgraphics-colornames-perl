use Test;

BEGIN { plan tests => 10, todo => [ ] }

use strict;
use Carp;

use Graphics::ColorNames 0.39, qw( hex2tuple tuple2hex );
ok(1);

tie my %colors, 'Graphics::ColorNames', './t/rgb.txt';
ok(1);

ok(keys %colors, 6); #

my $count = 0;
foreach my $name (keys %colors)
  {
    my @RGB = hex2tuple( $colors{$name} );
    $count++, if (tuple2hex(@RGB) eq $colors{$name} );
  }
ok($count, keys %colors);

foreach my $name (qw( one two three four five six)) {
  ok(exists $colors{$name});
}
