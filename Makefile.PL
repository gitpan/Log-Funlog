#!/usr/bin/perl -w
#$Header: /var/cvs/sources/Funlog/Makefile.PL,v 1.9 2004/12/09 00:35:01 gab Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	ABSTRACT		=> 'Simple and useful log module with fun inside ;)',
	NAME			=> 'Log::Funlog',
	VERSION_FROM	=> "lib/Log/Funlog.pm",
	AUTHOR			=>	'Gabriel Guillon <korsani(removeme)@free(removeme).fr(removeagain)>',
);
#sub MY::postamble {
#	return <<'MAKE_FRAG';
#$(MYEXTLIB): sdbm/Makefile
#cd sdbm && $(MAKE) all
#MAKE_FRAG
#}
1;
