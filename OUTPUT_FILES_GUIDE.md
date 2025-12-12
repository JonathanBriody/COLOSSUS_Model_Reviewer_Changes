# COLOSSUS Model Output Files Guide

This document explains all CSV output files produced by the COLOSSUS/ANGIOPREDICT bevacizumab cost-effectiveness model, including what each file contains, how it's produced, and why it matters.

---

## Understanding ICER Differences: Deterministic vs PSA

Before diving into the files, it's important to understand why you'll see **two different ICER values** for the same scenario (e.g., Ramsey base case):

### Deterministic Analysis
- Uses **point estimates** (single values) for all parameters
- Example: u_F = 0.85 exactly
- Produces a single ICER value
- **Germany Ramsey example: €240,868.59**

### Probabilistic Sensitivity Analysis (PSA)
- Draws **10,000 random samples** from parameter distributions
- Example: u_F ~ Beta distribution with mean ≈ 0.85
- Runs the model 10,000 times and takes the **mean** of results
- **Germany Ramsey example: €241,187.90**

### Why They Differ (~0.1-0.2%)
This is **expected and correct** due to:
1. **Jensen's inequality**: The mean of a nonlinear function ≠ the function of the means
2. **Parameter uncertainty**: PSA captures the full distribution, not just the center

### Consistency Rules
- ✅ All **deterministic** Ramsey results should match each other
- ✅ All **PSA** Ramsey results should match each other
- ⚠️ Deterministic and PSA will differ slightly (this is normal)

---

## Output Files by Category

### 1. Survival Model Selection

#### `AIC_BIC_TTP.csv` and `AIC_BIC_TTD.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | AIC and BIC values for different parametric survival distributions (Weibull, Exponential, Gompertz, Log-normal, Log-logistic, Gamma) |
| **Produced by** | Survival model fitting section in `Markov_3state.Rmd` |
| **Key values** | Lower AIC/BIC = better fit |
| **Why we care** | Justifies choice of survival distribution (Weibull) for the base case |
| **Used for** | Methods section of manuscript; survival model selection rationale |

---

### 2. Deterministic Base Case Results

#### `Baseline_ICER_For_<Country>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Strategy, Cost, Effect (QALYs), Incremental Cost, Incremental Effect, ICER, Status |
| **Produced by** | Base case deterministic analysis using `calculate_icers()` from dampack |
| **Key values** | `ICER` - the primary outcome; `Inc_Cost` and `Inc_Effect` |
| **Why we care** | This is the **headline deterministic result** for each country |
| **Used for** | Main results table in manuscript; base case cost-effectiveness conclusion |

**Example (Germany):**
```
Strategy              Cost        Effect    Inc_Cost   Inc_Effect   ICER
Standard of Care      64,365      0.610     NA         NA           NA
Experimental          106,043     0.783     41,678     0.173        240,869
```

#### `Main_Country_Results_<Country>_ramsey_basecase.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Comprehensive deterministic results including utility values, costs, QALYs, ICER, NMB, WTP threshold |
| **Produced by** | Deterministic scenario analysis section |
| **Key values** | All columns are important - this is the complete base case summary |
| **Why we care** | Single-row summary of everything needed for the base case |
| **Used for** | Results tables; cross-country comparison; manuscript reporting |

**Columns explained:**
- `country`: Analysis jurisdiction
- `utility_scenario`: "ramsey_basecase" or "population_norm_adjusted"
- `u_PFS`, `u_PD`: Utility values used (0.85, 0.65 for Ramsey)
- `cost_SoC`, `cost_Exp`: Total costs per arm
- `qaly_SoC`, `qaly_Exp`: Total QALYs per arm
- `inc_cost`, `inc_qaly`: Incremental values
- `icer`: Cost per QALY gained
- `nmb`: Net monetary benefit (negative = not cost-effective)
- `n_wtp`: Willingness-to-pay threshold used

---

### 3. Probabilistic Sensitivity Analysis (PSA) Results

#### `Probabilistic_ICER_For_<Country>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | PSA mean costs, effects, incremental values, and ICER |
| **Produced by** | Main PSA section (10,000 iterations) using original df_PA_input samples |
| **Key values** | `ICER` - the PSA mean ICER; `Inc_Effect` - mean incremental QALYs |
| **Why we care** | **Primary PSA result** - accounts for parameter uncertainty |
| **Used for** | PSA results in manuscript; probabilistic cost-effectiveness conclusion |

