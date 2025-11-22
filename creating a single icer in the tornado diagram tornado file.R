#08.1 Load Markov model function

#08.3 One-way sensitivity analysis (OWSA)

# A brief note on how parameters are varied one at a time:

# A simple one-way DSA starts with choosing a model parameter to be investigated. Next, the modeler specifies a range for this parameter and the number of evenly spaced points along this range at which to evaluate model outcomes. The model is then run for each element of the vector of parameter values by setting the parameter of interest to the value, holding all other model parameters at their default base case values.

# To conduct the one-way DSA, we then call the function run_owsa_det with my_owsa_params_range, specifying the parameters to be varied and over which ranges, and my_params_basecase as the fixed parameter values to be used in the model when a parameter is not being explicitly varied in the one-way sensitivity analysis.


options(digits=4)

## Initialization ----

# Load the model as a function that is defined in the supporting script
# source("Functions_markov_3state.R")
# Test function
# calculate_ce_out(l_params_all)

# source(file = "oncologySemiMarkov_function.R")
# If I change any code in this main model code file, I will also need to update the function that I call.


# Create list l_params_all with all input probabilities, costs, utilities, etc.,

# Test whether the function works (and generates the same results)
# - to do so, first a list of parameter values needs to be generated

# Now I update this list with the variables I have:

# If I updated utility for AE above, then I'll have to take that into account for u_F below:

l_params_all <- list(
  HR_FP_Exp = HR_FP_Exp,
  HR_FP_SoC = HR_FP_SoC,
  HR_PD_Exp = HR_PD_Exp,
  HR_PD_SoC = HR_PD_SoC,
  P_OSD_SoC = P_OSD_SoC,      
  P_OSD_Exp = P_OSD_Exp,
  p_FA1_STD = p_FA1_STD,
  p_FA2_STD = p_FA2_STD,
  p_FA3_STD = p_FA3_STD,
  p_FA1_EXPR = p_FA1_EXPR,
  p_FA2_EXPR = p_FA2_EXPR,
  p_FA3_EXPR = p_FA3_EXPR,
  administration_cost = administration_cost,
  #ITS FINE TO INCLUDE THE INGRIDENIENTS THAT MAKE UP c_F_SoC, c_F_Exp, c_P, but don't include c_F_SoC, c_F_Exp, c_P themsleves, BECAUSE WE ARE CHANGING WHAT BUILDS THESE COSTS WITH THE INGRIEDIENTS, SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  c_PFS_Folfox = c_PFS_Folfox,
  c_PFS_Bevacizumab = c_PFS_Bevacizumab,
  c_OS_Folfiri = c_OS_Folfiri,
  subtyping_test_cost  = subtyping_test_cost,
  c_D       = c_D,    
  c_AE1 = c_AE1,
  c_AE2 = c_AE2,
  c_AE3 = c_AE3,
  u_F = u_F,   
  #ITS FINE TO INCLUDE U_F BUT DON'T INCLUDE U_F_SoC, BECAUSE WE ARE CHANGING WHAT BUILDS U_F_SoC WTH U_F AND AE1_DisUtil SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  u_P = u_P,   
  u_D = u_D,  
  AE1_DisUtil = AE1_DisUtil,
  AE2_DisUtil = AE2_DisUtil,
  AE3_DisUtil = AE3_DisUtil,
  d_e       = d_e,  
  d_c       = d_c,
  n_cycle   = n_cycle,
  t_cycle   = t_cycle
)


# Test function

# Test whether the function works (and generates the same results)

oncologySemiMarkov(l_params_all = l_params_all, n_wtp = n_wtp)


# Entering parameter values:


UpperCI <- 0.87
LowerCI <- 0.53

HR_FP_Exp

Minimum_HR_FP_Exp <- LowerCI
Maximum_HR_FP_Exp <- UpperCI


HR_FP_SoC

Minimum_HR_FP_SoC <- HR_FP_SoC - 0.20*HR_FP_SoC
Maximum_HR_FP_SoC <- HR_FP_SoC + 0.20*HR_FP_SoC


# Now that we're using the OS curves, I add hazard ratios for PFS to dead that reflect the hazard ratio of the experimental strategy changing the probability of going from PFS to Death, and the hazard ratio of 1 that I apply in standard of care so that I can vary transition probabilities under standard of care in this one-way sensitivity analysis:

