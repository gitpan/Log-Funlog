#	$Header: /var/cvs/sources/Funlog/lib/Log/Funlog.pm,v 1.48 2005/02/17 11:24:25 gab Exp $

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

It should be easy to use, and provide all the fonctionalities you want.

Just initialize the module, then use is as if it was an ordinary function!

When you want to log something, just write:

 your-sub-log(priority,"what"," I ","wanna log")

then the module will analyse if the priority if higher enough (seeing L</verbose> option). If yes, your log will be written with the format you decided on STDERR (default) or a file.

As more, the module can write funny things to your logs, if you want ;) It can be very verbose, or just ... shy :)

L<Log::Funlog|Log::Funlog> may export an 'error' function: it logs your message with a priority of 1 and with an specific (parametrable) string. You can use it when you want to highlight error messages in your logs.

Parameters are: L</header>, L</error_header>, L</cosmetic>, L</verbose>, L</file>, L</daemon>, L</fun> and L</caller>

L</verbose> is mandatory.

B<NOTE NOTE NOTE>: Interface (L</header>) is subject to change!

=head2 MANDATORY OPTION

=over

=item B<verbose>

In the form B<n>/B<m>, where B<n><B<m> or B<n>=max.

B<n> is the wanted verbosity of your script, B<m> if the maximum verbosity of your script.

Everything that is logged with a priority more than B<n> (in case B<n> is numeric)  will not be logged.

0 if you do not want anything to be printed.

The common way to define B<n> is to take it from the command line with Getopt:

 use Getopt::Long;
 use Log::Funlog;
 &GetOptions("verbose=s",\$verbose);
 *Log=new Log::Funlog(
	[...]
	verbose => "$verbose/5",
	[...]
	)

In this case, you can say --verbose=max so that it will log with the max verbosity level available (5, here)

This option is backward compatible with 0.7.x.x versions.

See L</EXAMPLE>

=back

=head2 NON MANDATORIES OPTIONS

=over

=item B<header>

Pattern specifying the header of your logs.

The fields are made like this: %<B<letter>><B<delimiters1>><B<delimiters2>><B<same_letter>>

The B<letter> is, for now:

	s: stack calls
	d: date
	p: name of the prog
	l: verbosity level