#### `Probabilistic_ICER_For_<Country>_ramsey_basecase.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Same structure as above, explicitly for Ramsey scenario |
| **Produced by** | Utility scenario PSA (Section 09.3.1.1) |
| **Key values** | Should **exactly match** `Probabilistic_ICER_For_<Country>.csv` |
| **Why we care** | Confirms consistency; provides explicit Ramsey PSA for comparison |
| **Used for** | Utility sensitivity analysis; comparison with population-norm adjusted |

#### `Probabilistic_ICER_For_<Country>_population_norm_adjusted.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | PSA results using population-norm adjusted utilities |
| **Produced by** | Utility scenario PSA (Section 09.3.1.1) |
| **Key values** | `ICER` - shows impact of using country-specific population norms |
| **Why we care** | Addresses reviewer concern about utilities exceeding population norms |
| **Used for** | Sensitivity analysis; response to reviewer comments on utility values |

---

### 4. PSA Summary Statistics

#### `PSA_Summary_NMB_<Country>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Incremental cost, QALY, and NMB with 95% credible intervals |
| **Produced by** | PSA summary section using quantile calculations |
| **Key values** | `Incremental_NMB_Mean` and credible intervals |
| **Why we care** | Shows uncertainty around cost-effectiveness; CrI indicates if conclusion is robust |
| **Used for** | Uncertainty reporting; manuscript results; decision-making |

**Key columns:**
- `Incremental_Cost_Mean`: Mean additional cost of bevacizumab
- `Incremental_Cost_Lower_CrI`, `Incremental_Cost_Upper_CrI`: 95% credible interval
- `Incremental_QALY_Mean`: Mean additional QALYs gained
- `Incremental_NMB_Mean`: Mean net monetary benefit (Cost - WTP × QALY)
- Negative NMB = not cost-effective at the given WTP threshold

#### `PSA_Summary_NMB_Formatted_<Country>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Same as above but formatted for manuscript tables |
| **Produced by** | Formatting of PSA_Summary_NMB results |
| **Key values** | Human-readable formatted values with currency symbols |
| **Why we care** | Ready for copy-paste into manuscript |
| **Used for** | Direct inclusion in manuscript tables |

#### `PSA_Summary_NMB_All_Countries.csv` and `_Formatted.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Combined PSA summary for all three countries |
| **Produced by** | Aggregation of country-specific PSA results |
| **Key values** | Cross-country comparison of PSA outcomes |
| **Why we care** | Single table for comparing all jurisdictions |
| **Used for** | Cross-country comparison table in manuscript |

---

### 5. Survival Distribution Sensitivity Analysis

#### `Weibull_vs_Gamma_<Country>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Deterministic comparison of Weibull vs Gamma survival distributions |
| **Produced by** | Structural sensitivity analysis section |
| **Key values** | ICER difference between distributions |
| **Why we care** | Tests robustness to survival model choice |
| **Used for** | Structural sensitivity analysis in manuscript |

#### `Weibull_vs_Gamma_<Country>_PSA.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | PSA comparison of Weibull vs Gamma with credible intervals |
| **Produced by** | PSA run separately for each distribution |
| **Key values** | `ICER_PSA` for each distribution; `ICER_Pct_Change_Gamma_vs_Weibull` |
| **Why we care** | Shows if conclusions are robust to distributional assumptions under uncertainty |
| **Used for** | Structural uncertainty discussion; supplementary materials |

#### `Weibull_vs_Gamma_All_Countries_PSA.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Combined Weibull vs Gamma PSA for all countries |
| **Produced by** | Aggregation across countries |
| **Key values** | Cross-country comparison of structural sensitivity |
| **Why we care** | Single table showing distributional sensitivity across all jurisdictions |
| **Used for** | Supplementary table; methods robustness discussion |

---

### 6. Utility Scenario Analysis

#### `Utility_Scenario_Summary.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | **Deterministic** comparison of Ramsey vs population-norm adjusted utilities |
| **Produced by** | Deterministic scenario loop over utility scenarios |
| **Key values** | ICER comparison; shows % change from base case |
| **Why we care** | Shows impact of utility choice on results (deterministic) |
| **Used for** | Utility sensitivity analysis; reviewer response |

**Important:** This is DETERMINISTIC, so ICERs will differ slightly from PSA equivalents.

---

### 7. Age-Band Sensitivity Analysis (PSA)

