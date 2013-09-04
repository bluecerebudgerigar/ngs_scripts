#!/usr/bin/env perl


use strict;
use warnings;


## The purpose of the document is to allow one obtain cds 
sequence based on their favourite gencode file using gffread from the tuxedo suite
ARGV[0] = gencode file 
ARGV[1] = whole genome fasta file
will produce 2 file transcript.gtf and transcript.fa
transcript.gtf is the gtf file with only gene transcripts and exon 
transcript.fa is fasta frile for your cds .##



open(GENCODE, "<", $ARGV[0])
or die "cannot open $!";
open(CODINGSEQ, "+>>", "transcript.gtf")
or die "cannot open $!";

while (my $lines = <GENCODE>){
next if ($lines=~ m/#/g);

my @array = split("\t", $lines);
if (($array[2] eq "exon" || $array[2] eq "transcript" || $array[2] eq "gene")) {
print CODINGSEQ $lines;


} }

close GENCODE;
close CODINGSEQ;


system("gffread -w transcript.fa -g $ARGV[1] transcript.gtf");
if ($? == -1){
print "command to execute gffread failed";
}
else {
printf "command exited with value %d", $? >> 8;
}
