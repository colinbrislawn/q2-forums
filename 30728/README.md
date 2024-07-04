# Readme

[forums post](https://forum.qiime2.org/t/removing-specific-taxa-from-analysis-that-arent-identified-beyond-o-alphaproteobacteria-but-keeping-others-of-that-order-that-are-identified-beyond-order/30728/2)

## Testing

```sh
# setup
conda activate qiime2-amplicon-2024.5

wget https://docs.qiime2.org/2024.5/data/tutorials/pd-mice/taxonomy.qza
wget https://docs.qiime2.org/2024.5/data/tutorials/pd-mice/dada2_table.qza

# Works!
qiime taxa filter-table \
  --i-table dada2_table.qza \
  --i-taxonomy taxonomy.qza \
  --p-exclude "c__Alphaproteobacteria;__,Mitochondria,Chloplast,Eukaryota,Archaea,Wolbachia,unknown,Unknown,unassigned,Unassigned" \
  --o-filtered-table dada2_out.qza

```

## Cleanup

```sh
rm -f *.qza
```

## Posts

```md

|Before filter: taxa|percent|
|---|---|
|o__Alphaproteobacteria;o__|.425|
|o__Alphaproteobacteria;o__Rhizobiales|.425|
|o__Alphaproteobacteria;o__example|.135|
|o__Alphaproteobacteria;o__example2|.110|
|o__Alphaproteobacteria;o__example2;f__family|.110|

|After filter: taxa|percent|
|---|---|
|o__Alphaproteobacteria;o__Rhizobiales|.425|
|o__Alphaproteobacteria;o__example|.135|
|o__Alphaproteobacteria;o__example2|.110|
|o__Alphaproteobacteria;o__example2;f__family|.110|

```
