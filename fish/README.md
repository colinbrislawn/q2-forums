# FISH probes from Hundo OTUs

```sh
seqkit grep -r -n -p 'p__Ascomycota' ITS_OTU_tax.fasta \
    > ITS_OTU_tax_p__Ascomycota.fasta

mafft --op 3.0 --auto ITS_OTU_tax_p__Ascomycota.fasta \
    > ITS_OTU_tax_p__Ascomycota_mafft.aln

cons -sequence ITS_OTU_tax_p__Ascomycota_mafft.aln \
    -outseq ITS_OTU_tax_p__Ascomycota_cons.fasta \
    -name "p__Ascomycota"

# From the program cons
#grep -B 1 "GTAGGTGAACCTGCGGAAGG"
cat ITS_OTU_tax_p__Ascomycota_cons.fasta | head
grep "GTAGGTGAACCTGCGGAAGG" ITS_OTU_tax_p__Ascomycota_cons.fasta | wc -l

# The start of ITS OTU_4
grep "GTTGGTGAACCAGCGGAGGG" ITS_OTU_tax_p__Ascomycota_cons.fasta | wc -l

trimal -in ITS_OTU_tax_p__Ascomycota_mafft.aln \
    -out ITS_OTU_tax_p__Ascomycota_mafft_gap.aln \
    -gappyout

cons -sequence ITS_OTU_tax_p__Ascomycota_mafft_gap.aln \
    -outseq ITS_OTU_tax_p__Ascomycota_mafft_gap_cons.fasta \
    -name "p__Ascomycota"


# Start of OTU 4
# GTTGGTGAACCAGCGGAGGGATCATTA
#        missmatch G
grep -B 1    "GCGGAGGGATCATTA" ITS_OTU_tax_p__Ascomycota.fasta | head -n 2
# Start of OTU 5
# GTAGGTGAACCTGCGGAAGGATCATTA
#          matches A
grep -B 1    "GCGGAAGGATCATTA" ITS_OTU_tax_p__Ascomycota.fasta | head -n 2


# From trimal+conda
grep "TAGGTGAACCTGCGGAAGGA" ITS_OTU_tax_p__Ascomycota.fasta | wc -l
# From trimal+conda
#  TAGGTGAACCTGCGGAAGGATCATTAAAACTTTCAACAAC
#        AACCTGCGGAAGGATCATTA

# same:    .... ..... .........
grep -B 1 "AACCTGCGGAAGGATCATTA" ITS_OTU_tax_p__Ascomycota.fasta | head -n 2
grep -B 1 "AACCAGCGGAGGGATCATTA" ITS_OTU_tax_p__Ascomycota.fasta | head -n 2

# Count
# same:    .... ..... .........
grep "AACCTGCGGAAGGATCATTA" ITS_OTU_tax_p__Ascomycota.fasta | wc -l # 1358
grep "AACCAGCGGAGGGATCATTA" ITS_OTU_tax_p__Ascomycota.fasta | wc -l # 376
# Total of 1734
grep ">" ITS_OTU_tax_p__Ascomycota.fasta | wc -l # 2140
# 1734 / 2140 = 0.8102804 = 81%


```
