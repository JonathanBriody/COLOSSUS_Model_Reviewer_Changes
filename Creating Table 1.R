# Install necessary packages if you haven't already
if(!require(flextable)){install.packages("flextable")}
if(!require(officer)){install.packages("officer")}

# Load necessary libraries
library(flextable)
library(officer)

# Create a data frame with the table data, replacing variable names with their values
data <- data.frame(
  Parameter = c(
    "**Cost (Per Cycle)**", "FOLFOX", "FOLFIRI", "Bevacizumab", "Subtyping Test Cost", "Administration Cost",
    "**Adverse Event Cost**", "Leukopenia", "Diarrhea", "Vomiting", 
    "**Adverse Event Incidence - With Bevacizumab**", "Leukopenia", "Diarrhea", "Vomiting",
    "**Adverse Event Incidence - Without Bevacizumab**", "Leukopenia", "Diarrhea", "Vomiting", 
    "**Adverse Event Incidence - Second Line**", "Leukopenia", "Diarrhea", "Vomiting", 
        "**Utility (Per Cycle)**", "Progression Free Survival", "Overall Survival", 
    "**Adverse Event Disutility**", "Leukopenia", "Diarrhea", "Vomiting", 
    "**Hazard Ratios**", "PFS to OS under the Experimental Strategy", "PFS to Dead under the Experimental Strategy", 
    "**Probability of Dying under Second-Line Treatment**",
    "**Discount Rate**", "Costs", "Outcomes"
  ),
  Base_Case_Value = c(
    "", sprintf("%.2f", c_PFS_Folfox), sprintf("%.2f", c_OS_Folfiri), sprintf("%.2f", c_PFS_Bevacizumab), sprintf("%.2f", subtyping_test_cost), sprintf("%.2f", administration_cost),
    "", sprintf("%.2f", c_AE1), sprintf("%.2f", c_AE2), sprintf("%.2f", c_AE3),
    "", sprintf("%.2f", p_FA1_EXPR), sprintf("%.2f", p_FA2_EXPR), sprintf("%.2f", p_FA3_EXPR),
    "", sprintf("%.2f", p_FA1_STD), sprintf("%.2f", p_FA2_STD), sprintf("%.2f", p_FA3_STD),
    "", sprintf("%.2f", p_OSA1_FOLFIRI), sprintf("%.2f", p_OSA2_FOLFIRI), sprintf("%.2f", p_OSA3_FOLFIRI),
    "", sprintf("%.2f", u_F), sprintf("%.2f", u_P),
    "", sprintf("%.2f", AE1_DisUtil), sprintf("%.2f", AE2_DisUtil), sprintf("%.2f", AE3_DisUtil),
    "", sprintf("%.2f", HR_FP_Exp), sprintf("%.2f", HR_PD_Exp),
    sprintf("%.2f", P_OSD_SoC),
    "", sprintf("%.2f", country_discount_rate), sprintf("%.2f", country_discount_rate)
  ),
  Minimum_Value = c(
    "", sprintf("%.2f", Minimum_c_PFS_Folfox), sprintf("%.2f", Minimum_c_OS_Folfiri), sprintf("%.2f", Minimum_c_PFS_Bevacizumab), sprintf("%.2f", Minimum_subtyping_test_cost), sprintf("%.2f", Minimum_administration_cost),
    "", sprintf("%.2f", Minimum_c_AE1), sprintf("%.2f", Minimum_c_AE2), sprintf("%.2f", Minimum_c_AE3),
    "", sprintf("%.2f", Minimum_p_FA1_EXPR), sprintf("%.2f", Minimum_p_FA2_EXPR), sprintf("%.2f", Minimum_p_FA3_EXPR),
    "", sprintf("%.2f", Minimum_p_FA1_STD), sprintf("%.2f", Minimum_p_FA2_STD), sprintf("%.2f", Minimum_p_FA3_STD),
    "", sprintf("%.2f", Minimum_p_OSA1_FOLFIRI), sprintf("%.2f", Minimum_p_OSA2_FOLFIRI), sprintf("%.2f", Minimum_p_OSA3_FOLFIRI),
    "", sprintf("%.2f", Minimum_u_F), sprintf("%.2f", Minimum_u_P),
    "", sprintf("%.2f", Minimum_AE1_DisUtil), sprintf("%.2f", Minimum_AE2_DisUtil), sprintf("%.2f", Minimum_AE3_DisUtil),
    "", sprintf("%.2f", Minimum_HR_FP_Exp), sprintf("%.2f", Minimum_HR_PD_Exp),
    sprintf("%.2f", Minimum_P_OSD_SoC),
    "", sprintf("%.2f", country_min_discount_rate), sprintf("%.2f", country_min_discount_rate)
  ),
  Maximum_Value = c(
    "", sprintf("%.2f", Maximum_c_PFS_Folfox), sprintf("%.2f", Maximum_c_OS_Folfiri), sprintf("%.2f", Maximum_c_PFS_Bevacizumab), sprintf("%.2f", Maximum_subtyping_test_cost), sprintf("%.2f", Maximum_administration_cost),
    "", sprintf("%.2f", Maximum_c_AE1), sprintf("%.2f", Maximum_c_AE2), sprintf("%.2f", Maximum_c_AE3),
    "", sprintf("%.2f", Maximum_p_FA1_EXPR), sprintf("%.2f", Maximum_p_FA2_EXPR), sprintf("%.2f", Maximum_p_FA3_EXPR),
    "", sprintf("%.2f", Maximum_p_FA1_STD), sprintf("%.2f", Maximum_p_FA2_STD), sprintf("%.2f", Maximum_p_FA3_STD),
    "", sprintf("%.2f", Maximum_p_OSA1_FOLFIRI), sprintf("%.2f", Maximum_p_OSA2_FOLFIRI), sprintf("%.2f", Maximum_p_OSA3_FOLFIRI),
    "", sprintf("%.2f", Maximum_u_F), sprintf("%.2f", Maximum_u_P),
    "", sprintf("%.2f", Maximum_AE1_DisUtil), sprintf("%.2f", Maximum_AE2_DisUtil), sprintf("%.2f", Maximum_AE3_DisUtil),
    "", sprintf("%.2f", Maximum_HR_FP_Exp), sprintf("%.2f", Maximum_HR_PD_Exp),
    sprintf("%.2f", Maximum_P_OSD_SoC),
    "", sprintf("%.2f", country_max_discount_rate), sprintf("%.2f", country_max_discount_rate)
  ),
  Source = c(
    "", "", "", "", "", "", 
    "", "", "", "",
    "", "", "", "", 
    "", "", "", "", 
    "", "", "", "", 
    "", "", "", 
    "", "BRTYA", "BETA", "BETA", 
    "", "[@smeets2018]", "[@smeets2018]", 
    "", 
    "", "", ""
  ),
  Distribution = c(
    "", sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_c_PFS_Folfox, b.cIntervention_c_PFS_Folfox), sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_c_OS_Folfiri, b.cIntervention_c_OS_Folfiri), sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_c_PFS_Bevacizumab, b.cIntervention_c_PFS_Bevacizumab), sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_subtyping_test_cost, b.cIntervention_subtyping_test_cost), sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_administration_cost, b.cIntervention_administration_cost), 
    "", sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_c_AE1, b.cIntervention_c_AE1), sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_c_AE2, b.cIntervention_c_AE2), sprintf("GAMMA(%.2f, %.2f)", a.cIntervention_c_AE3, b.cIntervention_c_AE3), 
    "", sprintf("BETA(%.2f, %.2f)", alpha_p_FA1_EXPR, beta_p_FA1_EXPR), sprintf("BETA(%.2f, %.2f)", alpha_p_FA2_EXPR, beta_p_FA2_EXPR), sprintf("BETA(%.2f, %.2f)", alpha_p_FA3_EXPR, beta_p_FA3_EXPR), 
    "", sprintf("BETA(%.2f, %.2f)", alpha_p_FA1_STD, beta_p_FA1_STD), sprintf("BETA(%.2f, %.2f)", alpha_p_FA2_STD, beta_p_FA2_STD), sprintf("BETA(%.2f, %.2f)", alpha_p_FA3_STD, beta_p_FA3_STD), 
    "", sprintf("BETA(%.2f, %.2f)", alpha_p_OSA1_FOLFIRI, beta_p_OSA1_FOLFIRI), sprintf("BETA(%.2f, %.2f)", alpha_p_OSA2_FOLFIRI, beta_p_OSA2_FOLFIRI), sprintf("BETA(%.2f, %.2f)", alpha_p_OSA3_FOLFIRI, beta_p_OSA3_FOLFIRI), 
    "", sprintf("BETA(%.2f, %.2f)", u_F_alpha, u_F_beta), sprintf("BETA(%.2f, %.2f)", u_P_alpha, u_P_beta), 
    "", sprintf("alpha_u_AE1, beta_u_AE1 (%.2f, %.2f)", alpha_u_AE1, beta_u_AE1), sprintf("alpha_u_AE2, beta_u_AE2 (%.2f, %.2f)", alpha_u_AE2, beta_u_AE2), sprintf("alpha_u_AE3, beta_u_AE3 (%.2f, %.2f)", alpha_u_AE3, beta_u_AE3), 
    "", "rlnorm()", "rlnorm()", 
    sprintf("BETA(%.2f, %.2f)", P_OSD_SoC_alpha, P_OSD_SoC_beta), 
    "", "", ""
  )
)

# ... (The rest of the code to create the flextable and Word document remains the same)


ft <- flextable(data) %>%
  theme_box() %>%
  autofit() %>%
  set_header_labels(
    Parameter = "Parameter",
    Base_Case_Value = "Base Case Value",
    Minimum_Value = "Minimum Value",
    Maximum_Value = "Maximum Value",
    Source = "Source",
    Distribution = "Distribution"
  )

library(officer)

doc <- read_docx() %>%
  body_add_par("Table 1 Model Parameters Values: Baseline, Ranges and Distributions for Sensitivity Analysis", style = "heading 1") %>%
  body_add_flextable(ft)

print(doc, target = file.path("output", paste0("Table_1_", country_name, ".docx")))