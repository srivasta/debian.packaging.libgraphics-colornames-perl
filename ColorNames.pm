package Graphics::ColorNames;

require 5.005;

use strict;

use vars qw( @ISA $VERSION @EXPORT @EXPORT_OK );

use Carp;

@ISA = qw( Exporter );

$VERSION   = '0.32';

@EXPORT    = qw( );
@EXPORT_OK = qw( hex2tuple tuple2hex );

sub _load_scheme
  {
    my $self   = shift;

    my $scheme = shift;

    my $module = "Graphics\:\:ColorNames\:\:$scheme";
    eval "require $module;";
    if ($@)
      {
	croak "Cannot load color naming scheme \`$scheme\'";
      }
    else
      {
	no strict 'refs';
	push @{ $self->{SCHEMES} }, $module->NamesRgbTable();
      }
    }

sub TIEHASH
  {
    my $class = shift;

    my $self  = {
      SCHEMES => [ ], # a list of naming schemes, in priority search order
    };

    bless $self, $class;

    if (@_)
      {
	foreach my $scheme (@_)
	  {
	    $self->_load_scheme( $scheme );
	  }
      }
    else
      {
	$self->_load_scheme( 'X' );
      }

    return $self;
  }

sub FETCH
  {
    my ($self, $key) = @_;

    my $value;
    if ($key =~ m/\x23?[\da-f]{6}/i)
      {
	$value =  $key;
	$value =~ s/\x23//;
      }
    else
      {
	my $i = 0;
	while ( (!defined $value) and (defined $self->{SCHEMES}->[$i]) )
	  {
	    $value = $self->{SCHEMES}->[$i++]->{ lc($key) };
	  }
	$value = sprintf( '%06x', $value ), if (defined $value);
      }
    return $value;
  }

sub EXISTS
  {
    my ($self, $key) = @_;
    exists( $self->{SCHEMES}->[0]->{ lc($key) } );
  }

sub FIRSTKEY
  {
    my $self = shift;
    my $a = keys %{$self->{SCHEMES}->[0]};
    each %{$self->{SCHEMES}->[0]};
  }

sub NEXTKEY
  {
    my $self = shift;
    each %{$self->{SCHEMES}->[0]};
  }

sub hex2tuple

# Convert 6-digit hexidecimal code (used for HTML etc.) to an array of
# RGB values

  {
    my $rgb = hex( shift );
    my ($red, $green, $blue);
    $blue  = ($rgb & 0x0000ff);
    $green = ($rgb & 0x00ff00) >> 8;
    $red   = ($rgb & 0xff0000) >> 16;
    return ($red, $green, $blue);
  }

sub tuple2hex

# Convert list of RGB values to 6-digit hexidecimal code (used for HTML, etc.)
  {
    my ($red, $green, $blue) = @_;
    my $rgb = sprintf "%.2x%.2x%.2x", $red, $green, $blue;
    return $rgb;
  }

sub _readonly_error
  {
    croak "Cannot modify a read-only value";
  }

BEGIN
  {
    no strict 'refs';
    *STORE  = \ &_readonly_error;
    *DELETE = \ &_readonly_error;
    *CLEAR  = \ &_readonly_error; # causes problems with 'undef'
  }

1;

__END__

=head1 NAME

Graphics::ColorNames - defines RGB values for common color names

=head1 REQUIREMENTS

C<Graphics::ColorNames> should work on Perl 5.005.

It uses only standard modules.

=head2 Installation

Installation is pretty standard:

  perl Makefile.PL
  make
  make test
  make install

=head1 SYNOPSIS

  use Graphics::ColorNames qw( hex2tuple tuple2hex );

  tie %NameTable, 'Graphics::ColorNames', 'X';

  my $rgbhex1 = $NameTable{'green'};    # returns '00ff00'
  my $rgbhex2 = tuple2hex( 0, 255, 0 ); # returns '00ff00'
  my @rgbtup  = hex2tuple( $rgbhex );   # returns (0, 255, 0)

  my $rgbhex3 = $NameTable{'#123abc'};  # returns '123abc'
  my $rgbhex4 = $NameTable{'123abc'};   # returns '123abc'

=head1 DESCRIPTION

This module defines RGB values for common color names. The intention is to
(1) provide a common module that authors can use with other modules to
specify colors; and (2) free module authors from having to "re-invent the
wheel" whenever they decide to give the users the option of specifying a
color by name rather than RGB value.

