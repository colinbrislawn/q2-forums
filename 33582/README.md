# Readme

[x-ref](https://forum.qiime2.org/t/duplicate-barcode-error-but-barcodes-listed-are-not-the-same/33582/4)

```sh
wget https://forum.qiime2.org/uploads/short-url/cuN9C0PiLOFUC4j8HWnbJXbRdY7.tsv -O Osburn10BSS8.All.tsv
```

```sh
cat Osburn10BSS8.All.tsv | cut -f3 | sort | uniq -c | awk '$1 > 1'

```

```R
library(tidyverse)

read_tsv("Osburn10BSS8.All.tsv") |>
  mutate(across(everything(), as.character)) |>
  pivot_longer(everything(), names_to = "column", values_to = "value") |>
  count(column, value, sort = TRUE)
```
