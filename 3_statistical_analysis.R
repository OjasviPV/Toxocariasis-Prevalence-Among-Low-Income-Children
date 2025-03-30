# --------------------------------------------------------
# Statistical Analysis for Toxocariasis Study
# --------------------------------------------------------
# This script performs hypothesis testing and regression analysis
# for the Toxocariasis prevalence study by income level
# --------------------------------------------------------

# Create a frequency table for toxocariasis by income group
table(lowincome, tox)

# Chi-square test for equality of proportions
# Test if there is a statistically significant difference in Toxocariasis prevalence
# between lower and higher income groups
chi_square_test <- prop.test(c(20, 10), c(563, 734), correct = FALSE)
print(chi_square_test)

# Extract key statistics from the test
p_value <- chi_square_test$p.value
confidence_interval <- chi_square_test$conf.int
proportion_low_income <- chi_square_test$estimate[1]  # Prevalence in lower income group
proportion_high_income <- chi_square_test$estimate[2] # Prevalence in higher income group
prevalence_difference <- proportion_low_income - proportion_high_income

# Print the prevalence difference and its 95% confidence interval
cat("Prevalence difference (low income - high income):", prevalence_difference, "\n")
cat("95% confidence interval:", confidence_interval, "\n")

# Logistic regression analysis
# Crude model (unadjusted)
LogitModel1 <- glm(tox ~ lowincome, family = binomial(link = logit))
summary(LogitModel1)

# Exponentiate coefficients to get odds ratios
exp(LogitModel1$coefficients)

# Calculate 95% confidence intervals for odds ratios
exp(confint(LogitModel1))

# Adjusted model (controlling for potential confounders)
LogitModel2 <- glm(
  tox ~ lowincome + log_lead + age + relevel(factor(race), ref = "3") + factor(home_status), 
  family = binomial(link = logit)
)
summary(LogitModel2)

# Exponentiate coefficients to get adjusted odds ratios
exp(LogitModel2$coefficients)

# Calculate 95% confidence intervals for adjusted odds ratios
exp(confint(LogitModel2))

# Calculate magnitude of confounding
crude_OR <- exp(LogitModel1$coefficients["lowincome"])
adjusted_OR <- exp(LogitModel2$coefficients["lowincome"])
confounding_percentage <- (crude_OR - adjusted_OR) / adjusted_OR * 100
cat("Magnitude of confounding:", confounding_percentage, "%\n")