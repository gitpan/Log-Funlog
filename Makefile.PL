#!/usr/bin/perl -w
#$Header: /var/cvs/sources/Funlog/Makefile.PL,v 1.6 2004/07/30 09:53:54 gab Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	ABSTRACT		=> 'Simple and useful log module with fun inside ;)',
	NAME			=> 'Log::Funlog',
	VERSION_FROM	=> "lib/Log/Funlog.pm",
	INSTALLDIRS		=> 'vendor',
	AUTHOR			=>	'Gabriel Guillon <korsani@free.fr>'
);
#sub MY::postamble {
#	return <<'MAKE_FRAG';
#$(MYEXTLIB): sdbm/Makefile
#cd sdbm && $(MAKE) all
#MAKE_FRAG
#}
1;