B<delimiters1> is something taken from +-=|!./\<{([ and B<delimiters2> is take from +-=|!./\>})] (replacement regexp is s/\%<letter>([<delimiters1>]*)([<delimiters2>*)<letter>/$1<field>$2/ ). B<delimiters1> will be put before the field once expanded, B<delimiters2> after.

Example:
 '%dd %p::p hey %l[]l %s{}s '
 
should produce something like:

 Wed Sep 22 18:50:34 2004 :gna.pl: hey [x    ] {sub48} Something happened
 ^------this is %dd-----^ ^%p::p^      ^%l[]l^ ^%s{}s^

If no header is specified, no header will be written, and you would have:

 Something happened

Although you can specify a pattern like that:
 ' -{(%d(<>)d)}%p-<>-p %l-<()>-l '

is not advisable because the code that whatch for the header is not that smart and will probably won't do what you expect.

Putting things in %?? is good only for %ss because stack won't be printed if there is nothing to print:
 ' {%ss} '

will print something like that if you log from anywhere than a sub:
 {}

Although
 ' %s{}s '

won't print anything if you log from outside a sub. Both will have the same effect if you log from inside a sub.

You should probably always write things like:
 ' -{((<%dd>))}-<%pp>- -<(%ll)>- '


I<NOTE NOTE NOTE>: The fields are subject to change!

=item B<daemon>

1 if the script should be a daemon. (default is 0: not a daemon)

When B<daemon>=1, L<Log::Funlog|Log::Funlog> write to L</file> instead of B<STDERR>

If you specify B<daemon>, you must specify L</file>

The common way to do is the same that with L</verbose>: with Getopt

=item B<file>

File to write logs to.

MUST be specified if you specify L</daemon>

File is opened when initializing, and never closed by the module. That is mainly to avoid open and close the file each time you log something and then increase speed.

Side effect is that if you tail -f the log file, you won't see them in real time.

=item B<cosmetic>

An alphanumeric char to indicate the log level in your logs.

There will be as many as these chars as the log level of the string being logged. See L</EXAMPLE>

Should be something like 'x', or '*', or '!', but actually no test are performed to verify that there is only one caracter...

=item B<error_header>

Header you want to see in the logs when you call the B<error> function (if you import it, of course)

Default is '## Oops! ##'.

=item B<fun>=n%

Probs of fun in your logs.

Should be: 0<fun<=100

See the sources of L<Log::Funlog|Log::Funlog> if you want to change the sentences

=item B<caller>

'all' if you want the stack of subs.

'last' if you want the last call.

If you specify a number B<n>, it will print the B<n> last calls (yes, if you specify '1', it is equivalent to 'last')

If this number is negative, it will print the B<n> first calls.

Of course, nothing will happen if no L</header> is specified, nor %ss in the L</header> ...

=back

=head1 EXAMPLE

Here is an example with almost all of the options enabled:

 $ vi gna.pl
 #!/usr/bin/perl -w
 use Log::Funlog qw( error );
 *Log=new Log::Funlog(
		file => "zou.log",		#name of the file
		verbose => "3/5",			#verbose 3 out of a maximum of 5
		daemon => 0,			#I am not a daemon
		cosmetic => 'x',		#crosses for the level
		fun => 10,			#10% of fun (que je passe autour de moi)
		error_header => 'Groumpf... ',  #Header for true errors
		header => '%dd %p[]p %l[]l %s{}s ',	#The header
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
 Wed Sep 22 18:50:34 2004 [gna.pl] [x    ] I'm logged...
 Wed Sep 22 18:50:34 2004 [gna.pl] [xxx  ] Me too...
 Wed Sep 22 18:50:34 2004 [gna.pl] [x    ] Onetwo1C++
 Wed Sep 22 18:50:34 2004 [gna.pl] [x    ] Groumpf...  oups!
 Wed Sep 22 18:50:34 2004 [gna.pl] [x    ] Groumpf...  Zut


=head1 BUGS

This:

 header => '-(%dd)--( %p)><(p )-( %l)-<>-(l %s)<>(s '
 
won't do what you expect ( this is the ')><(' )

Workaround is:

 header => '-(%dd)--( )>%pp<( )-( %l)-<>-(l %s)<>(s '

And this kind of workaround work for everything but %ss, as it is not calculated during initialization.

 

=head1 DISCUSSION

As you can see, the 'new' routine return a pointer to a sub. It's the easiest way I found to make this package as easy as possible to use.

I guess that calling the sub each time you want to log something (and even if it won't print anything due to the too low level of the priority given) is not really fast...

Especially if you look at the code, and you see all the stuffs the module do before printing something.

But in fact, I tried to make it rather fast, that mean that if the module try to know as fast as possible if it will write something, and what to write

If you want a I<really> fast routine of log, please propose me a way to do it, or do it yourself, or do not log :)

=head1 HISTORY

I'm doing quite a lot of Perl scripts, and I wanted the scripts talk to me. So I searched a log routine.

As I didn't found it on the web, and I wanted something more 'personnal' than syslog (I didn't want my script write to syslog), I started to write a very little routine, that I copied to all the scripts I made.

As I copied this routine, I added some stuff to match my needs; I wanted something rather fast, easy to use, easy to understand (even for me :P ), quite smart and ... a little bit funny :)

The I wrote this module, that I 'use Log::Funlog' in each of my scripts.

=head1 CHANGELOG

See Changelog

=head1 AUTHOR

Gabriel Guillon, from Chashew team

korsani-spam@free-spam.fr-spam

(remove you-know-what :)

=head1 LICENCE

As Perl itself.

Let me know if you have added some features, or removed some bugs ;)

=cut

package Log::Funlog;

BEGIN {
	use Exporter;
	@ISA=qw(Exporter);
	@EXPORT=qw( );
	@EXPORT_OK=qw( &error );
	$VERSION=0.83_2;
}
use Carp;
use strict;
#use Sys::Syslog;
use Scalar::Util qw(tainted);
my @fun=<DATA>;
chomp @fun;
my $count=0;