HR_PD_SoC

Minimum_HR_PD_SoC <- HR_PD_SoC - 0.20*HR_PD_SoC
Maximum_HR_PD_SoC <- HR_PD_SoC + 0.20*HR_PD_SoC


OS_UpperCI <- 0.86
OS_LowerCI <- 0.49


HR_PD_Exp

Minimum_HR_PD_Exp <- OS_LowerCI
Maximum_HR_PD_Exp <- OS_UpperCI








# Probability of progressive disease to death:

# Under the assumption that everyone will get the same second line therapy, I give them all the same probability of going from progessed (i.e., OS) to dead, and thus only need to include p_PD here once - because it is applied in oncologySemiMarkov_function.R for both SoC and Exp. ACTUALLY I THINK IT SHOULD BE P_OSD_SoC P_OSD_Exp BOTH INCLUDED.

P_OSD_SoC

Minimum_P_OSD_SoC <- 0.12
Maximum_P_OSD_SoC <- 0.22

P_OSD_Exp

Minimum_P_OSD_Exp <- 0.12
Maximum_P_OSD_Exp <- 0.22







# Probability of going from PFS to Death states under the standard of care treatment and the experimental treatment:

# # HR_PD_SoC and HR_PD_Exp address this as above:

# p_FD_SoC
# 
# Minimum_p_FD_SoC <- p_FD_SoC - 0.20*p_FD_SoC
# Maximum_p_FD_SoC <- p_FD_SoC + 0.20*p_FD_SoC
# 
# p_FD_Exp
# 
# Minimum_p_FD_Exp<- p_FD_Exp - 0.20*p_FD_Exp
# Maximum_p_FD_Exp <- p_FD_Exp + 0.20*p_FD_Exp



# Probability of Adverse Events:

p_FA1_STD
Minimum_p_FA1_STD <- p_FA1_STD - 0.20*p_FA1_STD
Maximum_p_FA1_STD <- p_FA1_STD + 0.20*p_FA1_STD

p_FA2_STD
Minimum_p_FA2_STD <- p_FA2_STD - 0.20*p_FA2_STD
Maximum_p_FA2_STD <- p_FA2_STD + 0.20*p_FA2_STD

p_FA3_STD
Minimum_p_FA3_STD <- p_FA3_STD - 0.20*p_FA3_STD
Maximum_p_FA3_STD <- p_FA3_STD + 0.20*p_FA3_STD


p_FA1_EXPR
Minimum_p_FA1_EXPR <- p_FA1_EXPR - 0.20*p_FA1_EXPR
Maximum_p_FA1_EXPR <- p_FA1_EXPR + 0.20*p_FA1_EXPR

p_FA2_EXPR
Minimum_p_FA2_EXPR <- p_FA2_EXPR - 0.20*p_FA2_EXPR
Maximum_p_FA2_EXPR <- p_FA2_EXPR + 0.20*p_FA2_EXPR

p_FA3_EXPR
Minimum_p_FA3_EXPR <- p_FA3_EXPR - 0.20*p_FA3_EXPR
Maximum_p_FA3_EXPR <- p_FA3_EXPR + 0.20*p_FA3_EXPR




# Cost:

# If I decide to include the cost of the test for patients I will also need to include this in the sensitivity analysis here:

administration_cost

Minimum_administration_cost <- administration_cost - 0.20*administration_cost
Maximum_administration_cost <- administration_cost + 0.20*administration_cost

c_PFS_Folfox

Minimum_c_PFS_Folfox  <- c_PFS_Folfox - 0.20*c_PFS_Folfox
Maximum_c_PFS_Folfox  <- c_PFS_Folfox + 0.20*c_PFS_Folfox

c_PFS_Bevacizumab 

Minimum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab - 0.20*c_PFS_Bevacizumab
Maximum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab + 0.20*c_PFS_Bevacizumab

c_OS_Folfiri 

Minimum_c_OS_Folfiri  <- c_OS_Folfiri - 0.20*c_OS_Folfiri
Maximum_c_OS_Folfiri  <- c_OS_Folfiri + 0.20*c_OS_Folfiri

subtyping_test_cost 

Minimum_subtyping_test_cost  <- subtyping_test_cost - 0.20*subtyping_test_cost
Maximum_subtyping_test_cost <- subtyping_test_cost + 0.20*subtyping_test_cost

