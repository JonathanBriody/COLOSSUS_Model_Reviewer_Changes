# Country-Specific Analysis Guide

## Summary of Changes

The country-specific parameter handling has been refactored to solve the "object not found" errors while enabling both manual country selection and automated multi-country analysis.

## What Was Changed

### 1. Created `get_country_params()` Helper Function (Line ~799)

A new helper function centralizes all country-specific parameters:
- Treatment costs (FOLFOX, Bevacizumab, FOLFIRI)
- Administration costs
- Adverse event costs (leukopenia, diarrhea, nausea/vomiting)
- Willingness-to-pay thresholds
- Discount rates (base case, min, max)

### 2. Set Default Country Parameters (Line ~926)

By default, **Ireland** parameters are loaded into the workspace. This ensures all country-specific variables exist when referenced by downstream code chunks (e.g., `c_F_SoC <- administration_cost + c_PFS_Folfox`).

### 3. Updated Utility Scenario Analysis (Line ~11926)

The utility scenario analysis chunk now uses `get_country_params()` instead of hard-coded values, ensuring consistency across all analyses.

---

## How to Use

### Option 1: Analyze a Single Country (Manual Selection)

To analyze Ireland, Germany, or Spain individually:

1. Open `Markov_3state.Rmd`
2. Find the line (around line 926):
   ```r
   DEFAULT_COUNTRY <- "Ireland"
   ```
3. Change it to your desired country:
   ```r
   DEFAULT_COUNTRY <- "Germany"  # or "Spain"
   ```
4. Knit the document normally

All country-specific variables will be automatically set for your chosen country.

### Option 2: Run All Countries Automatically

The **Utility Scenario Analysis** chunk (near the end of the document, around line 11877) automatically loops through all three countries:

```r
countries_to_analyze <- c("Ireland", "Germany", "Spain")

for (ctry in countries_to_analyze) {
  # Automatically loads country-specific parameters
  params_ctry <- get_country_params(ctry)

  # Runs analysis for this country
  # ...
}
```

This chunk:
1. Loops through Ireland, Germany, and Spain
2. For each country, loads the correct parameters using `get_country_params()`
3. Runs the cost-effectiveness analysis under both utility scenarios:
   - Ramsey base case (0.85, 0.65)
   - Population norm adjusted
4. Saves results to `output/Utility_Scenario_Summary.csv`

---

## Benefits of This Approach

✅ **Solves "object not found" errors**: Country-specific variables are always defined upfront

✅ **Eliminates manual editing**: Change `DEFAULT_COUNTRY` instead of commenting/uncommenting blocks

✅ **Enables automation**: Utility scenario analysis automatically runs all countries sequentially

✅ **Maintains consistency**: Single source of truth for country parameters (the `get_country_params()` function)

✅ **Easy to extend**: Add new countries by adding a new `else if` block in `get_country_params()`

---

## Country Parameter Reference

### Ireland
- FOLFOX cost: €157.77 per cycle
- Bevacizumab cost: €1,425.84 per cycle
- FOLFIRI cost: €167.10 per cycle
- Administration: €406.50 per cycle
- WTP threshold: €45,000/QALY
- Discount rate: 4% (range: 0-8%)

### Germany
- FOLFOX cost: €656.30 per cycle (monthly costs converted to 14-day)
- Bevacizumab cost: €1,517.69 per cycle
- FOLFIRI cost: €672.59 per cycle
- Administration: €1,927.72 per cycle
- WTP threshold: €78,871/QALY
- Discount rate: 3% (range: 0-6%)

### Spain
- FOLFOX cost: €323.39 per cycle
- Bevacizumab cost: €1,399.33 per cycle
- FOLFIRI cost: €147.31 per cycle
- Administration: €332.39 per cycle
- WTP threshold: €30,000/QALY
- Discount rate: 3% (range: 0-6%)

---

## Technical Notes

### Variable Loading Order

The code now follows this sequence:

1. **Line ~799**: Define `get_country_params()` function
2. **Line ~926**: Set `DEFAULT_COUNTRY <- "Ireland"`
3. **Line ~929**: Call `params <- get_country_params(DEFAULT_COUNTRY)`
4. **Line ~932-944**: Unpack parameters into individual variables:
   ```r
   country_name <- params$country_name
   c_PFS_Folfox <- params$c_PFS_Folfox
   administration_cost <- params$administration_cost
   # ... etc
   ```
5. **Line ~4038+**: Use these variables in calculations:
   ```r
   c_F_SoC <- administration_cost + c_PFS_Folfox
   ```

This ordering ensures variables are always defined before use.

### Backward Compatibility

Existing code chunks that expect country-specific variables (OWSA, TWSA, PSA) will work correctly because:
- Ireland parameters are loaded by default
- All required variables are defined upfront
- No changes needed to downstream chunks

---

## Troubleshooting

**Error: "object 'administration_cost' not found"**
- **Cause**: This error occurred in the old refactored version where country parameters weren't loaded upfront
- **Solution**: This is now fixed! The new implementation loads all parameters at line ~929-944

**Want to add a new country?**
1. Add a new `else if` block in `get_country_params()` function
2. Follow the same structure as existing countries
3. Add the new country to `countries_to_analyze` in the utility scenario chunk

**Need different parameters for sensitivity analysis?**
- Modify the `country_max_discount_rate` and `country_min_discount_rate` values in `get_country_params()`
- These are used by OWSA/TWSA for discount rate sensitivity

---

## Questions?

For issues or questions about this implementation, refer to:
- `CLAUDE.md` - Project documentation
- `Model_Explanation.md` - Technical model details
- GitHub issues: https://github.com/JonathanBriody/COLOSSUS_Model_Reviewer_Changes/issues
