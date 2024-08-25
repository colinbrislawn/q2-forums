#!/bin/bash

# . ~/Q2/q2-2024.source

wget https://www.homd.org/ftp//16S_rRNA_refseq/HOMD_16S_rRNA_RefSeq/V15.23/HOMD_16S_rRNA_RefSeq_V15.23.fasta
wget https://www.homd.org/ftp//16S_rRNA_refseq/HOMD_16S_rRNA_RefSeq/V15.23/HOMD_16S_rRNA_RefSeq_V15.23.qiime.taxonomy

qiime tools import \
      --type 'FeatureData[Sequence]' \
      --input-path HOMD_16S_rRNA_RefSeq_V15.23.fasta \
      --output-path HOMD_16S_rRNA_RefSeq_V15.23.qza
rm HOMD_16S_rRNA_RefSeq_V15.23.fasta

qiime tools import \
      --type 'FeatureData[Taxonomy]' \
      --input-format HeaderlessTSVTaxonomyFormat \
      --input-path HOMD_16S_rRNA_RefSeq_V15.23.qiime.taxonomy \
      --output-path ref-taxonomy-homd-v4.qza
rm HOMD_16S_rRNA_RefSeq_V15.23.qiime.taxonomy

qiime feature-classifier extract-reads \
      --i-sequences HOMD_16S_rRNA_RefSeq_V15.23.qza \
      --p-f-primer GTGCCAGCMGCCGCGGTAA \
      --p-r-primer GACTACHVGGGTATCTAATCC \
      --p-trunc-len 250 \
      --p-min-length 200 \
      --p-max-length 300 \
      --o-reads ref-seqs-homd-v4.qza
rm HOMD_16S_rRNA_RefSeq_V15.23.qza

qiime feature-classifier fit-classifier-naive-bayes \
      --i-reference-reads ref-seqs-homd-v4.qza \
      --i-reference-taxonomy ref-taxonomy-homd-v4.qza \
      --o-classifier homd-15.23-515-806-nb-q2-2024.5.qza
rm ref-seqs-homd-v4.qza ref-taxonomy-homd-v4.qza



