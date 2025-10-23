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

# View number of sequences
qiime tools inspect-metadata filtered-rep-seqs.qza # keep
qiime tools inspect-metadata removed-rep-seqs.qza # toss

```

OUT

```sh
There was an issue with loading the file # as metadata:

  Metadata file path doesn't exist, or the path points to something other than a file. Please check that the path exists, has read permissions, and points to a regular file (not a directory): #

  There may be more errors present in the metadata file. To get a full report, sample/feature metadata files can be validated with Keemei: https://keemei.qiime2.org

  Find details on QIIME 2 metadata requirements here: https://docs.qiime2.org/2025.7/tutorials/metadata/

```



