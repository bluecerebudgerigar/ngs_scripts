#!/usr/bin/env Rscript


#### A Updated version of Brian's bam to bigwig R script #########
# Now With get options feature!                                  # 
# Requires library(getopt)                                       #
# Required Options                                               #
# -b /path/to/bamfiles                                           #
# -o /name/for/outputbigwigfile                                  #
# -s strandedness, T for stranded, F for unstranded              #
# -p paired-ness, T for paired, F for unpaired                   #
# Optional Options                                               #
# -f firststranded-ness                                          #
#    T for first strand, F for not first pair.                   #
#    ( default = T, doesnt matter if not using stranded library) #
#                                                                #
# Example :                                                      #
# ./RNAbamtobwBG2.R -b /path/to/bamfiles -o outputname -s F -p T # 
#  qsub-able                                                     #  
# This should work! Cheers                                       #
#                                                                # 
##################################################################

library(rtracklayer);
library(getopt);

spec =matrix(c(
'bam', 'b',1,"character",
'outputname', 'o',1,"character",
'stranded','s',1,"logical",
'paired','p',1,"logical",
'first_strand','f',2"logical"
), byrow=TRUE, ncol=4);
opt = getopt(spec);

if (is.null(opt$first_strand)){opt$first_strand=TRUE};

RNAbamTobw <- function(file, name, stranded=TRUE, firstStrand=TRUE, paired=TRUE) {
    require(rtracklayer)
    if (paired) {
        rs <- readGappedAlignmentPairs(file);
        rs.count <- length(rs)/1e6;
        rs.cov <- unlist(grglist(rs));
        if (stranded) {
            rs.cov <- lapply(split(rs.cov, strand(rs.cov))[c("+", "-")], coverage);
            if (!firstStrand) 
		names(rs.cov) <- rev(names(rs.cov));
            	export(rs.cov[["+"]]/rs.count, BigWigFile(paste(name, "_+.bw", sep="")));
            	export(rs.cov[["-"]]/rs.count, BigWigFile(paste(name, "_-.bw", sep="")));
            	export(rs.cov[["-"]]/-rs.count, BigWigFile(paste(name, "_--.bw", sep="")));
        } else export(coverage(rs.cov)/rs.count, BigWigFile(paste(name, ".bw", sep="")));
    } else {
        rs <- readGappedAlignments(file);
        rs.count <- length(rs);
    }
}

RNAbamTobw(opt$bam,opt$outputname,stranded=opt$stranded, firstStrand=opt$first_strand, paired=opt$paired)
