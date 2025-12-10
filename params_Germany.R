#===============================================================================
# GERMANY COUNTRY-SPECIFIC PARAMETERS
#===============================================================================
#
# This file contains all Germany-specific parameters for the health economic
# cost-effectiveness analysis.
#
# TO USE: In Markov_3state.Rmd, uncomment the line:
#   source("params_Germany.R")
#
# NOTE: Germany costs were received as monthly values and are converted to
#       14-day cycles using: (monthly / 30) * 14
#
#===============================================================================

country_name <- "Germany"

# 1. Cost of treatment in this country (2024 values, € per 14-day cycle)
# Monthly costs converted to 14-day cycles: (monthly / 30) * 14
c_PFS_Folfox        <- ((1406.37 / 30) * 14)
c_PFS_Bevacizumab   <- ((3252.19 / 30) * 14)
c_OS_Folfiri        <- ((1442.70 / 30) * 14)
administration_cost <- 1927.72
subtyping_test_cost <- 400

# 2. Cost of treating adverse events conditional on occurrence (€)
c_AE1 <- 4188.31  # Leukopenia (grade 3/4)
c_AE2 <- 1982.68  # Diarrhea (grade 3/4)
c_AE3 <- 1307.72  # Nausea/vomiting (grade 3/4)

# 3. Willingness to pay threshold (€/QALY)
n_wtp <- 78871

# 4. Country-specific discount rates (annual)
country_discount_rate     <- 0.03  # Base case
country_max_discount_rate <- 0.06  # Upper bound for sensitivity analysis
country_min_discount_rate <- 0.00  # Lower bound for sensitivity analysis
