#===============================================================================
# TEST SCRIPT: UTILITY SCENARIO CALCULATIONS
#===============================================================================

# This script tests the utility scenario functions without running the full model.
# It demonstrates the utility values that would be used for each country and scenario.

# Load data and helper functions
# -------------------------------
source("Markov_3state.Rmd")  # This would load all the chunks we've created

# Test countries
countries <- c("Ireland", "Germany", "Spain")

# Test age
test_age <- 65

# Results storage
test_results <- list()

cat("\n")
cat("================================================================================\n")
cat("UTILITY SCENARIO TEST: COMPARING BASE CASE VS POPULATION NORM ADJUSTED\n")
cat("================================================================================\n")
cat("\n")

for (ctry in countries) {
  cat("------------------------------------------------------------------------\n")
  cat("COUNTRY:", ctry, "\n")
  cat("------------------------------------------------------------------------\n")

  # Scenario 1: Ramsey base case
  result_ramsey <- get_utility_scenario(
    country = ctry,
    age = test_age,
    utility_scenario = "ramsey_basecase",
    df_popnorm = df_popnorm
  )

  cat("\nSCENARIO 1: RAMSEY BASE CASE\n")
  cat("  u_PFS:  ", round(result_ramsey$u_PFS, 4), "\n")
  cat("  u_PD:   ", round(result_ramsey$u_PD, 4), "\n")
  cat("  Method: ", result_ramsey$method, "\n")
  cat("  Source: ", result_ramsey$source, "\n")

  # Scenario 2: Population norm adjusted
  result_popnorm <- get_utility_scenario(
    country = ctry,
    age = test_age,
    utility_scenario = "population_norm_adjusted",
    df_popnorm = df_popnorm
  )

  cat("\nSCENARIO 2: POPULATION NORM ADJUSTED\n")
  cat("  u_PFS:  ", round(result_popnorm$u_PFS, 4), "\n")
  cat("  u_PD:   ", round(result_popnorm$u_PD, 4), "\n")
  cat("  Method: ", result_popnorm$method, "\n")
  cat("  Source: ", result_popnorm$source, "\n")
  cat("\n  DETAILS:\n")
  cat("    Population norm (", ctry, " age ", test_age, "): ", round(result_popnorm$U_pop, 4), "\n", sep = "")
  cat("    UK reference norm (age 65): ", round(result_popnorm$U_ref, 4), "\n")
  cat("    mCRC PFS mean: ", round(result_popnorm$mean_PFS_mcrc, 4), "\n")
  cat("    mCRC PD mean:  ", round(result_popnorm$mean_PD_mcrc, 4), "\n")
  cat("    mult_PFS:      ", round(result_popnorm$mult_PFS_mcrc, 4), "\n")
  cat("    mult_PD:       ", round(result_popnorm$mult_PD_mcrc, 4), "\n")

  # Compare scenarios
  cat("\nCOMPARISON:\n")
  cat("  Δ u_PFS (PopNorm - Ramsey): ", round(result_popnorm$u_PFS - result_ramsey$u_PFS, 4), "\n")
  cat("  Δ u_PD  (PopNorm - Ramsey): ", round(result_popnorm$u_PD - result_ramsey$u_PD, 4), "\n")

  # Check if population norm utilities are below Ramsey
  if (result_popnorm$u_PFS < result_ramsey$u_PFS) {
    cat("  ✓ PopNorm PFS utility is BELOW Ramsey (more conservative, as expected)\n")
  } else {
    cat("  ⚠ PopNorm PFS utility is ABOVE Ramsey (unexpected!)\n")
  }

  if (result_popnorm$u_PD < result_ramsey$u_PD) {
    cat("  ✓ PopNorm PD utility is BELOW Ramsey (more conservative)\n")
  } else if (result_popnorm$u_PD > result_ramsey$u_PD) {
    cat("  ⚠ PopNorm PD utility is ABOVE Ramsey\n")
  } else {
    cat("  = PopNorm PD utility equals Ramsey\n")
  }

  # Check if utilities are below population norms (as expected for cancer patients)
  if (result_popnorm$u_PFS < result_popnorm$U_pop) {
    cat("  ✓ PopNorm PFS utility is BELOW general population norm (expected for cancer)\n")
  } else {
    cat("  ⚠ PopNorm PFS utility equals or EXCEEDS general population norm (unexpected!)\n")
  }

  cat("\n")

  # Store results
  test_results[[ctry]] <- list(
    ramsey = result_ramsey,
    popnorm = result_popnorm
  )
}

cat("================================================================================\n")
cat("SUMMARY INTERPRETATION\n")
cat("================================================================================\n")
cat("\n")
cat("EXPECTED PATTERNS:\n")
cat("1. Population norm-adjusted utilities should generally be BELOW Ramsey values\n")
cat("   (addresses reviewer concern that Ramsey may overestimate QoL)\n")
cat("2. Population norm-adjusted utilities should be BELOW general population norms\n")
cat("   (cancer patients have lower QoL than general population)\n")
cat("3. Higher population norms (e.g., Ireland 0.879) will produce higher cancer utilities\n")
cat("   (country-specific adjustment)\n")
cat("4. The multipliers should be < 1.0 (cancer decrement from population norm)\n")
cat("\n")
cat("IMPACT ON ICERs:\n")
cat("- Lower utilities → Lower QALYs → Higher ICERs (less cost-effective)\n")
cat("- This scenario analysis demonstrates robustness of conclusions to utility source\n")
cat("\n")
cat("================================================================================\n")
