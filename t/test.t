#!/usr/bin/perl -w
use Test::Simple tests => 30;
use Log::Funlog qw( error );
*Log=Log::Funlog->new(
	file => "zou.log",
	verbose => '5/5',
	fun => 10,
	cosmetic => '*',
	fun => 50,
	caller => 'all',
	header => ' ) %dd ( )>-%pp-<(O)>%l--l<( %s{||}s '
);
for ($j=1;$j<=5;$j++) {
	ok( Log($j,"Log level $j") );
}
sub gna {
	for ($j=1;$j<=5;$j++) {
		ok( Log($j,"Gna sub ","level ",$j) );
	}
	&gna2;
	ok( error("An error occured here") );
}
sub gna2 {
	for ($j=1;$j<=5;$j++) {
		ok( Log($j,"Gna2 sub in Gna sub ","level ",$j) );
	}
	ok( error("An error occured here") );
	&gna3;
}
sub gna3 {
	for ($j=1;$j<=5;$j++) {
		ok( Log($j,"Gna3 sub in Gna sub ","level ",$j) );
	}
	ok( error("An error occured here") );
	&gna4;
}
sub gna4 {
	for ($j=1;$j<=5;$j++) {
		ok( Log($j,"Gna4 sub in Gna sub ","level ",$j) );
	}
	ok( error("An error occured here") );
}
gna;
ok( ! Log(6,"plop") );
