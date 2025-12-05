# Country-Specific Analysis Guide

## Overview

This guide explains how to run cost-effectiveness analyses for Ireland, Germany, and Spain using the refactored parameter file system.

## New File Structure

The country-specific parameters are now stored in separate files:

-   **`params_Ireland.R`** - All Ireland-specific costs, WTP threshold, and discount rates
-   **`params_Germany.R`** - All Germany-specific costs, WTP threshold, and discount rates
-   **`params_Spain.R`** - All Spain-specific costs, WTP threshold, and discount rates

## How to Run Analyses for Each Country

### Step 1: Select Country

In `Markov_3state.Rmd`, find the parameter loading section (around line 933) and uncomment ONE country:

``` r
# Uncomment ONE country (leave the others commented):
source("params_Ireland.R")
# source("params_Germany.R")
# source("params_Spain.R")
```

### Step 2: Run the Analysis

Knit the `Markov_3state.Rmd` file or run all chunks.

### Step 3: Outputs

All outputs will be saved with country-specific filenames:

**Ireland outputs:** - `output/Baseline_ICER_For_Ireland.csv` - `output/Probabilistic_ICER_For_Ireland.csv` - `output/Baseline_PFS_Curves_Ireland.png` - `output/Baseline_OS_Curves_Ireland.png` - `output/CE_Scatter_Plot_Ireland.png` - `output/CEAC_Ireland.png` - `output/tornado_top10_ireland.png` - And more...

**Germany outputs:** - `output/Baseline_ICER_For_Germany.csv` - `output/Probabilistic_ICER_For_Germany.csv` - `output/Baseline_PFS_Curves_Germany.png` - And more...

**Spain outputs:** - `output/Baseline_ICER_For_Spain.csv` - `output/Probabilistic_ICER_For_Spain.csv` - `output/Baseline_PFS_Curves_Spain.png` - And more...

### Step 4: Switch Countries and Re-run

To run the analysis for another country:

1.  Open `Markov_3state.Rmd`
2.  **Comment out** the current country's source line
3.  **Uncomment** the desired country's source line
4.  Knit the file again

**Example - Switching from Ireland to Germany:**

``` r
# Before (Ireland active):
source("params_Ireland.R")
# source("params_Germany.R")
# source("params_Spain.R")

# After (Germany active):
# source("params_Ireland.R")
source("params_Germany.R")
# source("params_Spain.R")
```

The new results will be saved with Germany-specific filenames and will NOT overwrite the Ireland results.

### Step 5: Aggregate All Countries (Optional)

After running all three countries, you can combine the results using the aggregation script:

``` r
source("aggregate_country_results.R")
```

This will create: - `output/Combined_Country_Results_Summary.csv` - Base-case ICERs for all countries - `output/Combined_PSA_Results_Summary.csv` - PSA results for all countries - `output/Country_Comparison_ICER_Plot.png` - Visual comparison across countries

## Complete Workflow Example

``` r
# 1. Run Ireland
# In Markov_3state.Rmd: Uncomment source("params_Ireland.R")
# Knit the file

# 2. Run Germany
# In Markov_3state.Rmd: Comment Ireland, uncomment source("params_Germany.R")
# Knit the file

# 3. Run Spain
# In Markov_3state.Rmd: Comment Germany, uncomment source("params_Spain.R")
# Knit the file

# 4. Aggregate results
source("aggregate_country_results.R")
```

## Benefits of This Approach

✅ **No overwriting** - Each country's outputs are saved separately

✅ **Easy comparison** - Run all three countries, then compare results side-by-side

✅ **Cleaner code** - Parameter files are organized and easy to review

✅ **Better version control** - Changes to country parameters are clearly tracked

✅ **Flexible workflow** - Run one country, some countries, or all countries as needed

## Key Country Parameters

### Ireland

-   WTP threshold: €45,000/QALY
-   Discount rate: 4% (range: 0-8%)
-   FOLFOX cost: €157.77 per cycle
-   Bevacizumab cost: €1,425.84 per cycle

### Germany

-   WTP threshold: €78,871/QALY
-   Discount rate: 3% (range: 0-6%)
-   FOLFOX cost: €655.63 per cycle (converted from monthly)
-   Bevacizumab cost: €1,517.69 per cycle (converted from monthly)

### Spain

-   WTP threshold: €30,000/QALY
-   Discount rate: 3% (range: 0-6%)
-   FOLFOX cost: €323.39 per cycle
-   Bevacizumab cost: €1,399.33 per cycle

## Troubleshooting

**Problem:** "Error: cannot open file 'params_Ireland.R'"

**Solution:** Make sure you're running the Rmd file from the correct working directory. The parameter files should be in the same directory as `Markov_3state.Rmd`.

------------------------------------------------------------------------

**Problem:** Results from different countries are overwriting each other

**Solution:** Check that all output statements in `Markov_3state.Rmd` include `country_name` in the filename. All major outputs have been updated to use country-specific names.

------------------------------------------------------------------------

**Problem:** Aggregation script can't find result files

**Solution:** Make sure you've run `Markov_3state.Rmd` for each country successfully. Check that the output files exist in the `output/` directory with the correct naming pattern (e.g., `Baseline_ICER_For_Ireland.csv`).

## Questions?

Refer to `CLAUDE.md` for detailed project documentation and methodological guidance.
