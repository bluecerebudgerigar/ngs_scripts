#!/usr/bin/env perl 


use strict;
use warnings;
use diagnostics;
use File::Glob;
use Getopt::Std;

my %options=();
getopts("a:b:c:d:", \%options);

#declare each options into variables

my $a =$options{a}; ## pattern file name 
my $b =$options{b}; ## search doc
my $c =$options{c}; ## how many split files
my $d =$options{d}; ## grep options

#split files into smaller bits for grepping
#split files are with the prefix aratherfastgrep, 
system("split -l$c $b aratherfastgrep_files_");

my @sources = <aratherfastgrep_files_*>;
open(FILE,">","aratherfastgrep_sh.sh")
  or die "cant open < file: $!";

foreach (@sources) {
    	print FILE "qsub -cwd -b y -j y -pe smp 1 -V -N $_ \"grep -$d $a $_ > GREP_$_\"\n";
}

print "Going to start Greping please wait\n";
# Read script that Grep gene files 
system("sh aratherfastgrep_sh.sh");
sleep(15);

while (`qstat` =~ m/aratherfas/) 
{print "still grepping\n";
sleep(10);}


system("cat GREP_* >> youhavebeengrepped.txt");
print "Run Finished\n";
system("rm aratherfastgrep_* GREP_*")
