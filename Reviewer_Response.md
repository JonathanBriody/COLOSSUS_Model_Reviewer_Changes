# Response to Reviewers

## Summary of Revisions

We thank the reviewers for their constructive feedback, which has substantially improved the manuscript. Below, we provide detailed responses to each comment and describe the specific changes implemented in the model and manuscript.

---

# Reviewer #1

> Thank you for the opportunity to review this manuscript... To me, the model is sound and appropriate, and the writing of the manuscript is of very high quality. I only have minor suggestions for the authors to improve the clarity of the manuscript.

We thank the reviewer for their positive assessment of the model and manuscript quality.

---

### Comment 1.1: Section restructuring

> The section "2. Description of Patients and Treatment Regimens" feels out of place and should be a subheading in "3. Materials and Methods"

**Response:** We agree with this suggestion. The "Description of Patients and Treatment Regimens" section has been moved to become a subheading within the "Materials and Methods" section, improving the logical flow of the manuscript.

---

### Comment 1.2: Country justification placement

> The "Model Structure" subsection begins with a justification as to why the three countries were chosen. Perhaps the authors would like to consider whether some of this text is better suited in the Introduction. Description of the COLOSSUS project can remain where it is.

**Response:** We have revised the manuscript to move the justification for country selection to the Introduction, while retaining the COLOSSUS project description in its original location.

---

### Comment 1.3: BIC for goodness-of-fit

> Can the authors also include the BIC for their goodness-of-fit in the supplementary?

**Response:** We have added BIC (Bayesian Information Criterion) values alongside AIC values for all candidate parametric distributions. The model now computes and reports both AIC and BIC for time-to-progression (TTP) and time-to-death (TTD) survival models.

**Model changes implemented:**
- Added BIC extraction for all six candidate distributions (exponential, gamma, Gompertz, log-logistic, log-normal, Weibull)
- Created comprehensive comparison tables (`AIC_BIC_TTP.csv` and `AIC_BIC_TTD.csv`) that are saved to the output folder
- BIC results confirm that gamma distribution provides the best fit for TTP (BIC = 2577.0), while Weibull provides the best fit for TTD (BIC = 2652.7)

**Results:**

| Outcome | Distribution | AIC | BIC |
|---------|-------------|-----|-----|
| TTP | Gamma | 2570.4 | 2577.0 |
| TTP | Weibull | 2575.0 | 2581.6 |
| TTD | Weibull | 2646.1 | 2652.7 |
| TTD | Gamma | 2648.9 | 2655.5 |

---

### Comment 1.4: Deterministic sensitivity analysis description

> I suggest that the authors revise the paragraph describing the results of the deterministic sensitivity analysis, as the current phrasing is somewhat cumbersome and difficult to understand.

**Response:** We have revised the description of the deterministic sensitivity analysis results to improve clarity, adopting more direct phrasing as suggested by the reviewer.

---

# Reviewer #2

> This is an interesting and novel paper, and I congratulate the authors for addressing this topic. However, several aspects could be improved to enhance both the clarity of presentation and the robustness of the analysis.

We thank the reviewer for their detailed and constructive feedback.

---

## Major Comments

### Comment 2.1: Access to data and relation to previous study

> In the Methods section, it is not clear whether the authors had access to individual patient-level data from the published trial or relied solely on the publication. It is also unclear whether the authors were directly involved in the previous study.

**Response:** We have clarified in the Methods section that we had access to individual patient-level data from the ANGIOPREDICT consortium through the COLOSSUS project. The relationship to the previous study has been explicitly stated.

---

### Comment 2.2: Model structure justification

> The model is a very simple 3-state approach, but the rationale for choosing a Markov model rather than a partitioned survival model is not discussed.

**Response:** We have added a justification for the choice of a Markov cohort model over a partitioned survival model. The semi-Markov approach was chosen because:
1. It allows explicit modelling of transitions between health states
2. It enables time-dependent transition probabilities derived from parametric survival models
3. It is consistent with NICE and other HTA body methodological guidelines
4. It allows flexibility in incorporating hazard ratios for treatment effects

---

### Comment 2.3: Utility values - face validity concerns

