# Readme

[x-ref](https://forum.qiime2.org/t/help-advice-on-truncation-parameters/33462/11)


```sh
wget https://forum.qiime2.org/uploads/short-url/5Hq0uoAh95GLM1W3FnujBTtleKD.tsv -O retained_summary.tsv
```

```R
library(tidyverse)
library(viridisLite)


read_tsv('retained_summary.tsv', show_col_types = FALSE) |>
  mutate(
    pct_retained_s1 = suppressWarnings(as.numeric(percent_retained_first_sample)),
    is_max = pct_retained_s1 == max(pct_retained_s1, na.rm = TRUE)
  ) |>
  ggplot(aes(
    x = trunc_len_f,
    y = trunc_len_r,
    fill = pct_retained_s1
    )) +
  geom_raster() +
  geom_text(aes(
    label = pct_retained_s1,
    fontface = ifelse(is_max, "bold", "plain")
    )) +
  scale_fill_viridis_c() +
  coord_fixed()

ggsave("retained_summary.png")


```