#### `Age_Band_PSA_Sensitivity_Summary_<Country>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | PSA results across age bands (55-64, 65-74, 75+) plus Ramsey comparison |
| **Produced by** | Age-band PSA loop (Section 09.3.1.2) |
| **Key values** | `ICER`, `ICER_pct_change` (% change vs Ramsey) |
| **Why we care** | Shows how cost-effectiveness varies with patient age; addresses population norm concerns |
| **Used for** | Age sensitivity analysis; reviewer response on utility values |

**Columns explained:**
- `scenario`: "Ramsey (base case)" or "Pop-norm adjusted (XX-YY)"
- `age_band`: Which age band's population norms were used
- `u_F_mean`, `u_P_mean`: Utility values for this scenario
- `ICER_pct_change`: Percentage change from Ramsey base case
- `Inc_QALY_pct_change`: Change in incremental QALYs

#### `Age_Band_Utilities_All_Countries.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | Anchored utilities for all countries across all age bands |
| **Produced by** | Age-band PSA setup section |
| **Key values** | `anchored_utility` - the final utility after population norm adjustment |
| **Why we care** | Transparency on how utilities were derived; shows country differentiation |
| **Used for** | Methods documentation; supplementary materials |

**Columns explained:**
- `age_band`: e.g., "55-64", "65-74", "75+"
- `country`: England (UK), Ireland, Germany, Spain
- `state_category`: "PFS-like" or "PD-like"
- `U_pop_norm`: Country-specific population norm for that age band
- `U_ref_band`: Reference (England) norm used for multiplier calculation
- `multiplier`: mCRC utility / reference norm
- `anchored_utility`: Final adjusted utility = U_pop_norm × multiplier

#### `Probabilistic_ICER_For_<Country>_age_band_<band>.csv`

| Aspect | Description |
|--------|-------------|
| **What it contains** | PSA ICER for specific age band scenario |
| **Produced by** | Age-band PSA loop |
| **Key values** | `ICER` for that age cohort assumption |
| **Why we care** | Detailed results for each age band sensitivity run |
| **Used for** | Supplementary analysis; detailed age sensitivity |

---

## Quick Reference: Which File to Use When

| Question | File to Check |
|----------|---------------|
| What's the base case ICER? | `Baseline_ICER_For_<Country>.csv` |
| What's the PSA mean ICER? | `Probabilistic_ICER_For_<Country>.csv` |
| What are the 95% credible intervals? | `PSA_Summary_NMB_<Country>.csv` |
| How does ICER change with utilities? | `Age_Band_PSA_Sensitivity_Summary_<Country>.csv` |
| Ramsey vs population-norm adjusted? | `Utility_Scenario_Summary.csv` (deterministic) or `Probabilistic_ICER_For_<Country>_*.csv` (PSA) |
| Weibull vs Gamma distribution? | `Weibull_vs_Gamma_<Country>_PSA.csv` |
| Cross-country comparison? | `PSA_Summary_NMB_All_Countries.csv` |
| What utilities were used for each country/age? | `Age_Band_Utilities_All_Countries.csv` |

---

## Consistency Checks

When validating results, these values should match:

### Deterministic Ramsey ICER (should all be identical)
- `Baseline_ICER_For_<Country>.csv` → ICER column
- `Main_Country_Results_<Country>_ramsey_basecase.csv` → icer column
- `Utility_Scenario_Summary.csv` → ICER for ramsey_basecase rows

### PSA Ramsey ICER (should all be identical)
- `Probabilistic_ICER_For_<Country>.csv` → ICER column
- `Probabilistic_ICER_For_<Country>_ramsey_basecase.csv` → ICER column
- `Age_Band_PSA_Sensitivity_Summary_<Country>.csv` → ICER for "Ramsey (base case)" row
- `Weibull_vs_Gamma_<Country>_PSA.csv` → ICER_PSA for Weibull row
- `PSA_Summary_NMB_<Country>.csv` → derives from same PSA run

### Expected Difference
- Deterministic ICER ≠ PSA ICER (typically differs by 0.1-0.5%)
- This is mathematically expected and correct

---

## File Naming Conventions

- `<Country>`: Ireland, Germany, or Spain
- `_PSA`: Indicates probabilistic (vs deterministic) analysis
- `_ramsey_basecase`: Uses Ramsey et al. utilities (0.85, 0.65)
- `_population_norm_adjusted`: Uses country-specific population norms
- `_age_band_XX-YY`: Uses population norms for specific age band
- `_Formatted`: Human-readable formatting for manuscript
- `_All_Countries`: Combined results across jurisdictions