> The use of trial-based utilities is problematic. Trial participants often have better health status than typical patients, and the reported value (0.85) appears unrealistically high for metastatic cancer... The authors should calculate country-specific multipliers based on general population norms.

**Response:** This is an important methodological point. We have implemented a comprehensive **population norm adjustment scenario analysis** to address this concern.

**Model changes implemented:**

1. **Created population norm utility database:** Added country-specific and age-specific population norm utilities for Ireland, Germany, and Spain from published EQ-5D national health surveys:
   - Ireland: Hobbins et al., 2018 (EQ-5D-5L)
   - Germany: Grochtdreis et al., 2019 (EQ-5D-5L)
   - Spain: Garcia-Gordillo et al., 2016 (EQ-5D-5L)

2. **Created mCRC utility evidence database:** Compiled utility values from mCRC-specific literature (Ramsey 2000, Stein 2014, Farkkila 2013, Mittmann 2009) to derive disease-specific multipliers.

3. **Implemented multiplier-based adjustment:** Following reviewer guidance, we calculate multipliers by comparing mCRC utilities to UK population norms, then apply these multipliers to country-specific population norms:
   - PFS multiplier: mCRC PFS utility / UK population norm
   - PD multiplier: mCRC PD utility / UK population norm
   - Country-adjusted utility = Country population norm × multiplier

4. **Ran scenario analysis:** Both the original Ramsey et al. base case and the population norm adjusted scenario are now reported.

**Results - Utility Scenario Analysis:**

| Country | Scenario | u_PFS | u_PD | ICER |
|---------|----------|-------|------|------|
| Ireland | Ramsey (base case) | 0.85 | 0.65 | €180,119 |
| Ireland | Population norm adjusted | 0.87 | 0.72 | €175,819 |
| Germany | Ramsey (base case) | 0.85 | 0.65 | €240,869 |
| Germany | Population norm adjusted | 0.83 | 0.69 | €245,755 |
| Spain | Ramsey (base case) | 0.85 | 0.65 | €200,968 |
| Spain | Population norm adjusted | 0.81 | 0.68 | €209,927 |

The conclusions remain unchanged: bevacizumab is not cost-effective in any country under either utility scenario.

---

### Comment 2.4: Measurement of utilities

> The methods section does not describe how utilities were measured (e.g., EQ-5D). The approach should be clarified, and multipliers applied to population reference values for each country.

**Response:** We have clarified that the base case utilities from Ramsey et al. were measured using the Health Utilities Index Mark III (HUI3). Additionally, as described above, we have implemented a scenario analysis using EQ-5D-based population norm utilities with multiplier adjustments.

---

### Comment 2.5: Deterministic vs. probabilistic analysis

> The base-case results are presented deterministically. Unless explicitly justified by local guidance, probabilistic analysis should be considered the base case. Results should include net monetary benefit (NMB) and credible intervals (CrI).

**Response:** We agree with this recommendation. We have implemented comprehensive PSA reporting with NMB and 95% credible intervals (CrI).

**Model changes implemented:**

1. **PSA methodology clarified:** The PSA uses Monte Carlo simulation with 10,000 iterations, sampling from parameter distributions defined in Table 1.

2. **NMB calculation added:** Net Monetary Benefit is now calculated as:
   ```
   NMB = (Incremental QALYs × WTP threshold) - Incremental Cost
   ```

3. **95% Credible Intervals reported:** For all PSA outputs (incremental cost, incremental QALYs, and NMB), we now report:
   - Mean value
   - 95% CrI (2.5th and 97.5th percentiles)

**Results - PSA with NMB and 95% CrI (Ireland example):**

| Metric | Mean | 95% CrI |
|--------|------|---------|
| Incremental Cost | €31,058 | €22,229 to €41,052 |
| Incremental QALY | 0.1729 | 0.0669 to 0.2918 |
| Incremental NMB | -€23,278 | -€30,649 to -€16,884 |

The negative NMB with 95% CrI entirely below zero confirms that bevacizumab is not cost-effective at Ireland's €45,000/QALY threshold, with high confidence.

---

### Comment 2.6: Survival analysis (Weibull fit)

> Weibull was not clearly the best fit according to AIC or visual inspection. Alternative parametric fits should be considered at least in scenario analyses.

