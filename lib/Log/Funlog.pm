#	$Header: /var/cvs/sources/Funlog/lib/Log/Funlog.pm,v 1.15 2004/09/22 18:06:25 gab Exp $

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

When you want to log something, just write:

 your-sub-log(priority,"what"," I ","wanna log")

then the module will analyse if the priority if higher enough (seeing B<L<verbose>> option). If it is, your log will be written with the format you decided.

L<Funlog.pm> may export an 'error' function: it logs your message with a priority of 1 and with an specific (parametrable) string. You can use it when you want to highlight error messages in your logs.

Parameters are: L<B<header>>, L<B<error_header>>, L<B<cosmetic>>, L<B<verbose>>, L<B<file>>, L<B<daemon>>, L<B<fun>> and L<B<caller>>

L<B<verbose>> is mandatory.

I<NOTE NOTE NOTE>: Interface (B<header>) is subject to change!

=head2 MANDATORIES OPTION

=over

=item B<verbose>

Should be of the form 'B<n>/B<m>', where B<n><B<m>.

B<n> is the wanted verbosity of your script, B<m> if the maximum verbosity of your script.

Everything that is logged with a priority more than B<n>will not be logged.

0 if you do not want anything to be printed (??? what for ???)

The common way to define B<n> is to take it from the command line with Getopt:

 use Getopt::Long;
 use Log::Funlog;
 &GetOptions("verbose",\$verbose);
 *Log=Log::Funlog(
	[...]
	verbose => "$verbose/5",
	[...]
	)

This option is backward compatible with 0.7.x.x versions.

=back

=head2 NON MANDATORIES OPTIONS

=over

=item B<header>

Pattern specifying the header of your logs.

The fields are made like this: %<B<letter>><B<delimiter1>><B<delimiter2>><B<same_letter>>

The B<letter> is, for now:

	s: stack of the calling sub
	d: date
	p: name of the prog
	l: verbosity level

B<delimiter> is what you want, but MUST BE one character long (replacement regexp is s/\%<letter>(.?)(.?)<letter>/$1<field>$2/ ). B<delimiter1> will be put before the field once expanded, B<delimiter2> after.

Example: '%dd %p::p %l[]l %s{}s ' should produce something like:

 Wed Sep 22 18:50:34 2004 :gna.pl: [x    ] {sub1} Something happened

If no header is specified, no header will be written, and you would have:

 Something happened

I<NOTE NOTE NOTE>: The fields are subject to change!

=item B<daemon>

1 if the script should be a daemon. (default is 0: not a daemon)

When B<daemon>=1, L<Log::Funlog> write to B<L<file>> instead of B<STDERR>

If you specify B<daemon>, you must specify B<L<file>>

The common way to do is the same that with B<L<verbose>>: with Getopt

=item B<file>

File to write logs to.

MUST be specified if you specify B<daemon>

1 if you want the current date being printed in the logs.

The date is printed like: Thu Aug 14 13:56:56 2003

=item B<cosmetic>

An alphanumeric char to indicate the log level in your logs.

There will be as many as these chars as the log level of the string being logged. See L<EXAMPLE>

Should be something like 'x', or '*', or '!', but actually no test are performed to verify that there is only one caracter...

=item B<error_header>

Header you want to see in the logs when you call the B<error> function.

Default is '## Oops! ##'.

=item B<fun>

Probs of fun in your logs.

Should be: 0<fun<=100

See the sources of L<Log::Funlog> if you want to change the sentences

=item B<caller>
1 if you want the name of the subroutine which is logging.

'all' if you want the stack of subs

Of course, nothing will happen if no B<header> is specified, nor %s in the B<header> ...

=back

=head1 EXAMPLE

Here is an example with almost all of the options enabled:

 $ vi gna.pl
 #!/usr/bin/perl -w
 use Log::Funlog qw( error );
 *Log=Log::Funlog->new(
		file => "zou.log",		#name of the file
		verbose => "3/5",			#verbose 3 out of 5
		daemon => 0,			#I am not a daemon
		cosmetic => 'x',		#crosses for the level
		fun => 10,			#10% of fun (que je passe autour de moi)
		error_header => 'Groumpf... ',  #Header for true errors
		header => '%d [ %p ] [ %l ] ',	#The header
		caller => 1);			#and I want the name of the last sub

 Log(1,"I'm logged...");
 Log(3,"Me too...");
 Log(4,"Me not!");          #because 4>verbose
 sub ze_sub {
	$hop=1;
	Log(1,"One","two",$hop,"C"."++");
	error("oups!");
 }
 ze_sub;
 error("Zut");
 
 :wq
 
 $ ./gna.pl
 Wed Sep 22 18:50:34 2004 [ gna.pl ] [ x     ] I'm logged...
 Wed Sep 22 18:50:34 2004 [ gna.pl ] [ xxx   ] Me too...
 Wed Sep 22 18:50:34 2004 [ gna.pl ] [ x     ] Onetwo1C++
 Wed Sep 22 18:50:34 2004 [ gna.pl ] [ x     ] Groumpf...  oups!
 Wed Sep 22 18:50:34 2004 [ gna.pl ] [ x     ] Groumpf...  Zut


