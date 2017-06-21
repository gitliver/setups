#!/bin/bash

### define functions

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

### make a software directory and go into it
sudo mkdir -p /opt/software && sudo chown $( whoami ):$( whoami ) /opt/software && cd /opt/software
echo "*** change directory: /opt/software ***"

### get software

# make sure ubuntu packages up to date
echo "*** update system software ***"
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install awscli

# grab programs
echo "*** grab bioinformatics programs ***"
toget="https://github.com/samtools/samtools/releases/download/1.4/samtools-1.4.tar.bz2
https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
https://github.com/broadinstitute/picard/archive/2.9.2.tar.gz
https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz
ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip
https://sourceforge.net/projects/snpeff/files/snpEff_v4_1c_core.zip
https://sourceforge.net/projects/snpeff/files/snpEff_latest_core.zip
https://github.com/alexdobin/STAR/archive/2.5.3a.tar.gz
https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.1/bowtie2-2.3.1-linux-x86_64.zip
https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.4.0.tar.gz
ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.6.0+-x64-linux.tar.gz
https://sourceforge.net/projects/subread/files/subread-1.5.2/subread-1.5.2-Linux-x86_64.tar.gz
https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.2.0/bowtie-1.2-linux-x86_64.zip
https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2
https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.1.1.tar.gz
https://sourceforge.net/projects/samtools/files/samtools/1.2/htslib-1.2.1.tar.bz2
https://sourceforge.net/projects/samtools/files/samtools/1.2/bcftools-1.2.tar.bz2
https://sourceforge.net/projects/samtools/files/samtools/1.2/samtools-1.2.tar.bz2"

for i in $toget; do
    echo "***"${i}"***";
    # wget ${i}
    extract $( basename ${i} )
done

echo
echo "--- Please make samtools, etc ---"
echo

# get repositories
echo "*** clone stuff from git ***"
# homemade
git clone https://github.com/RabadanLab/Pandora.git
git clone https://github.com/RabadanLab/SAVI.git
# third party
git clone https://github.com/broadinstitute/gatk
git clone --recursive https://github.com/vcflib/vcflib.git

# Python stuff
echo "*** install python packages ***"
sudo pip install scipy numpy pandas biopython

# make venvs, too
echo "*** install stuff into virtualenvs ***"
sudo apt-get install virtualenv
# for Pandora
virtualenv venv_pandora
source venv_pandora/bin/activate
pip install scipy numpy pandas biopython
deactivate
# for Savi
virtualenv venv_savi
source venv_savi/bin/activate
pip install scipy numpy
deactivate

# put these in front of PATH because copies exist in /usr/local/bin
PATH=/opt/software/bowtie2-2.3.1:$PATH
PATH=/opt/software/bwa-0.7.15:$PATH
PATH=/opt/software/samtools-1.4:$PATH

PATH=$PATH:/opt/software/vcflib/bin
PATH=$PATH:/opt/software/snpEff
PATH=$PATH:/opt/software/STAR-2.5.3a/bin/Linux_x86_64
# PATH=$PATH:/opt/software/trinityrnaseq-Trinity-v2.4.0
PATH=$PATH:/opt/software/trinityrnaseq-2.1.1
PATH=$PATH:/opt/software/ncbi-blast-2.6.0+/bin
PATH=$PATH:/opt/software/subread-1.5.2-Linux-x86_64/bin
PATH=$PATH:/opt/software/bowtie-1.2
PATH=$PATH:/opt/software/FastQC
PATH=$PATH:/opt/software/kallisto_linux-v0.43.1
PATH=$PATH:/opt/software/hisat2-2.1.0

export PATH