use vars qw( %args $me $error_header $error $metaheader);

# Defined here, used later!
####################################"
my $rexpleft=q/<>{}()[]/;				#Regular expression that are supposed to be on the left of the thing to print
my $rexprite=$rexpleft;
$rexprite=~tr/><}{)(][/<>{}()[]/;		#tr same for right
my $rexpsym=q'+-=|!.\/';		#These can by anywhere (left or right)
$rexpleft=quotemeta $rexpleft;
$rexprite=quotemeta $rexprite;
$rexpsym=quotemeta $rexpsym;
my $level;
my $LOCK_SH=1;
my $LOCK_EX=2;
my $LOCK_NB=4;
my $LOCK_UN=8;
my $handleout;			#Handle of the output
my %whattoprint;

################################################################################################################################
sub replace {						#replace things like %l<-->l by things like <-** ->
	my $header=shift;
	my $what=shift;
	my $center=shift;
	if ($center) {
		$header=~s/\%$what$what/$center/;				# for cases like %dd
		#
		# Now, for complicated cases like %d<-->d or %d-<>-d
		# 
		$header=~s/\%$what(.*[$rexpleft]+)([$rexprite]+.*)$what/$1$center$2/;	#%d-<>-d   -> -<plop>-
																				#%d<-->d   -> <-->
		$header=~s/\%$what(.*[$rexpsym]+)([$rexpsym]+.*)$what/$1$center$2/;		#-<plop>-  -> -<plop>-
																				#<-->      -> <-plop->
	} else {
		$header=~s/\%$what.*$what//;
	}
	return $header;
}
################################################################################################################################
################################################################################################################################
sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	%args=@_;							#getting args to a hash

	# Okay, now sanity checking!
	# This is cool because we have time, so we can do all sort of checking, calculating, things like that
	#########################################
	if (defined $args{daemon}) {
		croak 'You want me to be a daemon, but you didn\'t specifie a file to log to...' unless (defined $args{file});
	}
	croak "'verbose' should be of the form n/m or max/m" if (($args{'verbose'} !~ /^\d+\/\d+$/) and ($args{'verbose'} !~ /^max\/\d+$/));

	# Parsing 'verbose' option...
	#########################################
	my ($verbose,$levelmax)=split('/',$args{verbose});
	$levelmax=$levelmax ? $levelmax : "";						#in case it is not defined...
	$verbose=$levelmax if ($verbose =~ /^max$/);
	if (($verbose !~ /\d+/) or ($levelmax !~ /\d+/)) {
		carp "Arguments in 'verbose' should be of the form n/m, where n and m are numerics.\nAs this is a new feature, I'll assume you didn't upgraded your script so I'll make it compatible...\nAnyhow, consider upgrading soon!\n";
		croak "No 'levelmax' provided" unless ($args{levelmax});
	} else {
		$args{verbose}=$verbose;
		$args{levelmax}=$levelmax;
	}
	croak "'verbose' should be of the form 'n/m', where n<=m, which not seem to be the case: $args{verbose} > $args{levelmax}" if ($args{verbose} > $args{levelmax});

	# Time for fun!
	#########################################
	if ($args{'fun'}) {
		croak "'fun' should only be a number" if ($args{fun} !~ /^\d+$/);
	}
	croak "0<fun<=100" if (defined $args{fun} and ($args{fun}>100 or $args{fun}<=0));

	# Error handler
	#########################################
	$error_header=defined $args{error_header} ? $args{error_header} : '## Oops! ##';

	# We define default cosmetic if no one was defined
	#########################################
	$args{cosmetic}='x' if (not defined $args{cosmetic});

	# Parsing header. Goal is to avoid work in the wr() function
	#########################################
	if (defined $args{header}) {

		$metaheader=$args{header};

		# if %ll is present, we can be sure that it will always be, be it will vary
		$whattoprint{'l'}=1 if ($metaheader=~/\%l.*l/);
		$metaheader=replace($metaheader,"l","\$level");

		# same for %dd
		$whattoprint{'d'}=1 if ($metaheader=~/\%d.*d/);
		$metaheader=replace($metaheader,"d","\$date");

		# but %pp won't vary
		$me=`basename $0`;
		chomp $me;
		$whattoprint{'p'}=1 if ($metaheader=~/\%p.*p/);
		$metaheader=replace($metaheader,"p",$me);
		# and stack will be present or not, depending of the state of the stack
		$whattoprint{'s'}=1 if ($metaheader=~/\%s.*s/);
		if ((! defined $args{'caller'}) and ($metaheader=~/\%s.*s/)) {
			carp "\%ss is defined but 'caller' option is not specified.\nI assume 'caller => 1'";
			$args{'caller'}=1;
		}
	} else {
		$metaheader="";
	}

	# Daemon. We calculate here the output handle to use
	##########################################
	if ($args{'daemon'}) {
		open($handleout,">>$args{'file'}") or croak "$!";
	} else {
		$handleout=\*STDERR;
	}


	my $self = \&wr;
	bless $self, $class;
	return $self;					#Return the function's address
}