**Response:** The reviewer is correct that gamma distribution provides a better fit for TTP according to both AIC and BIC criteria. We have implemented a **gamma distribution scenario analysis** as requested.

**Model changes implemented:**

1. **Gamma distribution parameters extracted:** Shape and scale parameters from the gamma distribution fit are now stored alongside Weibull parameters.

2. **Gamma scenario analysis function:** The model engine (`oncologySemiMarkov_function.R`) can now use either Weibull or gamma distributions via a `curve_choice_param` parameter.

3. **Comparative analysis performed:** Both Weibull (base case) and gamma (scenario) results are computed and compared.

**Results - Weibull vs. Gamma Scenario (Ireland):**

| Distribution | Strategy | Cost | QALY | ICER |
|--------------|----------|------|------|------|
| Weibull | Standard of Care | €19,763 | 0.607 | - |
| Weibull | Experimental | €50,575 | 0.778 | €180,119 |
| Gamma | Standard of Care | €19,601 | 0.602 | - |
| Gamma | Experimental | €50,331 | 0.774 | €178,526 |

**Conclusion:** The choice between Weibull and gamma distributions has minimal impact on cost-effectiveness conclusions. Both scenarios yield ICERs substantially above willingness-to-pay thresholds, confirming the robustness of our findings.

---

### Comment 2.7: Use of country-specific data

> The limited variability in cost-effectiveness results stems from the fact that no country-specific data (other than costs) were incorporated. This limitation should be explicitly discussed.

**Response:** We acknowledge this limitation and have added explicit discussion in the manuscript. The key country-specific parameters are:
- Treatment costs (drug, administration)
- Willingness-to-pay thresholds
- Discount rates
- Population norm utilities (in the scenario analysis)

Clinical efficacy parameters (hazard ratios, survival distributions) are derived from the pooled ANGIOPREDICT data and applied uniformly across countries, which is a limitation of the analysis.

---

## Minor Comments

### Comment 2.8: Abbreviation consistency

> Ensure abbreviations are consistent: some are spelled out more than once (e.g., CIN), while others are introduced inconsistently (hazard ratio).

**Response:** We have reviewed and standardised all abbreviations throughout the manuscript.

---

### Comment 2.9: Cost-effectiveness transferability

> The statement that cost-effectiveness analyses cannot be generalisable contradicts existing transferability frameworks.

**Response:** We have revised this statement to acknowledge existing transferability frameworks while noting the specific limitations of transferring economic evaluations across jurisdictions with different healthcare systems and willingness-to-pay thresholds.

---

### Comment 2.10: Trial description - patient numbers

> In the description of trials, please report the number of patients in intervention and comparator arms, not only tumour biopsies or samples.

**Response:** We have added the number of patients in each arm of the relevant trials.

---

### Comment 2.11: CHEERS clarification

> CHEERS is a reporting standard, clarify how it has been used

**Response:** We have clarified that the manuscript follows the CHEERS (Consolidated Health Economic Evaluation Reporting Standards) 2022 checklist as a reporting framework to ensure transparency and completeness.

---

### Comment 2.12: Scenario analysis ranges

> The ranges used in scenario analyses should be presented and justified.

**Response:** Parameter ranges for sensitivity analyses are presented in Table 1, with justifications provided in the supplementary material.

---

### Comment 2.13: Table 1 formatting

> Formatting of Table 1 should be improved for readability (especially in PDF conversion).

**Response:** We have improved the formatting of Table 1 for better readability.

---

### Comment 2.14: Table 2 discrepancies

> Numbers in Table 2 do not appear to match; if this is due to rounding, please clarify. The title should state explicitly whether results are deterministic or probabilistic. For PSA, please report NMB and CrI.

**Response:** We have:
1. Clarified that minor discrepancies are due to rounding
2. Explicitly labelled results as "Deterministic Base Case" or "Probabilistic Sensitivity Analysis"
3. Added NMB and 95% CrI to PSA results (see Comment 2.5 above)

---

# Reviewer #3

> Thank you for giving me the opportunity to review this work... The manuscript is well written, is clear, concise with good reader flow.

We thank the reviewer for their positive comments and detailed feedback.

---

