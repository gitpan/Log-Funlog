#!/usr/bin/perl -w
#$Header: /var/cvs/sources/Funlog/Makefile.PL,v 1.5 2004/07/27 00:56:42 gab Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	ABSTRACT		=> 'Simple and useful log module with fun inside ;)',
	NAME			=> 'Log::Funlog',
	VERSION_FROM	=> "lib/Log/Funlog.pm",
	AUTHOR			=>	'Gabriel Guillon <korsani@free.fr>'
);
1;
