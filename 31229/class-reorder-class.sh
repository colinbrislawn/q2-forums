#!/bin/bash

. ~/Q2/q2-2024.source

qiime feature-classifier classify-sklearn \
      --i-classifier homd-15.23-515-806-nb-q2-2024.5.qza \
      --p-n-jobs 1 \
      --i-reads orig-rep-seqs.qza \
      --o-classification rep-seqs-tax.qza

qiime tools export \
      --input-path rep-seqs-tax.qza \
      --output-path rep-seqs-tax
rm rep-seqs-tax.qza
    
sort rep-seqs-tax/taxonomy.tsv > rep-seqs-calls-homd.txt
rm -rf rep-seqs-tax

qiime tools export \
      --input-path orig-rep-seqs.qza \
      --output-path rep-seqs-fasta
cp rep-seqs-fasta/dna-sequences.fasta rep-seqs.fna
rm -rf rep-seqs-fasta

awk '(NR%2 == 1) { meta=$0; } \
     (NR%2 == 0) { print meta"\t"$0; }' rep-seqs.fna | sort | tr "\t" "\n" > rep-seqs-sorted.fna
rm rep-seqs.fna

qiime tools import \
      --type 'FeatureData[Sequence]' \
      --input-path rep-seqs-sorted.fna \
      --output-path rep-seqs-sorted.qza
rm rep-seqs-sorted.fna

qiime feature-classifier classify-sklearn \
      --i-classifier homd-15.23-515-806-nb-q2-2024.5.qza \
      --p-n-jobs 1 \
      --i-reads rep-seqs-sorted.qza \
      --o-classification rep-seqs-sorted-tax.qza
rm rep-seqs-sorted.qza

qiime tools export \
      --input-path rep-seqs-sorted-tax.qza \
      --output-path rep-seqs-sorted-tax
rm rep-seqs-sorted-tax.qza
    
sort rep-seqs-sorted-tax/taxonomy.tsv > rep-seqs-sorted-calls-homd.txt
rm -rf rep-seqs-sorted-tax
