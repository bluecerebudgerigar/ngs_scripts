#!/usr/bin/env perl

use strict;
use warnings;
no warnings 'uninitialized';
use diagnostics;
use Getopt::Std;



#### Example for usage ####
# ./doIGVshots.pl -i <input_bedfile> -o <output_igv_script> -s
#				<xml_session_directory> -d <snapshot_directory>  #######

#store options into hashes with getopts::std module
my %opts = ();
getopts('i:o:s:d:h:', \%opts);

# Store each value of the hash table %opts as perl variables.
my $line="";
my $input = $opts{i};
my $output = $opts{o};


#create output file and print xml session directory and snapshopt directory
open(FILE2,">>$output");
	if (defined $opts{s}){
	my $xml = $opts{s};
		print FILE2 "new\nload $xml\n";
};
	if (defined $opts{d}){
	my $snapshotdirectory = $opts{d};
		print FILE2 "snapshot direcroy $snapshotdirectory\n";
}

#Read each lines from the bedfile, split them by tab and printing them with the correct format into the output file
open(FILE,"<$input");
while (my $line = <FILE>)
{
	foreach ($line){
		my @fields= split /\t/, $line;
		chomp @fields;
	if (defined($fields[3])){
		  print FILE2 "goto $fields[0]:$fields[1]-$fields[2]\nsnapshot $fields[3].png\n";}
	else {
		  print FILE2 "goto $fields[0]:$fields[1]-$fields[2]\nsnapshot\n";}
}
}



