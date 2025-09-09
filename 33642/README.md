# Readme

[x-ref](https://forum.qiime2.org/t/abbreviating-taxonomic-names-in-r/33642/)

```R
# Load required libraries
library(phyloseq)
library(tidyverse)

# Load example data
data(GlobalPatterns)
GlobalPatterns

# Let's use the GlobalPatterns phyloseq object

# Extract tax_table and convert it into a tibble for easy edits
taxa_df <- GlobalPatterns |>
  tax_table() |>
  as.data.frame() |> 
  # Keep full ASV IDs for merging later!
  as_tibble(rownames = "ASV_ID") 
taxa_df # view the tibble


# Create new, shorter taxa labels in new columns.
taxa_df_custom <- taxa_df |>
  mutate(
    # Find the most specific taxonomic rank available for a clean label
    MostSpecific = coalesce(Genus, Family, Order, Class, Phylum),
    
    # Create a unique version for plotting to prevent aggregation of
    # different ASVs that have the same taxonomy (e.g., multiple Lactobacillus)
    Taxa_unique = str_c(MostSpecific, " (", str_sub(ASV_ID, 1, 5), ")")
  )
taxa_df_custom # view the new column


# Convert back into a phyloseq tax_table.
# We turn the ASV_IDs back into rownames for phyloseq!
new_tax_table <- taxa_df_custom |>
  column_to_rownames("ASV_ID") |>
  as.matrix() |>
  tax_table()
# new_tax_table # don't view this. Too big!

# Replace the old tax_table in your phyloseq object.
# The original 'ps_obj' remains unchanged
GlobalPatternsNew <- GlobalPatterns 
tax_table(GlobalPatternsNew) <- new_tax_table

# Now, check for new taxonomy columns!
head(tax_table(GlobalPatternsNew))
```
