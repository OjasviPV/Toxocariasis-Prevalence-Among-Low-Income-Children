# --------------------------------------------------------
# Descriptive Statistics for Toxocariasis Study
# --------------------------------------------------------
# This script generates descriptive statistics for Table 1
# of the Toxocariasis prevalence study by income level
# --------------------------------------------------------

# Calculate mean and standard deviation of log-transformed blood lead levels by income group
tapply(log_lead, lowincome, mean)
tapply(log_lead, lowincome, sd)

# Calculate median and interquartile range of age by income group
tapply(age, lowincome, median)
tapply(age, lowincome, IQR)

# Create cross-tabulation of race by income group
table(race, lowincome)

# Calculate proportions of race categories within each income group
prop.table(table(lowincome, race), 1)

# Create cross-tabulation of home ownership status by income group
table(lowincome, home_status)

# Calculate proportions of home ownership status within each income group
prop.table(table(lowincome, home_status), 1)

# Calculate proportions for toxocariasis presence by income group
prop.table(table(lowincome, tox))

# Generate the bar plot for toxocariasis prevalence by income group (Figure 1)
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

# Save the plot
# Uncomment to save the plot as a PNG file
# png("prevalence_toxocariasis_by_income_group.png", width = 800, height = 600)
# barplot(
#   prop.table(table(tox, lowincome), 2),
#   beside = TRUE,
#   names = c("Higher Income", "Lower Income"),
#   col = c("blue", "green"),
#   xlab = "Income",
#   ylab = "Toxocara %",
#   main = "Prevalence of Toxocariasis by Income Group"
# )
# legend("topright", 
#        legend = c("No Toxocara Antibody Detected", "Toxocara Antibody Detected"), 
#        fill = c("blue", "green"))
# dev.off()