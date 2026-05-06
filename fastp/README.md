# How does fastp dedup handle read labels?

## Setup

```bash
pixi init
pixi workspace channel add https://conda.anaconda.org/bioconda/
pixi add curl seqtk gzip fastp
```

## Get Data

```bash
# Process Read 1
time \
curl -sL ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR666/002/SRR6664342/SRR6664342_1.fastq.gz \
  | pixi run seqtk sample -s 100 - 1000000 \
  | gzip > SRR6664342_1_1m.fastq.gz

# Process Read 2 (Crucial: use the same seed '-s 100' to keep pairs synced)
time \
curl -sL ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR666/002/SRR6664342/SRR6664342_2.fastq.gz \
  | pixi run seqtk sample -s 100 - 1000000 \
  | gzip > SRR6664342_2_1m.fastq.gz
```

## dedup and inspect

```bash
pixi run fastp \
  -i SRR6664342_1_1m.fastq.gz -I SRR6664342_2_1m.fastq.gz \
  -o SRR6664342_dedup_1.fastq.gz -O SRR6664342_dedup_2.fastq.gz \
  --dedup

open .

gzip -dc SRR6664342_1_1m.fastq.gz | grep "^@" | head

gzip -dc SRR6664342_dedup_1.fastq.gz | grep "^@" | head
# same long names?
```

# `fastp --dedup` keeps the input read names!

This means we can remove names upstream, if we want.

```bash
# Untested
curl -sL ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR666/002/SRR6664342/SRR6664342_1.fastq.gz \
  | pixi run seqtk sample -s 100 - 1000000 \
  | pixi run seqtk rename - SRR6664342_ \
  | gzip > SRR6664342_1_clean.fastq.gz

curl -sL ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR666/002/SRR6664342/SRR6664342_2.fastq.gz \
  | pixi run seqtk sample -s 100 - 1000000 \
  | pixi run seqtk rename - SRR6664342_ \
  | gzip > SRR6664342_2_clean.fastq.gz
```
