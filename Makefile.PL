# Makefile.PL for Graphics-ColorNames package
# $Id: Makefile.PL,v 0.23 2001/04/18 02:41:58 rob Exp rob $

use ExtUtils::MakeMaker;

WriteMakefile(
    'PM' => {
       'ColorNames.pm'  => '$(INST_LIBDIR)/ColorNames.pm',
       'X.pm'           => '$(INST_LIBDIR)/ColorNames/X.pm',
       'HTML.pm'        => '$(INST_LIBDIR)/ColorNames/HTML.pm',
       'Netscape.pm'    => '$(INST_LIBDIR)/ColorNames/Netscape.pm',
       'Windows.pm'     => '$(INST_LIBDIR)/ColorNames/Windows.pm',
    },
    'NAME'		=> 'Graphics::ColorNames',
    'VERSION_FROM'	=> 'ColorNames.pm',
    'PREREQ_PM'		=> {},
  ($] ge '5.005') ? (
    'AUTHOR'   => 'Robert Rothenberg (rrwo@cpan.org)',
    'ABSTRACT' => 'RGB values for standard color names',
  ) : (),
);
