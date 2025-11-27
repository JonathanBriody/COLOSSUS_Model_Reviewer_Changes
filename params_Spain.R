#===============================================================================
# SPAIN COUNTRY-SPECIFIC PARAMETERS
#===============================================================================
#
# This file contains all Spain-specific parameters for the health economic
# cost-effectiveness analysis.
#
# TO USE: In Markov_3state.Rmd, uncomment the line:
#   source("params_Spain.R")
#
#===============================================================================

country_name <- "Spain"

# 1. Cost of treatment in this country (2024 values, € per 14-day cycle)
c_PFS_Folfox        <- 323.39
c_PFS_Bevacizumab   <- 1399.33
c_OS_Folfiri        <- 147.31
administration_cost <- 332.39
subtyping_test_cost <- 400

# 2. Cost of treating adverse events conditional on occurrence (€)
c_AE1 <- 5710.97  # Leukopenia (grade 3/4)
c_AE2 <- 305.55   # Diarrhea (grade 3/4)
c_AE3 <- 35.11    # Nausea/vomiting (grade 3/4)

# 3. Willingness to pay threshold (€/QALY)
n_wtp <- 30000

# 4. Country-specific discount rates (annual)
country_discount_rate     <- 0.03  # Base case
country_max_discount_rate <- 0.06  # Upper bound for sensitivity analysis
country_min_discount_rate <- 0.00  # Lower bound for sensitivity analysis
