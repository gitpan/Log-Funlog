#!/usr/bin/perl -w
$flag=0;
while ($l=<>) {
	$flag=1 if ($l=~/=head/);
	$flag=0 if ($l=~/=cut/);
	$flag=1 if ($l=~/__DATA__/);
	print $l unless($flag or $l=~/pc/ or $l=~/cut/);
}
