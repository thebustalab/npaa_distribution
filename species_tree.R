setwd("~/Documents/Phylogeny_paper/aze_data_comparison_phylo")

bustalab <- TRUE
source("https://thebustalab.github.io/phylochemistry/phylochemistry.R")

#generate a file with random species
set.seed(69)
random_species <- plant_species %>% sample_n(500)
write.csv(random_species, "random_species.csv", row.names = FALSE)

#manually combined random_species with nonproteogenic aminoacids data

#generate treee
aze_test <- read.csv("nonproteogenic_aa.csv")
test_tree <- buildTree(
  scaffold_type = "newick",
  scaffold_in_path = "http://thebustalab.github.io/data/angiosperms.newick",
  members = unique(aze_test$Genus_species)
)

test_tree_fortified <- fortify(test_tree)

#write newick file and import to iTOL
ape::write.tree(as.phylo(test_tree_fortified), file = "~/Documents/Phylogeny_paper/aze_data_comparison_phylo/species_tree")
