#!/usr/bin/perl -w
#$Header: /var/cvs/sources/Funlog/Makefile.PL,v 1.11 2005/02/17 11:24:25 gab Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	ABSTRACT		=> 	'Simple and useful log module with fun inside ;)',
	NAME			=>	'Log::Funlog',
	VERSION_FROM	=>	"lib/Log/Funlog.pm",
	AUTHOR			=>	'Gabriel Guillon <korsani(removeme)@free(removeme).fr(removeagain)>',
);
1;