=head1 BUGS

Hopefully none :)

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

The I wrote this module, that I 'use Log::Funlog' in each of my scripts.

=head1 CHANGELOG

See Changelog

=head1 AUTHOR

Gabriel Guillon

korsani@free.fr

=head1 LICENCE

GPL

Let me know if you have added some features, or removed some bugs ;)

=cut

package Log::Funlog;

BEGIN {
	use Exporter;
	@ISA=qw(Exporter);
	@EXPORT=qw( );
	@EXPORT_OK=qw( error );
	$VERSION='0.8.0.1';
}
use Carp;
use strict;
#use Sys::Syslog;
my @fun=<DATA>;
chomp @fun;
my $count=0;
use vars qw( %args $me $error_header $error);
sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	%args=@_;							#getting args to a hash
	if (defined $args{daemon}) {
		croak 'You want me to be a daemon, but you didn\'t specifie a file to log to...' unless (defined $args{file});
	}
	my ($verbose,$levelmax)=split('/',$args{verbose});
	$levelmax=$levelmax ? $levelmax : "";						#in case it is not defined...
	if (($verbose !~ /\d+/) or ($levelmax !~ /\d+/)) {
		warn "Arguments in 'verbose' should be of the form n/m, where n and m are numerics.\nAs this is a new feature, I'll assume you didn't upgraded your script so I'll make it compatible...\nAnyhow, consider upgrading soon!\n";
		croak "No 'levelmax' provided" unless ($args{levelmax});
	} else {
		$args{verbose}=$verbose;
		$args{levelmax}=$levelmax;
	}
	croak "'verbose' should be of the form 'n/m', where n<=m, which not seem to be the case: $args{verbose} > $args{levelmax}" if ($args{verbose} > $args{levelmax});
	croak "0<fun<=100" if (defined $args{fun} and ($args{fun}>100 or $args{fun}<=0));                   #>pc<
	$error_header=defined $args{error_header} ? $args{error_header} : '## Oops! ##';
	
	$me=`basename $0`;
	chomp $me;

	my $self = \&wr;
	bless $self, $class;
	return $self;					#Return the function's adress
}
sub wr {
	my $level=shift;						#log level wanted by the user
	return if ($level > $args{verbose} or $level == 0);	#and exit if it is greater than the verbosity
	my $LOCK_SH=1;
	my $LOCK_EX=2;
	my $LOCK_NB=4;
	my $LOCK_UN=8;
	if ($args{daemon}) {					#write to a file if I am a daemon
		open(LOG,">>$args{file}") or croak "$!";
		select LOG;
		flock LOG, $LOCK_EX;
	} else {								#write to stderr if not
		select STDERR;
	}
#####################################
#	Header building!!
#####################################
	
	my $logstring;
	my $header=defined $args{header} ? $args{header} : "";
# 	Date
	my $tmp=scalar localtime;
	$header=~s/\%d(.?)(.?)d/$1$tmp$2/;
#	Nom du programme
	$header=~s/\%p(.?)(.?)p/$1$me$2/;
#	Niveau de Log
	if (defined $args{cosmetic}) {
		$tmp=$args{cosmetic} x $level. " " x ($args{levelmax} - $level);
		$header=~s/\%l(.?)(.?)l/$1$tmp$2/;
	}
	$logstring.=" " if ((defined $logstring) and ($logstring ne ""));
	if ($args{'caller'}) {						#if the user want the call stack
		my $caller;
		if ($args{'caller'} eq "all") {			#if the user want ALL the call stack
			my $i=1;
			while (my $tmp=(caller($error?$i+1:$i))[3]) {	#turn as long as there is something on the stack
				$caller.=$tmp."/";
				$i++;
			};
		} else {								#okay, the user want only the top of the call stack
			$caller=(caller($error?2:1))[3];	#I get the only the last
		}
		if ($caller) {							#if I there were something on the stack (ie: we are not in 'main')
			$caller=~s/main\:\://g;
			my @a=split(/\//,$caller);
			@a=reverse @a;
			my $tmp=join(':',@a);
			$header=~s/\%s(.?)(.?)s/$1$tmp$2/;
		} else {
			$header=~s/\%s.?.?s//;
		}
		undef $caller;
	}
#####################################
#	End oh header building
#####################################

	print $header if (defined $header);					#print the header
	print $logstring if (defined $logstring);
	while (my $tolog=shift) {			#and then print all the things the user wants me to print
		print $tolog;
	}
	print "\n";
#   Passe le fun autour de toi!
    print $fun[1+int(rand $#fun)],"\n" if ($args{fun} and (rand(100)<$args{fun}) and ($count>10));			#write a bit of fun, but not in the first 10 lines
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

