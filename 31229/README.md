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

## Does shuffeling usually change results?

```sh



```
