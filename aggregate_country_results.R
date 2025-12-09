#===============================================================================
# AGGREGATE COUNTRY RESULTS SCRIPT
#===============================================================================
#
# This script combines cost-effectiveness results from Ireland, Germany, and
# Spain into consolidated summary tables and comparison plots.
#
# PREREQUISITES:
#   Before running this script, you must have already run Markov_3state.Rmd
#   separately for each country (Ireland, Germany, and Spain).
#
# HOW TO USE:
#   1. Run Markov_3state.Rmd with params_Ireland.R (uncommented)
#   2. Run Markov_3state.Rmd with params_Germany.R (uncommented)
#   3. Run Markov_3state.Rmd with params_Spain.R (uncommented)
#   4. Then run this script: source("aggregate_country_results.R")
#
# OUTPUTS:
#   - Combined_Country_Results_Summary.csv: Base-case ICERs for all countries
#   - Combined_PSA_Results_Summary.csv: PSA results for all countries
#   - Country_Comparison_Plot.png: Visual comparison of ICERs across countries
#
#===============================================================================

# Clear workspace
cat("\n")
cat("================================================================================\n")
cat("AGGREGATING COUNTRY RESULTS\n")
cat("================================================================================\n")
cat("\n")

# Load required packages
library(ggplot2)
library(dplyr)

# Create output directory if it doesn't exist
if (!dir.exists("output")) {
  dir.create("output", recursive = TRUE)
}

#===============================================================================
# PART 1: AGGREGATE BASE-CASE RESULTS
#===============================================================================

cat("PART 1: Aggregating base-case ICER results...\n")

# Define file paths for base-case results
base_ireland <- file.path("output", "Baseline_ICER_For_Ireland.csv")
base_germany <- file.path("output", "Baseline_ICER_For_Germany.csv")
base_spain <- file.path("output", "Baseline_ICER_For_Spain.csv")

# Check which files exist
exists_ireland <- file.exists(base_ireland)
exists_germany <- file.exists(base_germany)
exists_spain <- file.exists(base_spain)

# Report status
cat("\nChecking for base-case result files:\n")
cat("  Ireland:", ifelse(exists_ireland, "✓ Found", "✗ Missing"), "\n")
cat("  Germany:", ifelse(exists_germany, "✓ Found", "✗ Missing"), "\n")
cat("  Spain:  ", ifelse(exists_spain, "✓ Found", "✗ Missing"), "\n")
cat("\n")

# Read and combine base-case results
base_results_list <- list()

if (exists_ireland) {
  df_ireland <- read.csv(base_ireland)
  df_ireland$Country <- "Ireland"
  base_results_list[[length(base_results_list) + 1]] <- df_ireland
}

if (exists_germany) {
  df_germany <- read.csv(base_germany)
  df_germany$Country <- "Germany"
  base_results_list[[length(base_results_list) + 1]] <- df_germany
}

if (exists_spain) {
  df_spain <- read.csv(base_spain)
  df_spain$Country <- "Spain"
  base_results_list[[length(base_results_list) + 1]] <- df_spain
}

# Combine into single data frame
if (length(base_results_list) > 0) {
  combined_base <- do.call(rbind, base_results_list)

  # Reorder columns to put Country first
  combined_base <- combined_base %>%
    select(Country, everything())

  # Write to CSV
  base_output_file <- file.path("output", "Combined_Country_Results_Summary.csv")
  write.csv(combined_base, file = base_output_file, row.names = FALSE)

  cat("✓ Combined base-case results saved to:", base_output_file, "\n")
  cat("\n")

  # Print summary table
  cat("COMBINED BASE-CASE RESULTS:\n")
  cat("================================================================================\n")
  print(combined_base)
  cat("\n")

} else {
  cat("✗ No base-case result files found. Please run Markov_3state.Rmd for each country.\n")
}

#===============================================================================
# PART 2: AGGREGATE PSA RESULTS
#===============================================================================

cat("\nPART 2: Aggregating PSA results...\n")

# Define file paths for PSA results
psa_ireland <- file.path("output", "Probabilistic_ICER_For_Ireland.csv")
psa_germany <- file.path("output", "Probabilistic_ICER_For_Germany.csv")
psa_spain <- file.path("output", "Probabilistic_ICER_For_Spain.csv")

# Check which files exist
psa_exists_ireland <- file.exists(psa_ireland)
psa_exists_germany <- file.exists(psa_germany)
psa_exists_spain <- file.exists(psa_spain)

# Report status
cat("\nChecking for PSA result files:\n")
cat("  Ireland:", ifelse(psa_exists_ireland, "✓ Found", "✗ Missing"), "\n")
cat("  Germany:", ifelse(psa_exists_germany, "✓ Found", "✗ Missing"), "\n")
cat("  Spain:  ", ifelse(psa_exists_spain, "✓ Found", "✗ Missing"), "\n")
cat("\n")

