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

Takes about a minute to run this.

```sh
sh build-HOMD-v4.sh

# This script takes a fasta file and number of head lines to use
time sh edit-import-class.sh rep-seqs.fna 400 # results change at 300

# Their order the the same (good!) and their estimates are different (fine)
head -n2 rep-seq-raw-tax.tsv
head -n2 rep-seq-edit-tax.tsv

# Different!
cut -f2 rep-seq-raw-tax.tsv | grep "k__Bacteria\;" | wc -l # 2 lines
cut -f2 rep-seq-edit-tax.tsv | grep "k__Bacteria\;" | wc -l # 10 lines

cut -f2 rep-seq-raw-tax.tsv | grep "k__Bacteria\;"
cut -f2 rep-seq-edit-tax.tsv | grep "k__Bacteria\;"

diff --width=200 --suppress-common-lines --side-by-side <(cut -f2 rep-seq-raw-tax.tsv) <(cut -f2 rep-seq-edit-tax.tsv)
diff --width=400 --suppress-common-lines --side-by-side <(cut -f1,2 rep-seq-raw-tax.tsv) <(cut -f1,2 rep-seq-edit-tax.tsv)


rm rep-seq-*-tax.tsv
```

Try this on an existing public data set: PR2 18S

```sh
wget https://raw.githubusercontent.com/torognes/vsearch-data/master/PR2-18S-rRNA-V4.derep.fsa

sh build-HOMD-v4.sh

# This script takes a fasta file and number of head lines to use
time sh edit-import-class.sh PR2-18S-rRNA-V4.derep.fsa 9999999 # Small change at 34999

# Their order the the same (good!) and their estimates are different (fine)
head -n2 rep-seq-raw-tax.tsv
head -n2 rep-seq-edit-tax.tsv

# Different!
cut -f2 rep-seq-raw-tax.tsv | grep "k__Bacteria\;" | wc -l # 51 lines
cut -f2 rep-seq-edit-tax.tsv | grep "k__Bacteria\;" | wc -l # 30 lines

cut -f2 rep-seq-raw-tax.tsv | grep "k__Bacteria\;"
cut -f2 rep-seq-edit-tax.tsv | grep "k__Bacteria\;"

diff --width=$COLUMNS --suppress-common-lines --side-by-side <(cut -f2 rep-seq-raw-tax.tsv) <(cut -f2 rep-seq-edit-tax.tsv)
diff --width=$COLUMNS --suppress-common-lines --side-by-side <(cut -f1,2 rep-seq-raw-tax.tsv) <(cut -f1,2 rep-seq-edit-tax.tsv)

rm rep-seq-*-tax.tsv
```
