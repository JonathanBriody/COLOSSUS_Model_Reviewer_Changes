# CLAUDE.md – Project Guide

## Project Overview

This repository contains an **open-source health economic cost-effectiveness analysis (CEA)** for bevacizumab in metastatic colorectal cancer (CIN subtype).

**Model type:**
- 3-state semi-Markov cohort model
- Evaluates costs and quality-adjusted life years (QALYs)
- Generates incremental cost-effectiveness ratios (ICERs) and net monetary benefit (NMB)
- Country-specific analyses for Ireland, Germany, and Spain

**Implementation:**
- Built in R using R Markdown
- Separate engine function for deterministic and probabilistic sensitivity analysis (PSA)
- Structure and workflow aligned with **DARTH/dampack** tutorials and vignettes (referenced below)

---

## Core Files

### 1. `Markov_3state.Rmd` – Master Driver

The main R Markdown file that orchestrates the entire analysis:

- **Loads input data:**
  - `df_TTP.RData`: individual patient data for time to progression (PFS)
  - `df_TTD.RData`: individual patient data for time to death (OS)

- **Survival modeling:**
  - Fits parametric survival curves (Weibull, exponential, etc.) to PFS and OS data
  - Selects best-fitting distributions based on AIC/BIC

- **Model parameters:**
  - Defines all costs (treatment, administration, adverse events, testing)
  - Utilities and disutilities
  - Hazard ratios for treatment effects
  - Country-specific discount rates and willingness-to-pay thresholds

- **Base-case analysis:**
  - Runs the Markov cohort model
  - Computes base-case costs, QALYs, and ICERs
  - Generates tables and figures

- **Sensitivity analyses:**
  - **One-way sensitivity analysis (OWSA):** varies each parameter individually
  - **Two-way sensitivity analysis (TWSA):** varies pairs of parameters (may be commented out)
  - **Probabilistic sensitivity analysis (PSA):** samples from parameter distributions and runs multiple simulations

### 2. `oncologySemiMarkov_function.R` – Model Engine (Used for PSA)

Defines the core health economic engine as a single function:

```r
oncologySemiMarkov <- function(l_params_all, n_wtp = n_wtp) { ... }
```

**Purpose:**
- Reconstructs time-dependent transition probabilities from survival parameters and hazard ratios
- Runs the cohort trace using semi-Markov logic
- Applies discounting to costs and QALYs
- Accumulates total costs and effects for each strategy

**Usage:**
- Called by `run_owsa_det()` and `run_twsa_det()` for deterministic sensitivity analysis
- Called in a loop for **PSA**, where each row of sampled parameters generates one simulated outcome
- Returns structured output (costs, effects, ICER metrics) used by dampack functions

**Critical note:**
This function is **how the probabilistic sensitivity analysis is applied** in practice. Each PSA iteration passes a different row of sampled parameters into `oncologySemiMarkov()` to generate costs and QALYs under uncertainty.

### 3. Data Files (Read-Only Inputs)

- `df_TTP.RData`: individual patient data for **time to progression (PFS)**
- `df_TTD.RData`: individual patient data for **time to death (OS)**

These files are **fixed inputs** used for survival curve fitting and should **not** be regenerated or modified.

### 4. `Creating Table 1` Script – Parameter Summary

Generates **Table 1** for the manuscript: a summary of baseline parameter values, ranges, and probability distributions used in sensitivity analyses.

**Requirements:**
- Must be run **after** `Markov_3state.Rmd` for a selected country
- Assumes all model parameters are defined in the workspace
- Uses `flextable`/`officer` to export a Word document:
  ```r
  Table_1_<country_name>.docx
  ```

**Dependencies:**
- Depends on `country_name` being correctly set by the active country block
- Must be kept consistent with any changes to model parameters or PSA distributions

---

## Country-Specific Logic (Very Important)

### Key Principle

There is **one** main R Markdown file (`Markov_3state.Rmd`), but the analysis is run separately for **three countries**: Ireland, Germany, and Spain.

### How Country Selection Works

Country differences are handled by **manually uncommenting** one of three country blocks in `Markov_3state.Rmd`. Each block sets:

- `country_name`: identifier for outputs
- **Treatment costs:** `c_PFS_Folfox`, `c_PFS_Bevacizumab`, `c_OS_Folfiri`, `administration_cost`, `subtyping_test_cost`
- **Adverse event costs:** `c_AE1`, `c_AE2`, `c_AE3`
- **Willingness-to-pay threshold:** `n_wtp`
- **Discount rates:** `country_discount_rate`, `country_max_discount_rate`, `country_min_discount_rate`

### Country Block Summary

**Ireland block (active when uncommented):**
- `country_name <- "Ireland"`
- Irish treatment and AE costs
- `n_wtp = 45000`
- Discount rate: base 0.04, range 0.00–0.08

**Germany block (commented when not in use):**
- `country_name <- "Germany"`
- Treatment costs converted from monthly to 14-day cycles
- `n_wtp = 78871`
- Discount rate: base 0.03, range 0.00–0.06

