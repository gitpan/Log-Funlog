#!/usr/bin/perl -w
use Test::More qw(no_plan);

use_ok('Log::Funlog');
can_ok('Log::Funlog','error');

use Log::Funlog qw( error );
use Config;
if ($Config{'osname'} eq 'linux' or $Config{'osname'} eq 'darwin') {
	$file='/dev/null';
	$daemon=1;
} elsif ($Config{'osname'} eq 'MSWin32') {
	$file='c:\\test4log-funlog.tmp',
	$daemon=0;
} else {
	print "** Unknown OS **\n";
	$file='c:\\test4log-funlog.tmp',
	$daemon=0;
}
SKIP: {
	eval{ require Log::Funlog::Lang};
	if (!$@) {
		$fun=50;
	} else {
		skip('No fun: Log::Funlog::Lang is not installed');
		$fun=0;
	}
}
*Log=Log::Funlog->new(
	file => $file,
	verbose => '5/5',
	cosmetic => '*',
	caller => 'all',
	daemon => $daemon,
	fun => $fun,
	colors => {
		'date' => 'black',
		'caller' => 'green',
		'msg' => 'black'
	},
	header => ' ) %dd ( )>-%pp-<(O)>%l--l<( %s{||}s '
);
isa_ok( \&Log, 'Log::Funlog','&Log is not a Log::Funlog object' );

for ($j=1;$j<=5;$j++) {
	$sent="Log level $j";
	is( Log($j,$sent), $sent,$sent);
}
sub gna {
	for ($j=1;$j<=5;$j++) {
		$sent="Gna sub level $j";
		is( Log($j,$sent) ,$sent,$sent);
	}
	&gna2;
	like( error("An error occured here"),qr/An error occured here/);
}
sub gna2 {
	for ($j=1;$j<=5;$j++) {
		$sent="Gna2 sub level $j";
		is( Log($j,$sent),$sent,$sent);
	}
	like( error("An error occured here"),qr/An error occured here/);
	&gna3;
}
sub gna3 {
	for ($j=1;$j<=5;$j++) {
		$sent="Gna3 sub level $j";
		is( Log($j,$sent),$sent,$sent);
	}
	like( error("An error occured here"),qr/An error occured here/);
}
gna;
ok( ! Log(6,"plop"), 'Log level 6 (which should not be printed)' );