c_D  

Minimum_c_D  <- c_D - 0.20*c_D
Maximum_c_D  <- c_D + 0.20*c_D

c_AE1

Minimum_c_AE1  <- c_AE1 - 0.20*c_AE1
Maximum_c_AE1  <- c_AE1 + 0.20*c_AE1

c_AE2

Minimum_c_AE2  <- c_AE2 - 0.20*c_AE2
Maximum_c_AE2  <- c_AE2 + 0.20*c_AE2

c_AE3

Minimum_c_AE3  <- c_AE3 - 0.20*c_AE3
Maximum_c_AE3  <- c_AE3 + 0.20*c_AE3


# Utilities:

u_F

Minimum_u_F <- 0.68
Maximum_u_F <- 1.00


u_P

Minimum_u_P <- 0.52
Maximum_u_P <- 0.78 


u_D

Minimum_u_D <- u_D - 0.20*u_D
Maximum_u_D <- u_D + 0.20*u_D 


AE1_DisUtil

Minimum_AE1_DisUtil <- AE1_DisUtil - 0.20*AE1_DisUtil
Maximum_AE1_DisUtil <- AE1_DisUtil + 0.20*AE1_DisUtil 


AE2_DisUtil

Minimum_AE2_DisUtil <- AE2_DisUtil - 0.20*AE2_DisUtil
Maximum_AE2_DisUtil <- AE2_DisUtil + 0.20*AE2_DisUtil 


AE3_DisUtil

Minimum_AE3_DisUtil <- AE3_DisUtil - 0.20*AE3_DisUtil
Maximum_AE3_DisUtil <- AE3_DisUtil + 0.20*AE3_DisUtil 




# Discount factor
# Cost Discount Factor
# Utility Discount Factor
# I divided these by 365 earlier in the R markdown document, so no need to do that again here:

d_e

Minimum_d_e <- 0
Maximum_d_e <- 0.08/365



d_c

Minimum_d_c <- 0
Maximum_d_c <- 0.08/365


# I am concerned that the min or max may go above 1 or below 0 in cases where parameter values should be bounded at 1 or 0, therefore, in such cases I say, replace the minimum I created with 0 or the maximum I created with 1, if the minimum is below 0 or the maximum is above 1:


HR_FP_Exp
Minimum_HR_FP_Exp<- replace(Minimum_HR_FP_Exp, Minimum_HR_FP_Exp<0, 0)
Maximum_HR_FP_Exp<- replace(Maximum_HR_FP_Exp, Maximum_HR_FP_Exp>1, 1)

HR_FP_SoC
Minimum_HR_FP_SoC<- replace(Minimum_HR_FP_SoC, Minimum_HR_FP_SoC<0, 0)
Maximum_HR_FP_SoC<- replace(Maximum_HR_FP_SoC, Maximum_HR_FP_SoC>1, 1)

HR_PD_SoC
Minimum_HR_PD_SoC<- replace(Minimum_HR_PD_SoC, Minimum_HR_PD_SoC<0, 0)
Maximum_HR_PD_SoC<- replace(Maximum_HR_PD_SoC, Maximum_HR_PD_SoC>1, 1)

HR_PD_Exp
Minimum_HR_PD_Exp<- replace(Minimum_HR_PD_Exp, Minimum_HR_PD_Exp<0, 0)
Maximum_HR_PD_Exp<- replace(Maximum_HR_PD_Exp, Maximum_HR_PD_Exp>1, 1)

P_OSD_SoC
Minimum_P_OSD_SoC<- replace(Minimum_P_OSD_SoC, Minimum_P_OSD_SoC<0, 0)
Maximum_P_OSD_SoC<- replace(Maximum_P_OSD_SoC, Maximum_P_OSD_SoC>1, 1)

P_OSD_Exp
Minimum_P_OSD_Exp<- replace(Minimum_P_OSD_Exp, Minimum_P_OSD_Exp<0, 0)
Maximum_P_OSD_Exp<- replace(Maximum_P_OSD_Exp, Maximum_P_OSD_Exp>1, 1)

p_FA1_STD
Minimum_p_FA1_STD<- replace(Minimum_p_FA1_STD, Minimum_p_FA1_STD<0, 0)
Maximum_p_FA1_STD<- replace(Maximum_p_FA1_STD, Maximum_p_FA1_STD>1, 1)

