#!/bin/bash

# . ~/Q2/q2-2024.source

echo "Broken because rdp_16s_v18.fa.gz has 'L' at position 2 on line 251310"
exit

# Import HOMD database
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

# Import rdp_16s for reorientation
wget https://www.drive5.com/sintax/rdp_16s_v18.fa.gz
gzip -d rdp_16s_v18.fa.gz

qiime tools import \
      --type 'FeatureData[Sequence]' \
      --input-path rdp_16s_v18.fa \
      --output-path rdp_16s_v18.qza
rm rdp_16s_v18.fa

qiime rescript orient-seqs \
      --i-sequences HOMD_16S_rRNA_RefSeq_V15.23.qza \
      --i-reference-sequences rdp_16s_v18.qza \
      --p-threads 8 \
      --o-oriented-seqs HOMD_16S_rRNA_RefSeq_V15.23-oriented.qza \
      --o-unmatched-seqs HOMD_16S_rRNA_RefSeq_V15.23-unmatched.qza
rm HOMD_16S_rRNA_RefSeq_V15.23.qza
rm rdp_16s_v18.qza

qiime feature-classifier extract-reads \
      --i-sequences HOMD_16S_rRNA_RefSeq_V15.23-oriented.qza \
      --p-f-primer GTGCCAGCMGCCGCGGTAA \
      --p-r-primer GACTACHVGGGTATCTAATCC \
      --p-trunc-len 250 \
      --p-min-length 200 \
      --p-max-length 300 \
      --o-reads ref-seqs-homd-oriented-v4.qza
rm HOMD_16S_rRNA_RefSeq_V15.23-oriented.qza

qiime feature-classifier fit-classifier-naive-bayes \
      --i-reference-reads ref-seqs-homd-oriented-v4.qza \
      --i-reference-taxonomy ref-taxonomy-homd-v4.qza \
      --o-classifier homd-15.23-515-806-oriented-nb-q2-2024.5.qza
rm ref-seqs-homd-oriented-v4.qza
rm ref-taxonomy-homd-v4.qza

