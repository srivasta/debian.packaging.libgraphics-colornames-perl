
use strict;
use warnings;

use constant TEST_CASES => {
    "black"		    => 0x000000,
    "red"		    => 0xff0000,
    "green"		    => 0x00ff00,
    "blue"		    => 0x0000ff,
    "white"                 => 0xffffff,
};

use Test::More tests => 3 + (9 * 5);

use_ok('Graphics::ColorNames', (qw(tuple2hex)));

my $rgb = Graphics::ColorNames->new(qw( X ));
ok(defined $rgb);
ok($rgb->isa('Graphics::ColorNames'));

my $tests = TEST_CASES;

foreach my $name (keys %$tests) {

  my $a = $rgb->hex($name, '0x');
  ok( $a =~ /^0x[0-9a-f]{6}$/i );
  ok( eval($a) == $tests->{$name}, "Testing color $name" );

  my $b = $rgb->hex($name, '#');
  ok( $b =~ /^\x23[0-9a-f]{6}$/i );

  my $c = $rgb->hex($name, "");
  ok( $c =~ /^[0-9a-f]{6}$/i );  

     $c = $rgb->hex($name);
  ok( $c =~ /^[0-9a-f]{6}$/i );  

  my $d = $rgb->rgb($name, ',');
  ok( $d =~ /^\d{1,3}(\,\d{1,3}){2}$/ );

  my @v = $rgb->rgb($name);
  ok( @v == 3 );

  ok( join(',', @v) eq $d );
  ok( tuple2hex(@v) eq $c );

}
