Marie Muramatsu
Last Update: 2024-07-15

----------

# *Mus musculus* Data Analysis Project Documentation

## Overview

### Purpose 

To practice and apply skills learnt in "Data Science for Bioinformatics" class, including unix shell scripting and creating reproducile data analysis files. 

### Background 

This project performs a basic analysis of the Mouse genome data (Mus musculus, assembly GRCm39) from NCBI. The shell script `run.sh` downloads the genome data, verifies its integrity, and performs various analyses using common Unix tools.

I have chosen to use the house mouse genome data because of its large significance in biology research applications. It is said to be very similar to the human genome. 

## Documentation index 

- [prerequisuites](#prerequisites)
- [project directory](#Project-directory)
- [script](#script-file)
- [data](#data-used)
- [analysis](#data-analysis)
- [reproducibility](#reproducibility)

## Prerequisites

- Unix-like operating system (e.g., Linux, macOS)
- `wget` installed
- `gunzip` installed
- `md5sum` installed

## Project directory

```
houseMousse/README.md
houseMousse/analysis/2024-07-15/output.txt
houseMousse/data/2024-07-15/GCA_000001635.9_GRCm39_genomic.fna
houseMousse/data/2024-07-15/GCA_000001635.9_GRCm39_genomic.gff
houseMousse/data/2024-07-15/md5checksums.txt
houseMousse/scripts/run.sh
```

## Script file

The shell script `scripts/run.sh` automatically carries out the entire steps: creating directories, downloading data, and inspecting data.

Let's run the shell script `scripts/run.sh` in the project's main directory with:
```
(bash scripts/run.sh &) >& log.$(date +%F).txt
```

## Data used

A complete genome of *Mus musculus* was retrieved from the NCBI FTP site. Unix tools (grep, cut, sort and uniq) were used to assess genome sequence features.

**Source**: NCBI FTP site [https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_921999095.2/]

**Format**: 

- .fna.gz: FASTA format, contains the nucleotide sequences of the genome
- .gff.gz: GFF format, contains information about the features of the genome, such as genes, exons, and other genomic elements


## Data analysis

I used Unix shell commands (tail, head, grep, awk, etc.) to look into the components and features of the mouse genome data. 


### Script source code 

```
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

```

### Expected Output 

```
$cat analysis/2024-07-15/output.txt

First 3 lines of the genome file:

>CM000994.3 Mus musculus chromosome 1, GRCm39 reference primary assembly C57BL/6J
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN

Total Number of Sequences:
61

Length of the longest sequence:
195154279

Number of Unique feature types in the GFF file:
      11

Unique feature types:
  13 CDS
   1 D_loop
   1 centromere
  24 exon
  13 gene
   1 origin_of_replication
   2 rRNA
  61 region
   6 sequence_alteration
   6 sequence_feature
  22 tRNA

Number of exons per gene:
      24

```

## Reproducibility

I have tested that this project is reproducible, and the below criteria can be used in order to confirm it

1) Does not give errors
2) Output file content is similar or same to [output](#expected-output)
3) The only difference after running the below command is the date on the first line 


```
diff analysis/2024-07-15/output.txt analysis/2024-07-16/output.txt
```
