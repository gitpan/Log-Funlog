#!/usr/bin/perl -w
use Test::Simple tests => 17;
use Log::Funlog qw( error );
*Log=Log::Funlog->new(levelmax => 5,
	file => "zou.log",
	verbose => 5,
#	prog => 1,
#	fun => 10,
	cosmetic => '*',
#	date => 1,
	fun => 50,
	caller => 1
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
}
gna;