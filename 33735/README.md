# Readme

[x-ref](https://forum.qiime2.org/t/filtering-all-metazoa-and-bacteria-out-of-my-sample/33735)

```sh
cd 33735/

wget https://moving-pictures-tutorial.readthedocs.io/en/latest/data/moving-pictures/rep-seqs.qza
wget https://moving-pictures-tutorial.readthedocs.io/en/latest/data/moving-pictures/taxonomy.qza

qiime taxa filter-seqs \
  --i-sequences rep-seqs.qza \
  --i-taxonomy taxonomy.qza \
  --p-exclude "d__Bacteria,p__Arthropoda,p__Annelida,p__Thermoplasmatota,p__Incertae_Sedis,Unassigned,p__Rotifera,p__Tunicata,p__Platyhelminthes,p__Mollusca,p__Nematozoa,p__Holozoa,p__Florideophycidae,p__Porifera,p__Xenacoelomorpha,p__Nemertea,p__Gastrotricha,p__Bryozoa,p__Vertebrata,p__uncultured,p__Phragmoplastophyta,p__Cnidaria" \
  --o-filtered-sequences filtered-rep-seqs.qza

qiime taxa filter-seqs \
  --i-sequences rep-seqs.qza \
  --i-taxonomy taxonomy.qza \
  --p-include "d__Bacteria,p__Arthropoda,p__Annelida,p__Thermoplasmatota,p__Incertae_Sedis,Unassigned,p__Rotifera,p__Tunicata,p__Platyhelminthes,p__Mollusca,p__Nematozoa,p__Holozoa,p__Florideophycidae,p__Porifera,p__Xenacoelomorpha,p__Nemertea,p__Gastrotricha,p__Bryozoa,p__Vertebrata,p__uncultured,p__Phragmoplastophyta,p__Cnidaria" \
  --o-filtered-sequences removed-rep-seqs.qza

ls -lh

```
