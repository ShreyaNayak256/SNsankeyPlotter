#' Plot Sankey Diagram
#'
#' This function plots a Sankey diagram based on pre-defined data.
#'
#' @export 
  plot_sankey <- function() {
  install.packages("remotes")
  remotes::install_github("davidsjoberg/ggsankey")
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(ggsankey) 
  library(crayon)
  data <- data.frame(
    Factor = c("Obesity", "Diabetes", "Smoking", "Hypercholesterolemia", "Hypertension"),
    `1990` = c(0.001, 0.359, 0.171, 0.161, 0.654),
    `1995` = c(0.013, 0.316, 0.156, 0.104, 0.633),
    `2000` = c(0.043, 0.26, 0.142, 0.045, 0.602),
    `2005` = c(0.077, 0.187, 0.128, 0.001, 0.561),
    `2010` = c(0.115, 0.092, 0.116, 0.001, 0.509)
  )
  # Convert data to long format
  long_data <- data %>%
    gather(key = "Year", value = "Value", -Factor)
  # Create a shifted version of the data for the next year's values
  shifted_data <- long_data %>%
    group_by(Factor) %>%
    arrange(Year) %>%
    mutate(Year_next = lead(Year), Value_next = lead(Value)) %>%
    ungroup()
  # Filter out rows where Year_next is NA
  df <- shifted_data
  # Rename columns for clarity
  df <- df %>%
    rename(x = Year, next_x = Year_next, node = Value, next_node = Value_next)
  # Remove the "X" prefix from the years
  df$x <- as.numeric(gsub("X", "", df$x))
  df$next_x <- as.numeric(gsub("X", "", df$next_x))
  # Define colors for each factor
  factor_colors <- c("Obesity" = "#756ab1", 
                     "Diabetes" = "#db6449", 
                     "Smoking" = "#7cabc5", 
                     "Hypercholesterolemia" = "#da8e4d", 
                     "Hypertension" = "#88bb8d")
  pl <- ggplot(df, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = Factor, label = round(node, 2)))
  pl <- pl + geom_sankey(flow.alpha = 0.8, node.color = "white", show.legend = TRUE)
  pl <- pl + geom_sankey_label(size = 3, color = "white", fontface = "bold", hjust = -0.1)
  pl <- pl + annotate("text", x = unique(df$x), y = 3.3, label = unique(df$x), fontface = "bold", color = "black")
  pl <- pl + theme_sankey(base_size = 8)
  pl <- pl + theme(legend.position = "right")
  pl <- pl + theme(axis.title = element_blank(), axis.text.y = element_blank() , axis.ticks = element_blank(), panel.grid = element_blank())
  pl <- pl + scale_fill_manual(values = factor_colors)
  pl <- pl + labs(title = "Sankey diagram using ggplot", subtitle = "using David Sjoberg's ggsankey package", fill = 'Risk Factor')
  
  print(pl)
  
  
}