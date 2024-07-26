#!/bin/bash
set -e
set -u
set -o pipefail

# Creating directories

echo; echo "[$(date)] $0 job has been started."
echo; echo "--> Creating directories"
mkdir -p {analysis/$(date +%F),data/$(date +%F),scripts}

# Download data

cd data/$(date +%F)/
echo; echo "--> Downloading data"
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/635/GCA_000001635.9_GRCm39/GCA_000001635.9_GRCm39_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/635/GCA_000001635.9_GRCm39/GCA_000001635.9_GRCm39_genomic.gff.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/635/GCA_000001635.9_GRCm39/md5checksums.txt

# checksum 

echo; echo "--> MD5 checksum"
md5 *.gz
grep "_genomic.fna.gz" *md5checksums.txt
grep "_genomic.gff.gz" *md5checksums.txt

# Unzip the genome files

echo; echo "--> Unzipping the genome files..."
gunzip *.gz

# Inspecting and Manipulating Text Data with Unix Tools

date > ../../analysis/$(date +%F)/output.txt

# Creating variables 

FNA=GCA_000001635.9_GRCm39_genomic.fna
GFF=GCA_000001635.9_GRCm39_genomic.gff

echo; echo "# Starting analysis"


# Extract first 3 lines of the genome file

echo "First 3 lines of the genome file:" >> ../../analysis/$(date +%F)/output.txt
head -n 3 $FNA >> ../../analysis/$(date +%F)/output.txt
echo; echo "--> Printed first 3 lines of the genome file"


# Count Total Number of Sequences　

echo "Total Number of Sequences:" >> ../../analysis/$(date +%F)/output.txt
grep -c "^>" $FNA >> ../../analysis/$(date +%F)/output.txt
echo; echo "--> Calculated number of sequences"

# Identify the Longest Sequence in the Genome File

echo "Length of the longest sequence:" >> ../../analysis/$(date +%F)/output.txt
awk '/^>/ {if (seqlen){print seqlen};seqlen=0;next;}{seqlen+=length($0)}END{print seqlen}' $FNA | sort -nr | head -n 1 >> ../../analysis/$(date +%F)/output.txt
echo; echo "--> Identified the Longest Sequence in the Genome File"


# Count and Print the unique feature types in the GFF file

echo "Number of Unique feature types in the GFF file:" >> ../../analysis/$(date +%F)/output.txt
grep -v "^#" $GFF |cut -f3 | sort | uniq | wc -l >> ../../analysis/$(date +%F)/output.txt
echo "Unique feature types:" >> ../../analysis/$(date +%F)/output.txt
grep -v "^#" $GFF |cut -f3 | sort | uniq -c >> ../../analysis/$(date +%F)/output.txt
echo; echo "--> Counted unique feature types in the GFF file"


# Calculate the Number of Exons per Gene

echo "Number of exons per gene:" >> ../../analysis/$(date +%F)/output.txt
#grep -w "exon" $GFF | cut -f9 | cut -d ";" -f 1 | sort | uniq -c >> ../../analysis/$(date +%F)/output.txt
grep -w "exon" $GFF | wc -l >> ../../analysis/$(date +%F)/output.txt
echo; echo "--> Calculated the Number of Exons per Gene"


# Done
echo; echo "[$(date)] $0 has been successfully completed."