**Spain block (commented when not in use):**
- `country_name <- "Spain"`
- Spanish treatment and AE costs
- `n_wtp = 30000`
- Discount rate: base 0.03, range 0.00–0.06

### Critical Rules for Claude

1. **Only one** country block should be active (uncommented) at a time
2. When instructed to "run Ireland/Germany/Spain", only uncomment the relevant block and leave the others commented
3. **Do not silently change this interface** (e.g. by automatically looping over all three countries) unless explicitly instructed to redesign it
4. The current manual-uncomment approach is intentional and should be preserved

---

## Sensitivity Analysis Wiring

The sensitivity analysis structure follows standard **dampack** usage patterns.

### One-Way Sensitivity Analysis (OWSA)

- Uses `run_owsa_det()` from dampack
- `FUN = oncologySemiMarkov` (calls the model engine)
- Base-case parameters provided via `l_params_all`
- Parameter ranges defined in `df_params_OWSA`
- Outputs used for tornado plots via `owsa_tornado()` or equivalent functions

### Two-Way Sensitivity Analysis (TWSA)

- Uses `run_twsa_det()` with `FUN = oncologySemiMarkov`
- Parameter pairs and ranges defined in `df_params_TWSA`
- May be commented out; can be re-enabled if needed
- Plots generated with `plot.twsa()` or similar

### Probabilistic Sensitivity Analysis (PSA)

**Process:**

1. Build parameter draw data frame (e.g. `df_PA_input`) with one row per simulation (typically 10,000 rows)

2. Each row contains sampled values for:
   - Survival parameters (shape, scale, hazard ratios)
   - Costs (treatment, AE, administration, testing)
   - Probabilities (AE rates, baseline risks)
   - Utilities and disutilities
   - Discount rates

3. For each simulation `i`, call:
   ```r
   oncologySemiMarkov(l_params_all = df_PA_input[i, ], n_wtp = n_wtp)
   ```

4. Collect resulting costs and QALYs by strategy into matrices/data frames (`df_c`, `df_e`)

5. Combine into a PSA object for use with dampack functions:
   - Cost-effectiveness planes: `plot.psa()`
   - Cost-effectiveness acceptability curves (CEACs): `plot.ceac()`
   - Summaries of incremental cost, QALY, and NMB

**Alignment:**
This structure is consistent with dampack's recommended workflow and the DARTH tutorials referenced below.

---

## Conceptual Background & External References

Much of the structure and logic of the deterministic and probabilistic analyses is based on, or consistent with, the following **dampack/DARTH resources**. These are provided for conceptual orientation and documentation; you do not need to access them programmatically.

### General DSA / OWSA Structure and dampack Usage

