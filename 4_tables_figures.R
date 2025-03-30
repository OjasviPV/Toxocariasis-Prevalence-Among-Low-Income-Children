# --------------------------------------------------------
# Tables and Figures for Toxocariasis Study
# --------------------------------------------------------
# This script generates the tables and figures for the
# Toxocariasis prevalence study report
# --------------------------------------------------------

# Function to create Table 1: Participant Characteristics by Income Group
create_table1 <- function() {
  # Blood lead levels
  lead_mean_high <- tapply(log_lead, lowincome, mean)[1]
  lead_mean_low <- tapply(log_lead, lowincome, mean)[2]
  lead_sd_high <- tapply(log_lead, lowincome, sd)[1]
  lead_sd_low <- tapply(log_lead, lowincome, sd)[2]
  
  # Age
  age_median_high <- tapply(age, lowincome, median)[1]
  age_median_low <- tapply(age, lowincome, median)[2]
  age_iqr_high <- tapply(age, lowincome, IQR)[1]
  age_iqr_low <- tapply(age, lowincome, IQR)[2]
  
  # Race distribution
  race_table <- table(race, lowincome)
  race_prop <- prop.table(table(lowincome, race), 1)
  
  # Home ownership status
  home_table <- table(lowincome, home_status)
  home_prop <- prop.table(table(lowincome, home_status), 1)
  
  # Print Table 1
  cat("Table 1: Participant Characteristics by Income Group\n\n")
  cat("Characteristic                    Lower-Income            Higher-Income\n")
  cat("                                  n=", table(lowincome)[2], "                  n=", table(lowincome)[1], "\n", sep="")
  cat("-----------------------------------------------------------------\n")
  
  cat(sprintf("Log Transformed                  %-8.7f               %-8.7f\n", 
              lead_mean_low, lead_mean_high))
  cat(sprintf("Blood Lead Level (ug/dL)         (%-8.7f)             (%-8.7f)\n", 
              lead_sd_low, lead_sd_high))
  cat("Mean (SD)\n\n")
  
  cat(sprintf("Age in months                    %-3.0f (%-3.1f)              %-3.0f (%-3.0f)\n", 
              age_median_low, age_iqr_low, age_median_high, age_iqr_high))
  cat("Median (IQR)\n\n")
  
  cat("Race\n")
  for(i in 1:5) {
    cat(sprintf("%d                              %-3.0f (%-5.2f%%)            %-3.0f (%-5.2f%%)\n", 
                i, race_table[i,2], race_prop[2,i]*100, race_table[i,1], race_prop[1,i]*100))
  }
  cat("\n")
  
  cat("Home Ownership Status\n")
  for(i in 1:3) {
    cat(sprintf("%d                              %-3.0f (%-5.2f%%)            %-3.0f (%-5.2f%%)\n", 
                i, home_table[2,i], home_prop[2,i]*100, home_table[1,i], home_prop[1,i]*100))
  }
  
  # Toxocariasis prevalence
  tox_table <- table(tox, lowincome)
  tox_prop_low <- tox_table[2,2]/sum(tox_table[,2])*100
  tox_prop_high <- tox_table[2,1]/sum(tox_table[,1])*100
  
  cat("\nToxocariasis Prevalence\n")
  cat(sprintf("                                  %-5.2f%%                 %-5.2f%%\n", 
              tox_prop_low, tox_prop_high))
}

# Function to create Table 2: Association between Toxocariasis and Income Group
create_table2 <- function() {
  # Perform chi-square test
  chi_test <- prop.test(c(20, 10), c(563, 734), correct = FALSE)
  
  # Extract results
  p_value <- chi_test$p.value
  ci_lower <- chi_test$conf.int[1]
  ci_upper <- chi_test$conf.int[2]
  test_stat <- chi_test$statistic
  
  # Print Table 2
  cat("Table 2: Association between Toxocariasis Infection and Income Group, NHANES SURVEY 2011-2012\n\n")
  cat("Prevalence Difference (95% CI)                Test Statistic (df)            p-value\n")
  cat("----------------------------------------------------------------------------------\n")
  cat(sprintf("%.4f (%.4f, %.4f)                       %.4f (1)                %.6f\n", 
              chi_test$estimate[1] - chi_test$estimate[2], ci_lower, ci_upper, test_stat, p_value))
}

# Function to create Table 3: Crude and Adjusted Association
create_table3 <- function() {
  # Fit models
  LogitModel1 <- glm(tox ~ lowincome, family = binomial(link = logit))
  LogitModel2 <- glm(
    tox ~ lowincome + log_lead + age + relevel(factor(race), ref = "3") + factor(home_status), 
    family = binomial(link = logit)
  )
  
  # Extract odds ratios and confidence intervals
  crude_OR <- exp(coef(LogitModel1)["lowincome"])
  adjusted_OR <- exp(coef(LogitModel2)["lowincome"])
  
  crude_CI <- exp(confint(LogitModel1))["lowincome", ]
  adjusted_CI <- exp(confint(LogitModel2))["lowincome", ]
  
  crude_p <- summary(LogitModel1)$coefficients["lowincome", "Pr(>|z|)"]
  adjusted_p <- summary(LogitModel2)$coefficients["lowincome", "Pr(>|z|)"]
  
  # Print Table 3
  cat("Table 3: Crude and Adjusted Association between Toxocariasis and Income Group, NHANES Survey 2011-2012\n\n")
  cat("Model                          Measure of Effect                 95% CI                p-value\n")
  cat("-------------------------------------------------------------------------------------------\n")
  cat(sprintf("Crude Odds Ratio                   %-7.4f                (%-7.4f, %-7.4f)      %-7.4f\n", 
              crude_OR, crude_CI[1], crude_CI[2], crude_p))
  cat(sprintf("Adjusted Odds Ratio*               %-7.4f                (%-7.4f, %-7.4f)      %-7.4f\n",
              adjusted_OR, adjusted_CI[1], adjusted_CI[2], adjusted_p))
  cat("\n*Adjusted for log-transformed blood lead level, age, race, and home ownership status")
}

# Function to create Figure 1: Prevalence of Toxocariasis by Income Group
create_figure1 <- function() {
  # Save plot to file
  png("prevalence_toxocariasis_by_income_group.png", width = 800, height = 600)
  
  barplot(
    prop.table(table(tox, lowincome), 2),
    beside = TRUE,
    names = c("Higher Income", "Lower Income"),
    col = c("blue", "green"),
    xlab = "Income",
    ylab = "Toxocara %",
    main = "Prevalence of Toxocariasis by Income Group"
  )
  
  # Add a legend
  legend("topright", 
         legend = c("No Toxocara Antibody Detected", "Toxocara Antibody Detected"), 
         fill = c("blue", "green"))
  
  dev.off()
  
  cat("Figure 1 has been saved as 'prevalence_toxocariasis_by_income_group.png'\n")
}

# Run functions to create tables and figures
create_table1()
cat("\n\n")
create_table2()
cat("\n\n")
create_table3()
cat("\n\n")
create_figure1()