package Log;


BEGIN {
	use Exporter;
	@ISA=qw(Exporter);
	@EXPORT=qw( );
	@EXPORT_OK=qw();
	$VERSION="0.6.3";
}
use Carp;
#use Sys::Syslog;
$count=0;
#my $logh=new FileHandle;
sub new {
	shift;
	%args=@_;
	croak "'file' missing" unless (defined $args{file});
	croak "'levelmax' missing" unless (defined $args{levelmax});
	#croak "Manque 'daemon'" unless (defined $args{daemon});
	croak "'verbose' missing" unless (defined $args{verbose});
	croak "verbose > levelmax (which value is $args{levelmax})" if ($args{verbose} > $args{levelmax});
#	open($logh,">>$args{file}") or croak "$!" if ($daemon);
	if ($args{prog}) {
		$prog=`basename $0`;
		chomp $prog;
	}

	return \&wr;					#Ruse de sioux: retourne l'adresse de la fonction de log
}
sub wr {
	my $level=shift;						#Niveau de log
	return if ($level > $args{verbose});	#Sort si la 'verbosité' du messages et plus grande que celle voulue
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
#	print $logh "troubidou\n";
#	Format de log, à ce jour:
#	Thu Aug 14 13:56:56 2003 [ gna ] [ xxx   ] Gna gna gna ...
#
#Et moi je dis prout
#
	my $logstring;
	$logstring=scalar localtime if defined $args{date};
#	Nom du programme
	$logstring.=" [ ".$prog." ]" if defined $prog;
#	Niveau de Log
	$logstring.=" [ ".$args{cosmetic} x $level. " " x ($args{levelmax} - $level)." ]" if defined $args{cosmetic};
	$logstring.=" ";
	my $caller=(caller(1))[3] if ($args{caller});	#arf! trop forte, cette commande!
	if ($caller) {
		my @a=split(/\:\:/,$caller);
		$caller=pop @a;
		$logstring.="{".$caller."}".": ";
	}
	print $logstring;					#Et hop, on affiche le début
	while (my $tolog=shift) {			#tant qu'il y a des trucs sur la ligne
		print $tolog;
	}
	print "\n";
	close LOG if ($args{daemon});
	select(STDOUT);
	$count++;
}
1;
