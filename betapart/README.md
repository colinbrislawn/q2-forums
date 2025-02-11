## Betapart on Qiime2 artifacts

Data from [Qiime2 Cancer microbiome tutorial: core-phylogenetic-diversity](https://docs.qiime2.org/jupyterbooks/cancer-microbiome-intervention-tutorial/030-tutorial-downstream/050-core-metrics.html#core-phylogenetic-diversity-metrics).

```sh
# Download data
wget https://docs.qiime2.org/jupyterbooks/cancer-microbiome-intervention-tutorial/data/020-tutorial-upstream/020-metadata/sample-metadata.tsv
wget https://docs.qiime2.org/jupyterbooks/cancer-microbiome-intervention-tutorial/data/030-tutorial-downstream/050-core-metrics/diversity-core-metrics-phylogenetic/rarefied_table.qza


# Export data from Qiime2
conda activate qiime2-amplicon-2024.10

qiime tools export --input-path rarefied_table.qza --output-path .

biom normalize-table -p \
    -i feature-table.biom \
    -o feature_table_binary.biom

biom convert --to-tsv \
    -i feature_table_binary.biom \
    -o feature_table_binary.tsv

# Cleanup
rm -f *.biom
```