### Comment 3.1: Parametric model choice

> The only substantial comment that I have pertains to the parameter model choice for KM data extrapolation... I would advise that BIC is also evaluated. I note also, that the AIC indicated that Weibull was not necessarily the best fit for progression; the gamma distribution may be more appropriate here.

**Response:** We fully agree with this comment and have implemented the requested changes:

1. **BIC added:** Both AIC and BIC are now reported for all candidate distributions (see Comment 1.3).

2. **Gamma scenario analysis:** A gamma distribution scenario for TTP has been implemented (see Comment 2.6).

3. **Structural uncertainty addressed:** Parameter choice for survival curves is now explicitly addressed as a source of structural uncertainty, with scenario analysis demonstrating robustness of conclusions.

---

### Comment 3.2: Structural uncertainty in DSA

> Of note, I do not see that parameter choice has been investigated in the deterministic SA. This is an omission. There is much evidence to suggest that CEAs in cancer are often sensitive to the choice of curve.

**Response:** The gamma distribution scenario analysis (described above) directly addresses this concern. As demonstrated, the choice between Weibull and gamma distributions results in similar ICERs (€180,119 vs €178,526 for Ireland), indicating that our conclusions are robust to this structural uncertainty.

---

### Comment 3.3: Utility transparency

> There is a lack of transparency regarding the choice of utilities. Values of 0.85 (for the first-line health state) and 0.65 (for the second-line health state) have been derived from Ramsey et al. These values (particularly 0.85) lack some face validity.

**Response:** We acknowledge this concern and have addressed it comprehensively through the population norm adjustment scenario analysis (see Comment 2.3). We have also added:

1. **Transparent extraction methodology:** Clarification that 0.85 represents long-term survivors in the Ramsey study and 0.65 represents patients who died within 12 months of the survey.

2. **mCRC evidence review:** A literature review of mCRC-specific utilities from multiple studies (Stein 2014, Farkkila 2013, Mittmann 2009) to contextualise our base case values.

3. **Population norm scenario:** An alternative scenario using country-specific population norms with disease multipliers, which produces utilities more in line with expectations for metastatic cancer patients.

---

### Comment 3.4: Jurisdiction in title

> It would be useful if the jurisdiction(s) were mentioned in the title.

**Response:** We have revised the title to include "Ireland, Germany, and Spain" to indicate the jurisdictions covered.

---

### Comment 3.5: Abstract wording

> In the abstract, the authors note that 'adding bevacizumab was only cost-effective when willingness to pay (WTP) thresholds were multiple times larger than currently accepted cut-offs'. Suggest that this is reworded...

**Response:** We have revised the abstract to state: "Bevacizumab was not cost-effective at conventional willingness-to-pay thresholds in any of the three countries analysed."

---

### Comment 3.6: EU diversity argument

> The argument that by choosing these three countries, the authors have captured the diversity of health expenditure across the EU is not compelling.

**Response:** We have revised this statement to more accurately reflect that the three countries represent a range of Western European health systems rather than claiming to capture full EU diversity.

---

### Comment 3.7: Median PFS and OS differences

> It would be useful for the reader to also understand what the differences in median PFS and OS versus SoC were.

**Response:** We have added median PFS and OS values alongside the hazard ratios in the methods section.

---

### Comment 3.8: Outdated bevacizumab citation

> The authors state that 'bevacizumab may be the most successful of all targeted therapies'. It is problematic that this statement is made whilst being supported by an outdated (2006) citation.

**Response:** We have updated this section with more recent citations and tempered the claim to acknowledge developments in targeted therapy since 2006.

---

### Comment 3.9: Time horizon justification

> It is necessary to inform the reader if the extrapolations indicated that this time horizon was appropriate (i.e. 100% of patients had experienced the event of interest in the extrapolated curves).

**Response:** We have added explicit confirmation that the extrapolated survival curves indicate near-complete mortality by the 5.5-year time horizon, justifying this as an appropriate lifetime horizon for the analysis.

---

### Comment 3.10: Older citations

> The transition probability of second-line treatment into death is as informed by a 2016 citation in a different population. It would be useful to know why a relatively old citation was used here.

**Response:** We have added justification for the use of older citations, noting the limited availability of more recent data for specific transition probabilities and explaining the clinical plausibility of the values used.

