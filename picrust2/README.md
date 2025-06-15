# Picrust2

Example command:

```bash
gzip -dc pred_metagenome_unstrat.tsv.gz | sed 's/function/#NAME/' | sed 's/^ko://' > pred_metagenome_unstrat_ko_sansKO.txt
```
