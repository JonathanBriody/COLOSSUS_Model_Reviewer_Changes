# Notes to Myself: Detailed Explanation of All Manuscript Changes

This document explains **every single change** made to the `Journal Submission.md` manuscript in response to reviewer feedback. For each change, I explain:

1. **What was changed** (the exact text modification)
2. **Where it was changed** (location in the manuscript)
3. **Why it was changed** (the reviewer's concern)
4. **The health economic theory** (academic justification)
5. **The code evidence** (model outputs supporting the change)

---

## Table of Contents

1. [Title Update: Adding Country Names](#1-title-update-adding-country-names)
2. [Abstract Results Wording](#2-abstract-results-wording)
3. [Phase III Terminology Standardisation](#3-phase-iii-terminology-standardisation)
4. [Bevacizumab Success Claim Update](#4-bevacizumab-success-claim-update)
5. [Model Structure Justification (Markov vs PSM)](#5-model-structure-justification-markov-vs-psm)
6. [Transferability Statement Revision](#6-transferability-statement-revision)
7. [EU Diversity Statement Revision](#7-eu-diversity-statement-revision)
8. [Time Horizon Justification](#8-time-horizon-justification)
9. [CHEERS Clarification](#9-cheers-clarification)
10. [German WTP Threshold Missing Unit](#10-german-wtp-threshold-missing-unit)
11. [Discussion "Efficiency" to "Value"](#11-discussion-efficiency-to-value)

---

## 1. Title Update: Adding Country Names

### What Was Changed

**BEFORE:**
> Bevacizumab for Metastatic Colorectal Cancer with Chromosomal Instability: Cost-Effectiveness Analysis for a Novel Precision Treatment Approach

**AFTER:**
> Bevacizumab for Metastatic Colorectal Cancer with Chromosomal Instability in Ireland, Germany, and Spain: Cost-Effectiveness Analysis for a Novel Precision Treatment Approach

### Where It Was Changed

- Full Title in manuscript header
- Author Comments / Cover Letter

### Why It Was Changed

**Reviewer #3 stated:**
> "It would be useful if the jurisdiction(s) were mentioned in the title."

### The Health Economic Theory

In health economic evaluations, **transparency about the jurisdictional scope** is paramount. Cost-effectiveness results are not universally transferable because:

1. **Costs vary by jurisdiction**: Drug prices, hospital costs, and administration costs differ dramatically between countries due to different healthcare systems, negotiation mechanisms, and reimbursement structures.

2. **Willingness-to-pay (WTP) thresholds differ**: Each country has its own implicit or explicit cost-effectiveness threshold:
   - Ireland: €45,000 per QALY (HIQA guidance)
   - Germany: €78,871 per QALY (derived from empirical analysis)
   - Spain: €30,000 per QALY (commonly cited threshold)

3. **Discount rates differ**: Germany and Spain use 3% while Ireland uses 4% per national guidelines.

4. **ISPOR and CHEERS guidelines** recommend clearly specifying the decision-making context and perspective in study titles to help readers quickly assess relevance to their context.

Including country names in the title allows readers and policymakers to immediately identify whether the analysis is relevant to their decision-making context.

### Code Evidence

The model is structured with country-specific parameters in `Markov_3state.Rmd`:
- Three separate country blocks (Ireland, Germany, Spain) each defining `country_name`, treatment costs, WTP thresholds, and discount rates
- Outputs are generated separately per country (e.g., `Main_Country_Results_Ireland_ramsey_basecase.csv`)

---

## 2. Abstract Results Wording

### What Was Changed

**BEFORE:**
> Adding bevacizumab was only cost-effective when willingness to pay (WTP) thresholds were multiple times larger than currently accepted cut-offs.

**AFTER:**
> Bevacizumab was not cost-effective at conventional willingness-to-pay (WTP) thresholds in any of the three countries analysed.

### Where It Was Changed

- Abstract Results section
- This change appears in both the formatted abstract and the inline abstract

### Why It Was Changed

**Reviewer #3 stated:**
> "In the abstract, the authors note that 'adding bevacizumab was only cost-effective when willingness to pay (WTP) thresholds were multiple times larger than currently accepted cut-offs'. Suggest that this is reworded to state that bevacizumab is not cost effective even at thresholds that are appreciably higher than those that are considered realistic (or similar wording)."

### The Health Economic Theory

The original wording was **methodologically misleading** for several reasons:

1. **Framing matters in health economics communication**: The original phrasing ("only cost-effective when WTP thresholds were multiple times larger") implies there *is* a threshold at which bevacizumab becomes cost-effective, which is trivially true for any intervention. This is not informative.

2. **Decision-relevant communication**: Health economic analyses inform resource allocation decisions. The decision-relevant conclusion is whether the intervention is cost-effective at **real-world decision thresholds**, not at hypothetical elevated thresholds.

3. **ICER interpretation**: The ICERs in our study ranged from €180,477/QALY (Ireland) to €241,188/QALY (Germany). These exceed all three countries' WTP thresholds by factors of 3-8x:
   - Ireland: €180,477 vs €45,000 threshold (4x higher)
   - Germany: €241,188 vs €78,871 threshold (3x higher)
   - Spain: €200,968 vs €30,000 threshold (6.7x higher)

4. **The revised wording is clearer**: It directly states the policy-relevant conclusion without requiring readers to infer the implication.

### Code Evidence

From `output/Utility_Scenario_Summary.csv`:
- Ireland ICER: €180,118 vs WTP €45,000
- Germany ICER: €240,868 vs WTP €78,871
- Spain ICER: €200,968 vs WTP €30,000

All ICERs substantially exceed their respective thresholds, confirming bevacizumab is not cost-effective.

---

## 3. Phase III Terminology Standardisation

### What Was Changed

**BEFORE:** Mixed use of "phase 3" and "phase III"

**AFTER:** Consistent use of "phase III" throughout

### Where It Was Changed

Two instances in "Description of Patients and Treatment Regimens" section:
- "phase 3 trials" → "phase III trials"
- "CAIRO phase 3 trial" → "CAIRO phase III trial"

### Why It Was Changed

**Reviewer #3 stated:**
> "The terms 'phase 3' and 'phase III' are used interchangeably. In the interests of consistency, the preferred should be used throughout."

### The Health Economic Theory

This is a **stylistic/editorial issue** rather than a health economic theory issue. However, consistency in terminology is important for:

1. **Professional standards**: Academic journals expect consistent nomenclature
2. **Indexing and searchability**: Consistent terminology improves literature searchability
3. **Regulatory alignment**: The FDA and EMA typically use Roman numerals (Phase I, II, III, IV) in official documentation

"Phase III" (Roman numerals) is the more formal and widely used convention in clinical and health economics literature.

### Code Evidence

Not applicable - this is a text consistency change.

---

## 4. Bevacizumab Success Claim Update

### What Was Changed

**BEFORE:**
> ...bevacizumab may be the most successful of all targeted therapies [7].

**AFTER:**
> ...bevacizumab remains one of the most widely used targeted therapies in oncology [7].

### Where It Was Changed

Introduction section, paragraph 2

### Why It Was Changed

**Reviewer #3 stated:**
> "The authors state that 'bevacizumab may be the most successful of all targeted therapies'. It is problematic that this statement is made whilst being supported by an outdated (2006) citation."

### The Health Economic Theory

This change addresses **scientific accuracy and currency**:

1. **2006 context vs 2024 context**: When the original citation [7] was published (2006), bevacizumab was indeed revolutionary as the first anti-angiogenic therapy. Since then, the oncology landscape has transformed:
   - **Immune checkpoint inhibitors** (pembrolizumab, nivolumab) have become dominant
   - **CAR-T therapies** have shown remarkable success in haematological malignancies
   - **Other targeted therapies** (EGFR inhibitors, ALK inhibitors, HER2 inhibitors) have proven highly effective in specific populations

2. **Avoiding contestable claims**: The original claim ("most successful") is subjective and difficult to defend. The revised claim ("most widely used") is factually defensible - bevacizumab has been used in millions of patients across multiple tumour types since approval.

3. **Scientific rigour**: Health economic analyses should avoid hyperbolic or outdated claims that may undermine the credibility of the analysis.

### Code Evidence

Not applicable - this is a text accuracy change.

---

## 5. Model Structure Justification (Markov vs PSM)

### What Was Changed

**BEFORE:**
> We constructed a Markov model to calculate the lifetime costs and health outcomes of each treatment strategy in mCRC. The intention-to-treat...

**AFTER:**
> We constructed a Markov model to calculate the lifetime costs and health outcomes of each treatment strategy in mCRC. A semi-Markov approach was chosen over a partitioned survival model because it allows explicit modelling of transitions between health states, enables time-dependent transition probabilities derived from parametric survival models, and aligns with methodological guidelines from NICE and other HTA bodies. The intention-to-treat...

### Where It Was Changed

Model Structure section, second paragraph

### Why It Was Changed

**Reviewer #2 (Major Comment 2) stated:**
> "The model is a very simple 3-state approach, but the rationale for choosing a Markov model rather than a partitioned survival model is not discussed. A stronger justification for the structural choice is needed."

### The Health Economic Theory

This is a **critical methodological justification**. Two main approaches exist for modelling cancer survival:

#### Partitioned Survival Model (PSM)
- Uses separate survival curves (OS and PFS) to partition patients into health states
- Health state membership at time t is calculated as:
  - PFS state: S_PFS(t)
  - Progressed state: S_OS(t) - S_PFS(t)
  - Dead: 1 - S_OS(t)
- **Limitation**: Does not explicitly model transitions; patients can "jump" between states in ways that may be clinically implausible

#### Semi-Markov (State-Transition) Model
- Explicitly models **transition probabilities** between states
- Patients move between states according to estimated transition probabilities
- Allows **time-dependent transitions** (hazards that change over time)
- **Advantages**:
  1. **Clinical plausibility**: Transitions are explicit and can be validated against clinical pathways
  2. **Treatment effect modelling**: Hazard ratios can be applied directly to transition probabilities
  3. **Methodological alignment**: NICE Decision Support Unit Technical Support Document 19 recommends state-transition models when transition data are available
  4. **Flexibility**: Can incorporate tunnel states, patient history, and varying risks

#### Why Semi-Markov for This Analysis

Our model uses individual patient data (IPD) from the ANGIOPREDICT consortium to estimate parametric survival curves. The semi-Markov approach allows us to:

1. **Derive transition probabilities** from these survival curves using the relationship:
   ```
   tp_t = 1 - exp(-H(t) + H(t-1))
   ```
   where H(t) is the cumulative hazard at time t

2. **Apply hazard ratios** from Cox regression (HR_PFS = 0.68, HR_OS = 0.65) to adjust transition probabilities for the experimental arm

3. **Maintain the Markov property** while allowing time-dependent transitions (semi-Markov extension)

### Code Evidence

In `oncologySemiMarkov_function.R`, the semi-Markov structure is implemented:
- Transition probabilities are calculated from parametric survival parameters each cycle
- Hazard ratios (`HR_FP_Exp` and `HR_PD_Exp`) modify transitions for the experimental strategy
- The cohort trace (`m_M_SoC` and `m_M_Exp`) tracks patients through health states over time

In `Markov_3state.Rmd`:
- Survival curves are fitted using `flexsurvreg()` to estimate shape and scale parameters
- Time-dependent transition probabilities are derived from these parameters

---

## 6. Transferability Statement Revision

### What Was Changed

**BEFORE:**
> The challenge to drawing compelling and generalisable conclusions from such an analysis is the fact that it is not possible to simply extrapolate cost-effectiveness data globally.

**AFTER:**
> While transferability frameworks exist for adapting economic evaluations across jurisdictions, the challenge to drawing compelling conclusions from such an analysis is that direct extrapolation of cost-effectiveness data globally is limited by substantial variation in health system factors.

### Where It Was Changed

Model Structure section, first paragraph

### Why It Was Changed

**Reviewer #2 (Minor Comment) stated:**
> "The statement that cost-effectiveness analyses cannot be generalisable contradicts existing transferability frameworks."

### The Health Economic Theory

The original statement was **too absolute** and ignored established health economics literature on **transferability**.

#### The Transferability Framework

Health economists have developed systematic frameworks for assessing and adapting CEA results across settings:

1. **ISPOR Task Force on Transferability** (Drummond et al., 2009): Identified factors affecting transferability:
   - Clinical factors (disease epidemiology, clinical practice patterns)
   - Economic factors (costs, resource use, productivity costs)
   - Patient factors (demographics, preferences, adherence)
   - System factors (healthcare organisation, perspective, discount rates)

2. **EUnetHTA methodology**: Provides structured approaches for adapting assessments across European countries

3. **Welte et al. (2004) "Knock-out" criteria**: Identified factors that make direct transfer inappropriate:
   - Substantial differences in treatment comparators
   - Different patient populations
   - Incompatible perspectives
   - Different discount rates

#### The Nuanced Position

The revised text acknowledges that:
- Transferability frameworks **do exist** (accurate)
- **Direct extrapolation** remains limited (also accurate) due to:
  - Different drug prices and negotiation mechanisms
  - Different healthcare delivery costs
  - Different WTP thresholds and decision criteria
  - Different discount rates

This is why we conducted **separate country analyses** rather than assuming results would transfer.

### Code Evidence

The model structure itself demonstrates the limitations of direct transferability:
- Three completely separate country blocks in `Markov_3state.Rmd`
- Different cost inputs per country
- Different WTP thresholds (`n_wtp = 45000`, `78871`, `30000`)
- Different discount rates (4% Ireland, 3% Germany/Spain)

Despite using the **same clinical data** (hazard ratios, survival parameters), the ICERs differ substantially:
- Ireland: €180,477/QALY
- Germany: €241,188/QALY
- Spain: €200,968/QALY

This demonstrates that cost-effectiveness conclusions are country-specific.

---

## 7. EU Diversity Statement Revision

### What Was Changed

**BEFORE:**
> By choosing these countries as representative cases, we aim to capture the diversity of health expenditure patterns across the EU to produce conclusions on cost-effectiveness that are applicable to member states with high, medium and low public health investment.

**AFTER:**
> By choosing these countries as representative cases, we aim to represent a range of Western European health systems with varying levels of health expenditure, though we acknowledge this does not capture the full diversity of EU member states, particularly those with lower public health investment in Eastern Europe.

### Where It Was Changed

Model Structure section, first paragraph

### Why It Was Changed

**Reviewer #3 stated:**
> "The argument that by choosing these three countries, the authors have captured the diversity of health expenditure across the EU is not compelling. Spain sits only below the EU average. The public health investment in a number of eastern European countries is much lower. I would suggest that this argument be reworded to be more valid."

### The Health Economic Theory

This is about **sampling representativeness** and **honest acknowledgment of limitations**.

#### The Original Claim's Problems

The original claim overstated representativeness:

1. **Germany** (highest EU health expenditure, ~12.7% GDP) - ✓ high spending
2. **Ireland** (above EU average, ~7.1% GDP) - middle, but still above average
3. **Spain** (slightly below EU average, ~9.1% GDP) - below average but not "low"

Missing from this sample:
- **Eastern European countries**: Poland (~6.3% GDP), Hungary (~6.4% GDP), Romania (~5.8% GDP), Bulgaria (~8.1% GDP)
- These countries have fundamentally different health systems, lower pharmaceutical prices, and different decision-making structures

#### The Revised Position

The revision:
1. **Accurately describes what we have**: A range of **Western European** health systems
2. **Acknowledges the limitation**: Does not capture Eastern European systems with genuinely lower spending
3. **Maintains validity**: The study remains valuable for the countries included, just not for the entire EU

#### Health Economic Implications

This matters because:
- Eastern European countries often have **different WTP thresholds** (often implicit rather than explicit)
- **Drug prices** may be lower due to reference pricing tied to lower-income EU states
- **Healthcare delivery costs** are substantially lower
- Conclusions about cost-effectiveness in Ireland/Germany/Spain may not apply to Romania or Bulgaria

### Code Evidence

The COLOSSUS consortium (which funded this work) included Germany, Ireland, and Spain - this constrained our country selection. The code reflects this with three country blocks, but no provision for Eastern European countries.

---

## 8. Time Horizon Justification

### What Was Changed

**BEFORE:**
> A 5-and-a-half-year time horizon was also chosen; this was appropriate to estimate life expectancy in this patient population [28].

**AFTER:**
> A 5-and-a-half-year time horizon was also chosen; this was appropriate to estimate life expectancy in this patient population, as the extrapolated survival curves indicated near-complete mortality by this time point (see Online Resource Supplementary Figures) [28].

### Where It Was Changed

Model Structure section, third paragraph

### Why It Was Changed

**Reviewer #3 stated:**
> "The authors state that a 5-and-a half-year time horizon was considered appropriate to estimate life expectancy in this patient population. It is necessary to inform the reader if the extrapolations indicated that this time horizon was appropriate (i.e. 100% of patients had experienced the event of interest in the extrapolated curves). The extrapolated curves, presented in the supplemental appendix, indicate that this time horizon was appropriate, but it would be useful to state this within the body of the manuscript."

### The Health Economic Theory

**Time horizon selection** is a critical methodological choice in health economic modelling.

#### General Principle

NICE, CADTH, and most HTA bodies recommend using a **lifetime horizon** for chronic and life-threatening conditions because:
1. It captures all relevant costs and health outcomes
2. Shorter horizons may bias results if one treatment has delayed benefits
3. Patients and society value health gains whenever they occur

#### When Shorter Horizons Are Acceptable

A shorter time horizon is justified when:
1. **All clinically relevant outcomes occur within the horizon**: If >99% of patients have died or experienced the endpoint, extending further adds no information
2. **Discounting makes distant outcomes negligible**: At 3-4% discount rates, outcomes beyond 5-10 years contribute minimally
3. **Clinical equipoise after certain point**: If treatments converge in effectiveness after a certain time

#### Why 5.5 Years Is Appropriate Here

For metastatic colorectal cancer:
1. **Median OS** is approximately 20-24 months
2. **5-year survival** is only ~14%
3. The extrapolated survival curves show **near-complete mortality** by 5.5 years

The addition of the explicit justification ("as the extrapolated survival curves indicated near-complete mortality by this time point") provides the reader with the **empirical basis** for the time horizon choice, referencing the supplementary figures that show this.

### Code Evidence

In `Markov_3state.Rmd`:
- `n_cycle` defines the number of 14-day cycles
- 5.5 years ≈ 143 cycles × 14 days
- The survival curves (Weibull for OS, Gamma for TTP) asymptote to zero before this horizon

The supplementary figures (referenced in the manuscript) show the extrapolated curves reaching near-zero survival.

---

## 9. CHEERS Clarification

### What Was Changed

**BEFORE:**
> ...and the 2022 Consolidated Health Economic Evaluation Reporting Standards (CHEERS) guidelines were applied in this study, as per field standards in a health economic analysis, to describe evaluation and results [37].

**AFTER:**
> ...and the 2022 Consolidated Health Economic Evaluation Reporting Standards (CHEERS) checklist was applied as a reporting framework to ensure transparency and completeness of reporting, as per field standards in a health economic analysis [37].

### Where It Was Changed

Model Structure section, third paragraph

### Why It Was Changed

**Reviewer #2 (Minor Comment) stated:**
> "CHEERS is a reporting standard, clarify how it has been used"

### The Health Economic Theory

This addresses the **nature and purpose of reporting guidelines** in health economics.

#### What CHEERS Is

The **Consolidated Health Economic Evaluation Reporting Standards (CHEERS)** is:
- A **reporting checklist** (24 items in CHEERS 2022)
- Developed by ISPOR and endorsed by multiple journals
- Designed to improve **transparency and completeness** of reporting
- NOT a methodological guideline or quality assessment tool

#### What CHEERS Is NOT

- Not a guideline for **how to conduct** a health economic analysis (that would be the NICE reference case or national HTA guidelines)
- Not a quality appraisal tool (that would be CHEC, QHES, or Philips checklist)
- Not a standard that confers approval or certification

#### The Original Problem

The original text ("CHEERS guidelines were applied... to describe evaluation and results") was ambiguous:
- Could be interpreted as CHEERS dictating the methodology
- Could be interpreted as formal compliance or approval
- Unclear how exactly CHEERS was "applied"

#### The Revised Clarity

The revision specifies:
- CHEERS is a **checklist** (accurate terminology)
- Used as a **reporting framework** (accurate purpose)
- Purpose: **transparency and completeness of reporting** (accurate goal)

This accurately reflects that we structured our manuscript to address each CHEERS item, ensuring readers can find all relevant methodological and results information.

### Code Evidence

Not applicable - this is a methodological clarification. The CHEERS checklist would typically be provided as a supplementary table mapping each checklist item to manuscript locations.

---

## 10. German WTP Threshold Missing Unit

### What Was Changed

**BEFORE:**
> "...threshold of €78,871 is applied as suggested by a recent assessment of the German..."

**AFTER:**
> "...threshold of €78,871 per QALY is applied as suggested by a recent assessment of the German..."

### Where It Was Changed

Model Structure section (or Results, depending on location)

### Why It Was Changed

**Reviewer #3 (Editorial Comment) stated:**
> "The authors state that 'threshold of €78,871 is applied as suggested by a recent assessment of the German'. The outcome (i.e. QALY) here is missing."

### The Health Economic Theory

This is a **units and clarity** issue, but important for correct interpretation.

#### Why Units Matter

A willingness-to-pay threshold is always expressed as **currency per unit of health outcome**:
- €45,000 **per QALY** (Ireland)
- €78,871 **per QALY** (Germany)
- €30,000 **per QALY** (Spain)
- £20,000-30,000 **per QALY** (NICE, England)

Without the denominator ("per QALY"), the number is meaningless - it could be:
- €78,871 per QALY (correct interpretation)
- €78,871 per LY (life year, different metric)
- €78,871 per patient (completely different meaning)

#### QALY vs Other Metrics

**QALY (Quality-Adjusted Life Year)** combines:
- Quantity of life (survival time)
- Quality of life (utility weight, 0-1 scale)

This is distinct from:
- **LY (Life Year)**: Only survival, no quality adjustment
- **DALY (Disability-Adjusted Life Year)**: Used more in global health; measures burden rather than benefit

The German threshold of €78,871/QALY was derived empirically by analysing historical G-BA (Federal Joint Committee) decisions.

### Code Evidence

In `Markov_3state.Rmd`, the German block sets:
```r
n_wtp <- 78871  # WTP threshold in euros per QALY
```

The ICER calculation divides incremental cost by incremental QALY:
```r
ICER <- inc_cost / inc_QALY  # Result is €/QALY
```

---

## 11. Discussion "Efficiency" to "Value"

### What Was Changed

**BEFORE:**
> "We hypothesised that this improved efficacy may consequently increase efficiency, such that bevacizumab may finally reach a reasonable cost-per-QALY threshold to be deemed cost-effective."

**AFTER:**
> "We hypothesised that this improved efficacy may consequently increase value, such that bevacizumab may finally reach a reasonable cost-per-QALY threshold to be deemed cost-effective."

### Where It Was Changed

Discussion section

### Why It Was Changed

**Reviewer #3 stated:**
> "In the discussion, the authors state that 'We hypothesised that this improved efficacy may consequently increase efficiency, such that bevacizumab may finally reach a reasonable cost-per-QALY threshold to be deemed cost-effective'. I expect that 'efficiency' here should be replaced with 'value'."

### The Health Economic Theory

This addresses **precise use of health economics terminology**.

#### Efficiency vs Value

These terms have distinct meanings in health economics:

**Efficiency** (in health economics):
- **Technical efficiency**: Producing maximum output from given inputs
- **Allocative efficiency**: Optimal distribution of resources across the population
- **Pareto efficiency**: No reallocation can make someone better off without making someone worse off

Efficiency is about the **process** of converting inputs to outputs, typically measured at system or production level.

**Value** (in health economics):
- The **worth** of an intervention to patients, payers, or society
- Often operationalised as the ratio of health outcomes to costs
- A high-value intervention provides substantial health gains relative to its cost
- Directly relates to **cost-effectiveness**: high value = cost-effective

#### Why "Value" Is Correct Here

The sentence discusses whether improved clinical **efficacy** (better outcomes) would make bevacizumab reach a cost-effective threshold. This is asking about **value**:
- Better efficacy → more QALYs gained
- Same (or similar) cost → better ICER (lower €/QALY)
- Better ICER → higher **value** → potentially cost-effective

We are not asking whether the healthcare system would become more efficient, but whether bevacizumab would provide better **value for money** in this subgroup.

#### ISPOR Value Framework

ISPOR's Value Assessment Frameworks explicitly discuss "value" as the relationship between clinical benefits, costs, and other factors. Cost-effectiveness analysis is a **value assessment** methodology.

### Code Evidence

The model calculates:
- **Efficacy**: Captured by hazard ratios (HR_PFS = 0.68, HR_OS = 0.65) - these represent clinical benefit
- **Value**: Captured by the ICER (€180,477/QALY for Ireland) - this represents value for money

The model demonstrates that even with improved efficacy in CIN patients, the **value** (ICER) does not reach cost-effectiveness thresholds.

---

## Summary of All Changes

| # | Location | Change Type | Reviewer |
|---|----------|-------------|----------|
| 1 | Title | Added country names | R3 |
| 2 | Abstract | Revised results wording | R3 |
| 3 | Methods | Standardised "phase III" | R3 |
| 4 | Introduction | Updated bevacizumab claim | R3 |
| 5 | Model Structure | Added Markov vs PSM justification | R2 |
| 6 | Model Structure | Revised transferability statement | R2 |
| 7 | Model Structure | Revised EU diversity claim | R3 |
| 8 | Model Structure | Added time horizon justification | R3 |
| 9 | Model Structure | Clarified CHEERS usage | R2 |
| 10 | Model Structure | Added "per QALY" to German threshold | R3 |
| 11 | Discussion | Changed "efficiency" to "value" | R3 |

---

## Code Changes Already Implemented

In addition to the manuscript text changes above, the following model code changes were implemented to address reviewer concerns:

### BIC Statistics Added (Reviewer #1, #3)

**File**: `Markov_3state.Rmd`
**Output**: `output/AIC_BIC_TTP.csv`, `output/AIC_BIC_TTD.csv`

Results show:
- **TTP (Time to Progression)**: Gamma distribution best by both AIC (2570.4) and BIC (2577.0); Weibull close second (AIC 2575.0, BIC 2581.6)
- **TTD (Time to Death)**: Weibull distribution best by both AIC (2646.1) and BIC (2652.7)

### Gamma Distribution Scenario Analysis (Reviewer #3)

**File**: `Markov_3state.Rmd`
**Output**: `output/Weibull_vs_Gamma_Ireland.csv`

Results show minimal difference between Weibull and Gamma for TTP:
- Weibull ICER: €180,119/QALY
- Gamma ICER: €178,526/QALY (slightly lower)

This confirms robustness to distributional choice.

### PSA with NMB and Credible Intervals (Reviewer #2)

**File**: `Markov_3state.Rmd`
**Output**: `output/PSA_Summary_NMB_All_Countries_Formatted.csv`

Results for Ireland:
- Incremental Cost: €31,058 (95% CrI: €22,229 to €41,052)
- Incremental QALY: 0.1729 (95% CrI: 0.0669 to 0.2918)
- Incremental NMB: -€23,278 (95% CrI: -€30,649 to -€16,884)

The negative NMB confirms bevacizumab is not cost-effective (negative NMB = costs exceed value of benefits at the WTP threshold).

### Population Norm Utility Adjustment (Reviewer #2, #3)

**File**: `Markov_3state.Rmd`
**Data**: `population_norm_utilities_by_country_age.csv`

Implemented country-specific utility multipliers to adjust trial-based utilities to population norms. Results in `output/Utility_Scenario_Summary.csv` show similar conclusions across both utility approaches.

---

## Document Version History

- **Created**: December 2024
- **Author**: Claude Code Assistant
- **Purpose**: Detailed documentation of all manuscript changes for reviewer response

---

*This document is intended for personal reference to understand exactly what changes were made, why, and the underlying health economic rationale.*