---

### Comment 3.11: DSA parameter details in main text

> Details are provided, in the appendix, about the parameter variations used in the deterministic SA. I would consider that a brief description should be provided within the main body of the manuscript.

**Response:** We have added a brief description of the parameter ranges and variation approach in the main text.

---

### Comment 3.12: Tornado plot clarity

> The tornado plots are very busy and thus difficult to decipher. Perhaps the top 10 parameters only could be presented (per country) and the x-axis range reduced. Please add a footnote to define all abbreviated text.

**Response:** We have implemented simplified tornado plots showing only the **top 10 most influential parameters** for each country.

**Model changes implemented:**

1. **Top 10 parameter selection:** Parameters are ranked by their absolute impact on ICER, and only the top 10 are displayed.

2. **Optimised axis ranges:** X-axis limits are calculated dynamically based on the ICER range for the top 10 parameters, with a 5% buffer for readability.

3. **Abbreviation footnotes:** All parameter abbreviations are defined in a footnote below each tornado plot.

4. **Clearer interpretation:** The plots now clearly show that no parameter variation brings the ICER below the relevant WTP threshold.

---

### Comment 3.13: Table 1 sources

> The sources for all inputs should be provided. I see that there are no citations, for example, for any Irish drug cost data.

**Response:** We have added complete source citations for all cost inputs, including Irish drug costs from the HSE National Pricing Office.

---

### Comment 3.14: Discount rate presentation

> The presentation of the application of discounts rates, in table 1, is not clear.

**Response:** We have improved the presentation of discount rates in Table 1, clarifying that the same discount rate is applied to both costs and health outcomes in each country.

---

### Comment 3.15: "Efficiency" vs "value"

> In the discussion, the authors state that 'We hypothesised that this improved efficacy may consequently increase efficiency...'. I expect that 'efficiency' here should be replaced with 'value'.

**Response:** We have replaced "efficiency" with "value" as suggested.

---

### Comment 3.16: PSA methodology

> I have may missed the detail, but I do not see how the PSA was undertaken. For example, was this MC PSA and how many iterations were undertaken.

**Response:** We have added explicit methodology for the PSA in the Methods section:

- **Method:** Monte Carlo probabilistic sensitivity analysis
- **Iterations:** 10,000 simulations
- **Seed:** Random number seed set for reproducibility (seed = 123)
- **Distributions:** Parameter distributions detailed in Table 1

---

### Editorial Comments (3.17-3.18)

> The authors state that 'threshold of €78,871 is applied as suggested by a recent assessment of the German'. The outcome (i.e. QALY) here is missing.
>
> The terms 'phase 3' and 'phase III' are used interchangeably.

**Response:** We have:
1. Added "per QALY" to complete the sentence about the German threshold
2. Standardised to "phase III" throughout the manuscript

---

# Summary of Model Changes

The following technical changes were made to the model in response to reviewer feedback:

| Change | Reviewer(s) | Files Modified |
|--------|-------------|----------------|
| BIC goodness-of-fit statistics | R1, R3 | `Markov_3state.Rmd` |
| Gamma distribution scenario | R2, R3 | `Markov_3state.Rmd`, `oncologySemiMarkov_function.R` |
| Population norm utility adjustment | R2, R3 | `Markov_3state.Rmd`, new data files |
| PSA NMB with 95% CrI | R2, R3 | `Markov_3state.Rmd` |
| Top 10 tornado plots | R3 | `Markov_3state.Rmd` |
| Country-specific outputs | All | `Markov_3state.Rmd` |

All changes maintain consistency between the base-case analysis and PSA engine, and results have been validated across all three countries (Ireland, Germany, Spain).

---

# Conclusion

We thank all reviewers for their thorough and constructive feedback. The revisions have substantially strengthened the methodological rigour and transparency of the analysis. Importantly, all additional analyses (gamma scenario, population norm utilities, PSA with NMB) confirm the primary conclusion: **bevacizumab plus standard chemotherapy is not cost-effective compared to standard chemotherapy alone in CIN-subtype mCRC patients in Ireland, Germany, or Spain at conventional willingness-to-pay thresholds.**