For example,

  use Graphics::ColorNames 'hex2tuple';
  tie %COLORS, 'Graphics::ColorNames';

  use GD;

  $img = new GD::Image(100, 100);

  $bgColor = $img->colorAllocate( hex2tuple( $COLORS{'CadetBlue3'} ) );

Though a little 'bureaucratic', the meaning of this code is clearer:
C<$bgColor> (or background color) is 'CadetBlue3' (which is easier to for one
to understand than C<0x7A, 0xC5, 0xCD>). The variable is named for its
function, not form (ie, C<$CadetBlue3>) so that if the author later changes
the background color, the variable name need not be changed.

As an added feature, a hexidecimal RGB value in the form of #RRGGBB or
RRGGBB will return itself:

  my $rgbhex3 = $NameTable{'#123abc'};  # returns '123abc'

=head2 Usage

The interface is through a tied hash:

  tie %NAMETABLE, 'Graphics::ColorNames', SCHEME

where C<%NAMETABLE> is the tied hash and C<SCHEME> is the color scheme(s)
specified.

Currently four schemes are available:

=over

=item X

About 650 color names used in X-Windows. I<This is the default naming scheme>, since it provides the most names.

=item HTML

16 common color names defined in the HTML 4.0 specification. These names
are also used with CSS and SVG.

=item Netscape

100 color names names associated Netscape 1.1 (I cannot determine whether
they were once usable in Netscape or were arbitrary names for RGB values--
many of these names are not recognized by later versions of Netscape).

=item Windows

16 commom color names used with Microsoft Windows and related products.
These are actually the same colors as C<HTML>, although with different
names.

=back

Multiple schemes can be used:

  tie %COLORS, 'Graphics::ColorNames', qw(HTML Windows Netscape);

In this case, if the name is not a valid HTML color, the Windows
name will be used; if it is not a valid Windows name, then the
Netscape name will be used.

RGB values can be retrieved with a case-insensitive hash key:

  $rgb = $colors{'AliceBlue'};

The value returned is in the six-digit hexidecimal format used in HTML and
CSS (without the initial '#'). To convert it to separate red, green, and
blue values (between 0 and 255), use the C<hex2tuple> function:

  @rgb = hex2tuple( $colors{'AliceBlue'} );

or

  ($red, $green, $blue) = hex2tuple( $colors{'AliceBlue'});

To convert separated red, green, and blue values into the corresponding RGB
hexidecimal format, use the C<tuple2hex> function:

  $rgb = tuple2hex( $red, $green, $blue );

The C<hex2tuple> and C<tuple2hex> functions are not exported by default. You
must specify them explicitly when you 'use' the module.

=head2 Adding Naming Schemes

You can add naming scheme files by creating a Perl module is the name
C<Graphics::ColorNames::SCHEMENAME> which has a subroutine named
C<NamesRgbTable> that returns a hash of color names and RGB values.

The color names must be in all lower-case, and the RGB values must be
24-bit numbers containing the red, green, and blue values in most- significant
to least- significant byte order.

An example naming schema is below:

  package Graphics::ColorNames::Metallic;

  sub NamesRgbTable() {
    use integer;
    return {
      copper => 0xb87333,
      gold   => 0xcd7f32,
      silver => 0xe6e8fa,
    };
  }

You would use the above schema as follows:

  tie %colors, 'Graphics::ColorNames', 'Metallic';

An example of an additional module is Steve Pomeroy's
Graphics::ColorNames::Mozilla module.

=head1 AUTHOR

Robert Rothenberg <rrwo@cpan.org>

=head2 Acknowledgements

Alan D. Salewski <alans@cji.com> for feedback and the addition of
C<tuple2hex>.

Steve Pomeroy <xavier@cpan.org> for pointing out invalid color
definitions in L<X.pm> v1.02.

<chemboy@perlmonk.org> who pointed out a mispelling of "fuchsia" in
the HTML color space <https://rt.cpan.org/Ticket/Display.html?id=1704>.

<magnus@mbox604.swipnet.se> who pointed out mispellings and naming
inconsistencies.

=head2 Suggestions and Bug Reporting

Feedback is always welcome.  Please use the CPAN Request Tracker at
L<http://rt.cpan.org> to submit bugs reports.

=head1 LICENSE

Copyright (c) 2001-2002 Robert Rothenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