- [DSA generation vignette](https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html)
- [run_owsa_det() documentation](https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html)
- [owsa_tornado() documentation](https://rdrr.io/github/DARTH-git/dampack/man/owsa_tornado.html)
- [owsa_opt_strat() documentation](https://rdrr.io/github/DARTH-git/dampack/man/owsa_opt_strat.html)
- [owsa_opt_strat() Quantargo help](https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/owsa_opt_strat)
- [run_dsa.R source code](https://rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R)

### PSA Structure and Analysis in dampack

- [PSA analysis vignette](https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html)
- [plot.psa() documentation](https://rdrr.io/cran/dampack/man/plot.psa.html)
- [plot.ceac() documentation](https://rdrr.io/github/DARTH-git/dampack/man/plot.ceac.html)

### Basic CEA Concepts and dampack Manual

- [Basic CEA vignette](https://cran.r-project.org/web/packages/dampack/vignettes/basic_cea.html)
- [dampack PDF manual](https://mran.microsoft.com/snapshot/2021-03-21/web/packages/dampack/dampack.pdf)

### TWSA-Related Functions

- [twsa documentation](https://rdrr.io/github/DARTH-git/dampack/man/twsa.html)
- [run_twsa_det() documentation](https://rdrr.io/cran/dampack/man/run_twsa_det.html)
- [plot.twsa() Quantargo help](https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/plot.twsa)

### DARTH Cohort-Model Tutorial Example

- [cSTM_time_indep.R](https://github.com/DARTH-git/cohort-modeling-tutorial-intro/blob/main/analysis/cSTM_time_indep.R)

### Project-Specific Notes

- The current project **adapts and extends** these ideas for a semi-Markov oncology CEA with multiple countries
- The goal is to **remain consistent** with these patterns unless explicitly instructed otherwise
- Do **not** attempt to copy or duplicate the content from these external resources

---

## Repository Documentation (Paper & Model Explanation)

The repository contains human-readable documentation files at the **root** of the repository:

### Main Manuscript

- `Journal Submission.md` – Markdown version of the main manuscript
- `Journal Submission.pdf` – Typeset PDF version of the main manuscript

**Editing rule:**
- `Journal Submission.md` is the **preferred source** if textual changes to the manuscript are needed
- The PDF is for reference only

### Model Explanation

- `Model_Explanation.md` – Markdown document explaining the deterministic and probabilistic Markov model code, including:
  - Structure and purpose of `oncologySemiMarkov()` and `Markov_3state.Rmd`
  - How time-dependent transition probabilities are derived from parametric survival models and hazard ratios
  - How costs and QALYs are accumulated with discounting in the semi-Markov trace
  - How deterministic (OWSA/TWSA) and probabilistic sensitivity analyses are implemented using dampack

- `Model_Explanation.pdf` – Typeset PDF version of the model explanation

**Usage for Claude:**
- When you need conceptual clarity about how the code should behave, refer primarily to `Model_Explanation.md` rather than inventing new logic
- This document serves as the methodological and technical specification for the health-economic model

**Important:**
Do **not** rewrite or delete these documents unless explicitly instructed. They serve as methodological and reporting documentation for the health-economic model.

---

## How to Run the Model

### 1. Select Country

In `Markov_3state.Rmd`, uncomment the desired country block (Ireland, Germany, or Spain) and leave the others commented.

### 2. Run Base-Case Analysis

Knit `Markov_3state.Rmd` to reproduce:
- Base-case costs, QALYs, and ICERs
- Main plots and tables

### 3. Run Sensitivity Analyses

**Deterministic:**
- Execute the OWSA chunk to produce one-way sensitivity outputs and tornado plots
- Optionally execute the TWSA chunk (if uncommented) for two-way sensitivity analysis

**Probabilistic:**
- Execute the PSA section to generate:
  - Probabilistic outputs (cost and QALY distributions)
  - Cost-effectiveness acceptability curves (CEACs)
  - Summary tables of incremental costs, QALYs, and NMB

### 4. Create Table 1

After running the model for the selected country:
- Run the `Creating Table 1` script
- Output: `Table_1_<country_name>.docx`
- Verify that parameter values, ranges, and distributions match the current model setup

### Expected Results

Base-case results (costs, QALYs, ICERs) should remain consistent with the published manuscript within rounding, unless explicitly instructed to change core assumptions.

---

## Editing Rules for Claude

### General Principles

1. **Preserve data integrity:**
   - Do **not** delete input data files (`df_TTP.RData`, `df_TTD.RData`)
   - Do **not** overwrite original outputs without clear suffixes
   - When adding new outputs, use descriptive suffixes (e.g. `_BIC`, `_gamma_scenario`, `_NMB`, `_top10tornado`)

2. **Maintain consistency across files:**
   - If you change **core model logic** (survival curve choice, utility assumptions, discounting, AE handling, etc.), you must update **both**:
     - The base-case implementation in `Markov_3state.Rmd`, **and**
     - The engine in `oncologySemiMarkov_function.R`
   - This ensures base-case, OWSA/TWSA, and PSA remain aligned

3. **Update dependent files:**
   - If you rename parameters, add new ones, or alter PSA distributions, also update:
     - Code that builds `l_params_all`
     - PSA sampling structure (`df_PA_input`)
     - The `Creating Table 1` script
   - Table 1 must always reflect the actual parameters used in the model

4. **Preserve documentation:**
   - Preserve existing comments and in-line explanations unless explicitly asked to simplify or rewrite them
   - Comments document health economic modelling choices and are important for transparency
   - When adding new code, include clear comments explaining the health economic rationale

5. **Respect the country interface:**
   - Do not automatically refactor the manual country block selection unless explicitly instructed
   - The current approach (uncomment one block at a time) is intentional

6. **Refer to existing documentation:**
   - When uncertain about model behaviour, consult `Model_Explanation.md` first
   - Do not invent new methodological approaches without explicit instruction
   - Stay consistent with dampack patterns unless requested otherwise

### Specific Scenarios

**When modifying survival models:**
- Update both the fitting code in `Markov_3state.Rmd` and the transition probability calculations in `oncologySemiMarkov_function.R`
- Ensure hazard ratios are applied consistently

**When adding or removing parameters:**
- Update base-case definitions
- Update OWSA ranges (`df_params_OWSA`)
- Update PSA sampling (`df_PA_input`)
- Update Table 1 generation script
- Update any hard-coded parameter lists

**When changing PSA distributions:**
- Document the rationale (health economic justification)
- Update the sampling code
- Update Table 1 to reflect new distribution types and parameters
- Verify that sampled values remain within plausible ranges

**When generating new outputs:**
- Use clear, descriptive file names
- Add country suffix if country-specific (e.g. `_Ireland`, `_Germany`, `_Spain`)
- Do not overwrite existing published results

---

## Questions or Modifications

If you (Claude) are uncertain about:
- Whether a change affects model validity
- How to maintain consistency with published results
- Whether a requested modification aligns with health economic best practices

**Ask the user for clarification before proceeding.**

This is a published health economic model, and maintaining scientific integrity and reproducibility is paramount.