#################################
# This is the main function
#################################
sub wr {
	my $level=shift;						#log level wanted by the user
	return if ($level > $args{verbose} or $level == 0);	#and exit if it is greater than the verbosity

	my $prevhandle=select $handleout;

# Header building!!
#####################################

	if ($metaheader) {							#Hey hey! Won't calculate anything if there is nothing to print!
		my $header=$metaheader;
		if ($whattoprint{'s'}) {						#if the user want to print the call stack
			my $caller;
			if (($args{'caller'} =~ /^last$/) or ($args{'caller'} =~ /^1$/)) {
				$caller=(caller($error?2:1))[3];
			} else {						#okay... I will have to unstack all the calls to an array...
				my @stack;
				my $i=1;
				while (my $tmp=(caller($error?$i+1:$i))[3]) {	#turn as long as there is something on the stack
					push @stack,($tmp);
					$i++;
				};
				@stack=reverse @stack;
				if ($args{'caller'} eq "all") {;					#all the calls
					$caller=join(':',@stack);
				} else {
					if ($#stack >= 0) {
						my $num=$args{'caller'};
						$num=$#stack if ($num>=$#stack);		#in case the stack is greater that the number of call we want to print
						if ($args{'caller'} eq "all") {							#all the cals
							$caller=join(':',@stack);
						} elsif ($args{'caller'} =~ /^-\d+$/) {					#the n first calls
							$caller=join(':',splice(@stack,0,-$num));
						} elsif ($args{'caller'} =~ /^\d+$/) {					#just the n last calls
							$caller=join(':',splice(@stack,1+$#stack-$num));
						}
					}
				}
			}

			if ($caller) {							#if there were something on the stack (ie: we are not in 'main')
				$caller=~s/main\:\://g;				#wipe 'main'
				my @a=split(/\//,$caller);			#split..
				@a=reverse @a;						#reverse...
				$header=replace($header,"s",join(':',@a));
			} else {
				$header=replace($header,"s");
			}
		} else {
			$header=replace($header,"s");
		}
		if ($whattoprint{'d'}) {
			my $tmp=scalar localtime;
			$header=~s/\$date/$tmp/;
		}
		if ($whattoprint{'l'}) {
			my $tmp=$args{cosmetic} x $level. " " x ($args{levelmax} - $level);
			$header=~s/\$level/$tmp/;
		}

		#####################################
		#	End oh header building
		#####################################
		print $header;						#print the header
	}
	while (my $tolog=shift) {			#and then print all the things the user wants me to print
		print $tolog;
	}
	print "\n";
	#Passe le fun autour de toi!
	print $fun[1+int(rand $#fun)],"\n" if ($args{fun} and (rand(100)<$args{fun}) and ($count>10));			#write a bit of fun, but not in the first 10 lines
	select($prevhandle);
	$count++;
	return 1;
}
sub error {
	$error=1;
	wr(1,$error_header," ",@_);
	$error=0;
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
Bon, il est bientôt fini, ce process??
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
Ton chien a fini de bouffer les rideaux?
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

