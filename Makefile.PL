#!/usr/bin/perl -w
#$Header: /var/cvs/sources/Funlog/Makefile.PL,v 1.8 2004/09/22 18:06:25 gab Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	ABSTRACT		=> 'Simple and useful log module with fun inside ;)',
	NAME			=> 'Log::Funlog',
	VERSION_FROM	=> "lib/Log/Funlog.pm",
	AUTHOR			=>	'Gabriel Guillon <korsani@free.fr>',
);
#sub MY::postamble {
#	return <<'MAKE_FRAG';
#$(MYEXTLIB): sdbm/Makefile
#cd sdbm && $(MAKE) all
#MAKE_FRAG
#}
1;