p_FA2_STD
Minimum_p_FA2_STD<- replace(Minimum_p_FA2_STD, Minimum_p_FA2_STD<0, 0)
Maximum_p_FA2_STD<- replace(Maximum_p_FA2_STD, Maximum_p_FA2_STD>1, 1)

p_FA3_STD
Minimum_p_FA3_STD<- replace(Minimum_p_FA3_STD, Minimum_p_FA3_STD<0, 0)
Maximum_p_FA3_STD<- replace(Maximum_p_FA3_STD, Maximum_p_FA3_STD>1, 1)

p_FA1_EXPR
Minimum_p_FA1_EXPR<- replace(Minimum_p_FA1_EXPR, Minimum_p_FA1_EXPR<0, 0)
Maximum_p_FA1_EXPR<- replace(Maximum_p_FA1_EXPR, Maximum_p_FA1_EXPR>1, 1)

p_FA2_EXPR
Minimum_p_FA2_EXPR<- replace(Minimum_p_FA2_EXPR, Minimum_p_FA2_EXPR<0, 0)
Maximum_p_FA2_EXPR<- replace(Maximum_p_FA2_EXPR, Maximum_p_FA2_EXPR>1, 1)

p_FA3_EXPR
Minimum_p_FA3_EXPR<- replace(Minimum_p_FA3_EXPR, Minimum_p_FA3_EXPR<0, 0)
Maximum_p_FA3_EXPR<- replace(Maximum_p_FA3_EXPR, Maximum_p_FA3_EXPR>1, 1)

u_F
Minimum_u_F<- replace(Minimum_u_F, Minimum_u_F<0, 0)
Maximum_u_F<- replace(Maximum_u_F, Maximum_u_F>1, 1)

u_P
Minimum_u_P<- replace(Minimum_u_P, Minimum_u_P<0, 0)
Maximum_u_P<- replace(Maximum_u_P, Maximum_u_P>1, 1)

AE1_DisUtil
Minimum_AE1_DisUtil<- replace(Minimum_AE1_DisUtil, Minimum_AE1_DisUtil<0, 0)
Maximum_AE1_DisUtil<- replace(Maximum_AE1_DisUtil, Maximum_AE1_DisUtil>1, 1)

AE2_DisUtil
Minimum_AE2_DisUtil<- replace(Minimum_AE2_DisUtil, Minimum_AE2_DisUtil<0, 0)
Maximum_AE2_DisUtil<- replace(Maximum_AE2_DisUtil, Maximum_AE2_DisUtil>1, 1)

AE3_DisUtil
Minimum_AE3_DisUtil<- replace(Minimum_AE3_DisUtil, Minimum_AE3_DisUtil<0, 0)
Maximum_AE3_DisUtil<- replace(Maximum_AE3_DisUtil, Maximum_AE3_DisUtil>1, 1)



# A one-way sensitivity analysis (OWSA) can be defined by specifying the names of the parameters that are to be incuded and their minimum and maximum values.


# We create a dataframe containing all parameters we want to do the sensitivity analysis on, and the min and max values of the parameters of interest 
# "min" and "max" are the mininum and maximum values of the parameters of interest.


# options(scipen = 999) # disabling scientific notation in R

