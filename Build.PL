use Module::Build;

my $build = Module::Build->new
    (
     module_name => 'Graphics::ColorNames',
     license => 'perl',
     requires => {
       'perl'                       => '5.6.0',
       'base'                       => 0,
       'Carp'                       => 0,
       'IO::File'                   => 0,
       'Module::Load'               => 0.10,
     },
     recommends => {
     },
     build_requires => {
       'Test::More'                 => 0,
       'Test'                       => 0,
     },
     create_makefile_pl => 'traditional',
     dist_author        => 'Robert Rothenberg <rrwo at cpan.org>',
);

$build->create_build_script;
