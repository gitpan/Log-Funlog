#!/usr/bin/perl -w
#$Header: /var/cvs/sources/Funlog/Makefile.PL,v 1.3 2004/07/22 17:55:27 gab Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	ABSTRACT		=> 'Simple and useful log module with fun inside ;)',
	NAME			=> 'Log::Funlog.pm',
	VERSION_FROM	=> 'lib/Log/Funlog.pm',
#	SITEPREFIX		=> '/usr/local/lib/perl5/site_perl',
	AUTHOR			=>	'Gabriel Guillon <korsani@free.fr>'
);

1;
