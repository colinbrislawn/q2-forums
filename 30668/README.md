# Readme

[forums post](https://forum.qiime2.org/t/moving-picture-tutorial-issues-when-running-the-core-metrics-phylogeny-pipeline-in-diversity-plugin/30668)

```sh
# setup
conda activate qiime2-amplicon-2024.5

wget https://docs.qiime2.org/2024.5/data/tutorials/moving-pictures/rooted-tree.qza
wget https://docs.qiime2.org/2024.5/data/tutorials/moving-pictures/table-dada2.qza
wget \
  -O "sample-metadata.tsv" \
  "https://data.qiime2.org/2024.5/tutorials/moving-pictures/sample_metadata.tsv"

```

```sh
# Address this bug: https://forum.qiime2.org/t/core-metrics-plugin-error-from-diversity/29402/7
export UNIFRAC_MAX_CPU=basic

rm -rf core-metrics-results
qiime diversity core-metrics-phylogenetic \
    --i-phylogeny rooted-tree.qza \
    --i-table table-dada2.qza \
    --p-sampling-depth 1103 \
    --m-metadata-file sample-metadata.tsv \
    --output-dir core-metrics-results \
    --verbose
```

```sh
# check verion
wget https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.5-py39-linux-conda.yml
grep diversity qiime2-amplicon-2024.5-py39-linux-conda.yml

mamba install -c https://packages.qiime2.org/qiime2/2024.5/amplicon/released q2-diversity=2024.5.0
```
