#===============================================================================
# IRELAND COUNTRY-SPECIFIC PARAMETERS
#===============================================================================
#
# This file contains all Ireland-specific parameters for the health economic
# cost-effectiveness analysis.
#
# TO USE: In Markov_3state.Rmd, uncomment the line:
#   source("params_Ireland.R")
#
#===============================================================================

country_name <- "Ireland"

# 1. Cost of treatment in this country (2024 values, € per 14-day cycle)
c_PFS_Folfox        <- 157.77
c_PFS_Bevacizumab   <- 1425.84
c_OS_Folfiri        <- 167.10
administration_cost <- 406.50
subtyping_test_cost <- 400

# 2. Cost of treating adverse events conditional on occurrence (€)
c_AE1 <- 3485.23  # Leukopenia (grade 3/4)
c_AE2 <- 1792.82  # Diarrhea (grade 3/4)
c_AE3 <- 502.69   # Nausea/vomiting (grade 3/4)

# 3. Willingness to pay threshold (€/QALY)
n_wtp <- 45000

# 4. Country-specific discount rates (annual)
country_discount_rate     <- 0.04  # Base case
country_max_discount_rate <- 0.08  # Upper bound for sensitivity analysis
country_min_discount_rate <- 0.00  # Lower bound for sensitivity analysis