df_params_OWSA <- data.frame(
  pars = c("HR_FP_Exp", "HR_FP_SoC", "HR_PD_SoC", "HR_PD_Exp", "P_OSD_SoC", "P_OSD_Exp", "p_FA1_STD", "p_FA2_STD", "p_FA3_STD", "p_FA1_EXPR", "p_FA2_EXPR", "p_FA3_EXPR", "administration_cost", "c_PFS_Folfox", "c_PFS_Bevacizumab", "c_OS_Folfiri", "subtyping_test_cost", "c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "AE1_DisUtil", "AE2_DisUtil", "AE3_DisUtil"),   # names of the parameters to be changed
  min  = c(Minimum_HR_FP_Exp, Minimum_HR_FP_SoC, Minimum_HR_PD_SoC, Minimum_HR_PD_Exp, Minimum_P_OSD_SoC, Minimum_P_OSD_Exp, Minimum_p_FA1_STD, Minimum_p_FA2_STD, Minimum_p_FA3_STD, Minimum_p_FA1_EXPR, Minimum_p_FA2_EXPR, Minimum_p_FA3_EXPR, Minimum_administration_cost, Minimum_c_PFS_Folfox, Minimum_c_PFS_Bevacizumab, Minimum_c_OS_Folfiri, Minimum_subtyping_test_cost, Minimum_c_AE1, Minimum_c_AE2, Minimum_c_AE3, Minimum_d_e, Minimum_d_c, Minimum_u_F, Minimum_u_P, Minimum_AE1_DisUtil, Minimum_AE2_DisUtil, Minimum_AE3_DisUtil),         # min parameter values
  max  = c(Maximum_HR_FP_Exp, Maximum_HR_FP_SoC, Maximum_HR_PD_SoC, Maximum_HR_PD_Exp, Maximum_P_OSD_SoC, Maximum_P_OSD_Exp, Maximum_p_FA1_STD, Maximum_p_FA2_STD, Maximum_p_FA3_STD, Maximum_p_FA1_EXPR, Maximum_p_FA2_EXPR, Maximum_p_FA3_EXPR, Maximum_administration_cost, Maximum_c_PFS_Folfox, Maximum_c_PFS_Bevacizumab, Maximum_c_OS_Folfiri, Maximum_subtyping_test_cost, Maximum_c_AE1,  Maximum_c_AE2, Maximum_c_AE3, Maximum_d_e, Maximum_d_c, Maximum_u_F, Maximum_u_P, Maximum_AE1_DisUtil, Maximum_AE2_DisUtil, Maximum_AE3_DisUtil)          # max parameter values
)


# I made sure the names of the parameters to be varied and their mins and maxs are in the same order in all the brackets above in order to make sure that the min and max being applied are the min and the max of the parameter I want to consider a min and a max for.



# The OWSA is performed using the run_owsa_det function


# This function runs a deterministic one-way sensitivity analysis (OWSA) on a given function that produces outcomes. rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

DSAICER  <- run_owsa_det(
  
  # run_owsa_det: https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html
  
  # We need to make sure we consistently use "DSAICER" throughout, or else the function will present with an error saying "DSAICER" not found.  
  
  # Arguments:
  
  params_range     = df_params_OWSA,     # dataframe with parameters for OWSA
  
  # params_range	
  # data.frame with 3 columns of parameters for OWSA in the following order: "pars", "min", and "max".
  # The number of samples from this range is determined by nsamp. 
  # "pars" are the parameters of interest and must be a subset of the parameters from params_basecase.
  
  
  # Details
  # params_range
  
  # "pars" are the names of the input parameters of interest. These are the parameters that will be varied in the deterministic sensitivity analysis. variables in "pars" column must be a subset of variables in params_basecase
  
  
  
  params_basecase  = l_params_all,       # list with all parameters
  
  # params_basecase	
  
  # a named list of basecase values for input parameters needed by FUN, the user-defined function. So, I guess it takes the values that the parameters are equal to in l_params_all as the base case, so if cost is generated equal to 1,000 it'll take that as the base case, and then take the min and the max around this from the data.frame we created above.
  
  # To conduct the one-way DSA, we then call the function run_owsa_det with my_owsa_params_range, specifying the parameters to be varied and over which ranges, and my_params_basecase as the fixed parameter values to be used in the model when a parameter is not being explicitly varied in the one-way sensitivity analysis. https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html
  
  nsamp            = 100,                # number of parameter values
  
  # nsamp	
  
  # number of sets of parameter values to be generated. If NULL, 100 parameter values are used -> I think Eva Enns said these are automatically evenly spaced out values of the parameters.
  
  # Additional inputs are the number of equally-spaced samples (nsamp) to be used between the specified minimum and maximum of each range, the user-defined function (FUN) to be called to generate model outcomes for each strategy, the vector of outcomes to be stored (must be outcomes generated by the data frame output of the function passed in FUN), and the vector of strategy names to be evaluated.
  
  # cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html
  
  FUN              = oncologySemiMarkov, # function to compute outputs
  
  # FUN	
  # function that takes the basecase in params_basecase and runs the analysis in the function... to produce the outcome of interest. The FUN must return a dataframe where the first column are the strategy names and the rest of the columns must be outcomes.
  #  
  
  outcomes         = c("DSAICER"),           # output to do the OWSA on
  
  # string vector with the outcomes of interest from FUN produced by nsamp
  # This basically tells run_owsa_det what the name of the outcome of interest from the function we fed it is. Here our function previously had NMB, i.e., the net monetary benefit.
  
  #  outcomes         = c("NMB"),           # output to do the OWSA on
  
  # outcomes	
  
  strategies       = "Experimental Treatment",       # names of the strategies
  
  # strategies
  # Set it equal to a vector of strategy names. The default NULL will use strategy names in FUN (  strategies = NULL,)
  # Here that's "Standard of Care" and "Experimental Treatment".
  
  progress = TRUE,
  
  # progress	
  # TRUE or FALSE for whether or not function progress should be displayed in console, i.e., like 75% complete, 100%, etc.,
  
  # The input progress = TRUE allows the user to see a progress bar as the DSA is conducted. When many parameters are being varied, nsamp is large, and/or the user-defined function is computationally burdensome, the DSA may take a noticeable amount of time to compute and the progress display is recommended.
  # cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html
  
  
  n_wtp            = n_wtp               # extra argument to pass to FUN to specify the willingness to pay
)

# Value
# A list containing dataframes with the results of the sensitivity analyses. The list will contain a dataframe for each outcome specified. List elements can be visualized with plot.owsa, owsa_opt_strat and owsa_tornado from dampack

# Basically, run_owsa_det creates the above.

# Also, each owsa object returned by run_owsa_det is a data frame with four columns: parameter, strategy, param_val, and outcome_val. For each row, param_val is the value used for the parameter listed in parameter and outcome_val is the value of the specified outcome for the strategy listed in strategy. 

# So, OWSA_NMB shows a row is created for each sampling of the parameter value from min to max, so 100 rows per parameter (because nsamp = 100,), and the outcome value associated with a parameter value of this size is displayed under outcome_val.

# You can see how this works by putting the below into the console.

# OWSA_NMB

# Or just DSAICER for DSAICER.

# Resources on this available here:


# https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html (also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\sensitivity analysis help files\rdrr-io-github-DARTH-git-dampack-man-run_owsa_det-html.pdf)


# This link is pretty good for showing that the OWSA can be run across a variety of outcomes outcomes = c("Cost", "QALY", "LY", "NMB"), and then you can pick which of the OWSA outcomes you'd like to focus on and build tornado diagrams, etc., from that:

# "Because we have defined multiple parameters in my_owsa_params_range, we have instructed run_owsa_det to execute a series of separate one-way sensitivity analyses and compile the results into a single owsa object for each requested outcome. When only one outcome is specified run_owsa_det returns a owsa data frame. When more than one outcome is specified, run_owsa_det returns a list containing one owsa data frame for each outcome. To access the owsa object corresponding to a given outcome, one can select the list item with the name “owsa_”. For example, the owsa object associated with the NMB outcome can be accessed as l_owsa_det$owsa_NMB."

# https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html 

owsa_tornado(owsa = DSAICER, txtsize = 11)
ggsave(file.path("output", paste("Tornado_Diagram_Singular_ICERs", country_name[1], ".png", sep = "")), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()
#png(paste("Tornado_Diagram_", country_name[1], ".png", sep = ""))
#dev.off()

# Plotting the outcomes of the OWSA in a tornado plot
# - note that other plots can also be generated using the plot() and owsa_opt_strat() functions


# owsa_tornado(
#   DSAICER,
#   return = c("data"),
#   txtsize = 12,
#   min_rel_diff = 0,
#   col = c("full", "bw"),
#   n_y_ticks = 8,
#   ylim = NULL,
#   ybreaks = NULL
# )


# owsa_tornado(DSAICER,
# 
# min_rel_diff = 0.05)

# For owsa objects that contain many parameters that have minimal effect on the parameter of interest, you may want to consider producing a plot that highlights only the most influential parameters. Using the min_rel_diff argument, you can instruct owsa_tornado to exclude all parameters that fail to produce a relative change in the outcome below a specific fraction.


# Maybe use the below to change the formatting of the above:
# TornadoPlot(main_title = "Tornado Plot", Parms = paramNames, Outcomes = m.tor, 
#             outcomeName = "Incremental Cost-Effectiveness Ratio (ICER)", 
#             xlab = "ICER", 
#             ylab = "Parameters", 
#             col1="#3182bd", col2="#6baed6")
