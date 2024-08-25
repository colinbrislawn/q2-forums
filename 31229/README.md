# readme

[x-ref](https://forum.qiime2.org/t/for-qiime-2-2024-5-does-the-order-of-the-sequences-matter-for-feature-classifier-classify-sklearn/31229)

## Reproduce origional post

### Colin's setup

```sh
cd /home/biouser/bin/github-repos/q2-forums/31229

# Bug is present in these envs
conda activate qiime2-amplicon-2024.5
conda activate qiime2-amplicon-2023.9
conda activate qiime2-2023.7

# Check these versions too
```

### eg.sh

I've included a copy of this file inline below. This calls the other two files and runs in a few minutes.

```sh
#!/bin/bash

sh build-HOMD-v4.sh
sh class-reorder-class.sh

head -n 5 rep-seqs-calls-homd.txt
head -n 5 rep-seqs-sorted-calls-homd.txt

rm homd-15.23-515-806-nb-q2-2024.5.qza
```

### Is the sorted file the same?

Yes they are.

```sh
vsearch --search_exact rep-seqs.fna --db rep-seqs-sorted.fna --uc rep-seqs-to-sorted.uc
# Count lines in results
cat rep-seqs-to-sorted.uc | wc -l
# Count identical lines
cat rep-seqs-to-sorted.uc | grep "=" | wc -l
```

## Replicate starting from any `.fna` file

Run on full fna file from origional post.

With the addition of `--p-read-orientation 'same'` the results are consistantl(ly better!)

```sh
sh build-HOMD-v4.sh

# This script takes a fasta file and number of head lines to use
time sh edit-import-class.sh rep-seqs.fna 999999 # results change at 300

# now it works!
cut -f2 rep-seq-raw-tax.tsv | grep "k__Bacteria\;" | wc -l # 2 lines
cut -f2 rep-seq-edit-tax.tsv | grep "k__Bacteria\;" | wc -l # 313 lines

cut -f2 rep-seq-raw-tax.tsv | grep "k__Bacteria\;"
cut -f2 rep-seq-edit-tax.tsv | grep "k__Bacteria\;"

diff --width=200 --suppress-common-lines --side-by-side <(cut -f2 rep-seq-raw-tax.tsv) <(cut -f2 rep-seq-edit-tax.tsv)
diff --width=400 --suppress-common-lines --side-by-side <(cut -f1,2 rep-seq-raw-tax.tsv) <(cut -f1,2 rep-seq-edit-tax.tsv)

rm rep-seq-*-tax.tsv
```

## Check the orientation of HOMD

Yes, HOMD is in the forward orientation, so `--p-read-orientation 'same'` working better makes sense.

```sh
# Get HOMD and sintax RPD
wget https://www.homd.org/ftp//16S_rRNA_refseq/HOMD_16S_rRNA_RefSeq/V15.23/HOMD_16S_rRNA_RefSeq_V15.23.fasta
wget https://www.drive5.com/sintax/rdp_16s_v18.fa.gz
gzip -d rdp_16s_v18.fa.gz

vsearch \
  --orient HOMD_16S_rRNA_RefSeq_V15.23.fasta \
  --db rdp_16s_v18.fa \
  --fastaout HOMD_16S_rRNA_RefSeq_V15.23-orient.fasta

# vsearch v2.22.1_linux_x86_64, 15.4GB RAM, 16 cores
# https://github.com/torognes/vsearch

# Reading file rdp_16s_v18.fa 100%  
# WARNING: 8 invalid characters stripped from FASTA file: I(2) L(5) O(1)
# REMINDER: vsearch does not support amino acid sequences
# 30743098 nt in 21195 seqs, min 455, max 1968, avg 1450
# Masking 100% 
# Counting k-mers 100% 
# Creating k-mer index 100% 
# Orienting sequences 100%  
# Forward oriented sequences: 1015 (100.00%)
# Reverse oriented sequences: 0 (0.00%)
# All oriented sequences:     1015 (100.00%)
# Not oriented sequences:     0 (0.00%)
# Total number of sequences:  1015

rm HOMD*
rm rdp*
```
