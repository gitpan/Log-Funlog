use Module::Build;
my $build = Module::Build->new
(
	module_name => 'Log::Funlog',
	license => 'perl',
);
$build->create_build_script;
