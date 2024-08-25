#!/bin/bash

# Starting from .fna file, go directly to skl
cat rep-seq.fna > rep-seqs-raw.fna

qiime tools import \
      --type 'FeatureData[Sequence]' \
      --input-path rep-seqs-raw.fna \
      --output-path rep-seq-raw.qza

qiime feature-classifier classify-sklearn \
      --i-classifier homd-15.23-515-806-nb-q2-2024.5.qza \
      --p-n-jobs 1 \
      --i-reads rep-seq-raw.qza \
      --o-classification rep-seq-raw-tax.qza

qiime tools export \
      --input-path rep-seq-raw-tax.qza \
      --output-path rep-seq-raw-tax
rm rep-seq-raw-tax.qza
    
sort rep-seq-raw-tax/taxonomy.tsv > rep-seq-raw-tax.tsv
rm -rf rep-seq-raw-tax


# Starting from .fna file, change it before skl

cat rep-seqs.fna | \
  awk '(NR%2 == 1) { meta=$0; } (NR%2 == 0) { print meta"\t"$0; }' | \
  sort | \
  tr "\t" "\n" > rep-seqs-edit.fna

qiime tools import \
      --type 'FeatureData[Sequence]' \
      --input-path rep-seqs-edit.fna \
      --output-path rep-seqs-edit.qza
rm rep-seqs-edit.fna

qiime feature-classifier classify-sklearn \
      --i-classifier homd-15.23-515-806-nb-q2-2024.5.qza \
      --p-n-jobs 1 \
      --i-reads rep-seqs-edit.qza \
      --o-classification rep-seqs-edit-tax.qza
rm rep-seqs-edit.qza

qiime tools export \
      --input-path rep-seqs-edit-tax.qza \
      --output-path rep-seqs-edit-tax
rm rep-seqs-edit-tax.qza
    
sort rep-seqs-edit-tax/taxonomy.tsv > rep-seq-edit-tax.tsv
rm -rf rep-seqs-edit-tax
