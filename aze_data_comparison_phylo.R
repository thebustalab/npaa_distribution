setwd("~/Documents/aze_data_comparison_phylo")
bustalab <- TRUE
source("https://thebustalab.github.io/phylochemistry/phylochemistry.R")


aze_test <- read.csv("aze_experimental.csv")



test_tree <- buildTree(
  scaffold_type = "newick",
  scaffold_in_path = "http://thebustalab.github.io/data/angiosperms.newick",
  members = unique(aze_test$Genus_species)
)

collapseTree(
  tree = test_tree,
  associations = data.frame(
    tip.label = test_tree$tip.label,
    Order = aze_test$label[match(test_tree$tip.label, aze_test$Genus_species)]
  )
) -> test_tree_genus


combined_data <- left_join(fortify(test_tree_genus), aze_test)


tree_plot <- ggtree(combined_data) +
  geom_tiplab() +
  coord_cartesian(xlim = c(0,400))

trait_plot <- ggplot(
  data = pivot_longer(
    filter(combined_data, isTip == TRUE),
    cols = 11:12, names_to = "compound", values_to = "metabolite"
  ),
  aes(x = compound, y = reorder(label, y), size = metabolite)
) +
  geom_point() +
  scale_y_discrete(name = "") +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    plot.margin = unit(c(1,1,1,-1.5), "cm") 
  ) 

plot_grid(
  tree_plot,
  trait_plot,
  nrow = 1, align = "h", axis = "tb"
)

