# Readme

[x-ref](https://forum.qiime2.org/t/abbreviating-taxonomic-names-in-r/33642/)

## Prep

```sh
wget https://forum.qiime2.org/uploads/short-url/p6bCkKPsAGEa6cjdFMcR5XtcfYy.qza
mv p6bCkKPsAGEa6cjdFMcR5XtcfYy.qza braycurtis.qza

# already in the repo!
# wget https://forum.qiime2.org/uploads/short-url/bjChHlEE9MN7nireHlaHQTUrTYd.tsv
# mv bjChHlEE9MN7nireHlaHQTUrTYd.tsv sample-metadata.tsv
```

## Run

```sh
conda activate qiime2-amplicon-2025.7
qiime info
time qiime diversity beta-group-significance \
  --i-distance-matrix braycurtis.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column "SampleType" \
  --o-visualization bgs-colinbrislawn-wsl-qiime2-amplicon-2025.7.qzv

conda activate qiime2-amplicon-2024.10
qiime info
time qiime diversity beta-group-significance \
  --i-distance-matrix braycurtis.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column "SampleType" \
  --o-visualization bgs-colinbrislawn-wsl-qiime2-amplicon-2024.10.qzv

conda activate qiime2-amplicon-2024.5
qiime info
time qiime diversity beta-group-significance \
  --i-distance-matrix braycurtis.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column "SampleType" \
  --o-visualization bgs-colinbrislawn-wsl-qiime2-amplicon-2024.5.qzv

conda activate qiime2-amplicon-2023.9
qiime info
time qiime diversity beta-group-significance \
  --i-distance-matrix braycurtis.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column "SampleType" \
  --o-visualization bgs-colinbrislawn-wsl-qiime2-amplicon-2023.9.qzv

```
