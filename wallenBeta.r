library(tidyverse)
library(phyloseq)
library(microbiome)
library(readxl)
library(tidyr)
library(knitr)
library(ggpubr)
wallen_subject <- read_excel("/Users/bengold/Desktop/Source_Data_24Oct2022.xlsx",
                             sheet = "subject_metadata"
)

wallen_metaphlan <- read_excel("/Users/bengold/Desktop/Source_Data_24Oct2022.xlsx",
                               sheet = "metaphlan_rel_ab"
)

wallen_metaphlan <- wallen_metaphlan %>%
  as.data.frame()

wallen_metaphlan_v2 <- column_to_rownames(wallen_metaphlan, var = "clade_name")

wallen_subject <- wallen_subject %>%
  as.data.frame()
rownames(wallen_subject) <- wallen_subject$sample_name

wallen <- phyloseq(otu_table(wallen_metaphlan_v2, taxa_are_rows = TRUE), sample_data(wallen_subject))
#code above creates the phyloseq object, below is data analysis


metadata <- microbiome::meta(wallen)
metadata %>% View()

metadata %>%
  as.data.frame()

abundance_wallen <- microbiome::abundances(wallen)
abundance_wallen %>% View()

abundance_wallen_formatted <- abundance_wallen %>%
  as.data.frame() %>%
  rownames_to_column(var = "taxid")
abundance_wallen_formatted %>% View()
#  pivot_longer(!taxid, names_to = "id", values_to = "counts")

#abundance_wallen_formatted %>% View()

abundance_wallen %>%
  as.data.frame()

analysis_wallen <- metadata %>%
  rownames_to_column(var = 'taxid') %>%
  left_join(abundance_wallen_formatted, by = "taxid")

View(analysis_wallen)

analysis_wallen %>%
  filter(taxid == "k__Bacteria.p__Firmicutes.c__Clostridia.o__Clostridiales.f__Ruminococcaceae.g__Ruthenibacterium.s__Ruthenibacterium_lactatiformans") %>%
  glimpse()
View()