# Read and combine PSA results
psa_results_list <- list()

if (psa_exists_ireland) {
  psa_df_ireland <- read.csv(psa_ireland)
  psa_df_ireland$Country <- "Ireland"
  psa_results_list[[length(psa_results_list) + 1]] <- psa_df_ireland
}

if (psa_exists_germany) {
  psa_df_germany <- read.csv(psa_germany)
  psa_df_germany$Country <- "Germany"
  psa_results_list[[length(psa_results_list) + 1]] <- psa_df_germany
}

if (psa_exists_spain) {
  psa_df_spain <- read.csv(psa_spain)
  psa_df_spain$Country <- "Spain"
  psa_results_list[[length(psa_results_list) + 1]] <- psa_df_spain
}

# Combine into single data frame
if (length(psa_results_list) > 0) {
  combined_psa <- do.call(rbind, psa_results_list)

  # Reorder columns to put Country first
  combined_psa <- combined_psa %>%
    select(Country, everything())

  # Write to CSV
  psa_output_file <- file.path("output", "Combined_PSA_Results_Summary.csv")
  write.csv(combined_psa, file = psa_output_file, row.names = FALSE)

  cat("✓ Combined PSA results saved to:", psa_output_file, "\n")
  cat("\n")

  # Print summary table
  cat("COMBINED PSA RESULTS:\n")
  cat("================================================================================\n")
  print(combined_psa)
  cat("\n")

} else {
  cat("✗ No PSA result files found. Please run Markov_3state.Rmd for each country.\n")
}

#===============================================================================
# PART 3: CREATE COMPARISON VISUALIZATIONS
#===============================================================================

if (length(base_results_list) > 0) {

  cat("\nPART 3: Creating comparison visualizations...\n")

  # Extract incremental results (Strategy = Experimental vs SoC)
  # This assumes the ICER table has both SoC and Exp strategies
  # and we want to show the incremental ICER

  # Filter for experimental strategy (if multiple rows per country)
  if ("Strategy" %in% names(combined_base)) {
    exp_results <- combined_base %>%
      filter(grepl("Exp|Bevacizumab|Experimental", Strategy, ignore.case = TRUE))
  } else {
    exp_results <- combined_base
  }

  # Create bar plot comparing ICERs across countries
  if ("Inc_Cost" %in% names(exp_results) && "Inc_Effect" %in% names(exp_results)) {

    # Calculate ICER if not already present
    if (!"ICER" %in% names(exp_results)) {
      exp_results$ICER <- exp_results$Inc_Cost / exp_results$Inc_Effect
    }

    # Create comparison plot
    comparison_plot <- ggplot(exp_results, aes(x = Country, y = ICER, fill = Country)) +
      geom_col(width = 0.6) +
      geom_text(aes(label = paste0("€", format(round(ICER, 0), big.mark = ","))),
                vjust = -0.5, size = 4) +
      labs(
        title = "Cost-Effectiveness Comparison: Bevacizumab + FOLFOX vs FOLFOX Alone",
        subtitle = "Incremental Cost-Effectiveness Ratio (ICER) by Country",
        x = "Country",
        y = "ICER (€/QALY)",
        caption = "Base-case deterministic results"
      ) +
      scale_fill_manual(values = c("Ireland" = "#1f77b4",
                                     "Germany" = "#ff7f0e",
                                     "Spain" = "#2ca02c")) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(size = 11),
        axis.title = element_text(size = 11),
        axis.text = element_text(size = 10),
        legend.position = "none"
      ) +
      scale_y_continuous(labels = scales::comma)

    # Save plot
    comparison_plot_file <- file.path("output", "Country_Comparison_ICER_Plot.png")
    ggsave(comparison_plot_file, plot = comparison_plot, width = 8, height = 6, dpi = 600)

    cat("✓ Comparison plot saved to:", comparison_plot_file, "\n")

    # Print the plot
    print(comparison_plot)
  }
}

#===============================================================================
# SUMMARY
#===============================================================================

cat("\n")
cat("================================================================================\n")
cat("AGGREGATION COMPLETE\n")
cat("================================================================================\n")
cat("\n")
cat("Generated files:\n")

if (exists("base_output_file")) {
  cat("  ✓", base_output_file, "\n")
}

if (exists("psa_output_file")) {
  cat("  ✓", psa_output_file, "\n")
}

if (exists("comparison_plot_file")) {
  cat("  ✓", comparison_plot_file, "\n")
}

cat("\n")
cat("All country results have been aggregated successfully.\n")
cat("================================================================================\n")
cat("\n")
