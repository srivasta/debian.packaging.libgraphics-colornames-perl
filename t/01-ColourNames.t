use Test;

BEGIN { plan tests => 44, todo => [ ] }

use strict;
use Carp;

use Graphics::ColourNames 0.30, qw( hex2tuple tuple2hex );
ok(1);

tie my %colors, 'Graphics::ColourNames';
ok(1);

my $count = 0;
foreach my $name (keys %colors)
  {
    my @RGB = hex2tuple( $colors{$name} );
    $count++, if (tuple2hex(@RGB) eq $colors{$name} );
  }
ok($count, keys %colors);

$count = 0;
foreach my $name (keys %colors)
  {
    $count++, if ($colors{lc($name)} eq $colors{uc($name)});
  }
ok($count, keys %colors);


$count = 0;
foreach my $name (keys %colors)
  {
    $count++, if (exists($colors{$name}))
  }
ok($count, keys %colors);

# Test CLEAR, DELETE and STORE as returning errors

eval { undef %colors };
ok(defined($!));

eval { %colors = (); };
ok(defined($!));

eval { $colors{MyCustomColour} = 'FFFFFF'; };
ok(defined($!));

eval { delete($colors{MyCustomColour}); };
ok(defined($!));

# Test RGB values being passed through

foreach my $rgb (qw(
    000000 000001 000010 000100 001000 010000 100000
    111111 123abc abc123 123ABC ABC123 abcdef ABCDEF
  )) {
  ok($colors{ "\x23" . $rgb } eq $rgb);
  ok($colors{ $rgb } eq $rgb);
}

# Test using multiple schemes

tie my %colors2, 'Graphics::ColourNames', qw( X Netscape );

ok(!exists $colors{Silver});  # Silver doesn't exist in X
ok(defined $colors2{Silver}); # It does in Netscape

# Test precedence

tie my %colors3, 'Graphics::ColourNames', qw( Netscape X );

ok($colors{Brown},  'a52a2a'); # Brown in X
ok($colors2{Brown}, 'a52a2a'); # Brown in X (don't try Netscape)
ok($colors3{Brown}, 'a62a2a'); # Brown in Netscape (don't try X)

# Test handling of non-existent color names

ok(!defined $colors{NonExistentColourName});
ok(!exists  $colors{NonExistentColourName});

