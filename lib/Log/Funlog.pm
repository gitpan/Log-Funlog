#	$Header: /var/cvs/sources/Funlog/lib/Log/Funlog.pm,v 1.8 2004/07/27 00:56:42 gab Exp $

package Log::Funlog;

BEGIN {
	use Exporter;
	@ISA=qw(Exporter);
	@EXPORT=qw( );
	@EXPORT_OK=qw( error );
	$VERSION='0.7.2.1';
}
use Carp;
#use Sys::Syslog;
@fun=<DATA>;                                    #>pc<
chomp @fun;                                     #>pc<
$count=0;

sub new {
	shift;
	%args=@_;
	if (defined $args{daemon}) {
		croak 'You want me to be a daemon, but you didn\'t specifie a file to log to...' unless (defined $args{file});
	}
	croak "'levelmax' missing" unless (defined $args{levelmax});
	#croak "Manque 'daemon'" unless (defined $args{daemon});
	croak "'verbose' missing" unless (defined $args{verbose});
	croak "verbose > levelmax (which value is $args{levelmax})" if ($args{verbose} > $args{levelmax});
	croak "0<=fun<=100" if (defined $args{fun} and ($args{fun}>100 or $args{fun}<0));                   #>pc<
	$error_header='## Oops! ##' unless (defined $args{error_header});
#	open($logh,">>$args{file}") or croak "$!" if ($daemon);
	if ($args{prog}) {
		$prog=`basename $0`;
		chomp $prog;
	}

	#&wr($args{levelmax},"Fun activated!") if ($args{fun});
	return \&wr;					#Ruse de sioux: retourne l'adresse de la fonction de log
}
sub wr {
	my $level=shift;						#Niveau de log
	return if ($level > $args{verbose} or $level == 0);	#Sort si la 'verbosité' du messages et plus grande que celle voulue
	my $LOCK_SH=1;
	my $LOCK_EX=2;
	my $LOCK_NB=4;
	my $LOCK_UN=8;
	if ($args{daemon}) {					#Si on est censé être un démon, on écrit dans le fichier
		open(LOG,">>$args{file}") or croak "$!";
		select LOG;
		flock LOG, $LOCK_EX;
	} else {								#Sinon, dans STDERR
		select STDERR;
	}
#
#	Si on est censé être un démon, on écrit dans le fichier

	my $logstring;
	$logstring=scalar localtime if defined $args{date};
#	Nom du programme
	$logstring.=" [ ".$prog." ]" if defined $prog;
#	Niveau de Log
	$logstring.=" [ ".$args{cosmetic} x $level. " " x ($args{levelmax} - $level)." ]" if defined $args{cosmetic};
	$logstring.=" " if ($logstring ne "");
	if ($args{'caller'}) {			#arf! trop forte, cette commande!
		if ($args{'caller'} eq "all") {			#si on demande tout les appels
			$i=1;
			while ($tmp=(caller($error?$i+1:$i))[3]) {	#on tournicote tant qu'il y en a
				$caller.=$tmp."/";
				$i++;
			};
		} else {
			$caller=(caller($error?2:1))[3];			#sinon on ne chope que le dernier
		}
		if ($caller) {								#si on a eu des résultats (ce qui n'est pas évident si on est dans main)
			$caller=~s/main\:\://g;
			my @a=split(/\//,$caller);
			@a=reverse @a;
			$logstring.="{".join(':',@a)."}"." ";
		}
		undef $caller;
	}
	print $logstring;					#Et hop, on affiche le début
	while (my $tolog=shift) {			#tant qu'il y a des trucs sur la ligne
		print $tolog;
	}
	print "\n";
#   Passe le fun autour de toi!                             #>pc<
    print $fun[1+int(rand $#fun)],"\n" if ($args{fun} and (rand(100)<$args{fun}) and ($count>10));		#>pc<
																				#pas dans les 10 1ères lignes
	close LOG if ($args{daemon});
	select(STDOUT);
	$count++;
	return 1;
}
sub error {
	$error=1;
	wr(1,$error_header," ",@_);
	return 1;
}
1;
__DATA__
-- this line will never be written --
Pfiou... marre de logger, moi
J'ai faim!
Je veux faire pipi!
Dis, t'as pensé à manger?
Fait froid, dans ce process, non?
Fait quel temps, dehors?
Aller, pastis time!
Je crois que je suis malade...
Dis, tu peux me choper un sandwich?
On se fait une toile?
Aller, décolle un peu de l'écran
Tu fais quoi ce soir, toi?
On va en boîte?
Pousse-toi un peu, je vois rien
Vivement les vacances...
Mince, j'ai pas prévenu ma femme que je finissais tard...
Il est chouette ton projet?
Bon, il est bientôt finit, ce process??
Je m'ennuie...
Tu peux me mettre la télé?
Y a quoi ce soir?
J'irais bien faire un tour à Pigalle, moi.
Et si je formattais le disque?
J'me ferais bien le tour du monde...
Je crois que je suis homosexuel...
Bon, je m'en vais, j'ai des choses à faire.
Et si je changeais de taf? OS, c'est mieux que script, non?
J'ai froid!
J'ai chaud!
Tu me prend un café?
T'es plutôt chien ou chat, toi?
Je crois que je vais aller voir un psy...
Tiens, 'longtemps que j'ai pas eu de news de ma soeur!
Comment vont tes parents?
Comment va Arthur, ton poisson rouge?
Ton chien a finit de bouffer les rideaux?
Ton chat pisse encore partout?
Tu sais ce que fait ta fille, là?
T'as pas encore claqué ton chef?
Toi, tu t'es engueulé avec ta femme, ce matin...
T'as les yeux en forme de contener. Soucis?
Et si je partais en boucle infinie?
T'es venu à pied?
Et si je veux pas exécuter la prochaine commande?
Tiens, je vais me transformer en virus...
Ca t'en bouche un coin, un script qui parle, hein?
Ah m...., j'ai oublié les clés à l'intérieur de la voiture...
T'as pas autre chose à faire, là?
Ca devient relou...
T'as pensé à aller voir un psy?
Toi, tu pense à changer de job...

__END__

=head1 NAME

Log::Funlog - Log module with fun inside!
 
=head1 SYNOPSIS

 use Log::Funlog;
 *my_sub=Log::Funlog->new(
 	parameter => value,
 	...
 );
 
 my_sub(priority,string,string, ... );

=head1 DESCRIPTION

This is a Perl module intended ton manage the logs you want to do from your Perl scripts.

It should be easy to use, and provide all the functions you should want.

Just initialise the module, then use is as if it was an ordinary function!

When you want to log something, just write your-sub-log(priority,"what I wanna log"), then the module will analyse if the priority if higher enough (seeing B<L<verbose>> option). If it is, your log will be written with the format you decided.

L<Funlog.pm> may export an 'error' function: it logs your message with a priority of 1 and with an specific (parametrable) string. You can use it when you want to highlight error messages in your logs.

=head2 Mandatories options

=over

=item B<levelmax>

Max log level

=item B<verbose>

Verbosity of the script calling Funlog.pm

0 if you do not want anything to be printed (??? what for ???)

MUST be less or equal to B<levelmax> or the module will complain.

Everything that is logged with a priority more than this will not be logged.
	
=back

=head2 Non-mandatories options:

=over

=item B<daemon>

1 if the script should be a daemon. (default is 0: not a daemon)

When B<daemon>=1, Funlog.pm write to B<file> instead of B<STDERR>

If you specify B<daemon>, you must specify B<file>

=item B<file>

File to write logs to.

MUST be specified if you specify B<daemon>

=item B<date>

1 if you want the current date being printed in the logs.

The date is printed like: Thu Aug 14 13:56:56 2003

=item B<prog>

1 if you want the name of the script ($0) being printed in the logs.

=item B<cosmetic>

An alphanumeric char you want to see in the logs.

There will be as many as these chars as the loglevel of the string being logged.

=item B<error_header>

Header you want to see in the logs when you call the B<error> function.

Default is '## Oops! ##'.

=item B<fun>

Probs of fun in your logs.

Should be: 0<fun<=100

See the sources of Funlog.pm if you want to change the sentences

=item B<caller>

1 if you want the name of the subroutine being logged.

'all' if you want the stack of subs

=back

=head1 EXAMPLE

Here is an example with almost all of the options enabled:

 $ vi gna.pl
 use Log::Funlog qw( error );
 *Log=Log::Funlog->new(levelmax => 5,	#Loglevel max: 5
 	file => "zou.log",			#name of the file
	verbose => 3,				#verbose 3
	daemon => 0,				#I (gna.pl) am not a daemon
	prog => 1,				#I want the name of the progs
	date => 1,				#and the date too
	cosmetic => 'x',				#crosses for the level
	fun => 10,              #10% of fun (que je passe autour de moi)
	error_header => 'Groumpf... ',	#Header for true errors
	caller => 1);				#and I want the name of the sub

 [ ... some code ... ]
 Log(1,"I'm logged...");
 Log(3,"Me too...");
 Log(4,"Me not!");			#because 4>verbose
 sub ze-sub {
		 $hop=1;
		 Log(1,"One","two",$hop,"C"."++");
		 error("oups!");
 }
 ze-sub;
 error("Zut");
 :wq
 
 $ ./gna.pl
 Thu Aug 14 13:56:56 2003 [ gna ] [ x     ] I'm logged...
 Thu Aug 14 13:56:56 2003 [ gna ] [ xxx   ] Me too...
 Thu Aug 14 13:56:56 2003 [ gna ] [ x     ] {ze-sub} Onetwo1C++
 Thu Aug 14 13:56:56 2003 [ gna ] [ x     ] {ze-sub} Groumpf... oups!
 Thu Aug 14 13:56:56 2003 [ gna ] [ x     ] Groumpf... Zut

=head1 DISCUSSION

As you can see, the 'new' routine return a pointer to a sub. It's the easiest way I found to make this package as easy as possible to use.

I guess that calling the sub each time you want to log something (and even if it won't print anything due to the too low level of the priority given) is not really fast...

Especially if you look at the code, and you see all the stuffs the module do before printing something.

But in fact, I tried to make it rather fast, that mean that if the module try to know as fast as possible if it will write something.

If you want a I<really> fast routine of log, please propose me a way to do it, or do it yourself, or do not log :)

=head1 HISTORY

I'm doing quite a lot of Perl scripts, and I wanted the scripts talk to me. So I searched a log routine.

As I didn't found it on the web, and I wanted something more 'personnal' than syslog (I didn't want my script write to syslog), I started to write a very little routine, that I copied to all the scripts I made.

As I copied this routine, I added some stuff to match my needs; I wanted something rather fast, easy to use, easy to understand (even for me :P ), quite smart and ... a little bit funny :)

The I wrote this module, that I 'use Funlog' in each of my scripts.

=head1 CHANGELOG

 0.2					: Print to STDERR instead of STDOUT
 0.3					: 'daemon' argument no more mandatory: false when not specified
 0.4					: 'fun' option added, and not mandatory (I think it should :P)
 0.5		08/08/2003 	: Lock of the log file, so the module can be used in forks and threads, without smashing
 						: the log file
 0.6		14/08/2003 	: 'caller' option added
 0.6.1		18/08/2003	: This doc added :P
 0.6.2		06/01/2004	: My mail address changed
						: {} around the name of the sub
 0.6.3		16/02/2004	: Fix a bug that garble logs if you don't chose 'date' option
 0.7.0		20/02/2004	: 'error' function added.
 						: Doc updated.
						: 'file' option was written not mandatory, but it complained if you didn't supply it
						: Doc fixed 'bout the {} around the name of the sub
						: Wiped the ':' after the name of the subs
 0.7.1		21/07/2004	: Minor (cosmetic) bug fixes
 0.7.2		23/07/2004	: There is now the name of all calling subs if you specify caller => 'all'
 						: Added to CPAN :)
 0.7.2.1	23/07/2004	: Doc moved to bottom
 						: README added
						: Do not write anything if you log with priority 0
 
										 
=head1 AUTHOR

Gabriel Guillon

korsani@free.fr

=head1 LICENCE

GPL, of course!

If you have comments, or if you (want to) add some features, PLEASE let me know!

=cut

